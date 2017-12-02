package lib;

import haxe.ds.Vector;
import sk.thenet.anim.*;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.bmp.*;
import sk.thenet.bmp.manip.*;
import sk.thenet.plat.Platform;

using sk.thenet.FM;

class UI {
  public static function bind():AssetBind {
    return new AssetBind(["interface", "pal"], (am, _) -> {
        var f = am.getBitmap("interface").fluent;
        b_crt = f >> new Cut(0, 0, 123, 102);
        b_tapeControl = f >> new Cut(0, 102, 137, 26);
        b_tapeControlDown
          = Vector.fromArrayCopy([ for (i in 0...5) f >> new Cut(1 + 27 * i, 128, 27, 26) ]);
        b_transcript = f >> new Cut(0, 154, 137, 71);
        b_transcriptWheel
          = Vector.fromArrayCopy([ for (i in 0...3) f >> new Cut(i * 5, 225, 5, 17) ]
          .concat([ for (i in 0...3) f >> new Cut(16 + i * 4, 225, 4, 16) ]));
        b_cursor
          = Vector.fromArrayCopy([ for (i in 0...4) f >> new Cut(128 + i * 16, 16, 16, 16) ]);
        b_tape = new Vector<Bitmap>(6);
        b_tape[0] = f >> new Cut(0, 242, 158, 158);
        trace(Pal.colours[21].toStringHex());
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
            for (i in 0...60) b_tape[3].fluent >> new Rotate((i / 60) * Math.PI * 2)
          ]);
        b_tapeMerged = Vector.fromArrayCopy([
            for (i in 0...60) {
              var ret = Platform.createBitmap(b_tape[0].width * 2, b_tape[0].height * 2, 0).fluent;
              ret << new Blit(b_tape[1], 79, 79)
                << new Blit(b_tape[2].fluent >> new Copy() << new AlphaMask(b_tape[4], true), 79, 79)
                << new Blit(b_tape[2].fluent >> new Grow(79, 79, 79, 79) << new AlphaMask(b_tapeOpening[i], true), -2, -1)
                << new Blit(b_tape[0].fluent >> new Grow(79, 79, 79, 79) << new AlphaMask(b_tapeOpening[i], true), 2, 1)
                << new Blit(b_tape[2].fluent >> new Grow(79, 79, 79, 79) << new AlphaMask(b_tapeOpening[i], true));
              ret;
            }
          ]);
        false;
      });
  }
  
  static var b_crt:Bitmap;
  static var b_tapeControl:Bitmap;
  static var b_tapeControlDown:Vector<Bitmap>;
  static var b_transcript:Bitmap;
  static var b_transcriptWheel:Vector<Bitmap>;
  static var b_cursor:Vector<Bitmap>;
  static var b_tape:Vector<Bitmap>;
  static var b_tapeOpening:Vector<Bitmap>;
  static var b_tapeMerged:Vector<Bitmap>;
  
  public var held:HeldButton = None;
  public var crt:Bitween;
  public var tapeControl:Bitween;
  public var transcript:Bitween;
  public var trWheel:Int;
  public var hover:Int;
  public var tapePh:Float;
  public var tapeSpeed:Float;
  
  public function new() {
    crt = new Bitween(60);
    tapeControl = new Bitween(55);
    transcript = new Bitween(43);
    crt.setTo(true);
    tapeControl.setTo(true);
    transcript.setTo(true);
    trWheel = 0;
    hover = 0;
    tapePh = 0;
    tapeSpeed = 0;
  }
  
  public function render(to:Bitmap):Void {
    to.blitAlpha(b_crt, 0, Main.H - Timing.quintOut.getI(crt.valueF, 99));
    var tcY = Main.H - Timing.quintOut.getI(tapeControl.valueF, 92);
    to.blitAlpha(b_tapeControl, 123, tcY);
    switch (held) {
      case TapeControl(i):
      to.blitAlpha(b_tapeControlDown[i], 124 + i * 27, tcY);
      case _:
    }
    var trY = Main.H - Timing.quintOut.getI(transcript.valueF, 71);
    to.blitAlpha(b_transcript, 123, trY);
    to.blitAlpha(b_transcriptWheel[2 - (trWheel >> 2)], 123, trY);
    to.blitAlpha(b_transcriptWheel[5 - (trWheel >> 2)], 256, trY);
    trWheel++;
    trWheel %= 12;
    crt.tick();
    tapeControl.tick();
    transcript.tick();
    /*
    to.blitAlpha(b_tape[0], 2, 2);
    to.blitAlpha(b_tape[1], 22, 22);
    to.blitAlpha(b_tape[2], 42, 42);
    to.blitAlpha(b_tape[3], 62, 62);
    to.blitAlpha(b_tape[4], 82, 82);
    */
    to.blitAlpha(b_tapeMerged[tapePh.floor().clampI(0, 59)], 263 - 79, 133 - 79);
    
    tapeSpeed = Platform.mouse.x / 100.0;
    tapePh += tapeSpeed;
    if (tapePh < 0) tapePh += 60;
    if (tapePh >= 60) tapePh -= 60;
    
    var mx = Platform.mouse.x;
    var my = Platform.mouse.y;
    #if flash
    if (mx.withinI(0, Main.W - 1) && my.withinI(0, Main.H - 1)) {
      flash.ui.Mouse.hide();
    }
    #end
    to.blitAlpha(b_cursor[1 + (hover >> 3)], mx, my);
    hover++;
    hover %= 24;
  }
  
  public function mouseDown(mx:Int, my:Int):Void {
    held = None;
    for (i in 0...5) {
      if (mx.withinI(124 + i * 27, 124 + i * 27 + 26)
          && my.withinI(Main.H - 92, Main.H - 92 + 21)) {
        Main.am.getSound("CasettePlay").play();
        held = TapeControl(i);
        break;
      }
    }
  }
  
  public function mouseUp(mx:Int, my:Int):Void {
    switch (held) {
      case TapeControl(_):
      Main.am.getSound("CasetteStop").play();
      case _:
    }
    held = None;
  }
}

enum HeldButton {
  None;
  TapeControl(i:Int);
}
