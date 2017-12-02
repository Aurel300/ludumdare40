package lib;

import sk.thenet.FM;
import sk.thenet.anim.*;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.bmp.*;
import sk.thenet.bmp.manip.*;

class UI {
  public static function bind():AssetBind {
    return new AssetBind(["interface", "pal"], (am, _) -> {
        var f = am.getBitmap("interface").fluent;
        b_crt = f >> new Cut(0, 0, 123, 102);
        b_tapeControl = f >> new Cut(0, 102, 137, 26);
        b_tapeControlDown = [ for (i in 0...5) f >> new Cut(1 + 27 * i, 128, 27, 26) ];
        b_transcript = f >> new Cut(0, 154, 137, 71);
        false;
      });
  }
  
  static var b_crt:Bitmap;
  static var b_tapeControl:Bitmap;
  static var b_tapeControlDown:Array<Bitmap>;
  static var b_transcript:Bitmap;
  
  public var crt:Bitween;
  public var tapeControl:Bitween;
  public var transcript:Bitween;
  public var tcDown:Int;
  
  public function new() {
    crt = new Bitween(60);
    tapeControl = new Bitween(55);
    transcript = new Bitween(43);
    crt.setTo(true);
    tapeControl.setTo(true);
    transcript.setTo(true);
    tcDown = -1;
  }
  
  public function render(to:Bitmap):Void {
    if (FM.prng.nextMod(10) == 0) tcDown = FM.prng.nextMod(6) - 1;
    to.blitAlpha(b_crt, 0, Main.H - Timing.quintOut.getI(crt.valueF, 99));
    var tcY = Main.H - Timing.quintOut.getI(tapeControl.valueF, 92);
    to.blitAlpha(b_tapeControl, 123, tcY);
    if (tcDown != -1) {
      to.blitAlpha(b_tapeControlDown[tcDown], 124 + tcDown * 27, tcY);
    }
    var trY = Main.H - Timing.quintOut.getI(transcript.valueF, 71);
    to.blitAlpha(b_transcript, 123, trY);
    crt.tick();
    tapeControl.tick();
    transcript.tick();
  }
}
