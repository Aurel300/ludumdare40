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
        + [ for (id in ids) id == "?" ? "$C - Unknown person" : '$$C - %name.${id}%'].join("\n") + "]");
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
          +'$$C FROM $$DCELL-${from == 0 ? "UNK" : "" + from}$$C - TO $$DCELL-${to == 0 ? "UNK" : "" + to}$$C]'
        ));
    }
    return new Story([
        /* 1  */  new Day([
             Lock(true)
            ,Sound("IntroRetarded")
            ,At(200, Lock(false))
            ,Action(TalkToState("aim", "intro"))
            ,Music("DroneChill")
            ,At(400, CharMove("d3", "d3p", "gs4"))
            ,At(1500, CharMove("d3", "gs4", "d3p"))
            ,At(1800, CharMove("d8", "d8p", "gs2"))
            ,At(3200, CharMove("d8", "gs2", "gs3"))
            ,At(3900, CharMove("d8", "gs3", "d8p"))
          ], 4000)
        /* 2  */ ,new Day([
             Music("HackerConversation")
            ,At(100, CharMove("d1", "d1p", "c3"))
            ,At(300, CharMove("d2", "d2p", "c3"))
            ,Conditional(
                 All([Location("d1", "c3"), Location("d2", "c3")])
                ,Meeting("c3", 300, 1800, TalkToState("d1", "bug-mm0")) // MM0
              )
            ,At(1800, Call("cell3", "d3", "d4", "call-mms1")) // MMS1
            ,At(2300, CharMove("d1", "c3", "d1p"))
            ,At(2320, CharMove("d2", "c3", "c2"))
            ,At(3200, CharMove("d2", "c2", "d2p"))
          ], 3600)
        /* 3  */ ,new Day([
             Music("DroneChill")
            ,At(800, Call("cell4", "d5", "d6", "call-mms2")) // MMS2
            ,At(1800, Call("cell1", "aim", "rl", "call-rmms")) // RMMS
            ,At(2300, CharMove("aim", "th", "c1"))
            ,At(2200, Call("cell2", "d8", "d1", "call-mms3")) // MMS3
            ,At(2900, CharMove("aim", "c1", "th"))
          ], 3600)
        /* 4  */ ,new Day([
             Music("HackerConversation")
            ,At(400, CharArmed("ml2", true))
            ,At(500, CharMove("ml2", "gs1", "d2p"))
            ,At(900, CharMove("d3", "d3p", "d5p"))
            ,At(1000, CharMove("d4", "d4p", "d5p"))
            ,Conditional(
                 All([Location("d3", "d5p"), Location("d4", "d5p")])
                ,Meeting("d5p", 300, 3100, TalkToState("d3", "bug-mm1")) // MM1
              )
            ,At(1900, CharMove("ml2", "d2p", "c2"))
            ,Conditional(
                 Location("ml2", "c2")
                ,Meeting("c2", 1900, 2500, TalkToState("ml2", "bug-mcm0"))//MCM0
              )
            ,At(2500, CharMove("ml2", "c2", "gs1"))
            ,At(3100, CharMove("d3", "d5p", "d4p"))
            ,At(3120, Call("cell1", "d1", "d2", "call-mms4")) // MMS4
            ,At(3140, CharMove("d4", "d5p", "d4p"))
          ], 5000)
        /* 5  */ ,new Day([
             Music("EasterEgg")
            ,At(1300, CharMove("d5", "d5p", "c1"))
            ,At(1600, CharMove("d6", "d6p", "c1"))
            ,Conditional(
                 All([Location("d5", "c1"), Location("d6", "c1")])
                ,Meeting("c1", 1600, 2400, TalkToState("d5", "bug-mm2")) // MM2
              )
            ,At(1620, CharMove("d5", "c1", "d5p"))
            ,At(1640, CharMove("d6", "c1", "d6p"))
            ,At(3350, CharMove("d8", "d8p", "gs4"))
            ,At(4150, CharMove("d1", "d1p", "gs4", 1.3))
            ,Conditional(
                 All([Location("d8", "gs4"), Location("d1", "gs4")])
                ,Meeting("gs4", 4150, 4700, TalkToState("d8", "bug-mm3")) // MM3
              )
            ,At(4700, CharMove("d8", "gs4", "d8p"))
            ,At(4700, CharMove("d1", "gs4", "d1p"))
          ], 5000)
        /* 6  */ ,new Day([
             Music("DroneChill")
            ,At(1100, CharMove("rl", "f3", "c1"))
            ,At(2400, CharMove("aim", "th", "c1"))
            ,Conditional(
                 All([Location("rl", "c1"), Location("aim", "c1")])
                ,Meeting("c1", 2400, 3800, TalkToState("aim", "bug-rmm")) // RMM
              )
            ,At(3300, CharMove("d1", "d1p", "gs2")) // "MM4"
            ,At(3800, CharMove("rl", "c1", "gs1"))
            ,At(4000, CharMove("aim", "c1", "th"))
            ,At(4800, CharMove("d1", "gs2", "d1p"))
          ], 5000)
        /* 7  */ ,new Day([
             Music("Investigation")
            ,At(900, Conditional(Alive("ml2"),
              Call("cell3", "rl", "ml2", "call-mcms2"))) // MCMS2
            ,At(1010, Conditional(Alive("ml2"),
              Call("cell3", "rl", "ml2", "call-mcms2-b"))) // MCMS2
          ], 5000)
        /* 8  */ ,new Day([
            At(900, Conditional(Not(Alive("ml2")),
              Call("cell3", "rl", "ml1", "call-mcms1"))) // MCMS1
          ], 5000)
        /* 9  */ ,new Day([
             Music("InvestigationOnToSomething")
            ,Conditional(
                 All([Alive("ml2")])
                ,At( 800, CharMove("rl", "f3", "c1"))
              )
            ,Conditional(
                 All([Location("rl", "c1"), Alive("ml2")])
                ,At(1800, CharMove("rl", "c1", "c3"))
              )
            ,Conditional(
                 All([Location("rl", "c3"), Alive("ml2")])
                ,At(2800, CharMove("rl", "c3", "mrf"))
              )
            ,Conditional(
                 All([Location("rl", "mrf"), Alive("ml2")])
                ,Meeting("mrf", 2800, 3800, TalkToState("rl", "bug-mcm2"))
                // MCM2
              )
          ], 5000)
        /* 10 */ ,new Day([
             Music("InvestigationGotEm")
            ,Conditional(
                 All([Not(Alive("ml2"))])
                ,At( 800, CharMove("rl", "f3", "c1"))
              )
            ,Conditional(
                 All([Location("rl", "c1"), Not(Alive("ml2"))])
                ,At(1800, CharMove("rl", "c1", "c3"))
              )
            ,Conditional(
                 All([Location("rl", "c3"), Not(Alive("ml2"))])
                ,At(2800, CharMove("rl", "c3", "mrf"))
              )
            ,Conditional(
                 All([Location("rl", "mrf"), Not(Alive("ml2"))])
                ,Meeting("mrf", 2400, 3800, TalkToState("rl", "bug-mcm1"))
                // MCM1
              )
          ], 5000)
        /* 11 */ ,new Day([
             Music("SynthWave1")
            ,CharArmed("ml1", true)
            ,CharArmed("ml2", true)
            ,CharArmed("ms", true)
            ,At(650, Music("Action1"))
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
            ,At(1100, Music("DroneChill"))
            // MWT1 / MWT2
          ], 5000)
        /* 12 */ ,new Day([
            // COUP
             Music("Action2")
            ,At(400, CharMove("ms", "mrts", "th", 2.0))
            ,At(400, CharMove("ms", "mrts", "th", 2.0))
            ,At(400, CharMove("ms", "mrts", "th", 2.0))
            ,At(400, CharMove("ms", "mrts", "th", 2.0))
            ,At(500, CharMove("ms", "mrts", "th", 2.0))
            ,At(500, CharMove("ms", "mrts", "th", 2.0))
            ,At(500, CharMove("ms", "mrts", "th", 2.0))
            ,Music("ActionChaos2")
            ,At(500, CharMove("ms", "mrts", "th", 2.0))
            ,At(600, CharMove("ms", "mrts", "th", 2.0))
            ,At(600, CharMove("ms", "mrts", "th", 2.0))
            ,At(600, CharMove("ms", "mrts", "th", 2.0))
            ,At(600, CharMove("ms", "mrts", "th", 2.0))
            ,At(700, CharMove("ms", "mrts", "th", 2.0))
            ,At(700, CharMove("ms", "mrts", "th", 2.0))
            ,At(700, Conditional(Alive("ml2"), CharMove("ml2", "mrts", "th", 2.0)))
            ,At(700, Conditional(Not(Alive("ml2")), CharMove("ml1", "mrts", "th", 2.0)))
            ,At(700, CharMove("rl", "mrts", "th", 2.0))
            ,Music("ActionChaos")
          ], 5000)
      ], [], [
        new Char("aim", "Grep Shamir", 0, [
            "idle" => 0
          ], new Dialogue("greet", [
            // calls
            "call-rmms" => [
                 callStart(null, null)
                ,Music("IntenseExo")
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
                ,Music("Investigation")
                ,SP("I would never have expected you!")
                ,S("Don't you do any kind of\nresearch before you meet\npeople?")
                ,SP("Times have been rough, my\nfriend. We can scarcely\nafford food.")
                ,S("Hah, what a glorius revolution.")
                ,SP("They were always like this.")
                ,S("So they say ...")
                ,S("As much as I love the security\nof our metropolice state,\nI want to know.")
                ,SP("What do you want to know?")
                ,S("Everything! We are living in a\nbubble. What is happening\noutside?")
                ,SP("Some of our friends were\noutside. It is not a pleasant\nsight.")
                ,S("Rather a single day of freedom\nthan years more with that\nfatso bossing me around.")
                ,SP("I heard he is quite liked ...")
                ,SP("By chefs and restaurant\nowners alike!")
                ,S("...")
                ,SP("$Cahem$D So. What of AICO?")
                ,S("I don't know ...")
                ,Music("InvestigationOnToSomething")
                ,SP("You don't know? I thought you\ncreated it?")
                ,S("'Cultivated' is a better word\nfor it.")
                ,SP("I see. What if it performs\ntoo well?")
                ,S("Maybe it will see our truth?")
                ,SP("Maybe...")
                ,bugInfo("c1")
              ]
            // ...
            ,"intro" => [
                 Seen("aim")
                ,Music("SynthWave1")
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
            ,"call-mcms2" => [
                 callStart(null, null)
                ,S("Is this Clip Mech?")
                ,SP("Who's askin'?")
                ,S("A man with some finances.")
                ,SP("Whaddaya want?")
                ,S("Not one for idle chatter,\nare you?")
                ,SP("I don't sell words!")
                ,S("Okay, okay, I ge--")
                ,callInfo(3, 0)
              ]
            ,"call-mcms2-b" => [
                 callStart(null, null)
                ,SP("What!")
                ,S("Shall we talk business?")
                ,SP("Make it quick this time.")
                ,S("Fine, fine. I need heavy, and I\nmean really heavy, infantry.")
                ,SP("How much?")
                ,S("A dozen should do it.\nIf they can be quick.")
                ,SP("Quicker than yer' wit.")
                ,S("Right. How much do you want?")
                ,SP("For a baker's dozen:\n12,000M wage p.p.\n"
                  +"30,000M casualty deposit p.p.\n3 x 5,000M squad lead bonus\n"
                  +"6,000M ...")
                ,SP("How heavy are we talkin'?")
                ,S("Well... Heavy enough to break\nLevel 4 auto-defenses.")
                ,SP("Hmph...\n9,000M gear p.p\nThat totals...\n")
                ,SP("267,000M + 360,000M casualties.")
                ,S("I'm convinced Mod would\nmake me a better offer.")
                ,SP("Then I'm convinced\nyer' calling the wrong number.")
                ,S("Hey, hey, just kidding!\nYou'll get your money.\nWhen can you be ready?")
                ,SP("3 days after the transfer.")
                ,S("Hey, not bad!")
                ,SP("Yeah, right. When do I collect?")
                ,S("I can fit you in Monday.")
                ,SP("Wonder if yer' tongue's so\nquick with the guns near you.")
                ,callInfo(3, 0)
              ]
            ,"call-mcms1" => [
                 callStart(null, null)
                ,S("Is this Mod Choke?")
                ,SP("Depends.")
                ,S("... depends?")
                ,SP("Can you afford it?")
                ,S("Straight to businesstalk.\nImpressive.")
                ,SP("Only poor people like the chat\nbefore.")
                ,S("On to business then!")
                ,SP("Smart man. Haha.")
                ,S("I need some really, really\nheavy infantry.")
                ,SP("Let me guess: Heavy enough\nfor some L4AD?")
                ,S("... Yes. How do you know?")
                ,SP("Your crafstmanship is famous,\nMr. R. Haha.")
                ,SP("I can get you what you need\nfor 300,000M.")
                ,SP("450,000M more for casualties.")
                ,S("That is a ridiculous price!")
                ,SP("Well luckily for me my only\ncompetent rival got himself\nlocked up ...")
                ,S("... 700,000M?")
                ,SP("I don't haggle, Mr. R.\nTake it or leave it.")
                ,SP("And we both know there is no\nleaving your craft.")
                ,S("Fine! 750,000M it is.")
                ,S("It'll be ready for you\non Tuesday.")
                ,SP("I'll be waiting. Haha.")
                ,callInfo(3, 0)
              ]
            ,"bug-mcm2" => [
                 bugStart(["rl", "ml2"])
                ,S("And here is your sum.")
                ,SP("Yer' a bit late.")
                ,S("I like to be careful.")
                ,S("And now you have yer'\npersonal army.")
                ,S("Well...\nEverything is ready now.\nSee you in the next government.")
                ,bugInfo("mrf")
              ]
            ,"bug-mcm1" => [
                 bugStart(["rl", "ml1"])
                ,S("As promised, here is your sum.\nRather heftier than I'd like.")
                ,SP("I'm sure you won't regret it.")
                ,SP("Besides, casualties happen\nvery rarely to us.")
                ,S("Amazing words of comfort.")
                ,S("Well...\nEverything is ready now.\nSee you in the next government.")
                ,bugInfo("mrf")
              ]
          ]), false, true)
        ,new Char("ml1", "Mod Choke", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => [S("?")]
          ]), false, true)
        ,new Char("ml2", "Clip Mech", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => [S("?")]
            ,"bug-mcm0" => [
                 bugStart(["ml2", "?"])
                ,SP("At last, Clip shows his\nugly mug.")
                ,S("...")
                ,SP("What? Not 'sellin' words' as\nyou put it so happily every\nsingle time?")
                ,S("...")
                ,SP("Oh, I enjoy having the upper\nhand for once.")
                ,SP("I could get used to this. In\nfact, I will:")
                ,SP("You will be the first person to\npay taxes on the Milton!")
                ,S("...")
                ,SP("Oh, is that not enough? Maybe I\nshould just ban you alto--")
                ,S("Look I'm sorry 'kay.")
                ,SP("You are sorry -- 'kay'? Do we\nspeak the same language?")
                ,S("...")
                ,SP("Fortunately for you the Milton\ndid not derail.")
                ,SP("Less fortunately for you, the\ncargo had to be jettisoned.")
                ,SP("If your short temper causes any\nmore trouble on the Milton you\nare done!")
                ,S("...")
                ,SP("Now, out of my face.")
                ,bugInfo("c2")
              ]
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
            ,"call-mms4" => [
                 callStart("d1", "d2")
                ,S("Hey - Route?")
                ,SP("...")
                ,S("I know you're still mad at me for Monday ...")
                ,SP("...")
                ,S("But I can make it up to you, I promise.")
                ,S("I got the money this time.")
                ,SP("... it's not about the money.")
                ,S("What is it then?")
                ,SP("It's ... ugh, never mind.")
                ,S("Let's have dinner at Isaa this Friday, what do you say?")
                ,SP("...")
                ,S("I'll be waiting for you.")
                ,callInfo(1, 4)
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
            ,"bug-mm1" => [
                 bugStart(["d3", "d4"])
                ,S("Hi!")
                ,SP("What's uuup my man!")
                ,S("So, what's new with you?")
                ,SP("Oh, you know. The usual.")
                ,S("Right, right, I can relate.")
                ,SP("Been doing this and that.")
                ,S("Haha! We're so alike!")
                ,SP("I know, right. Sometimes I wonder ...")
                ,SP("If there was someone listening to us ...")
                ,SP("Would they think we are just the most...")
                ,S("... completely ...")
                ,SP("... utterly ...")
                ,S("... stupidly ...")
                ,SP("... helluva ...")
                ,S("... totally ...")
                ,SP("... amazing people?")
                ,S("Heck yeah my dude.")
                ,bugInfo("d5p")
              ]
          ]))
        ,new Char("d4", "Boot Pisano", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => []
          ]))
        ,new Char("d5", "Mortimer Buffers", 0, ["idle" => 0], new Dialogue("greet", [
             "greet" => []
            ,"call-mms2" => [
                 callStart("d5", "d6")
                ,Music("ComfySong")
                ,S("Hi Infinity, it's Mort.")
                ,SP("Oh hey Mort. You're back from\nthe Milton Highway?")
                ,S("SHHush! ... jeeze, you and your\nbig mouth.")
                ,SP("What? You seriously think\nsomeone's listening to all\nthe phone lines?")
                ,SP("Puh-lease. Get real already!")
                ,S("Aw come on, Fini. You can't deny\nthe evidence.")
                ,SP("The - 'evidence'?")
                ,S("The evidence!")
                ,SP("Like what?")
                ,S("Well, like that huge complex\nnext to the town hall!")
                ,Music("NotSoComfySong")
                ,SP("What, some big warehouse is\nevidence for surveillance\nof the entire city?")
                ,S("'Some big warehouse', right.")
                ,Music("NotComfySong")
                ,S("A 'big warehouse' doesn't use\nas much electricity as the\nentirety of Manor!")
                ,SP("Where did you hear that from?")
                ,S("Well ... Ada told me.")
                ,Music("ComfySong")
                ,SP("Ah, theeere we go.\nAda 'Coredump' and her\ncrazy ideas.")
                ,S("She works at the Kasimov plant,\nat least there she has\nsome credibility.")
                ,SP("The Kasimov plant is in neither\nin Central nor in Manor.")
                ,SP("What you heard was just a\nsecond-hand urban myth,\nas always.")
                ,SP("You need to get out more, Mort.\nSpeaking of which, how was\nthe Milton--")
                ,S("Fini, please!")
                ,SP("Sheesh, fine. How was the\n'EMM' - 'AYTCH'?")
                ,S("The ... MH was fine. No delays,\nperfect service as always.")
                ,S("Considering how many shady\npeople you meet there\nI would have thought the\ngovs would close it already.")
                ,SP("You give them a bit too much\ncredit, I think.")
                ,S("I guess I like to think of Metro\nas more evil than it really is...")
                ,S("... Anyway.\nDinner this Thursday?")
                ,SP("Sure. Sushi as usual?")
                ,S("Of course. See you later.")
                ,Music("HackerConversation")
                ,callInfo(4, 2)
              ]
            ,"bug-mm2" => [
                 bugStart(["d5", "d6"])
                ,Music("ComfySong")
                ,SP("Hey Mort!")
                ,S("Oh hi Fini.")
                ,Wait(50)
                ,S("These sushi never disappoint.")
                ,SP("Yeah, considering they are\nsynthetic, it really is\npretty good.")
                ,Music("NotSoComfySong")
                ,Wait(20)
                ,S("But... Have you ever even had\norganic sushi?")
                ,SP("Well no, they were all synths\nalready when I was\njust a baby.")
                ,S("Not much older myself so same...")
                ,SP("Yep...? Were you going\nsomewhere with that?")
                ,Music("ActionChaos")
                ,S("I was gonna stop myself but\nnow I can't - how can we\nknow whether this is what\nsushi tastes like?!")
                ,SP("But...")
                ,Wait(20)
                ,Music("ComfySong")
                ,SP("Can you repeat that, I didn't\nhear over the music.")
                ,S("I said...")
                ,Music("ActionChaos2")
                ,S("HOW CAN WE KNOW WHEHTER THIS\nIS WHAT SUSHI TASTES LIKE?!")
                ,SP("Oh.")
                ,SP("I mean...")
                ,Wait(40)
                ,Music("ComfySong")
                ,SP("Your mouth is full of it so you\nprobably can tell.")
                ,S("Fini...")
                ,S("You misunderstand.")
                ,SP("How so?")
                ,S("These are synthetic sushi,\nright?")
                ,SP("Yep.")
                ,S("And we have never had organic\nsushi, right?")
                ,SP("Yep.")
                ,S("So...")
                ,Music("IntenseExo")
                ,Wait(30)
                ,S("What I am saying is ...")
                ,Wait(30)
                ,Music("Action2")
                ,S("What if organic sushi tastes\ncompletely different\nfrom synth sushi!")
                ,SP("...")
                ,SP("Well?")
                ,S("Well what?")
                ,Music("ComfySong")
                ,SP("Well what if it does?")
                ,S("Isn't that ... weird?")
                ,SP("Well no, I still love\nthis taste.")
                ,S("Hm.")
                ,Music("HackerConversation")
                ,bugInfo("c1")
              ]
          ]))
        ,new Char("d6", "Infinity Render", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => []
          ]), true)
        ,new Char("d7", "Marlyn Nagle", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => []
          ]), true)
        ,new Char("d8", "Ada Core", 0, ["idle" => 0], new Dialogue("greet", [
             "greet" => []
            ,"call-mms3" => [
                 callStart("d8", "d1")
                ,S("Hi, Chip!")
                ,SP("Oh, Ada it's you, er, hi?")
                ,S("Come on Chip, don't be\nso distant.")
                ,Music("EndingSad")
                ,S("We used to be friends,\nremember?")
                ,Wait(60)
                ,SP("Yeah, right - sure.")
                ,S("Agh, whatever. I have something\nreally important to show you\nthough.")
                ,SP("Let me guess: incontrovertible\nevidence that Metro is virtual?")
                ,NP(S("What, no--"))
                ,SP("Or maybe there are AI overlords\nin Metro?")
                ,NP(S("Come oon--"))
                ,SP("Ah, no, I know - the one about\nthe mysterious Manor reactor!")
                ,S("That's just not fair, Chip. Why\ndo you always pick on me?")
                ,SP("I don't ... want to pick\non you, it's just ...")
                ,SP("Your ideas seem a bit\nfar-fetched lately, you know?")
                ,S("Can you even imagine how it\nfeels to be ridiculed by\neveryone you used to be\nfriends with?")
                ,Wait(40)
                ,SP("Look, Ada ... I'm sorry, okay?")
                ,S("Could you just give me\none more chance?")
                ,SP("Well, uh, sure. Promise to take\nit easy though?")
                ,Music("HackerConversation")
                ,S("Sure, whatever ... So, Thursday\nat Powerfoods?")
                ,SP("Right. See you later, Ada.")
                ,callInfo(2, 1)
              ]
            ,"bug-mm3" => [
                 bugStart(["d8", "d1"])
                ,SP("Sorry I'm late! Had some work\nat the bank.")
                ,S("No worries. The sofas here are\npretty comfy.")
                ,S("And you'll need to sit pretty\ntight for what I'm about\nto tell you.")
                ,SP("Ada, you promised--")
                ,S("No, Chip, you promised.")
                ,SP("Ugh, alright, I'll listen.")
                ,Music("IntenseExo")
                ,S("So... What do you know about\nthe CELL towers?")
                ,SP("... They're tall? Carry phone\nsignals?")
                ,S("That's right... They do. But\nthere is one special tower.")
                ,SP("A special tower.")
                ,S("It's a tower accessible only in\nyour Central district. You\nprobably use it for your\nphone calls.")
                ,SP("O-kay?")
                ,S("But it is different from the\nothers.")
                ,SP("$Csigh$B How is it different, Ada.")
                ,Music("DroneChill")
                ,S("It has an 'uplink'.")
                ,SP("An 'uplink'?")
                ,S("Yes. It is an archaic term for\ninterplanetary communications.")
                ,SP("But Metro is a bastion...\nWe shield ourselves from the\nrest of the world for a reason.")
                ,S("Is that what you believe? Well,\nokay, whatever.")
                ,S("We still have an uplink. Only\nhighly-priviledged agents\ncan use it.")
                ,S("We are not isolated for our\nown good. The upper\nechelons isolate us!")
                ,SP("You had me at echelons.")
                ,S("Come on, Chip! Think about it\na little.")
                ,S("Metro must keep some diplomatic\ncontacts with other towns.")
                ,SP("Why?")
                ,S("Because, otherwise they would\nget silly ideas, like,\nwhat if we take their\nshiny city?")
                ,SP("Take our shiny city?")
                ,S("Metaphorically speaking.")
                ,SP("Okay...")
                ,SP("Alright, so you say there is\nan uplink.")
                ,Music("IntenseExo")
                ,S("That's right.")
                ,SP("What of it?")
                ,S("Don't you see what this means?")
                ,SP("I guess not?")
                ,S("We are their slaves. Their little\npets. They control all\nthe information flow.")
                ,SP("'They' sound pretty evil. Only\nI seem to recall you talking\nabout some Hilton Road...")
                ,S("Milton Highway. And keep your\nvoice down...")
                ,S("So? Some people found a way\nout. The rest of us\nare still pretty stuck.")
                ,SP("But what else do you need?\nMetro provides everything:\njobs, food, water, power,\nentertainment.")
                ,S("How can you even say that\nwithout knowing what is\nout there?")
                ,SP("What if there is nothing\nout there?")
                ,SP("What if it is a wasteland?\nI've read some articles...")
                ,SP("They mentioned people used to\ndetonate nuclear reactors\noffensively.")
                ,S("No, Chip, they had\nnuclear bombs.")
                ,SP("Bombs? As in 'FlavourBombs'?")
                ,S("You really don't read at all,\ndo you...")
                ,Music("HackerConversation")
                ,bugInfo("gs4")
              ]
          ]), true)
        ,new Char("ms", "Militant", 0, ["idle" => 0], new Dialogue("greet", [
            "greet" => []
          ]))
      ]);
  }
}
