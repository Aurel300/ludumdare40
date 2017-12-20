package font;

import sk.thenet.FM;
import sk.thenet.bmp.*;
import sk.thenet.bmp.manip.*;

@:allow(font)
class FontBase {
  private static function init(
     src:Bitmap, charW:Int, charH:Int
    ,colour:Colour, ?shadow:Colour, ?glow:Colour
    ,shadowX:Int = 1, shadowY:Int = 0
    ,offX:Int, offY:Int
    ,asciiOffset:Int, characters:Int
    ,auto:Bool
  ):Font {
    var doShadow = (shadow != null);
    var doGlow = (glow != null);
    var addX1:Int = 0;
    var addX2:Int = 0;
    var addY1:Int = 0;
    var addY2:Int = 0;
    if (doShadow) {
      addX1 += (shadowX < 0) ? -shadowX : 0;
      addX2 += (shadowX > 0) ? shadowX : 0;
      addY1 += (shadowY < 0) ? -shadowY : 0;
      addY2 += (shadowY > 0) ? shadowY : 0;
    }
    if (doGlow) {
      addX1++;
      addX2++;
      addY1++;
      addY2++;
    }
    offX -= addX1 + addX2;
    offY -= addY1 + addY2;
    var fdata = Font.spreadGrid(
         src
        ,charW, charH
        ,addX1, addX2, addY1, addY2
      ).fluent;
    fdata << new Recolour(colour);
    if (doShadow) {
      fdata << new Shadow(shadow, shadowX, shadowY);
    }
    if (doGlow) {
      fdata << new Glow(glow);
    }
    if (auto) {
      return Font.makeAutospaced(
           fdata
          ,asciiOffset, characters
          ,charW + addX1 + addX2, charH + addY1 + addY2
          ,FM.floor(src.width / charW)
          ,offX, offY
        );
    }
    return Font.makeMonospaced(
         fdata
        ,asciiOffset, characters
        ,charW + addX1 + addX2, charH + addY1 + addY2
        ,FM.floor(src.width / charW)
        ,offX, offY
      );
  }
}
