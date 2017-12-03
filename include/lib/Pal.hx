package lib;

import haxe.ds.Vector;
import sk.thenet.FM;
import sk.thenet.app.asset.Trigger as AssetTrigger;
import sk.thenet.bmp.*;
import sk.thenet.bmp.manip.*;

class Pal {
  public static var colours:Vector<Colour>;
  
  public static function bind():AssetTrigger {
    return new AssetTrigger("pal", ["interface"], (am, _) -> {
        var f = am.getBitmap("interface");
        colours = Vector.fromArrayCopy([
            for (y in 0...3) for (x in 0...8) f.get(128 + x * 4, y * 3)
          ]);
        false;
      });
  }
}
