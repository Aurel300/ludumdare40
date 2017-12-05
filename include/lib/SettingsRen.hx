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

class SettingsRen extends CRTRen {
  public var selectedText:Bitween;
  public var selectedNum:Int = 0;
  
  public function new(x:Int, y:Int, w:Int, h:Int) {
    super(x, y, w, h);
    selectedText = new Bitween(30);
    selectedText.setTo(true);
  }
  
  public function render(to:Bitmap):Void {
    prerender();/*
    var vec = to.getVectorRect(x, y, w, h);
    pitch = 1;
    scale = 1;
    angle = 0;
    to.setVectorRect(x, y, w, h, vec);*/
    if (Platform.mouse.x.withinI(x + 40, x + 10 + 50 + 219) && Platform.mouse.held) {
      var vol = ((Platform.mouse.x - x - 50) / 219).clampF(0, 1);
      if (Platform.mouse.y.withinI(y + 40 + 30, y + 40 + 30 + 19)) {
        SFX.volume = vol;
      }
      if (Platform.mouse.y.withinI(y + 90 + 30, y + 90 + 30 + 19)) {
        Music.volume = vol;
      }
    }
    to.fillRect(x + 50, y + 40 + 30, 220, 20, 0x4400FF00);
    to.fillRect(x + 50, y + 90 + 30, 220, 20, 0x4400FF00);
    to.fillRect(x + 50, y + 40 + 30, (220 * SFX.volume).floor(), 20, 0xFF00FF00);
    to.fillRect(x + 50, y + 90 + 30, (220 * Music.volume).floor(), 20, 0xFF00FF00);
    UI.f_fonts[0].render(
         to, x + 50, y + 20 + 30
        ,"Sound effects volume\n\n\n\n\nMusic volume"
        ,UI.f_fonts
      );
    selectedText.tick();
  }
}
