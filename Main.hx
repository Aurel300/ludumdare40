import sk.thenet.app.*;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.asset.Sound as AssetSound;
import sk.thenet.app.asset.Trigger as AssetTrigger;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;

using sk.thenet.FM;
using sk.thenet.stream.Stream;

class Main extends Application {
  public static var consoleFont:Font;
  
  public function new() {
    super([
         Framerate(60)
        ,Optional(Window("", 400, 300))
        ,Surface(400, 300, 0)
        ,Assets([])
        ,Keyboard
        ,Mouse
        ,Console
        ,ConsoleRemote("localhost", 8001)
      ]);
    preloader = new DummyPreloader(this, "dummy");
    addState(new Dummy(this));
    mainLoop();
  }
}

class Dummy extends JamState {
  public function new(app) super("dummy", app);
  
  override public function tick() {
    ab.fill(Colour.RED);
  }
}
