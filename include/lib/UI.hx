package lib;

import haxe.ds.Vector;
import sk.thenet.anim.*;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.bmp.*;
import sk.thenet.bmp.manip.*;
import sk.thenet.plat.Platform;

import font.*;

using sk.thenet.FM;

class UI {
  static var TAPE_FRAMES:Int = 60; // 2
  
  public static function binds():Array<AssetBind> {
    var loadA:Int = 0;
    var loadB:Int = 0;
    return [new AssetBind(["interface", "pal"], (am, _) -> {
        loadA++;
        if (loadA == 2 || loadA == 3) return false;
        var f = am.getBitmap("interface").fluent;
        b_crt = f >> new Cut(0, 0, 123, 102);
        b_tapeControl
          = Vector.fromArrayCopy([ for (i in 0...2) f >> new Cut(i * 137, 102, 137, 26) ]);
        b_tapeControlDown
          = Vector.fromArrayCopy([ for (i in 0...5) f >> new Cut(1 + 27 * i, 128, 27, 26) ]
          .concat([ for (i in 0...4) f >> new Cut(138 + 27 * i, 128, i == 3 ? 54 : 27, 26) ]));
        b_transcript = f >> new Cut(0, 154, 137, 71);
        b_transcriptWheel
          = Vector.fromArrayCopy([ for (i in 0...3) f >> new Cut(i * 5, 225, 5, 17) ]
          .concat([ for (i in 0...3) f >> new Cut(16 + i * 4, 225, 4, 16) ]));
        b_cursor
          = Vector.fromArrayCopy([ for (i in 0...8) f >> new Cut(128 + i * 16, 16, 16, 16) ]);
        b_tape = new Vector<Bitmap>(6);
        b_tape[0] = f >> new Cut(0, 242, 158, 158);
        b_tape[1] = b_tape[0].fluent
          >> new ReplaceColour(Pal.colours[20], Pal.colours[11])
          << new ReplaceColour(Pal.colours[17], Pal.colours[13])
          << new ReplaceColour(Pal.colours[21], Pal.colours[12])
          << new ReplaceColour(Pal.colours[22], Pal.colours[12]);
        b_tape[2] = b_tape[1].fluent
          >> new ReplaceColour(Pal.colours[11], Pal.colours[1])
          << new ReplaceColour(Pal.colours[13], Pal.colours[1])
          << new ReplaceColour(Pal.colours[12], Pal.colours[9]);
        b_tape[3] = f >> new Cut(0, 400, 158, 158);
        b_tape[4] = b_tape[3].fluent >> new ReplaceColour(Pal.colours[1], 0);
        b_tape[3].fluent << new ReplaceColour(Pal.colours[20], 0);
        b_tapeOpening = Vector.fromArrayCopy([
            for (i in 0...TAPE_FRAMES) b_tape[3].fluent >> new Rotate((i / TAPE_FRAMES) * Math.PI * 2)
          ]);
        b_tapeMerged = Vector.fromArrayCopy([
            for (i in 0...TAPE_FRAMES) {
              var ret = Platform.createBitmap(b_tape[0].width * 2, b_tape[0].height * 2, 0).fluent;
              ret << new Blit(b_tape[1], 79, 79)
                << new Blit(b_tape[2].fluent >> new Copy() << new AlphaMask(b_tape[4], true), 79, 79)
                << new Blit(b_tape[2].fluent >> new Grow(79, 79, 79, 79) << new AlphaMask(b_tapeOpening[i], true), -2, -1)
                << new Blit(b_tape[0].fluent >> new Grow(79, 79, 79, 79) << new AlphaMask(b_tapeOpening[i], true), 2, 1)
                << new Blit(b_tape[2].fluent >> new Grow(81, 77, 81, 77) << new AlphaMask(b_tapeOpening[i], true));
              ret >> new Grow(-79, -79, -79, -79);
            }
          ]);
        b_tapeBG = f >> new Cut(302, 0, 140, 119);
        b_tapeNums = f >> new Cut(442, 0, 7, 143);
        b_overlay = f >> new Cut(158, 154, 400, 300);
        b_zoom = Vector.fromArrayCopy([
            for (x in 0...4) for (y in 0...2) f >> new Cut(232 + 16 * x, 49 + 26 * y, 16, 26)
          ]);
        false;
      }), new AssetBind(["pal", FontNS.ASSET_ID, FontBasic3x9.ASSET_ID], (am, _) -> {
        if (loadB++ < 2) return false;
        f_fonts = [
             FontNS.initAuto(am, Pal.colours[1], Pal.colours[13], Pal.colours[21], 0, 1)
            ,FontBasic3x9.initAuto(am, Pal.colours[1], Pal.colours[13], Pal.colours[21], 0, 1)
            ,FontBasic3x9.init(am, Pal.colours[6])
            ,FontBasic3x9.init(am, Pal.colours[19], Pal.colours[9], Pal.colours[21], 0, 1)
          ];
        false;
      }), new AssetBind(["portraits"], (am, _) -> {
        var f = am.getBitmap("portraits").fluent;
        b_portraits = Vector.fromArrayCopy([ for (i in 0...2) f >> new Cut(0, i * 87, 111, 87) ]);
        false;
      })];
  }
  
