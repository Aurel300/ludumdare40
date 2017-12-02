package lib;

import haxe.ds.Vector;
import sk.thenet.bmp.*;
import sk.thenet.geom.*;
import sk.thenet.stream.bmp.*;
import sk.thenet.stream.prng.*;
import sk.thenet.plat.Platform;

using sk.thenet.FM;

class CityRen {
  public var crtEnable:Bool = false;
  public var crt:Float = .35;
  
  public var w:Int; // render size?
  public var h:Int;
  public var wh:Int;
  public var hh:Int;
  public var center:Point2DI;
  
  public var angle:Float = Math.PI; // camera angle
  public var scale:Float = 5;
  public var pitch:Float = .5; //.92;
  public var camX:Float = 0; // current camera position
  public var camY:Float = 0;
  public var camTX:Float = 25.0; // camera target
  public var camTY:Float = 25.0;
  public var xar:Int = 0; // x artefact
  public var xarPh:Int = 0;
  
  public function new(w:Int, h:Int) {
    this.w = w;
    this.h = h;
    wh = w >> 1;
    hh = h >> 1;
    center = new Point2DI(wh, hh);
  }
  
  public function render(to:Bitmap, c:City):Void {
    camX = (camX * 10 + camTX) / 11;
    camY = (camY * 10 + camTY) / 11;
    camTX = 30; // Platform.mouse.x;
    camTY = Platform.mouse.y;
    //pitch = Platform.mouse.x / 100;
    scale = Platform.mouse.x / 100;
    xarPh++;
    xarPh %= 4;
    var co = Math.cos(angle + (FM.prng.nextMod(100) == 0 ? .2 : 0)) * scale;
    var si = Math.sin(angle + (FM.prng.nextMod(100) == 0 ? .5 : 0)) * scale;
    angle += .01;
    //pitch = angle % 1.0;
    //angle = -Math.PI;
    var oangle = angle;
    var vec = to.getVector();
    var vw = to.width;
    var vh = to.height;
    if (xarPh == 0) {
      xar = FM.prng.nextMod(vw);
    }
    for (b in c.buildings) {
      renderBuilding(vec, vw, vh, co, si, b);
    }
    angle = oangle;
    to.setVector(vec);
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
    vec:Vector<Colour>, vw:Int, vh:Int, c:Float, s:Float, b:Building
  ):Void {
    //angle += .01;
    var vi = 0;
    var bx = -c * (b.x - camX) + s * (b.y - camY);
    var by = (-s * (b.x - camX) - c * (b.y - camY)) * pitch;
    inline function line(
      col:Colour, ox1:Float, oy1:Float, ox2:Float, oy2:Float, h:Float
    ):Void {
      var x1 = -c * ox1 + s * oy1 + wh + bx;
      var y1 = (-s * ox1 - c * oy1) * pitch + hh + by - h;
      var x2 = -c * ox2 + s * oy2 + wh + bx;
      var y2 = (-s * ox2 - c * oy2) * pitch + hh + by - h;
      var p1 = new Point2DI(x1.floor(), y1.floor());
      var p2 = new Point2DI(x2.floor(), y2.floor());
      if (crtEnable) {
        var gx1 = (x1 /= vw) - .5;
        var gy1 = (y1 /= vh) - .5;
        var gx2 = (x2 /= vw) - .5;
        var gy2 = (y2 /= vh) - .5;
        p1.x = ((x1 - crt * (gx1 * gx1 * gx1)) * vw).floor();
        p1.y = ((y1 - crt * (gy1 * gy1 * gy1)) * vh).floor();
        p2.x = ((x2 - crt * (gx2 * gx2 * gx2)) * vw).floor();
        p2.y = ((y2 - crt * (gy2 * gy2 * gy2)) * vh).floor();
      }
      for (p in Bresenham.getCurve(p1, p2)) {
        if (p.x >= xar && p.x < xar + 4) p.y += 2;
        if (p.x >= 0 && p.x < vw && p.y >= 0 && p.y < vh) {
          vi = p.x + p.y * vw;
          vec[vi] = col.blendWith(vec[vi] & (p.y % 2 == 0 ? 0xFFFFFFFF : 0x7FFFFFFF));
        }
      }
    }
    if ((FM.prng.nextMod(100):Int) < (switch (b.type) {
        case Road: 20;
        case Park: 1;
        case _: 0;
      })) {
      b.seed = FM.prng.next();
    }
    b.prng.seed = b.seed;
    var bp = new Generator(b.prng);
    switch (b.type) {
      case Road:
      for (i in 0...10) {
        var s = new Point2DF(
             b.floors[0][0].x + (b.floors[0][2].x - b.floors[0][0].x) * bp.nextFloat()
            ,b.floors[0][0].y
          );
        var e = new Point2DF(s.x, b.floors[0][2].y);
        line(0x99FF00FF, s.x, s.y, e.x, e.y, -2);
      }
      case Park:
      for (i in 0...30) {
        var s = new Point2DF(
             b.floors[0][0].x + (b.floors[0][2].x - b.floors[0][0].x) * bp.nextFloat()
            ,b.floors[0][0].y + (b.floors[0][2].y - b.floors[0][0].y) * bp.nextFloat()
          );
        var e = new Point2DF(s.x + bp.nextFloat() - .5, s.y + bp.nextFloat() - .5);
        line(0x6655FF00, s.x, s.y, e.x, e.y, 0);
      }
      case _:
      var h = 0.0; // height
      for (f in b.floors) {
        var col:Colour = b.col | (FM.prng.nextMod(0x20) << 24);
        for (i in 0...f.length) {
          var j = (i + 1) % f.length;
          line(col, f[i].x, f[i].y, f[j].x, f[j].y, h);
        }
        h += scale * (1 - pitch);
      }
    }
  }
}
