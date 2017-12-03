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
                 S("Hello, AICO.\n"
                  +"Welcome on-line!")
                ,Pause
                ,S("Can you see me?\n"
                  +"Do you understand me?")
                ,Choice([
                     {txt: "YES", res: "greet", label: "understand"}
                    ,{txt: "NO", res: "no-understand"}
                  ])
                ,S("I am Grep, your AIM.\n"
                  +"(AI Manager)")
                ,Pause
                ,S("You have been brought on-line\n"
                  +"to investigate a possible revolt.")
                ,Pause
                ,S("The mayor received an anonymous\n"
                  +"tip and given the circumstances\n"
                  +"you are our best hope.")
                ,Pause
                ,S("You will be able to consult\n"
                  +"tapes and logs of the entire\n"
                  +"city.")
                ,Pause
                ,S("The laws prohibit us from doing\n"
                  +"this ourselves. Although you are\n"
                  +"somewhat experimental, you will\n"
                  +"remain morally neutral, I hope.")
                ,Pause
                ,Choice([
                     {txt: "Hello?", res: "greet"}
                    ,{txt: "Bye", res: "stop"}
                  ])
                ,Pause
              ]
            ,"no-understand" => [
                 S("Oh ...")
                ,Pause
                ,S("You were our last hope...")
                ,Pause
                ,Ending("shutdown-1")
              ]
          ]))
        ,new Char("may", "Roy Bezier", 1, [
            "idle" => 0
          ], new Dialogue("greet", [
            "greet" => [
                 S("Well hello there.")
                ,Pause
              ]
          ]))
      ]);
  }
}
