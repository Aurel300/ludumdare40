package lib;

import haxe.ds.Vector;
import sk.thenet.bmp.*;
import sk.thenet.geom.*;
import sk.thenet.stream.bmp.*;
import sk.thenet.stream.prng.*;
import sk.thenet.plat.Platform;

using sk.thenet.FM;

class CityRen extends CRTRen {
  public var center:Point2DI; //?
  public var pointerX:Float = 0;
  public var pointerY:Float = 0;
  public var pointerShown:Bool = false;
  public var pointerTX:Float = 0;
  public var pointerTY:Float = 0;
  public var camX:Float = 0; // current camera position
  public var camY:Float = 0;
  public var camTX:Float = 25.0; // camera target
  public var camTY:Float = 25.0;
  
  public function new(x:Int, y:Int, w:Int, h:Int) {
    super(x, y, w, h);
    center = new Point2DI(wh, hh);
  }
  
  public function move(dx:Int, dy:Int):Void {
    var c = Math.cos(angle) * (1.2 / scale);
    var s = Math.sin(angle) * (1.2 / scale);
    camTX += c * dx + s * dy;
    camTY += -s * dx + c * dy;
  }
  
  public function pointer(x:Float, y:Float):Void {
    var c = Math.cos(-angle) / scale;
    var s = Math.sin(-angle) / scale;
    x -= wh + this.x;
    y -= hh + this.y;
    y /= pitch;
    pointerX = (-c * x + s * y) + camX;
    pointerY = (-s * x - c * y) + camY;
    pointerShown = true;
  }
  
  public function render(to:Bitmap):Void {
    if (camTX < 0) {
      camTX = camTX * .9;
    } else if (camTX > City.CW) {
      camTX = (camTX - City.CW) * .9 + City.CW;
    }
    if (camTY < 0) {
      camTY = camTY * .9;
    } else if (camTY > City.CH) {
      camTY = (camTY - City.CH) * .9 + City.CH;
    }
    camX = (camX * 10 + camTX) / 11;
    camY = (camY * 10 + camTY) / 11;
    //var oangle = angle;
    prerender();
    var vec = to.getVectorRect(x, y, w, h);
    if (pointerShown) {
      line(vec, 0x99FFFFFF, 0, 0, City.CW, 0, pointerX - camX, pointerY - camY, 0);
      line(vec, 0x99FFFFFF, 0, 0, -City.CW, 0, pointerX - camX, pointerY - camY, 0);
      line(vec, 0x99FFFFFF, 0, 0, 0, City.CH, pointerX - camX, pointerY - camY, 0);
      line(vec, 0x99FFFFFF, 0, 0, 0, -City.CH, pointerX - camX, pointerY - camY, 0);
      pointerShown = false;
    }
    for (b in Main.city.buildings) {
      renderBuilding(vec, co, si, b);
    }
    //angle = oangle;
    to.setVectorRect(x, y, w, h, vec);
    /*
    for (b in c.buildings) {
      if (b.id != null) {
        var bx = -co * (b.x - camX) + si * (b.y - camY);
        var by = (-si * (b.x - camX) - co * (b.y - camY)) * pitch;
        Main.consoleFont.render(to, bx.floor() + wh, by.floor() + hh, b.id);
      }
    }*/
  }
  
  public function renderBuilding(
    vec:Vector<Colour>, c:Float, s:Float, b:Building
  ):Void {
    if ((FM.prng.nextMod(100):Int) < (switch (b.type) {
        case Road: 20;
        case Park: 1;
        case _: 0;
      })) {
      b.seed = FM.prng.next();
    }
    b.prng.seed = b.seed;
    switch (b.type) {
      case Road:
      for (i in 0...10) {
        var s = new Point2DF(
             b.floors[0][0].x + (b.floors[0][2].x - b.floors[0][0].x) * b.prngen.nextFloat()
            ,b.floors[0][0].y
          );
        var e = new Point2DF(s.x, b.floors[0][2].y);
        line(vec, 0x99FF00FF, s.x, s.y, e.x, e.y, b.x - camX, b.y - camY, -2);
      }
      case Park:
      for (i in 0...30) {
        var s = new Point2DF(
             b.floors[0][0].x + (b.floors[0][2].x - b.floors[0][0].x) * b.prngen.nextFloat()
            ,b.floors[0][0].y + (b.floors[0][2].y - b.floors[0][0].y) * b.prngen.nextFloat()
          );
        var e = new Point2DF(s.x + b.prngen.nextFloat() - .5, s.y + b.prngen.nextFloat() - .5);
        line(vec, 0x6655FF00, s.x, s.y, e.x, e.y, b.x - camX, b.y - camY, 0);
      }
      case _:
      var bh = 0.0; // building height
      for (f in b.floors) {
        var col:Colour = b.col | (FM.prng.nextMod(0x20) << 24);
        for (i in 0...f.length) {
          var j = (i + 1) % f.length;
          line(vec, col, f[i].x, f[i].y, f[j].x, f[j].y, b.x - camX, b.y - camY, bh);
        }
        bh += scale * (1 - pitch);
      }
    }
  }
}
