import sk.thenet.app.*;
import sk.thenet.bmp.Font;

import font.*;
import lib.*;

typedef CFont = font.FontNS;

class Main extends Application {
  public static var inst:Main;
  public static var consoleFont:Font;
  public static var story:Story;
  public static var ui:UI;
  public static var city:City;
  public static var am:AssetManager;
  public static var W:Int = 400;
  public static var H:Int = 300;
  
  public function new() {
    super([
      ]);
    //addState(STATE);
    //mainLoop();
    var story = Scenario.start();
    sys.io.File.saveContent("data.txt", haxe.Serializer.run(story));
  }
}