  public static var f_fonts:Array<Font>;
  static var b_crt:Bitmap;
  static var b_tapeControl:Vector<Bitmap>;
  static var b_tapeControlDown:Vector<Bitmap>;
  static var b_transcript:Bitmap;
  static var b_transcriptWheel:Vector<Bitmap>;
  static var b_cursor:Vector<Bitmap>;
  static var b_tape:Vector<Bitmap>;
  static var b_tapeOpening:Vector<Bitmap>;
  static var b_tapeMerged:Vector<Bitmap>;
  static var b_tapeBG:Bitmap;
  static var b_tapeNums:Bitmap;
  static var b_overlay:Bitmap;
  static var b_portraits:Vector<Bitmap>;
  static var b_zoom:Vector<Bitmap>;
  
  public var held:HeldButton = None;
  public var overlay:Bitween;
  public var crt:Bitween;
  public var crtDisplay:Bitween;
  public var tapeControl:Bitween;
  public var tapeAlt:Bitween;
  public var transcript:Bitween;
  public var trWheel:Int;
  public var hover:Int;
  public var tapePh:Float;
  public var tapeSpeed:Float;
  public var tapeNum:Int;
  public var tapeDigits:Array<Float>;
  public var tapeDigitsT:Array<Float>;
  public var ren:CityRen;
  public var recording:Bool = false;
  public var wasRecording:Bool = false;
  public var portrait:Int = 0;
  public var portraitShow:Bool = false;
  public var cursor:Cursor = Normal;
  
  public var writeBuffer:Bitmap;
  public var writeQueue:Array<String> = [];
  public var writePos:Int = 0;
  public var writePh:Int = 0;
  public var writeSound:Int = 0;
  
  public function new(ren:CityRen) {
    Main.ui = this;
    overlay = new Bitween(120);
    crt = new Bitween(60);
    crtDisplay = new Bitween(20);
    tapeControl = new Bitween(55);
    tapeAlt = new Bitween(40);
    transcript = new Bitween(43);
    overlay.setTo(true);
    crt.setTo(true);
    tapeControl.setTo(true);
    transcript.setTo(true);
    trWheel = 0;
    hover = 0;
    tapePh = 0;
    tapeSpeed = 0;
    tapeDigits = [0, 0, 0, 0];
    tapeDigitsT = [0, 0, 0, 0];
    setTapeNum(1337);
    writeBuffer = Platform.createBitmap(129, 70 + 16, 0);
    this.ren = ren;
  }
  
  public function setTapeNum(num:Int):Void {
    tapeNum = num;
    var s = '0000$num'.substr(-4);
    for (i in 0...4) {
      tapeDigitsT[i] = s.charCodeAt(i) - '0'.code;
    }
  }
  
  public function write(msg:String):Void {
    msg.split("\n").map(writeQueue.push);
  }
  
  function at(mx:Int, my:Int):HeldButton {
    if (tapeAlt.isOn || tapeAlt.isOff) {
      for (i in 0...(tapeAlt.isOn ? 5 : 4)) {
        if (mx.withinI(124 + i * 27, 124 + i * 27 + 26)
            && my.withinI(Main.H - 92, Main.H - 92 + 21)) {
          return tapeAlt.isOn ? TapeControlAlt(i.minI(3)) : TapeControl(i);
        }
      }
    }
    if (mx.withinI(33, 33 + 333) && my.withinI(0, 207)) {
      if (mx < 66) {
        return TurnLeft;
      } else if (mx > 333) {
        return TurnRight;
      } else {
        ren.pointer(mx, my);
        return Move(mx, my);
      }
    }
    if (mx.withinI(0, 15)) {
      if (my.withinI(40, 40 + 25)) {
        return ZoomIn;
      } else if (my.withinI(40 + 26, 40 + 26 + 25)) {
        return ZoomOut;
      } else if (my.withinI(110, 110 + 25)) {
        return PitchUp;
      } else if (my.withinI(110 + 26, 110 + 26 + 25)) {
        return PitchDown;
      }
    }
    return None;
  }
  
