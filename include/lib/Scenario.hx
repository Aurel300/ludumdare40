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
    return new Story([
        /* 1  */  new Day([Action(TalkToState("aim", "intro"))])
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
            "intro" => [
                 S("Hello, AICO.\n"
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
      ]);
  }
}
