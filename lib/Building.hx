package lib;

import sk.thenet.bmp.*;
import sk.thenet.geom.Point2DF;
import sk.thenet.stream.prng.*;

using sk.thenet.FM;

class Building {
  public static function make(
    x:Int, y:Int, s:Bitmap, id:String, type:BuildingType
  ):Building {
    var ret = new Building();
    ret.id = id;
    ret.type = type;
    if (id == ".") ret.type = Road;
    ret.x = x;
    ret.y = y;
    var vec = s.getVector();
    var ground:Array<Point2DF> = [];
    if (vec[0].isTransparent) {
      var sx = 0;
      for (x in 1...s.width) {
        if (!vec[x].isTransparent) {
          sx = x;
          break;
        }
      }
      var sy = 0;
      for (y in 1...s.height) {
        if (!vec[y * s.width].isTransparent) {
          sy = y;
          break;
        }
      }
      ret.x -= sx;
      ground = [
           new Point2DF(sx, sy)
          ,new Point2DF(sx, 0)
          ,new Point2DF(s.width, 0)
          ,new Point2DF(s.width, s.height)
          ,new Point2DF(0, s.height)
          ,new Point2DF(0, sy)
        ];
    } else {
      ground = [
           new Point2DF(0, 0)
          ,new Point2DF(s.width, 0)
          ,new Point2DF(s.width, s.height)
          ,new Point2DF(0, s.height)
        ];
    }
    ret.floors = [ground, ground, ground, ground, ground];
    return ret;
  }
  
  public var id:String;
  public var type:BuildingType;
  public var x:Float;
  public var y:Float;
  public var floors:Array<Array<Point2DF>>;
  public var seed:UInt;
  public var prng:ParkMiller;
  
  public function new() {
    seed = FM.prng.next();
    prng = new ParkMiller(seed);
    /*
    this.x = x;
    this.y = y;
    var s:Float = 2.0 + FM.prng.nextMod(3);
    x += FM.prng.nextMod(2);
    y += FM.prng.nextMod(2);
    floors = [ for (i in 0...4 + FM.prng.nextMod(6))
        [new Point2DF(-s, -s), new Point2DF(s, -s), new Point2DF(s, s), new Point2DF(-s, s)]
      ];
    */
  }
}
