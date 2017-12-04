package lib;

import sk.thenet.app.Asset;
import sk.thenet.app.asset.Binary;
import sk.thenet.app.asset.Bind;

class Scenario {
  public static function binds():Array<Asset> {
    if (Debug.REMOTE_SCENARIO) {
      return [
           new Binary("scenario", "../tools/dialogue/data.txt", null)
          ,new Bind(["scenario"], (am, _) -> {
              var data = am.getBinary("scenario");
              if (data != null) {
                var mod = haxe.Unserializer.run(data.toString());
                Main.story.days = mod.days;
                Main.story.flags = mod.flags;
                Main.story.chars = mod.chars;
                Main.story.reload();
              }
              false;
            })
        ];
    }
    return [];
  }
  
  public static function start():Story {
    function bugStart(ids:Array<String>):DialogueAction {
      return EvalS("$C[WIRETAP PHONOSTREAM, IDS:\n"
        + [ for (id in ids) '$$C - %name.${id}%'].join("\n") + "]");
    }
    function bugInfo(loc:String) {
      return DialogueAction.NP(DialogueAction.S("$C[PHONOSTREAM END]"));
    }
    function callStart(?from:String, ?to:String):DialogueAction {
      return EvalS(
           "$C[PHONE TRANSMISSION INTERCEPT\n"
          +"$C C-ER: " + (from != null ? '%vnum.$from%' : "#.#.#.#") + "\n"
          +"$C C-EE: " + (to != null ? '%vnum.$to%' : "#.#.#.#") + "]"
        );
    }
    function callInfo(from:Int, to:Int) {
      return DialogueAction.NP(DialogueAction.S(
           "$C[PHONE TRANSMISSION END\n"
          +'$$C FROM $$DCELL-${from}$$C - TO $$DCELL-${to}$$C]'
        ));
    }
    return new Story([
        /* 1  */  new Day([
             Music("DroneChill")
            //,Action(TalkToState("aim", "intro"))
            ,At(400, CharMove("d3", "d3p", "gs4"))
            ,At(1500, CharMove("d3", "gs4", "d3p"))
            ,At(1800, CharMove("d8", "d8p", "gs2"))
            ,At(3200, CharMove("d8", "gs2", "gs3"))
            ,At(3900, CharMove("d8", "gs3", "d8p"))
          ], 4000)
        /* 2  */ ,new Day([
             At(100, CharMove("d1", "d1p", "c3"))
            ,At(300, CharMove("d2", "d2p", "c3"))
            ,Conditional(
                 All([Location("d1", "c3"), Location("d2", "c3")])
                ,Meeting("c3", 300, 1800, TalkToState("d1", "bug-mm0")) // MM0
              )
            ,At(1800, Call("cell3", "d3", "d4", "call-mms1"))
            ,At(2300, CharMove("d1", "c3", "d1p"))
            ,At(2320, CharMove("d2", "c3", "c2"))
            ,At(3200, CharMove("d2", "c2", "d2p"))
          ], 3600)
        /* 3  */ ,new Day([
             At(800, Call("cell4", "d5", "d6", "call-mms2"))
            ,At(1800, Call("cell1", "aim", "rl", "call-rmms"))
            ,At(2300, CharMove("aim", "th", "c1"))
            ,At(2200, Call("cell2", "d8", "d1", "call-mms3"))
            ,At(2900, CharMove("aim", "c1", "th"))
          ], 3600)
        /* 4  */ ,new Day([
             At(400, CharArmed("ml2", true))
            ,At(500, CharMove("ml2", "gs1", "d2p"))
            ,At(900, CharMove("d3", "d3p", "d5p"))
            ,At(1000, CharMove("d4", "d4p", "d5p"))
            ,At(1900, CharMove("ml2", "d2p", "c2")) // MCM0
            ,At(2500, CharMove("ml2", "c2", "gs1")) // MM1
            ,At(3100, CharMove("d3", "d5p", "d4p"))
            ,At(3140, CharMove("d4", "d5p", "d4p"))
          ], 5000)
        /* 5  */ ,new Day([], 5000)
        /* 6  */ ,new Day([
             At(1100, CharMove("rl", "f3", "c1"))
            ,At(2400, CharMove("aim", "th", "c1")) // RMM
            ,Conditional(
                 All([Location("rl", "c1"), Location("aim", "c1")])
                ,Meeting("c1", 2400, 3800, TalkToState("aim", "bug-rmm")) // RMM
              )
            ,At(3800, CharMove("rl", "c1", "gs1"))
            ,At(4000, CharMove("aim", "c1", "th"))
          ], 5000)
        /* 7  */ ,new Day([
            At(900, Conditional(Alive("ml2"),
              Call("cell3", "rl", "ml2", "call-mcms2"))) // MCMS2
          ], 5000)
        /* 8  */ ,new Day([
            At(900, Conditional(Not(Alive("ml2")),
              Call("cell3", "rl", "ml1", "call-mcms1"))) // MCMS1
          ], 5000)
        /* 9  */ ,new Day([
            At(2800, CharMove("rl", "f3", "mrf")) // MCM2
          ], 5000)
        /* 10 */ ,new Day([
            At(2400, CharMove("rl", "f3", "mrf")) // MCM1
          ], 5000)
        /* 11 */ ,new Day([
             CharArmed("ml1", true)
            ,CharArmed("ms", true)
            ,At(600, CharMove("ml1", "mrf", "mrts", 2.0))
            ,At(700, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(800, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(840, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(860, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(880, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(890, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(900, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(900, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(910, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(920, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(940, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(980, CharMove("ms", "mrf", "mrts", 2.0))
            ,At(1050, CharMove("ms", "mrf", "mrts", 2.0))
            // MWT1 / MWT2
          ], 5000)
        /* 12 */ ,new Day([
            // COUP
             At(400, CharMove("ms", "mrts", "th", 2.0))
            ,At(400, CharMove("ms", "mrts", "th", 2.0))
            ,At(400, CharMove("ms", "mrts", "th", 2.0))
            ,At(400, CharMove("ms", "mrts", "th", 2.0))
            ,At(500, CharMove("ms", "mrts", "th", 2.0))
            ,At(500, CharMove("ms", "mrts", "th", 2.0))
            ,At(500, CharMove("ms", "mrts", "th", 2.0))
            ,At(500, CharMove("ms", "mrts", "th", 2.0))
            ,At(600, CharMove("ms", "mrts", "th", 2.0))
            ,At(600, CharMove("ms", "mrts", "th", 2.0))
            ,At(600, CharMove("ms", "mrts", "th", 2.0))
            ,At(600, CharMove("ms", "mrts", "th", 2.0))
            ,At(700, CharMove("ms", "mrts", "th", 2.0))
            ,At(700, CharMove("ms", "mrts", "th", 2.0))
            ,At(700, CharMove("ml1", "mrts", "th", 2.0))
            ,At(700, CharMove("rl", "mrts", "th", 2.0))
          ], 5000)
      ], [], [
        new Char("aim", "Grep Shamir", 0, [
            "idle" => 0
          ], new Dialogue("greet", [
            // calls
            "call-rmms" => [
                 callStart(null, null)
                ,S("Hello, is this the\n"
                  +"'white craftsman'?")
                ,SP("Could be, could be ...")
                ,S("I have something that might\n"
                  +"interest you greatly.")
                ,NP(SP("Oh yeah? I am not buying anyth--"))
                ,S("Oh no, quite the opposite,\n"
                  +"I assure you!")
                ,SP("Are we talking charity here?")
                ,S("A lot of it. It is time your\n"
                  +"craft was pushed to its goal.")
                ,S("People are becoming restless.")
                ,SP("Hm...\n"
                  +"Where shall we discuss this?")
                ,S("Let's get some fresh fish,\n"
                  +"right under their noses.")
                ,S("Friday sounds good.")
                ,SP("Understood. Take care,\n"
                  +"... fellow craftsman.")
                ,callInfo(1, 3)
              ]
            // bugs
            ,"bug-rmm" => [
                 bugStart(["aim", "rl"])
                ,bugInfo("c3")
              ]
            // ...
            ,"intro" => [
                 Seen("aim")
                ,S("Hello, AICO.\n"
                  +"Welcome on-line!")
                ,NP(S("Can you see me?\n"
                  +"Do you understand me?"))
                ,Choice([
                     {txt: "YES", res: "intro", label: "understand"}
                    ,{txt: "NO", res: "no-understand"}
                  ])
                ,Label("understand")
                ,S("Good. I am Grep, your AIM.\n"
                  +"(AI Manager)")
                ,S("You have been brought on-line\n"
                  +"to investigate a possible revolt.")
                ,NP(S("Should I brief you on the\n"
                  +"situation? $C[tutorial recommended]"))
                ,Choice([
                     {txt: "YES", res: "intro", label: "tutorial"}
                    ,{txt: "NO", res: "intro", label: "skip-tutorial"}
                  ])
                ,Label("tutorial")
                ,S("The mayor received an anonymous\n"
                  +"tip and given the circumstances\n"
                  +"you are our best hope.")
                ,S("You will be able to consult the\n"
                  +"tapes and logs of the entire\n"
                  +"city.")
                ,S("The laws prohibit us from doing\n"
                  +"this ourselves. Although you are\n"
                  +"somewhat experimental, you will\n"
                  +"remain morally neutral, I hope.")
                ,S("We are currently communicating\n"
                  +"over videophone link. During your\n"
                  +"investigations you will need to\n"
                  +"interrogate your suspects.")
                ,S("You have a list of contacts\n"
                  +"with videophone link numbers.")
                ,NP(S("You know how to make choices\n"
                  +"when needed already:"))
                ,Choice([
                     {txt: "YES", res: "intro", label: "choices-yes"}
                    ,{txt: "NO", res: "intro", label: "choices-no"}
                  ])
                ,Label("choices-no")
                ,S("See, that was a choice.")
                ,S("(I don't recall you having\n"
                  +"a flippancy chip ...)")
                ,Label("choices-yes")
                ,S("Any conversation you have is\n"
                  +"$Dautomatically recorded$B, including\n"
                  +"this one. You can review your\n"
                  +"recordings at a later point if\n"
                  +"you need to.")
                ,S("When talking to people, you get\n"
                  +"the option to $Dsend them tapes$B.")
                ,S("Use this to provide evidence of\n"
                  +"your findings.")
                ,S("But be careful: you will get in\n"
                  +"trouble for sending the wrong\n"
                  +"tape to the wrong person!")
                ,S("Outside of conversations you\n"
                  +"will be navigating the city.")
                ,S("Move around by $Dholding down\n"
                  +"the $Dleft button$B on your virtual\n"
                  +"AI pointing device.")
                ,S("$DClick buildings$B to examine\n"
                  +"them - then proceed to read\n"
                  +"the $Dlogs$B, watch $Dtapes$B, or\n"
                  +"activate the $Dsentinel$B.")
                ,S("The sentinel automatically\n"
                  +"arrests any person that you\n"
                  +"marked as dangerous when they\n"
                  +"enter the building. Use wisely.")
                ,S("That is all.")
                ,NP(S("Would you like me to repeat\n"
                  +"my briefing?"))
                ,Choice([
                     {txt: "YES", res: "intro", label: "tutorial"}
                    ,{txt: "NO", res: "intro", label: "skip-tutorial"}
                  ])
                ,Label("skip-tutorial")
                ,S("Now that you know about\n"
                  +"the situation, you should talk\n"
                  +"to the mayor.")
              ]
            ,"no-understand" => [
                 S("Oh ...")
                ,S("You were our last hope...")
                ,Ending("shutdown-1")
              ]
            ,"greet" => [
                S("Hello.")
              ]
          ]))
        ,new Char("may", "Roy Bezier", 1, [
            "idle" => 0
          ], new Dialogue("greet", [
            "greet" => [
                 S("Well hello there.")
              ]
          ]))
        ,new Char("rl", "Arin Robotka", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => [S("?")]
          ]), false, true)
        ,new Char("ml1", "Clip Mech", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => [S("?")]
          ]), false, true)
        ,new Char("ml2", "Mod Choke", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => [S("?")]
          ]), false, true)
        
        ,new Char("d1", "Chip Babbage", 0, ["idle" => 0], new Dialogue("greet", [
             "greet" => []
            ,"bug-mm0" => [
                 bugStart(["d1", "d2"])
                ,S("Lovely weather we're having.")
                ,SP("Did you bring the money?")
                ,S("Relax, there is plenty of time!")
                ,SP("Did you forget?!")
                ,S("Money, money, money.\nIt's always about the money\nwith you.")
                ,SP("...")
                ,S("... Okay, maybe I forgot.")
                ,SP("I knew it!")
                ,S("Wait, don't go!")
                ,bugInfo("c3")
              ]
          ]))
        ,new Char("d2", "Nut Router", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => []
          ]))
        ,new Char("d3", "Bug Cobalt", 0, ["idle" => 0], new Dialogue("greet", [
             "greet" => []
            ,"call-mms1" => [
                 callStart("d3", "d4")
                ,S("Hey there, Boot.")
                ,SP("Bug, what's up?")
                ,S("Oh, not much. I got a week off,\nso we could get coffee\nor something.")
                ,SP("Right, let me think...")
                ,SP("How's Wednesday sound?")
                ,S("Yep, that's great. Listen, my\nphone is dying, so see you at\nNeo-coffee!")
                ,SP("Sure, talk to you later.")
                ,callInfo(3, 4)
              ]
          ]))
        ,new Char("d4", "Boot Pisano", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => []
          ]))
        ,new Char("d5", "Mortimer Buffers", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => []
          ]))
        ,new Char("d6", "Infinity Render", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => []
          ]), true)
        ,new Char("d7", "Marlyn Nagle", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => []
          ]), true)
        ,new Char("d8", "Ada Core", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => []
          ]), true)
        ,new Char("ms", "Militant", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => []
          ]))
      ]);
  }
}
