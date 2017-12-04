package lib;

import haxe.ds.Vector;
import sk.thenet.anim.Bitween;
import sk.thenet.app.Asset;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.bmp.*;
import sk.thenet.bmp.manip.*;
import sk.thenet.geom.*;
import sk.thenet.graph.AStar;

using sk.thenet.FM;

class Fig {
  static var b_icons:Vector<Bitmap>;
  static var b_iconsSmall:Vector<Bitmap>;
  static var b_colours:Array<Colour> = [
       0xAAFFFFAA
      ,0xAAFF44AA
      ,0xCCFF4422
    ];
  
  public static function binds():Array<Asset> {
    return [new AssetBind(["interface"], (am, _) -> {
        var c = am.getBitmap("interface").fluent;
        b_icons = Vector.fromArrayCopy([
            for (col in b_colours) for (i in 0...4)
              c >> new Cut(160 + i * 16, 0, 16, 16) << new Recolour(col)
          ]);
        b_iconsSmall = Vector.fromArrayCopy([
            for (col in b_colours) for (i in 0...4)
              c >> new Cut(224 + i * 8, 0, 8, 8) << new Recolour(col)
          ]);
        false;
      })];
  }
  
  public var x:Float;
  public var y:Float;
  public var vx:Float;
  public var vy:Float;
  public var path:Array<Point2DI>;
  public var char:String;
  public var remove:Bool = false;
  public var textShow:Bitween;
  public var col:Colour;
  public var icon:Bitmap;
  public var iconSmall:Bitmap;
  
  public function new(from:String, to:String) {
    var refs:Vector<Point2DI> = new Vector(City.CW * City.CH);
    function at(ax:Int, ay:Int):Point2DI {
      var i = ax + ay * City.CW;
      if (!ax.withinI(0, City.CW - 1) || !ay.withinI(0, City.CH - 1)
          || !Main.city.walk[i]) {
        return null;
      }
      if (refs[i] == null) {
        refs[i] = new Point2DI(ax, ay);
      }
      return refs[i];
    }
    var a = Main.city.idMap[from].getPoint();
    var b = Main.city.idMap[to].getPoint();
    refs[a.x + a.y * City.CW] = a;
    refs[b.x + b.y * City.CW] = b;
    path = AStar.path(
         a, b, p -> (p.x - b.x).absI() + (p.y - b.y).absI(), (_, _) -> 1
        ,n -> [ for (off in [[-1, 0], [1, 0], [0, -1], [0, 1]])
            at(n.x + off[0], n.y + off[1])
          ].filter(p -> p != null)
      );
    x = a.x;
    y = a.y;
    vx = 0;
    vy = 0;
    textShow = new Bitween(90);
    char = "aim";
    col = b_colours[2];
    icon = b_icons[8];
    iconSmall = b_iconsSmall[8];
  }
  
  public function tick():Void {
    if (path.length == 0) {
      remove = true;
      return;
    }
    var tx = path[0].x + .5;
    var ty = path[0].y + .5;
    vx = (vx + (.01).negposF(x > tx, x < tx)).clampF(-.04, .04);
    vy = (vy + (.01).negposF(y > ty, y < ty)).clampF(-.04, .04);
    x += vx;
    y += vy;
    if (x.withinF(path[0].x + .2, path[0].x + .8)
        && y.withinF(path[0].y + .2, path[0].y + .8)) {
      path.shift();
    }
    if (textShow.isOn) {
      textShow.setTo(false);
    }
    textShow.tick();
  }
}
