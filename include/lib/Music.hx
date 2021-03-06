package lib;

import sk.thenet.anim.*;
import sk.thenet.audio.*;

class Music {
  public static var volume:Float = 1.0;
  
  public static var tracks:Array<String> = [
       "Action1"
      ,"Action2"
      ,"ActionChaos"
      ,"ActionChaos2"
      ,"ComfySong"
      ,"DroneChill"
      ,"EasterEgg"
      ,"EndingRampantClueless"
      ,"EndingRampantMarch"
      ,"EndingRampantRebellion"
      ,"EndingRampantRebellionNoVoice"
      ,"EndingSad"
      ,"EndingTriumph"
      ,"HackerConversation"
      ,"IntenseExo"
      ,"Intro"
      ,"IntroRetarded"
      ,"IntroRetarded2"
      ,"Investigation"
      ,"InvestigationGotEm"
      ,"InvestigationOnToSomething"
      ,"JingelLong"
      ,"JingelRingShort"
      ,"Mem"
      ,"NotComfySong"
      ,"NotSoComfySong"
      ,"SynthWave1"
    ];
  public static var playing:Array<String> = [];
  public static var volumes:Array<Bitween> = [];
  public static var channels:Array<IChannel> = [];
  
  public static function init():Void {
    if (Debug.CONSOLE_COMMANDS && !Debug.DISABLE_MUSIC) {
      sk.thenet.app.Console.commands["track"] = (args:Array<String>) -> {
          if (args.length > 0 && tracks.indexOf(args[0]) != -1) {
            play(args[0]);
            ["OK"];
          } else {
            ["No such track"];
          }
        };
    }
  }
  
  public static function play(id:String):Void {
    switch (id) {
      case _: playMode(id, true, true);
    }
  }
  
  public static function playMode(id:String, fadeIn:Bool, fadeOutOthers:Bool):Void {
    if (Debug.DISABLE_MUSIC) {
      return;
    }
    playing.unshift(id);
    volumes.unshift(new Bitween(30));
    volumes[0].setTo(true, !fadeIn);
    //channels.unshift(Main.am.getSound(id).play(Forever, fadeIn ? 0.01 : 1));
#if BUILD_FLASH
    channels.unshift(SIntro.loadedOggs[id].play(Forever, fadeIn ? 0.01 : 1));
#else
    channels.unshift(Main.am.getSound(id).play(Forever, fadeIn ? 0.01 : 1));
#end
    if (!fadeOutOthers) {
      while (playing.length > 1) {
        channels[1].stop();
        playing.splice(1, 1);
        volumes.splice(1, 1);
        channels.splice(1, 1);
      }
    }
  }
  
  public static function tick():Void {
    var i = playing.length - 1;
    while (i > 0) {
      volumes[i].setTo(false);
      volumes[i].tick();
      if (volumes[i].isOff) {
        channels[i].stop();
        playing.splice(i, 1);
        volumes.splice(i, 1);
        channels.splice(i, 1);
      } else {
        channels[i].setVolume(volumes[i].valueF * volume);
      }
      i--;
    }
    if (playing.length > 0) {
      volumes[0].setTo(true);
      volumes[0].tick();
      channels[0].setVolume(volumes[0].valueF * volume);
    }
  }
}