  public function render(to:Bitmap):Void {
    if (wasRecording != recording) {
      SFX.s(wasRecording ? "CasetteStop" : "CasettePlay");
    }
    wasRecording = recording;
    
    // overlay and city
    var ovY = -300 + Timing.quintOut.getI(overlay.valueF, 300);
    if (!overlay.isOn) {
      ren.scale = overlay.valueF * 12;
      to.fillRect(0, 0, 400, 300, Pal.colours[0]);
    }
    ren.render(to);
    to.blitAlpha(b_overlay, 0, ovY);
    
    if (cursor == Normal) {
      cursor = (switch (held) {
          case TurnLeft: ren.angleT -= .02; TurnLeft;
          case TurnRight: ren.angleT += .02; TurnRight;
          case Move(mx, my):
          ren.move(Platform.mouse.x - mx, Platform.mouse.y - my);
          held = Move(Platform.mouse.x, Platform.mouse.y);
          Move;
          case _:
          var dx = (3).negposI(Main.inst.keyboard.isHeld(KeyD), Main.inst.keyboard.isHeld(KeyA));
          var dy = (3).negposI(Main.inst.keyboard.isHeld(KeyS), Main.inst.keyboard.isHeld(KeyW));
          var da = (.02).negposF(Main.inst.keyboard.isHeld(KeyE), Main.inst.keyboard.isHeld(KeyQ));
          ren.angleT += da;
          ren.move(dx, dy);
          switch (at(Platform.mouse.x, Platform.mouse.y)) {
            case TurnLeft: TurnLeft;
            case TurnRight: TurnRight;
            case Move(_, _): Move;
            case _: Normal;
          }
        });
    }
    
    // zoom
    var zX = -16 + Timing.quintOut.getI(overlay.valueF, 16);
    to.blitAlpha(b_zoom[held == ZoomIn ? 2 : 0], zX, 40);
    to.blitAlpha(b_zoom[held == ZoomOut ? 3 : 1], zX, 40 + 26);
    
    to.blitAlpha(b_zoom[held == PitchUp ? 6 : 4], zX, 110);
    to.blitAlpha(b_zoom[held == PitchDown ? 7 : 5], zX, 110 + 26);
    
    // crt
    var crtY = Main.H - Timing.quintOut.getI(crt.valueF, 99);
    to.blitAlpha(b_crt, 0, crtY);
    if (portraitShow) {
      crtDisplay.setTo(true);
    } else {
      crtDisplay.setTo(false);
    }
    if (crtDisplay.isOn) {
      to.blitAlpha(b_portraits[portrait], 6, crtY + 6);
    } else if (!crtDisplay.isOff) {
      var rev = 43 - Timing.circOut.getI(crtDisplay.valueF, 43);
      to.blitAlphaRect(b_portraits[portrait], 6 + rev, crtY + 6 + rev, rev, rev, 111 - rev * 2, 87 - rev * 2);
    }
    var tbgY = Main.H - Timing.quintOut.getI(crt.valueF, 119);
    to.blitAlpha(b_tapeBG, 260, tbgY);
    
    // tape control
    var tcY = Main.H - Timing.quintOut.getI(tapeControl.valueF, 92);
    var tcY1 = tcY + Timing.quadInOut.getI(tapeAlt.valueF, 40);
    var tcY2 = tcY + 40 - Timing.quadInOut.getI(tapeAlt.valueF, 40);
    if (!tapeAlt.isOn) {
      to.blitAlpha(b_tapeControl[0], 123, tcY1);
      if (recording) {
        to.blitAlpha(b_tapeControlDown[4], 124 + 4 * 27, tcY1);
      }
    }
    if (!tapeAlt.isOff) {
      to.blitAlpha(b_tapeControl[1], 123, tcY2);
    }
    switch (held) {
      case TapeControl(i):
      to.blitAlpha(b_tapeControlDown[i], 124 + i * 27, tcY1);
      case TapeControlAlt(i):
      to.blitAlpha(b_tapeControlDown[5 + i], 124 + i * 27, tcY2);
      case _:
    }
    
    // transcript
    var trY = Main.H - Timing.quintOut.getI(transcript.valueF, 71);
    to.blitAlpha(b_transcript, 123, trY);
    to.blitAlpha(b_transcriptWheel[(trWheel >> 2) % 3], 123, trY);
    to.blitAlpha(b_transcriptWheel[3 + ((trWheel >> 2) % 3)], 256, trY);
    to.blitAlpha(writeBuffer, 127, trY + 1);
    to.blitAlpha(b_tapeMerged[tapePh.floor().clampI(0, TAPE_FRAMES - 1)], 263, tbgY - 48);
    for (i in 0...4) {
      to.blitAlphaRect(b_tapeNums, 268 + i * 9, tbgY + 104, 0, (tapeDigits[i] * 13).round(), 7, 12);
      if (tapeDigitsT[i] < tapeDigits[i] - .5) {
        tapeDigits[i] = (tapeDigits[i] * 5 + tapeDigitsT[i] + 10) / 6;
        if (tapeDigits[i] > 10.0) tapeDigits[i] -= 10.0;
      } else {
        tapeDigits[i] = (tapeDigits[i] * 5 + tapeDigitsT[i]) / 6;
      }
    }
    
    tapeSpeed = Platform.mouse.x / 250.0;
    tapePh += tapeSpeed;
    if (tapePh < 0) tapePh += TAPE_FRAMES;
    if (tapePh >= TAPE_FRAMES) tapePh -= TAPE_FRAMES;
    
    var mx = Platform.mouse.x;
    var my = Platform.mouse.y;
    #if flash
    if (mx.withinI(0, Main.W - 1) && my.withinI(0, Main.H - 1)) {
      flash.ui.Mouse.hide();
    }
    #end
    if (cursor == Active) {
      if (hover >= 16) cursor = Active3;
      else if (hover >= 8) cursor = Active2;
    }
    to.blitAlpha(b_cursor[cursor], mx - (cursor == TurnRight ? 16 : 0), my);
    hover++;
    hover %= 24;
    cursor = Normal;
    
    if (writeQueue.length == 0) {
      writePh = 0;
    } else if (writePh == 0 && trWheel == 0) {
      if (Debug.FAST_WRITING) {
        writePos = 0;
        var rs = f_fonts[0].render(writeBuffer, 2, 70, writeQueue.shift(), f_fonts);
        trWheel = rs.y - 70 + 2;
      } else {
        if (writeQueue[0].charAt(writePos) != " ") {
          SFX.s('Typewriter${writeSound + 1}');
          writeSound += 1 + FM.prng.nextMod(3);
          writeSound %= 4;
        }
        writePos++;
        if (writePos >= writeQueue[0].length) {
          writePos = 0;
          var rs = f_fonts[0].render(writeBuffer, 2, 70, writeQueue.shift(), f_fonts);
          trWheel = rs.y - 70 + 2;
        }
      }
    }
    writePh++;
    writePh %= 4;
    if (trWheel > 0) {
      if (Debug.FAST_WRITING) {
        var tmp = writeBuffer.fluent >> new Cut(0, trWheel, writeBuffer.width, writeBuffer.height - trWheel);
        writeBuffer.fill(0);
        writeBuffer.blitAlpha(tmp, 0, 0);
        trWheel = 0;
      } else {
        var tmp = writeBuffer.fluent >> new Cut(0, 1, writeBuffer.width, writeBuffer.height - 1);
        writeBuffer.fill(0);
        writeBuffer.blitAlpha(tmp, 0, 0);
        trWheel--;
        if (trWheel == 8) {
          SFX.s('Typewriter5');
        }
      }
    }
    
    overlay.tick();
    crt.tick();
    crtDisplay.tick();
    tapeControl.tick();
    tapeAlt.tick();
    transcript.tick();
  }
  
