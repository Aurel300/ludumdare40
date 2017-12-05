package lib;

import sk.thenet.app.*;

class SIntro extends JamState {
  public function new(app) super("intro", app);
  
  override public function tick() {
    Music.tick();
    ab.fill(Pal.colours[0]);
    UI.f_fonts[0].render(ab, 5, 5, "Ignorance is Bliss.\nA game made for LDJAM 40 in 72 hours\nBy Aurel B%l& and eidovolta.\n\n<thenet.sk>\n\n\n\nClick to start the game.");
  }
  
  override public function mouseUp(_, _) {
    st("game");
  }
}
