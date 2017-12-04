package lib;

import sk.thenet.app.*;

using sk.thenet.FM;

class Story {
  public var days:Array<Day>;
  public var flags:Map<String, StoryFlag>;
  public var chars:Array<Char>;
  public var goals:Map<String, Bool>;
  public var goalsReached:Int = 0;
  
  public var charMap:Map<String, Char>;
  public var dayNum:Int;
  public var dayPos:Int;
  public var dayTime:Int;
  public var tape:Array<Array<TapeRecord>>;
  public var state:StoryState;
  public var dialogueQueue:Array<DialogueAction> = [];
  public var lock:Bool = false;
  
  public function new(
     days:Array<Day>, flags:Map<String, StoryFlag>, chars:Array<Char>
    ,goals:Array<String>
  ) {
    for (i in 0...days.length) {
      days[i].num = i;
    }
    this.days = days;
    this.flags = flags;
    this.chars = chars;
    this.goals = new Map<String, Bool>();
    for (g in goals) {
      this.goals[g] = false;
    }
    reload();
    tape = [];
    state = None;
    dayNum = -1;
    if (Debug.CONSOLE_COMMANDS) {
      Console.commands["story"] = (args:Array<String>) -> {
          if (args.length != 0) {
            state = (switch (args[0].toLowerCase()) {
                case "n" | "none": None;
                case "p" | "prev":
                var delta = 1;
                if (args.length > 0) {
                  delta = Std.parseInt(args[1]);
                }
                dialogueQueue = [];
                switch (state) {
                  case TalkingTo(c, st, po): StoryState.TalkingTo(c, st, po - delta);
                  case _: state;
                }
                case ("d" | "day") if (args.length == 2):
                dialogueQueue = [];
                dayNum = Std.parseInt(args[1]) - 2;
                nextDay();
                None;
                case ("tt" | "talkingto") if (args.length == 4):
                if (!charMap.exists(args[1]) || !charMap[args[1]].dialogue.states.exists(args[2])) {
                  state;
                } else {
                  var pos = (if (args[3].charCodeAt(0).withinI('0'.code, '9'.code)) {
                      Std.parseInt(args[3]);
                    } else {
                      resolveLabel(charMap[args[1]].dialogue, args[2], args[3]);
                    });
                  TalkingTo(args[1], args[2], pos);
                }
                case _: state;
              });
          }
          [Std.string(state)];
        };
      Console.commands["clrdia"] = (args:Array<String>) -> {
          dialogueQueue = [];
          [];
        };
      Console.commands["talkto"] = (args:Array<String>) -> {
          if (args.length != 0) {
            talkTo(args[0]);
          }
          [Std.string(state)];
        };
    }
  }
  
  public function reload():Void {
    charMap = new Map<String, Char>();
    for (c in chars) {
      charMap[c.id] = c;
    }
  }
  
  public function evalCond(s:StoryCondition):Bool {
    return (switch (s) {
        case Always: true;
        case Never: false;
        case Not(s): !evalCond(s);
        case All(a): [ for (ss in a) if (evalCond(ss)) 1 ].length == a.length;
        case Any(a): [ for (ss in a) if (evalCond(ss)) 1 ].length > 0;
        case Func(f): f(this);
        case FlagBool(id): switch (flags[id]) {
          case FBool(v): v;
          case _: false;
        }
        case GoalsReached(n): goalsReached >= n;
        case GoalReached(id): goals[id];
        case DayReached(n): dayNum >= n - 1;
        case Reachable(char): charMap[char].reachable;
        case InCity(char): charMap[char].inCity;
        case Alive(char): charMap[char].alive;
        case Location(char, loc): charMap[char].location == loc;
        // TODO:
        case Recorded(event): false;
      });
  }
  
