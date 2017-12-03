package lib;

import sk.thenet.audio.Sound.LoopMode;

class SFX {
  public static function s(id:String, ?mode:LoopMode):Void {
    Main.am.getSound(id).play(mode);
  }
}
