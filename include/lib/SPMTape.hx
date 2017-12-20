package lib;

import haxe.ds.Vector;
import sk.thenet.app.*;
import sk.thenet.bmp.*;
import sk.thenet.bmp.manip.*;
import sk.thenet.format.Archive;
import sk.thenet.format.archive.TAR;
import sk.thenet.format.bmp.PNG;
import sk.thenet.plat.Platform;

@:access(lib.UI)
class SPMTape extends JamState {
  public function new(app) super("pm-tape", app);
  
  var tapeph = 0;
  var b_tapeDebug:Vector<Bitmap>;
  var encPNG:PNG;
  var ar:Archive;
  
  override public function to() {
    encPNG = new PNG();
    b_tapeDebug = Vector.fromArrayCopy([
        for (i in 0...60) {
          var ret = Platform.createBitmap(158 * 2, 158 * 2, 0).fluent;
          ret << new Blit(UI.b_tape[1], 79, 79)
            << new Blit(UI.b_tape[2].fluent >> new Copy() << new AlphaMask(UI.b_tape[4], true), 79, 79)
            << new Blit(UI.b_tape[2].fluent >> new Grow(79, 79, 79, 79) << new AlphaMask(UI.b_tapeOpening[i], true) << new Recolour(0xFFFF0000), -2, -1)
            << new Blit(UI.b_tape[0].fluent >> new Grow(79, 79, 79, 79) << new AlphaMask(UI.b_tapeOpening[i], true) << new Recolour(0xFF00FF00), 2, 1)
            << new Blit(UI.b_tape[2].fluent >> new Grow(81, 77, 81, 77) << new AlphaMask(UI.b_tapeOpening[i], true) << new Recolour(0xFF0000FF));
          ret >> new Grow(-79, -79, -79, -79);
        }
      ]);
    ar = new Archive();
  }
  
  override public function tick() {
    ab.fill(0xFF333333);
    for (i in 0...5) {
      ab.blitAlpha(
           (i == 3 ? UI.b_tapeOpening[tapeph % 60] : UI.b_tape[i])
          ,[10, 121, 232, 10 - 79, 121][i]
          ,[10, 10, 10, 132 - 79, 132][i]
        );
    }
    ab.blitAlpha((tapeph < 60 ? UI.b_tapeMerged : b_tapeDebug)[tapeph % 60], 232, 132);
    UI.f_fonts[0].render(ab, 40, 40, "Reel BG\n- original");
    UI.f_fonts[0].render(ab, 151, 40, "Reel BG\n- recolour 1");
    UI.f_fonts[0].render(ab, 262, 40, "Reel BG\n- recolour 2");
    UI.f_fonts[0].render(ab, 40, 260, "Reel slots");
    UI.f_fonts[0].render(ab, 151, 260, "Reel edge");
    UI.f_fonts[0].render(ab, 262, 260, "Everything merged");
    
    if (ar != null) {
      var frameId = ("000" + tapeph).substr(-3);
      ar.addData(encPNG.encode(ab), './f${frameId}.png');
    }
    
    tapeph++;
    tapeph %= 120;
    
    if (ar != null && tapeph == 0) {
      var barr = (new TAR()).encode(ar);
      var f = new flash.net.FileReference();
      f.save(barr.getData());
      ar = null;
    }
  }
}
