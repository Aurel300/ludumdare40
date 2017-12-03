package lib;

import sk.thenet.app.*;

class SEnding extends JamState {
  public static var ending:String;
  
  public function new(app) super("ending", app);
  
  override public function to() {
    Music.play("EndingSad");
  }
  
  override public function tick() {
    Music.tick();
    ab.fill(Pal.colours[22]);
    UI.f_fonts[0].render(ab, 5, 5, "GAME OVER\n\n" + (switch (ending) {
        case "shutdown-1":
        "Maybe that was not the time for jokes ...";
        case _: "?";
      }) + "\n\n\nClick to restart");
  }
}
