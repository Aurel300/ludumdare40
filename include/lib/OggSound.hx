package lib;

#if BUILD_FLASH

import flash.events.Event;
import flash.media.SoundTransform;
import stb.format.vorbis.flash.*;
import sk.thenet.audio.Sound.LoopMode;

using sk.thenet.FM;

@:allow(lib.OggChannel)
class OggSound implements sk.thenet.audio.ISound {
  public var playing(get, null):Bool;
  private inline function get_playing():Bool return false;
  
  private var sound:VorbisSound;
  private var channels:Array<OggChannel>;
  
  public function new(sound:VorbisSound) {
    this.sound = sound;
    channels = [];
  }
  
  public function play(?mode:LoopMode, ?volume:Float = 1.0):sk.thenet.audio.IChannel {
    var channel = new OggChannel((switch (mode) {
        case Forever: sound.play(0, 1000000);
        case Loop(amount): sound.play(0, amount);
        case _: sound.play(0);
      }), this);
    if (volume != 1.0) {
      channel.setVolume(volume);
    }
    channels.push(channel);
    return channel;
  }
  
  public function stop():Void {}
}

@:allow(lib.OggSound)
class OggChannel implements sk.thenet.audio.IChannel {
  public var playing:Bool = true;
  
  private var native:VorbisSoundChannel;
  private var sound:OggSound;
  
  private var volume:Float = 1.0;
  private var pan:Float = 0.0;
  
  private function new(native:VorbisSoundChannel, sound:OggSound) {
    this.native = native;
    this.sound = sound;
    native.addEventListener(Event.SOUND_COMPLETE, function(event:Event) {
        stop();
      }, false, 0, true);
  }
  
  public function setVolume(volume:Float):Void {
    this.volume = volume.clampF(0, 1);
    native.soundTransform = new SoundTransform(this.volume, pan);
  }
  
  public function setPan(pan:Float):Void {
    this.pan = pan.clampF(-1, 1);
    native.soundTransform = new SoundTransform(volume, this.pan);
  }
  
  public function stop():Void {
    if (playing) {
      playing = false;
      native.stop();
      sound.channels.remove(this);
    }
  }
}

#end
