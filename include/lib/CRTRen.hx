package lib;

import haxe.ds.Vector;
import sk.thenet.bmp.*;
import sk.thenet.geom.*;
import sk.thenet.stream.bmp.*;
import sk.thenet.stream.prng.*;
import sk.thenet.plat.Platform;

using sk.thenet.FM;

class CRTRen {
  public var crtEnable:Bool = false;
  public var crt:Float = 0;
  
  public var x:Int;
  public var y:Int;
  public var w:Int; // render size
  public var h:Int;
  
  var wh:Int;
  var hh:Int;
  
  public var angle:Float = 0; // camera angle
  public var angleT:Float = .7;
  public var scale:Float = 12;
  public var scaleT:Float = 12;
  public var pitch:Float = 0;
  public var pitchT:Float = .5;
  
  var pitchLevel:Int = 1;
  var zoomLevel:Int = 0;
  
  var xar:Int = 0; // x artefact
  var xarPh:Int = 0;
  var boundX1:Float;
  var boundX2:Float;
  var boundY1:Float;
  var boundY2:Float;
  
  var co:Float;
  var si:Float;
  
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
  }
  
  public function zoomIn():Void {
    zoomLevel++;
    if (zoomLevel > 3) zoomLevel = 3;
    zoomScale();
  }
  
  public function zoomOut():Void {
    zoomLevel--;
    if (zoomLevel < -1) zoomLevel = -1;
    zoomScale();
  }
  
  public function zoomScale():Void {
    scaleT = (switch (zoomLevel) {
        case -1: 6;
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
  
  public function prerender():Void {
    co = Math.cos(angle);
    si = Math.sin(angle);
    if (xarPh == 0) {
      xar = FM.prng.nextMod(w);
    } else {
      xar++;
    }
    xarPh += FM.prng.nextMod(2);
    xarPh %= 16;
    scale = (scale * 9 + scaleT) / 10;
    pitch = (pitch * 9 + pitchT) / 10;
    angle = (angle * 9 + angleT) / 10;
  }
  
  inline function pointcalc(x:Float, y:Float, h:Float):Point2DF {
    return new Point2DF(
         -co * x + si * y + wh
        ,(-si * x - co * y) * pitch + hh - h
      );
  }
  
  inline function pointcalc2(ox:Float, oy:Float, bx:Float, by:Float, h:Float):Point2DF {
    ox = (ox + bx) * scale;
    oy = (oy + by) * scale;
    return new Point2DF(
         -co * ox + si * oy + wh
        ,(-si * ox - co * oy) * pitch + hh - h
      );
  }
  
  inline function line(
     vec:Vector<Colour>, col:Colour, ox1:Float, oy1:Float, ox2:Float, oy2:Float
    ,bx:Float, by:Float, bh:Float, ?bh2:Float = 0
  ):Void {
    ox1 = (ox1 + bx) * scale;
    oy1 = (oy1 + by) * scale;
    ox2 = (ox2 + bx) * scale;
    oy2 = (oy2 + by) * scale;
    var x1 = -co * ox1 + si * oy1 + wh;
    var y1 = (-si * ox1 - co * oy1) * pitch + hh - bh;
    var x2 = -co * ox2 + si * oy2 + wh;
    var y2 = (-si * ox2 - co * oy2) * pitch + hh - bh - bh2;
    var p1 = new Point2DI(x1.floor(), y1.floor());
    var p2 = new Point2DI(x2.floor(), y2.floor());
    if (crtEnable) {
      var gx1 = ((x1 /= w) - .5) * (1 + FM.prng.nextFloat() * crt * .08);
      var gy1 = ((y1 /= h) - .5) * (1 + FM.prng.nextFloat() * crt * .08);
      var gx2 = ((x2 /= w) - .5) * (1 + FM.prng.nextFloat() * crt * .08);
      var gy2 = ((y2 /= h) - .5) * (1 + FM.prng.nextFloat() * crt * .08);
      p1.x = ((x1 - crt * (gx1 * gx1 * gx1)) * w).floor();
      p1.y = ((y1 - crt * (gy1 * gy1 * gy1)) * h).floor();
      p2.x = ((x2 - crt * (gx2 * gx2 * gx2)) * w).floor();
      p2.y = ((y2 - crt * (gy2 * gy2 * gy2)) * h).floor();
    }
    var vi = 0;
    for (p in Bresenham.getCurve(p1, p2)) {
      if (p.x >= xar && p.x < xar + 4) p.y += 2;
      if (p.x >= 0 && p.x < w && p.y >= 0 && p.y < h) {
        vi = p.x + p.y * w;
        vec[vi] = col.blendWith(vec[vi] & (p.y % 2 == 0 ? 0xFFFFFFFF : 0x7FFFFFFF));
      }
    }
  }
}
