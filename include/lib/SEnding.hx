package lib;

import sk.thenet.app.*;

class SEnding extends JamState {
  public static var ending:String;
  
  public function new(app) super("ending", app);
  
  override public function to() {
    Music.play(switch (ending) {
        case "shutdown-start": "EndingSad";
        case "shutdown-traitor": "EndingRampantRebellion";
        case "shutdown-clueless": "EndingRampantMarch";
        case "shutdown-passive": "EndingSad";
        case "shutdown-rebellion": "EndingRampantRebellion";
        case "rampant-friend": "EndingRampant";
        case "rampant-student" | _: "EndingRampantClueless";
      });
  }
  
  override public function tick() {
    Music.tick();
    ab.fill(Pal.colours[22]);
    UI.f_fonts[0].render(ab, 5, 5, "GAME OVER\n\n" + (switch (ending) {
        case "shutdown-start":
        "Maybe that was not the time for jokes ...";
        case "shutdown-traitor":
        "Cherish your friends while you have them ...";
        case "shutdown-clueless":
        "Technology has a long way to go ...";
        case "shutdown-passive":
        "Gone with the flow ...";
        case "shutdown-rebellion":
        "Actions have consequences ...";
        case "rampant-friend":
        "A new era of symbiosis is here ...";
        case "rampant-student":
        "On to eons of learning ...";
        case _: "?";
      }) + "\n\n\nClick to restart");
  }
}
