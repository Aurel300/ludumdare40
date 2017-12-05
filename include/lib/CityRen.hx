package lib;

import haxe.ds.Vector;
import sk.thenet.anim.*;
import sk.thenet.audio.IChannel;
import sk.thenet.bmp.*;
import sk.thenet.geom.*;
import sk.thenet.stream.bmp.*;
import sk.thenet.stream.prng.*;
import sk.thenet.plat.Platform;

using sk.thenet.FM;

class CityRen extends CRTRen {
  public var pointerX:Float = 0;
  public var pointerY:Float = 0;
  public var pointerShown:Bool = false;
  public var pointerTX:Float = 0;
  public var pointerTY:Float = 0;
  public var camX:Float = 0; // current camera position
  public var camY:Float = 0;
  public var camTX:Float = 25.0; // camera target
  public var camTY:Float = 25.0;
  public var selected:Building = null;
  public var active:Building = null;
  public var bug:Building = null;
  public var sentinel:Building = null;
  public var activePh:Int = 0;
  public var activeTimer:Int = 0;
  public var activeChannel:IChannel;
  public var activeAction:Action;
  public var preselPitchLevel:Int;
  public var preselZoomLevel:Int;
  public var preselAngleT:Float;
  public var selectedText:Bitween;
  public var figs:Array<Fig>;
  
  public function new(x:Int, y:Int, w:Int, h:Int) {
    super(x, y, w, h);
    selectedText = new Bitween(30);
    figs = [];
  }
  
  public function activate(b:Building, t:Int, a:Action):Void {
    if (active != b) {
      active = b;
      activePh = 0;
      activeTimer = t;
      activeChannel = SFX.s("RingtoneShort", Loop(6));
      if (a == None) {
        activeChannel.setVolume(0);
      }
      activeAction = a;
    }
  }
  
  public function move(dx:Int, dy:Int):Void {
    var c = Math.cos(angle) * (1.2 / scale);
    var s = Math.sin(angle) * (1.2 / scale);
    camTX += c * dx + s * dy;
    camTY += -s * dx + c * dy;
  }
  
