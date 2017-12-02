package lib;

import sk.thenet.bmp.*;
import sk.thenet.geom.*;
import sk.thenet.bmp.manip.*;

class City {
  static var CW = 66;
  static var CH = 60;
  
  public static function make(c:Bitmap):City {
    var ret = new City();
    var build = c.fluent >> new Cut(0, 0, 66, 60);
    var power = c.fluent >> new Cut(66, 0, 66, 60);
    var ids = [
         "road"
        ,"pp4"
        ,"dis"
        ,"c4"
        ,"park"
        ,"cell4"
        ,"ai"
        ,"d4p"
        ,"f2"
        ,"road"
        ,"cell1"
        ,"pp1"
        ,"mrts"
        ,"gs2"
        ,"gs3"
        ,"park"
        ,"th"
        ,"gs1"
        ,"pp3"
        ,"c3"
        ,"d1p"
        ,"c2"
        ,"park"
        ,"road"
        ,"park"
        ,"mrf"
        ,"c1"
        ,"park"
        ,"gs5"
        ,"d3p"
        ,"d2p"
        ,"d5p"
        ,"mrs"
        ,"road"
        ,"cell2"
        ,"cell3"
        ,"gs4"
        ,"pp2"
        ,"a6"
        ,"a5"
        ,"a4"
        ,"d7p"
        ,"a3"
        ,"a2"
        ,"a1"
        ,"park"
        ,"f3"
        ,"f1"
        ,"f4"
        ,"d6p"
        ,"park"
        ,"a10"
        ,"a9"
        ,"d8p"
        ,"a8"
        ,"a7"
        ,"a6"
        ,"a5"
        ,"f5"
        ,"pp5"
      ];
    var vec = build.getVector();
    var vi = 0;
    var bc = 0;
    for (y in 0...CH) for (x in 0...CW) {
      var col = vec[vi] & 0xFFFFFF;
      if (col == 0x0000FF) {
        ret.sea.push(new Point2DF(x, y));
      } else if (!vec[vi].isTransparent && col != 0x111111) {
        var shape = Flood.floodOpaque(vec, CW, CH, x, y, 0xFF111111, true);
        ret.buildings.push(Building.make(x, y, shape.fill, ids.shift(), switch (col) {
            case 0xFF00FF: Road;
            case 0x00FF00: Park;
            case _: Normal;
          }));
        build.blitAlpha(shape.fill, shape.minX, shape.minY);
        vec = build.getVector();
        bc++;
      }
      vi++;
    }
    trace('$bc buildings');
    return ret;
  }
  
  public var buildings:Array<Building> = [];
  public var sea:Array<Point2DF> = [];
  
  public function new() {}
}
