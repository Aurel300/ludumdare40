package lib;

class Story {
  public static function start():Story {
    return new Story([
        /* 1  */  new Day([])
        /* 2  */ ,new Day([])
        /* 3  */ ,new Day([])
        /* 4  */ ,new Day([])
        /* 5  */ ,new Day([])
        /* 6  */ ,new Day([])
        /* 7  */ ,new Day([])
        /* 8  */ ,new Day([])
        /* 9  */ ,new Day([])
        /* 10 */ ,new Day([])
        /* 11 */ ,new Day([])
        /* 12 */ ,new Day([])
      ], [], [
        new Char("aim", "Grep Shamir", 0, [
            "idle" => 0
          ], new Dialogue("greet", [
            "greet" => [
                 S("Hello, AICO.\nWelcome on-line!")
                ,Pause
                ,S("hahaaa")
                ,Choice([
                     {txt: "Hello?", res: "greet"}
                    ,{txt: "Bye", res: "stop"}
                  ])
              ]
          ]))
      ]);
  }
  
  public var days:Array<Day>;
  public var flags:Array<StoryFlag>;
  public var chars:Array<Char>;
  
  public var charMap:Map<String, Char>;
  public var dayNum:Int;
  public var dayPos:Int;
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
    charMap = new Map<String, Char>();
    for (c in chars) {
      charMap[c.id] = c;
    }
    tape = [];
    state = None;
    dayNum = -1;
    dayPos = 0;
  }
  
  public function evalCond(s:StoryCondition):Bool {
    return (switch (s) {
        case Always: true;
        case Never: false;
        case Not(s): !evalCond(s);
        case All(a): [ for (ss in a) if (evalCond(ss)) 1 ].length == a.length;
        case Any(a): [ for (ss in a) if (evalCond(ss)) 1 ].length > 0;
        case Func(f): f(this);
        case Alive(char): charMap[char].alive;
        // TODO:
        case Recorded(event): false;
      });
  }
  
  public function runDayEvent(d:DayEvent):Void {
    switch (d) {
      case Action(a): runAction(a);
    }
  }
  
  public function runAction(a:Action):Void {
    switch (a) {
      case ReadAbout(t):
      case TalkTo(c):
      dayPos++;
      talkTo(c);
      case _:
    }
  }
  
  public function runDialogueAction(
    a:DialogueAction, st:String, po:Int
  ):{nst:String, npo:Int, stop:Bool} {
    return (switch (a) {
        case SP(txt, snd) | S(txt, snd) | SO(_, txt, snd):
        txt.split("\n").map(m -> Main.ui.write('$$B$m'));
        {nst: st, npo: po + 1, stop: false};
        case Choice(cs):
        var ci = 1;
        for (c in cs) {
          Main.ui.write('$$B${ci}) ${c.txt}');
          ci++;
        }
        dialogueQueue.push(a);
        {nst: st, npo: po + 1, stop: false};
        case GoTo(res): {nst: res, npo: 0, stop: false};
        case Conditional(c, a):
        evalCond(c) ? runDialogueAction(a, st, po) : {nst: st, npo: po + 1, stop: false};
        case Wait(f):
        dialogueQueue.push(a);
        {nst: st, npo: po + 1, stop: true};
        case Pause:
        Main.ui.write("$B                    (click)");
        dialogueQueue.push(a);
        {nst: st, npo: po + 1, stop: true};
        case Sound(snd):
        {nst: st, npo: po + 1, stop: false};
      });
  }
  
  public function talkTo(c:String):Void {
    var char = charMap[c];
    Main.ui.portrait = char.portrait;
    Main.ui.write('# ${char.name}');
    state = TalkingTo(c, char.dialogue.start, 0);
  }
  
  public function nextDay():Void {
    dayNum++;
    dayPos = 0;
    talkTo("aim");
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
      dialogueQueue.shift();
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
      if (i < cs.length) {
        switch (state) {
          case TalkingTo(c, st, po):
          Main.ui.write('$$B                       (${i + 1})');
          state = TalkingTo(c, cs[i].res, 0);
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
      return true;
      case _:
    }
    return false;
  }
  
  public function tick():Void {
    if (dayNum == -1) {
      nextDay();
    }
    Main.ui.recording = false;
    Main.ui.portrait = -1;
    Main.ui.tapeAlt.setTo(false);
    switch (state) {
      case None:
      case TalkingTo(c, st, po):
      Main.ui.recording = true;
      Main.ui.portrait = charMap[c].portrait;
      if (dialogueQueue.length > 0) {
        switch (dialogueQueue[0]) {
          case Wait(n):
          case Pause:
          case Choice(_):
          Main.ui.tapeAlt.setTo(true);
          case _:
        }
      }
      while (dialogueQueue.length == 0) {
        var next = runDialogueAction(charMap[c].dialogue.states[st][po], st, po);
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