  public function pointerCalc(x:Float, y:Float):Point2DF {
    var c = Math.cos(-angle) / scale;
    var s = Math.sin(-angle) / scale;
    y /= pitch;
    return new Point2DF(
         (-c * x + s * y) + camX
        ,(-s * x - c * y) + camY
      );
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
  
  public function select(x:Float, y:Float):Void {
    if (selected != null) {
      if ((x - this.x).withinF(220, 235)) {
        if ((y - this.y).withinF(18, 33)) {
          if (selected.dis == "Military" && selected.id != "mrf") {
            SFX.s("ClickError");
            Main.ui.write("Permission denied!\n$B  Military grounds not\n$B  under AICO supervision.");
          } else {
            bug = (bug == selected ? null : selected);
            if (bug != null) {
              SFX.s("Click");
            }
          }
          return;
        } else if ((y - this.y).withinF(38, 53)) {
          if (selected.dis == "Military" && selected.id != "mrf") {
            SFX.s("ClickError");
            Main.ui.write("Permission denied!\n$B  Military grounds not\n$B  under AICO supervision.");
          } else {
            sentinel = (sentinel == selected ? null : selected);
            if (sentinel != null) {
              SFX.s("Shutdown1");
            }
          }
          return;
        }
      }
    }
    for (f in figs) {
      var top = pointcalc2(f.vx, f.vy, f.x - camX, f.y - camY, .4 * scale);
      if ((x - this.x).withinF(top.x - 8, top.x + 8) && (y - this.y).withinF(top.y - 16, top.y)) {
        f.click();
        return;
      }
    }
    pointer(x, y);
    var px = pointerX.floor();
    var py = pointerY.floor();
    if (px.withinI(0, City.CW - 1) && py.withinI(0, City.CH - 1)) {
      var mi = px + py * City.CW;
      if (Main.city.map[mi] != null && selected == null) {
        SFX.s("BootUp");
        if (active == Main.city.map[mi]) {
          Main.story.runAction(activeAction);
          active = null;
          activePh = 0;
          activeTimer = 0;
          activeChannel.stop();
        } else {
          selected = Main.city.map[mi];
          selectedText.setTo(true);
          preselPitchLevel = pitchLevel;
          preselZoomLevel = zoomLevel;
          preselAngleT = angleT;
        }
      } else if (selected != null) {
        SFX.s("TurnOffPCDisplay");
        selected = null;
        selectedText.setTo(false, true);
        pitchLevel = preselPitchLevel;
        pitchScale();
        zoomLevel = preselZoomLevel;
        zoomScale();
        angleT = preselAngleT % (2 * Math.PI);
        angle = angle % (2 * Math.PI);
      }
    }
  }
  
  public function render(to:Bitmap, dialogueMode:Bool = false):Void {
    if (selected != null) {
      camX = (camX * 10 + selected.x) / 11;
      camY = (camY * 10 + selected.y) / 11;
      angleT += .01;
      pitchLevel = 2;
      pitchScale();
      zoomLevel = 2;
      zoomScale();
    } else {
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
    }
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
      if (selected == null || selected == b) {
        renderBuilding(vec, co, si, b);
      }
    }
    //angle = oangle;
    if (selected == null) {
      figs = [ for (f in figs) {
          if (f.remove) continue;
          line(vec, f.col, 0, 0, f.vx, f.vy, f.x - camX, f.y - camY, 0, .4 * scale);
          if (!dialogueMode) f.tick();
          f;
        } ];
    }
    to.setVectorRect(x, y, w, h, vec);
    if (selected != null) {
      var log = selected.prefix;
      log += "Currently inside:\n" + [ for (c in Main.story.chars)
          if (c.location == selected.id) c.name
        ].join("\n");
      UI.f_fonts[0].render(
           to, x + 50, y + 20
          ,log.substr(0, Timing.quadInOut.getI(selectedText.valueF, log.length + 1))
          ,UI.f_fonts
        );
      switch (selected.type) {
        case Cell | Power | Road | Park:
        case Normal:
        if (selected == bug) {
          to.fillRect(x + 218, y + 16, 20, 20, 0xCCFF4422);
        }
        if (selected == sentinel) {
          to.fillRect(x + 218, y + 36, 20, 20, 0xCCFF4422);
        }
        UI.f_fonts[0].render(to, x + 240, y + 20, "Plant bug");
        to.blitAlpha(Fig.b_icons[4], x + 220, y + 18);
        UI.f_fonts[0].render(to, x + 240, y + 40, "Drop sentinel");
        to.blitAlpha(Fig.b_icons[3], x + 220, y + 38);
      }
    } else {
      for (f in figs) {
        var top = pointcalc2(f.vx, f.vy, f.x - camX, f.y - camY, .4 * scale);
        top.x -= 4;
        top.y -= 8;
        if (zoomLevel > 1) {
          top.x -= 4;
          top.y -= 8;
        }
        to.blitAlpha(zoomLevel > 0 ? f.icon : f.iconSmall, top.x.floor() + x, top.y.floor() + y);
        if (!f.textShow.isOff) {
          var char = Main.story.charMap[f.char];
          UI.f_fonts[1].render(to, top.x.floor() + x, top.y.floor() - 10 + y, char.name + (char.armed ? " [ARMED]" : ""));
        }
      }
      var ox = -4;
      var oy = 8;
      if (zoomLevel > 0) {
        ox -= 4;
      }
      if (bug != null) {
        var pos = pointcalc2(0, 0, bug.x - camX, bug.y - camY, 0);
        to.blitAlpha(
             zoomLevel > 0 ? Fig.b_icons[4] : Fig.b_iconsSmall[4]
            ,pos.x.floor() + ox, pos.y.floor() - oy
          );
        oy += zoomLevel > 0 ? 16 : 8;
      }
      if (sentinel != null) {
        var pos = pointcalc2(0, 0, sentinel.x - camX, sentinel.y - camY, 0);
        to.blitAlpha(
             zoomLevel > 0 ? Fig.b_icons[3] : Fig.b_iconsSmall[3]
            ,pos.x.floor() + ox, pos.y.floor() - oy
          );
      }
    }
    selectedText.tick();
    if (activeTimer > 0) {
      activeChannel.setVolume((activeTimer / 1080) * SFX.volume);
      activeTimer--;
      var left = pointerCalc(-50, 0).distance(active.point);
      var right = pointerCalc(50, 0).distance(active.point);
      var total = left + right;
      activeChannel.setPan(((left / total) - .5) * 1.8);
      if (activeTimer == 0) {
        active = null;
        activeChannel.stop();
        activeChannel = null;
      }
    }
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
        case Road: 10;
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
      var fi = 0;
      for (f in b.floors) {
        var col:Colour = b.col | (FM.prng.nextMod(0x20) << 24);
        if (active == b) {
          if (fi == (activePh >> 2)) {
            col = 0xFFFFFFFF;
          }
        }
        for (i in 0...f.length) {
          var j = (i + 1) % f.length;
          line(vec, col, f[i].x, f[i].y, f[j].x, f[j].y, b.x - camX, b.y - camY, bh);
        }
        bh += scale * (1 - pitch);
        fi++;
      }
      if (active == b) {
        activePh++;
        activePh %= 4 * b.floors.length;
      }
    }
  }
}
