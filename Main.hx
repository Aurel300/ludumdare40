import sk.thenet.app.*;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.asset.Sound as AssetSound;
import sk.thenet.app.asset.Trigger as AssetTrigger;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;

import font.*;
import lib.*;

using sk.thenet.FM;
using sk.thenet.stream.Stream;

typedef CFont = font.FontNS;

class Main extends Application {
  public static var consoleFont:Font;
  public static var W:Int = 400;
  public static var H:Int = 300;
  
  public function new() {
    super([
         Framerate(60)
        ,Optional(Window("", 800, 600))
        ,Surface(400, 300, 1)
        ,Assets([
             CFont.embed()
            ,new AssetBind([CFont.ASSET_ID], (am, _) -> {
                consoleFont = CFont.initAuto(am, 0xFFFFFFFF, null, 0xFF999999);
                false;
              })
            ,Embed.getBitmap("city", "png/city.png")
            ,Embed.getBitmap("interface", "png/interface.png")
            ,Pal.bind()
            ,UI.bind()
          ])
        ,Keyboard
        ,Mouse
        ,Console
        //,ConsoleRemote("localhost", 8001)
      ]);
    preloader = new DummyPreloader(this, "dummy");
    addState(new Dummy(this));
    #if flash
    haxe.Log.setColor(0xFFFFFF);
    #end
    mainLoop();
  }
}

class Dummy extends JamState {
  public function new(app) super("dummy", app);
  
  var c:City;
  var ren:CityRen;
  var ui:UI;
  
  override public function to() {
    c = City.make(amB("city"));
    ren = new CityRen(400, 300);
    ui = new UI();
  }
  
  override public function tick() {
    ab.fill(Pal.colours[0]);
    ren.render(ab, c);
    ui.render(ab);
  }
}
