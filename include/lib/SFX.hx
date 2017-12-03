package lib;

import sk.thenet.FM;
import sk.thenet.audio.Sound.LoopMode;

class SFX {
  public static function s(id:String, ?mode:LoopMode):Void {
    var vol = 1.0;
    switch (id) {
      case "ZoomIn" | "ZoomOut":
      vol = .6;
      case "Typewriter1" | "Typewriter2" | "Typewriter3" | "Typewriter4":
      vol = .2 + FM.prng.nextFloat() * .2;
      case _:
    }
    Main.am.getSound(id).play(mode, vol);
  }
}
