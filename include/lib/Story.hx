package lib;

import sk.thenet.app.*;

using sk.thenet.FM;

class Story {
  public var days:Array<Day>;
  public var flags:Array<StoryFlag>;
  public var chars:Array<Char>;
  
  public var charMap:Map<String, Char>;
  public var dayNum:Int;
  public var dayPos:Int;
  public var dayTime:Int;
  public var tape:Array<TapeRecord>;
  public var state:StoryState;
  public var dialogueQueue:Array<DialogueAction> = [];
  
  public function new(
    days:Array<Day>, flags:Array<StoryFlag>, chars:Array<Char>
  ) {
    for (i in 0...days.length) {
      days[i].num = i;
    }
    this.days = days;
    this.flags = flags;
    this.chars = chars;
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
                var pos = (if (args[3].charCodeAt(0).withinI('0'.code, '9'.code)) {
                    Std.parseInt(args[3]);
                  } else {
                    resolveLabel(charMap[args[1]].dialogue, args[2], args[3]);
                  });
                TalkingTo(args[1], args[2], pos);
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
        case Call(cell, from, to, st):
        Main.ui.ren.activate(Main.city.idMap[cell], 540, TalkToState(from, st));
        true;
        case Meeting(id, start, end, a):
        if (dayTime.withinI(start, end) && Main.ui.ren.bug != null
            && Main.ui.ren.bug.id == id) {
          Main.ui.ren.activate(Main.ui.ren.bug, 540, a);
        }
        true;
        case CharReachable(id, r): charMap[id].reachable = r; true;
        case CharInCity(id, r): charMap[id].inCity = r; true;
        case CharAlive(id, r): charMap[id].alive = r; true;
        case CharArmed(id, r): charMap[id].armed = r; true;
        case CharMove(id, from, to, speed):
        Main.ui.ren.figs.push(new Fig(id, from, to, speed));
        true;
        case CharLocation(id, to): charMap[id].location = to; true;
        case Conditional(c, e): (evalCond(c) && runDayEvent(e));
        case At(t, e): (dayTime >= t && runDayEvent(e));
        case Music(id): Music.play(id); true;
        case _: false;
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
              charMap[cmd[1]].seen ? "Unknown " + (charMap[cmd[1]].female ? "female" : "male") : charMap[cmd[1]].name;
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
        case Choice(cs):
        var ci = 1;
        for (c in cs) {
          Main.ui.write('$$B${ci}) ${c.txt}');
          ci++;
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
/*        case Music(id):
        Music.play(id);
        {nst: st, npo: po + 1, stop: false};*/
        case Seen(i):
        charMap[i].seen = true;
        {nst: st, npo: po + 1, stop: false};
        case _:
        {nst: st, npo: po + 1, stop: false};
      });
  }
  
  public function talkTo(c:String, ?st:String):Void {
    var char = charMap[c];
    Main.ui.portrait = char.portrait;
    if (st.substr(0, 4) != "call" && st.substr(0, 3) != "bug") {
      Main.ui.write('# ${char.name}');
    }
    state = TalkingTo(c, st != null ? st : char.dialogue.start, 0);
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
  
  public function uiSelect(i:Int):Void {
    if (dialogueQueue.length == 0) {
      return;
    }
    switch (dialogueQueue[0]) {
      case Choice(cs):
      if (i < cs.length && Main.ui.writeQueue.length == 0) {
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
  
  public function tick():Void {
    if (dayNum == -1){ //} || dayNum == 9) {
      nextDay();
      dayTime = 590;
    }
    Main.ui.dialogueMode = false;
    Main.ui.recording = false;
    Main.ui.portraitShow = false;
    Main.ui.tapeAlt.setTo(false);
    switch (state) {
      case None:
      if (Main.ui.ren.selected == null) {
        dayTime++;
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
      Main.ui.dialogueMode = true;
      Main.ui.recording = true;
      Main.ui.portrait = charMap[c].portrait;
      Main.ui.portraitShow = true;
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
          case Choice(_):
          Main.ui.tapeAlt.setTo(true);
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
