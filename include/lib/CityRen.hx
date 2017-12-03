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
  
  public var x:Int;
  public var y:Int;
  public var w:Int; // render size
  public var h:Int;
  public var wh:Int;
  public var hh:Int;
  public var center:Point2DI;
  
  public var angle:Float = 0; // camera angle
  public var angleT:Float = .7;
  public var scale:Float = 12;
  public var scaleT:Float = 12;
  public var zoomLevel:Int = 0;
  public var pitch:Float = 0; //.92;
  public var pitchT:Float = .5;
  public var pitchLevel:Int = 1;
  public var camX:Float = 0; // current camera position
  public var camY:Float = 0;
  public var camTX:Float = 25.0; // camera target
  public var camTY:Float = 25.0;
  public var xar:Int = 0; // x artefact
  public var xarPh:Int = 0;
  public var boundX1:Float;
  public var boundX2:Float;
  public var boundY1:Float;
  public var boundY2:Float;
  
  public function new(x:Int, y:Int, w:Int, h:Int) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    wh = w >> 1;
    hh = h >> 1;
    boundX1 = w * -.2;
    boundX2 = w * 1.2;
    boundY1 = h * -.2;
    boundY2 = h * 1.2;
    center = new Point2DI(wh, hh);
  }
  
  public function zoomIn():Void {
    zoomLevel++;
    if (zoomLevel > 3) zoomLevel = 3;
    zoomScale();
  }
  
  public function zoomOut():Void {
    zoomLevel--;
    if (zoomLevel < 0) zoomLevel = 0;
    zoomScale();
  }
  
  public function zoomScale():Void {
    scaleT = (switch (zoomLevel) {
        case 0: 12;
        case 1: 20;
        case 2: 30;
        case _: 48;
      });
  }
  
  public function pitchUp():Void {
    pitchLevel++;
    if (pitchLevel > 3) pitchLevel = 3;
    pitchScale();
  }
  
  public function pitchDown():Void {
    pitchLevel--;
    if (pitchLevel < 0) pitchLevel = 0;
    pitchScale();
  }
  
  public function pitchScale():Void {
    pitchT = (switch (pitchLevel) {
        case 0: .2;
        case 1: .5;
        case 2: .75;
        case _: 1;
      });
  }
  
  public function move(dx:Int, dy:Int):Void {
    var c = Math.cos(angle) * (1.2 / scale);
    var s = Math.sin(angle) * (1.2 / scale);
    camTX += s * dy + c * dx;
    camTY += c * dy - s * dx;
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
    scale = (scale * 9 + scaleT) / 10;
    pitch = (pitch * 9 + pitchT) / 10;
    angle = (angle * 9 + angleT) / 10;
    //camTX = 30; // Platform.mouse.x;
    //camTY = Platform.mouse.y;
    //pitch = Platform.mouse.x / 100;
    //scale = Platform.mouse.x / 100;
    xarPh++;
    xarPh %= 4;
    var co = Math.cos(angle + (FM.prng.nextMod(100) == 0 ? .2 : 0)) * scale;
    var si = Math.sin(angle + (FM.prng.nextMod(100) == 0 ? .5 : 0)) * scale;
    //pitch = angle % 1.0;
    //angle = -Math.PI;
    var oangle = angle;
    var vec = to.getVectorRect(x, y, w, h);
    if (xarPh == 0) {
      xar = FM.prng.nextMod(w);
    }
    for (b in Main.city.buildings) {
      renderBuilding(vec, co, si, b);
    }
    angle = oangle;
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
    //angle += .01;
    var vi = 0;
    var bx = -c * (b.x - camX) + s * (b.y - camY);
    var by = (-s * (b.x - camX) - c * (b.y - camY)) * pitch;
    inline function line(
      col:Colour, ox1:Float, oy1:Float, ox2:Float, oy2:Float, bh:Float
    ):Void {
      var x1 = -c * ox1 + s * oy1 + wh + bx;
      var y1 = (-s * ox1 - c * oy1) * pitch + hh + by - bh;
      var x2 = -c * ox2 + s * oy2 + wh + bx;
      var y2 = (-s * ox2 - c * oy2) * pitch + hh + by - bh;
      if (b.type != Road
          && ((!x1.withinF(boundX1, boundX2) || !y1.withinF(boundY1, boundY2))
              && (!x2.withinF(boundX1, boundX2) || !y2.withinF(boundY1, boundY2)))
          && FM.prng.nextMod(10) < 8) {
        return;
      }
      var p1 = new Point2DI(x1.floor(), y1.floor());
      var p2 = new Point2DI(x2.floor(), y2.floor());
      if (crtEnable) {
        var gx1 = (x1 /= w) - .5;
        var gy1 = (y1 /= h) - .5;
        var gx2 = (x2 /= w) - .5;
        var gy2 = (y2 /= h) - .5;
        p1.x = ((x1 - crt * (gx1 * gx1 * gx1)) * w).floor();
        p1.y = ((y1 - crt * (gy1 * gy1 * gy1)) * h).floor();
        p2.x = ((x2 - crt * (gx2 * gx2 * gx2)) * w).floor();
        p2.y = ((y2 - crt * (gy2 * gy2 * gy2)) * h).floor();
      }
      for (p in Bresenham.getCurve(p1, p2)) {
        if (p.x >= xar && p.x < xar + 4) p.y += 2;
        if (p.x >= 0 && p.x < w && p.y >= 0 && p.y < h) {
          vi = p.x + p.y * w;
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
    switch (b.type) {
      case Road:
      for (i in 0...10) {
        var s = new Point2DF(
             b.floors[0][0].x + (b.floors[0][2].x - b.floors[0][0].x) * b.prngen.nextFloat()
            ,b.floors[0][0].y
          );
        var e = new Point2DF(s.x, b.floors[0][2].y);
        line(0x99FF00FF, s.x, s.y, e.x, e.y, -2);
      }
      case Park:
      for (i in 0...30) {
        var s = new Point2DF(
             b.floors[0][0].x + (b.floors[0][2].x - b.floors[0][0].x) * b.prngen.nextFloat()
            ,b.floors[0][0].y + (b.floors[0][2].y - b.floors[0][0].y) * b.prngen.nextFloat()
          );
        var e = new Point2DF(s.x + b.prngen.nextFloat() - .5, s.y + b.prngen.nextFloat() - .5);
        line(0x6655FF00, s.x, s.y, e.x, e.y, 0);
      }
      case _:
      var bh = 0.0; // building height
      for (f in b.floors) {
        var col:Colour = b.col | (FM.prng.nextMod(0x20) << 24);
        for (i in 0...f.length) {
          var j = (i + 1) % f.length;
          line(col, f[i].x, f[i].y, f[j].x, f[j].y, bh);
        }
        bh += scale * (1 - pitch);
      }
    }
  }
}