  public function runDayEvent(d:DayEvent):Bool {
    return (switch (d) {
        case Action(a): runAction(a); true;
        case DialogueAction(a): runDialogueAction(a, null, null, 0); true;
        case Call(cell, from, to, st):
        Main.ui.ren.activate(Main.city.idMap[cell], 1080, TalkToState(from, st));
        true;
        case Meeting(id, start, end, a):
        if (dayTime.withinI(start, end) && Main.ui.ren.bug != null
            && Main.ui.ren.bug.id == id && Main.ui.ren.selected == null) {
          Main.ui.ren.activate(Main.ui.ren.bug, 1080, a);
          true;
        } else {
          dayTime >= end;
        }
        case CharReachable(id, r): charMap[id].reachable = r; true;
        case CharInCity(id, r): charMap[id].inCity = r; true;
        case CharAlive(id, r): charMap[id].alive = r; true;
        case CharArmed(id, r): charMap[id].armed = r; true;
        case CharMove(id, from, to, speed):
        if (charMap[id].alive) {
          Main.ui.ren.figs.push(new Fig(id, from, to, speed));
        }
        true;
        case CharLocation(id, to): charMap[id].location = to; true;
        case Conditional(c, e): (evalCond(c) && runDayEvent(e));
        case At(t, e): if (dayTime >= t) runDayEvent(e); dayTime >= t;
        case Music(id): Music.play(id); true;
        case Sound(id): SFX.s(id); true;
        case Lock(l): lock = l; true;
      });
  }
  
  public function runAction(a:Action):Void {
    switch (a) {
      case ReadAbout(t):
      case TalkTo(c):
      talkTo(c);
      case TalkToState(c, st):
      talkTo(c, st);
      case _:
    }
  }
  
  function resolveLabel(d:Dialogue, st:String, n:String):Int {
    for (i in 0...d.states[st].length) {
      switch (d.states[st][i]) {
        case Label(nn):
        if (nn == n) return i;
        case _:
      }
    }
    return 0;
  }
  
  public function runDialogueAction(
    a:DialogueAction, d:Dialogue, st:String, po:Int, ?pause:Bool = true
  ):{nst:String, npo:Int, stop:Bool} {
    return (switch (a) {
        case S(txt, snd) | SO(_, txt, snd):
        txt.split("\n").map(m -> Main.ui.write('$$B$m'));
        if (pause) {
          Main.ui.write("$B                    (click)");
          dialogueQueue.push(Pause);
        }
        {nst: st, npo: po + 1, stop: pause};
        case SP(txt, snd):
        txt.split("\n").map(m -> Main.ui.write('$$D$m'));
        if (pause) {
          Main.ui.write("$B                    (click)");
          dialogueQueue.push(Pause);
        }
        {nst: st, npo: po + 1, stop: pause};
        case EvalS(msg):
        var parts = msg.split("%");
        var i = 1;
        while (i < parts.length) {
          var cmd = parts[i].split(".");
          parts[i] = (switch (cmd[0]) {
              case "vnum":
              charMap[cmd[1]].vnumSecret ? "#.#.#.#" : charMap[cmd[1]].vnum;
              case "name":
              !charMap[cmd[1]].seen ? "Unknown " + (charMap[cmd[1]].female ? "female" : "male") : charMap[cmd[1]].name;
              case _: "";
            });
          i += 2;
        }
        var txt = parts.join("");
        txt.split("\n").map(m -> Main.ui.write('$$D$m'));
        if (pause) {
          Main.ui.write("$B                    (click)");
          dialogueQueue.push(Pause);
        }
        {nst: st, npo: po + 1, stop: pause};
        case NP(a): runDialogueAction(a, d, st, po, false);
        case Choice(cs, tape):
        var ci = 1;
        for (c in cs) {
          Main.ui.write('$$B${ci}) ${c.txt}');
          ci++;
        }
        if (tape) {
          Main.ui.write("$B<TAPES ACCEPTED>");
        }
        dialogueQueue.push(a);
        {nst: st, npo: po + 1, stop: false};
        case GoToState(nst): {nst: nst, npo: 0, stop: false};
        case GoToLabel(n): {nst: st, npo: resolveLabel(d, st, n), stop: false};
        case GoToStateLabel(nst, n): {nst: nst, npo: resolveLabel(d, nst, n), stop: false};
        case Label(_): {nst: st, npo: po + 1, stop: false};
        case Conditional(c, a):
        evalCond(c) ? runDialogueAction(a, d, st, po) : {nst: st, npo: po + 1, stop: false};
        case Wait(f):
        dialogueQueue.push(a);
        {nst: st, npo: po + 1, stop: true};
        case Pause:
        Main.ui.write("$B                    (click)");
        dialogueQueue.push(a);
        {nst: st, npo: po + 1, stop: true};
        case Sound(snd):
        {nst: st, npo: po + 1, stop: false};
        case Ending(e):
        SEnding.ending = e;
        Main.inst.applyState(Main.inst.getStateById("ending"));
        {nst: st, npo: po, stop: true};
        case Music(id):
        Music.play(id);
        {nst: st, npo: po + 1, stop: false};
        case Seen(i):
        charMap[i].seen = true;
        charMap[i].vnumSeen = true;
        charMap[i].vnumAssoc = true;
        charMap[i].buildPrefix();
        {nst: st, npo: po + 1, stop: false};
        case VNumSeen(i):
        charMap[i].vnumSeen = true;
        charMap[i].buildPrefix();
        {nst: st, npo: po + 1, stop: false};
        case RandomState(ns):
        {nst: FM.prng.nextElement(ns), npo: 0, stop: false};
        case SetFlagBool(i, val):
        flags[i] = StoryFlag.FBool(val);
        {nst: st, npo: po + 1, stop: false};
      });
  }
  