  public function mouseDown(mx:Int, my:Int):Bool {
    held = at(mx, my);
    switch (held) {
      case TapeControl(_) | TapeControlAlt(_) | ZoomIn | ZoomOut | PitchDown | PitchUp:
      Main.am.getSound("CasettePlay").play();
      //setTapeNum((tapeNum + FM.prng.nextMod(5)) % 10000);
      case _:
      return false;
    }
    return true;
  }
  
  public function mouseUp(mx:Int, my:Int):Bool {
    switch (held) {
      case None | TurnLeft | TurnRight | Move(_, _):
      case _: Main.am.getSound("CasetteStop").play();
    }
    switch (held) {
      case TapeControl(_):
      case TapeControlAlt(i): Main.story.uiSelect(i);
      case ZoomIn: SFX.s("ZoomIn"); ren.zoomIn();
      case ZoomOut: SFX.s("ZoomOut"); ren.zoomOut();
      case PitchUp: SFX.s("ZoomIn"); ren.pitchUp();
      case PitchDown: SFX.s("ZoomOut"); ren.pitchDown();
      case TurnLeft | TurnRight | Move(_, _):
      case _:
      return false;
    }
    held = None;
    return true;
  }
}

enum HeldButton {
  None;
  TapeControl(i:Int);
  TapeControlAlt(i:Int);
  ZoomIn;
  ZoomOut;
  PitchUp;
  PitchDown;
  TurnLeft;
  TurnRight;
  Move(mx:Int, my:Int);
}
