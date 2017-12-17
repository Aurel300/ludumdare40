package lib;

import sk.thenet.app.*;
import sk.thenet.app.Keyboard.Key;

class SIntro extends JamState {
  var oggs = [
#if BUILD_FLASH
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
      ,"HackerConversation"
      ,"IntenseExo"
      ,"IntroRetarded"
      ,"Investigation"
      ,"InvestigationGotEm"
      ,"InvestigationOnToSomething"
      ,"NotComfySong"
      ,"NotSoComfySong"
      ,"SynthWave1"
      ,"BootUp"
      ,"CasettePlay"
      ,"CasetteStop"
      ,"Click"
      ,"Click2"
      ,"ClickError"
      ,"MenuClick"
      ,"MenuThump"
      ,"RingtoneShort"
      ,"Shutdown1"
      ,"Shutdown2"
      ,"TapeRewind"
      ,"TurnOffPCDisplay"
      ,"Typewriter1"
      ,"Typewriter2"
      ,"Typewriter3"
      ,"Typewriter4"
      ,"Typewriter5"
      ,"ZoomIn"
      ,"ZoomOut"
#end
    ];
  var totalOggs:Int;
#if BUILD_FLASH
  public static var loadedOggs = new Map<String, OggSound>();
#end
  
  public function new(app) {
    super("intro", app);
    totalOggs = oggs.length;
  }
  
  override public function tick() {
    Music.tick();
    ab.fill(Pal.colours[0]);
    UI.f_fonts[0].render(ab, 5, 5,
       "Ignorance is Bliss.\n"
      +"A game made for LDJAM 40 in 72 hours\n"
      +"By Aurel B%l& and eidovolta.\n\n"
      +"<thenet.sk>\n\n\n\n"
      +(oggs.length > 0 ? 'Unpacking assets ... ${totalOggs - oggs.length} / $totalOggs' : "Click to start the game."));
#if BUILD_FLASH
    if (oggs.length > 0) {
      var ogg = oggs.shift();
      var bytes = am.getBinary("Ogg" + ogg);
      var sound = new stb.format.vorbis.flash.VorbisSound(bytes);
      loadedOggs[ogg] = new OggSound(sound);
    }
#end
  }
  
  override public function mouseUp(_, _) {
    if (oggs.length == 0) st("game");
  }
}