  public function talkTo(c:String, ?st:String):Void {
    var char = charMap[c];
    Main.ui.portrait = char.portrait;
    if (st == null) st = char.dialogue.start;
    if (st.substr(0, 4) != "call" && st.substr(0, 3) != "bug") {
      Main.ui.write('# ${char.name}');
    }
    state = TalkingTo(c, st, 0);
  }
  
  public function nextDay():Void {
    dayNum++;
    dayPos = 0;
    dayTime = 0;
    if (dayNum < days.length) {
      Main.ui.write(' \n${days[dayNum].show()}\n ');
    }
  }
  
  public function mouseDown(mx:Int, my:Int):Bool {
    if (lock) {
      return true;
    }
    if (dialogueQueue.length == 0) {
      return false;
    }
    switch (dialogueQueue[0]) {
      case Pause:
      return true;
      case _:
    }
    return false;
  }
  
  public function mouseUp(mx:Int, my:Int):Bool {
    if (lock) {
      return true;
    }
    if (dialogueQueue.length == 0) {
      return false;
    }
    switch (dialogueQueue[0]) {
      case Pause:
      if (Main.ui.writeQueue.length < 2) {
        dialogueQueue.shift();
      }
      return true;
      case _:
    }
    return false;
  }
  
  public function tapeSelect(tape:Array<TapeRecord>):Void {
    var id = null;
    for (t in tape) {
      switch (t) {
        case Label(m): id = m; break;
        case _:
      }
    }
    trace("id: " + id);
    if (id != null) {
      switch (state) {
        case TalkingTo(c, st, po):
        var dia = charMap[c].dialogue;
        var key = "react." + id;
        if (dia.states.exists(key)) {
          state = TalkingTo(c, key, 0);
          dialogueQueue.shift();
        } else {
          SFX.s("ClickError");
        }
        case _:
      }
    }
  }
  
