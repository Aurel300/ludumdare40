package lib;

import sk.thenet.bmp.*;
import sk.thenet.geom.*;
import sk.thenet.stream.prng.*;

using sk.thenet.FM;

class Building {
  public static function make(
    x:Int, y:Int, s:Bitmap, sx:Int, sy:Int, id:String, type:BuildingType
  ):Building {
    var ret = new Building();
    ret.id = id;
    ret.type = type;
    if (id == ".") ret.type = Road;
    ret.x = x;
    ret.y = y;
    ret.xi = sx;
    ret.yi = sy;
    ret.w = s.width;
    ret.h = s.height;
    var bwh = s.width >> 1;
    var bhh = s.height >> 1;
    var vec = s.getVector();
    var ground:Array<Point2DF> = [];
    function box(x:Float, y:Float, w:Float, h:Float) {
      return [
           new Point2DF(x + 0, y + 0)
          ,new Point2DF(x + w, y + 0)
          ,new Point2DF(x + w, y + h)
          ,new Point2DF(x + 0, y + h)
        ];
    }
    if (vec[0].isTransparent) {
      ret.lShape = true;
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
      ret.lShape = false;
      ground = box(0, 0, s.width, s.height);
    }
    ret.x += bwh;
    ret.y += bhh;
    for (g in ground) {
      g.addM(new Point2DF(-bwh, -bhh));
    }
    function groundS(scale:Float) {
      return [ for (g in ground) g.scaleC(scale) ];
    }
    ret.col = 0x9900FF00;
    switch (ret.type) {
      case Normal | Cell | Power:
      ret.floors = (switch (ret.id) {
          case "th":
          [ground, ground, ground, groundS(1.05), ground, groundS(1.05),
            ground, groundS(1.05), ground, groundS(1.05), ground, groundS(1.05),
            ground, groundS(.8), groundS(.5)];
          case "ai":
          [ground, ground, ground, box(2, 2, 2, 2), box(2, 2, 2, 2), box(2, 2, 2, 2), box(2, 2, 2, 2)];
          case "d1p":
          [ for (i in 0...9) groundS(i % 2 == 0 ? .7 : 1) ];
          case "d8p" | "d7p" | (_.charAt(0) => "a"):
          [ground, ground, ground, ground, ground];
          case "mrf":
          [ for (i in 0...10) groundS(1.0 + i / 50.0) ];
          case "mrs" | "mrts" | (_.charAt(0) => "f"):
          [ground, ground, ground, ground, box(0, 0, 1, 1)];
          case "d2p" | "d5p" | "d6p" | (_.substr(0, 2) => "gs"):
          [ground, ground, groundS(.2), groundS(.2), ground];
          case _.substr(0, 2) => "pp":
          ret.col = 0x99AA3300;
          [ground, ground, groundS(.5), groundS(.5), groundS(.5)];
          case _.substr(0, 4) => "cell":
          ret.col = 0x99AADD00;
          [ground, ground, box(1, 1, 1, 1), box(1, 1, 1, 1), box(1, 1, 1, 1),
            box(1, 1, 1, 1), box(1, 1, 1, 1), box(1, 1, 1, 1)];
          case _.charAt(0) => "c":
          [ground, ground, groundS(.8), groundS(.8), groundS(.6), groundS(.6)];
          case _:
          [ground, ground];
        });
      case _: ret.floors = [ground];
    }
    return ret;
  }
  
  public var id:String;
  public var type:BuildingType;
  public var x:Float;
  public var y:Float;
  public var xi:Int;
  public var yi:Int;
  public var w:Int;
  public var h:Int;
  public var floors:Array<Array<Point2DF>>;
  public var col:Colour;
  public var seed:UInt;
  public var prng:ParkMiller;
  public var prngen:Generator;
  public var name:String;
  public var dis:String;
  public var prefix:String;
  public var lShape:Bool;
  
  public function new() {
    seed = FM.prng.next();
    prng = new ParkMiller(seed);
    prngen = new Generator(prng);
  }
  
  public function createPrefix():Void {
    prefix = name + "\n" + dis + " district\n\n";
  }
  
  public function getPoint():Point2DI {
    var pos = lShape || FM.prng.nextBool();
    if (FM.prng.nextBool()) {
      return new Point2DI(xi + (pos ? w : -1), yi + FM.prng.nextMod(h));
    } else {
      return new Point2DI(xi + FM.prng.nextMod(w), yi + (pos ? h : -1));
    }
  }
}
