package lib;

import sk.thenet.app.*;

class SGame extends JamState {
  public function new(app) super("game", app);
  
  var ren:CityRen;
  var ui:UI;
  
  override public function to() {
    Music.play("EasterEgg");
    ren = new CityRen(33, 0, 334, 280);
    ui = new UI(ren);
  }
  
  override public function tick() {
    Music.tick();
    Main.story.tick();
    ab.fill(Pal.colours[0]);
    ui.render(ab);
  }
  
  override public function mouseDown(mx:Int, my:Int):Void {
    if (Main.story.mouseDown(mx, my)) {
      return;
    }
    ui.mouseDown(mx, my);
  }
  
  override public function mouseUp(mx:Int, my:Int):Void {
    if (Main.story.mouseUp(mx, my)) {
      return;
    }
    ui.mouseUp(mx, my);
  }
}