  public function uiSelect(i:Int):Void {
    if (dialogueQueue.length == 0) {
      return;
    }
    switch (dialogueQueue[0]) {
      case Choice(cs, tape):
      if (Main.ui.writeQueue.length != 0) {
        return;
      }
      if (i < 3 && i < cs.length) {
        switch (state) {
          case TalkingTo(c, st, po):
          Main.ui.write('$$B                       (${i + 1})');
          state = TalkingTo(
               c, cs[i].res
              ,cs[i].label != null ? resolveLabel(charMap[c].dialogue, cs[i].res, cs[i].label) : 0
            );
          checkDialogueExit();
          dialogueQueue.shift();
          case _:
        }
      } else if (tape && i >= 3) {
        Main.ui.tapeAltModeT = Listen;
      }
      case _:
    }
  }
  
  public function checkDialogueExit():Bool {
    switch (state) {
      case TalkingTo(_, "stop", _):
      state = None;
      return true;/*
      case TalkingTo(c, st, po):
      var dia = charMap[c].dialogue;
      if (!dia.states.exists(st)){ //} || po >= dia.states[st].length) {
        state = None;
        return true;
      }*/
      case _:
    }
    return false;
  }
  
  public function checkGoals():Void {
    switch (state) {
      case TalkingTo(c, st, _):
      var k = c + "." + st;
      if (goals.exists(k) && !goals[k]) {
        goals[k] = true;
        goalsReached++;
      }
      case _:
    }
  }
  
  public function tick():Void {
    if (dayNum == -1) {
      nextDay();
    }
    if (lock) {
      Main.ui.cursor = Wait;
    }
    var wasRecording = Main.ui.recording;
    Main.ui.dialogueMode = false;
    Main.ui.recording = false;
    Main.ui.portraitShow = false;
    switch (state) {
      case None:
      if (Main.ui.renView == City && Main.ui.ren.selected == null) {
        dayTime++;
        if (Main.ui.ren.sentinel != null) {
          for (c in chars) {
            if (c.alive && c.armed && c.location == Main.ui.ren.sentinel.id) {
              Main.ui.ren.activate(Main.ui.ren.sentinel, 100, None);
              c.alive = false;
              c.location = "";
              Main.ui.write("# TARGET ELIMINATED");
              SFX.s("Shutdown2");
            }
          }
        }
      }
      if (dayPos < days[dayNum].events.length) {
        if (runDayEvent(days[dayNum].events[dayPos])) {
          dayPos++;
        }
      }/* else if (dayPos >= days[dayNum].length) {
        nextDay();
      }
      */
      if (dayTime >= days[dayNum].length) {
        nextDay();
      }
      case TalkingTo(c, st, po):
      checkGoals();
      Main.ui.dialogueMode = true;
      Main.ui.recording = true;
      Main.ui.portrait = charMap[c].portrait;
      Main.ui.portraitShow = true;
      if (!wasRecording) {
        Main.ui.writeLabel(c + "." + st);
      }
      if (dialogueQueue.length > 0) {
        switch (dialogueQueue[0]) {
          case Wait(n):
          if (n > 1) {
            Main.ui.cursor = Wait;
            dialogueQueue[0] = Wait(n - 1);
          } else {
            dialogueQueue.shift();
          }
          case Pause:
          Main.ui.cursor = Wait;
          case Choice(_, tape):
          var rst = true;
          if (tape && Main.ui.tapeAltModeT == Listen) {
            rst = false;
          }
          if (rst) {
            Main.ui.tapeAltModeT = Choice;
          }
          case _:
        }
      } else {
        var dia = charMap[c].dialogue;
        if (po >= dia.states[st].length) {
          state = None;
        } else {
          while (dialogueQueue.length == 0 && po < dia.states[st].length) {
            var next = runDialogueAction(dia.states[st][po], dia, st, po);
            state = TalkingTo(c, next.nst, next.npo);
            checkGoals();
            if (checkDialogueExit() || next.stop) {
              break;
            }
            st = next.nst;
            po = next.npo;
          }
        }
      }
    }
  }
}
