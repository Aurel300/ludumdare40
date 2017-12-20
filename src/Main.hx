import sk.thenet.app.*;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.app.asset.Bitmap as AssetBitmap;
import sk.thenet.app.asset.Sound as AssetSound;
import sk.thenet.app.asset.Trigger as AssetTrigger;
import sk.thenet.bmp.*;
import sk.thenet.plat.Platform;

import font.*;
import lib.*;

using sk.thenet.FM;
using sk.thenet.stream.Stream;

typedef CFont = font.FontNS;

class Main extends Application {
  public static var inst:Main;
  public static var consoleFont:Font;
  public static var story:Story;
  public static var ui:UI;
  public static var city:City;
  public static var am:AssetManager;
  public static var W:Int = 400;
  public static var H:Int = 300;
  
  public function new() {
    inst = this;
    super([
         Framerate(60)
        ,Optional(Window("", 800, 600))
        ,Surface(400, 300, 1)
        ,Assets([
             Embed.getBitmap(CFont.ASSET_ID, "ns8x16.png")
            ,Embed.getBitmap(FontBasic3x9.ASSET_ID, "basic3x9.png")
            ,new AssetBind([CFont.ASSET_ID], (am, _) -> {
                consoleFont = CFont.initAuto(am, 0xFFFFFFFF, null, 0xFF999999);
                false;
              })
            ,Embed.getBitmap("city", "../png/city.png")
            ,Embed.getBitmap("interface", "../png/interface.png")
            ,Embed.getBitmap("portraits", "../png/portraits.png")
            
#if BUILD_FLASH
            ,Embed.getBinary("OggAction1", "../ogg/music/Action1.ogg")
            ,Embed.getBinary("OggAction2", "../ogg/music/Action2.ogg")
            ,Embed.getBinary("OggActionChaos", "../ogg/music/ActionChaos.ogg")
            ,Embed.getBinary("OggActionChaos2", "../ogg/music/ActionChaos2.ogg")
            ,Embed.getBinary("OggComfySong", "../ogg/music/ComfySong.ogg")
            ,Embed.getBinary("OggDroneChill", "../ogg/music/DroneChill.ogg")
            ,Embed.getBinary("OggEasterEgg", "../ogg/music/EasterEgg.ogg")
            ,Embed.getBinary("OggEndingRampantClueless", "../ogg/music/EndingRampantClueless.ogg")
            ,Embed.getBinary("OggEndingRampantMarch", "../ogg/music/EndingRampantMarch.ogg")
            ,Embed.getBinary("OggEndingRampantRebellion", "../ogg/music/EndingRampantRebellion.ogg")
            ,Embed.getBinary("OggEndingRampantRebellionNoVoice", "../ogg/music/EndingRampantRebellionNoVoice.ogg")
            ,Embed.getBinary("OggEndingSad", "../ogg/music/EndingSad.ogg")
            // ,Embed.getBinary("OggEndingTriumph", "../ogg/music/EndingTriumph.ogg") /* unused */
            ,Embed.getBinary("OggHackerConversation", "../ogg/music/HackerConversation.ogg")
            ,Embed.getBinary("OggIntenseExo", "../ogg/music/IntenseExo.ogg")
            // ,Embed.getBinary("OggIntro", "../ogg/music/Intro.ogg") /* unused */
            ,Embed.getBinary("OggIntroRetarded", "../ogg/music/IntroRetarded.ogg") // not my nomenclature
            // ,Embed.getBinary("OggIntroRetarded2", "../ogg/music/IntroRetarded2.ogg") /* unused */
            ,Embed.getBinary("OggInvestigation", "../ogg/music/Investigation.ogg")
            ,Embed.getBinary("OggInvestigationGotEm", "../ogg/music/InvestigationGotEm.ogg")
            ,Embed.getBinary("OggInvestigationOnToSomething", "../ogg/music/InvestigationOnToSomething.ogg")
            // ,Embed.getBinary("OggJingelLong", "../ogg/music/JingelLong.ogg") /* unused */
            // ,Embed.getBinary("OggJingelRingShort", "../ogg/music/JingelRingShort.ogg") /* unused */
            //,Embed.getBinary("OggMem", "../ogg/music/Mem.ogg") /*unused */
            ,Embed.getBinary("OggNotComfySong", "../ogg/music/NotComfySong.ogg")
            ,Embed.getBinary("OggNotSoComfySong", "../ogg/music/NotSoComfySong.ogg")
            ,Embed.getBinary("OggSynthWave1", "../ogg/music/SynthWave1.ogg")
            // ,Embed.getBinary("OggUnused1", "../ogg/MUSIC/Unused1.ogg") /* unused */
            // ,Embed.getBinary("OggUnused2", "../ogg/MUSIC/Unused2.ogg") /* unused */
            
            // ,Embed.getBinary("OggAlarm", "../ogg/sfx/Alarm.ogg") /* unused */
            ,Embed.getBinary("OggBootUp", "../ogg/sfx/BootUp.ogg")
            // ,Embed.getBinary("OggBootUp2", "../ogg/sfx/BootUp2.ogg") /* unused */
            ,Embed.getBinary("OggCasettePlay", "../ogg/sfx/CasettePlay.ogg")
            ,Embed.getBinary("OggCasetteStop", "../ogg/sfx/CasetteStop.ogg")
            ,Embed.getBinary("OggClick", "../ogg/sfx/Click.ogg")
            ,Embed.getBinary("OggClick2", "../ogg/sfx/Click2.ogg")
            ,Embed.getBinary("OggClickError", "../ogg/sfx/ClickError.ogg")
            ,Embed.getBinary("OggMenuClick", "../ogg/sfx/MenuClick.ogg")
            ,Embed.getBinary("OggMenuThump", "../ogg/sfx/MenuThump.ogg")
            ,Embed.getBinary("OggRingtoneShort", "../ogg/sfx/RingtoneShort.ogg")
            // ,Embed.getBinary("OggScan", "../ogg/sfx/Scan.ogg") /* unused */
            // ,Embed.getBinary("OggSelectVideoGamey", "../ogg/sfx/SelectVideoGamey.ogg") /* unused */
            ,Embed.getBinary("OggShutdown1", "../ogg/sfx/Shutdown1.ogg")
            ,Embed.getBinary("OggShutdown2", "../ogg/sfx/Shutdown2.ogg")
            // ,Embed.getBinary("OggShutdownBig", "../ogg/sfx/ShutdownBig.ogg") /* unused */
            ,Embed.getBinary("OggTapeRewind", "../ogg/sfx/TapeRewind.ogg")
            ,Embed.getBinary("OggTurnOffPCDisplay", "../ogg/sfx/TurnOffPCDisplay.ogg")
            ,Embed.getBinary("OggTypewriter1", "../ogg/sfx/Typewriter1.ogg")
            ,Embed.getBinary("OggTypewriter2", "../ogg/sfx/Typewriter2.ogg")
            ,Embed.getBinary("OggTypewriter3", "../ogg/sfx/Typewriter3.ogg")
            ,Embed.getBinary("OggTypewriter4", "../ogg/sfx/Typewriter4.ogg")
            ,Embed.getBinary("OggTypewriter5", "../ogg/sfx/Typewriter5.ogg")
            ,Embed.getBinary("OggZoomIn", "../ogg/sfx/ZoomIn.ogg")
            ,Embed.getBinary("OggZoomOut", "../ogg/sfx/ZoomOut.ogg")
#else
            ,Embed.getSound("Action1", "../ogg/music/Action1.ogg")
            ,Embed.getSound("Action2", "../ogg/music/Action2.ogg")
            ,Embed.getSound("ActionChaos", "../ogg/music/ActionChaos.ogg")
            ,Embed.getSound("ActionChaos2", "../ogg/music/ActionChaos2.ogg")
            ,Embed.getSound("ComfySong", "../ogg/music/ComfySong.ogg")
            ,Embed.getSound("DroneChill", "../ogg/music/DroneChill.ogg")
            ,Embed.getSound("EasterEgg", "../ogg/music/EasterEgg.ogg")
            ,Embed.getSound("EndingRampantClueless", "../ogg/music/EndingRampantClueless.ogg")
            ,Embed.getSound("EndingRampantMarch", "../ogg/music/EndingRampantMarch.ogg")
            ,Embed.getSound("EndingRampantRebellion", "../ogg/music/EndingRampantRebellion.ogg")
            ,Embed.getSound("EndingRampantRebellionNoVoice", "../ogg/music/EndingRampantRebellionNoVoice.ogg")
            ,Embed.getSound("EndingSad", "../ogg/music/EndingSad.ogg")
            // ,Embed.getSound("EndingTriumph", "../ogg/music/EndingTriumph.ogg") /* unused */
            ,Embed.getSound("HackerConversation", "../ogg/music/HackerConversation.ogg")
            ,Embed.getSound("IntenseExo", "../ogg/music/IntenseExo.ogg")
            // ,Embed.getSound("Intro", "../ogg/music/Intro.ogg") /* unused */
            ,Embed.getSound("IntroRetarded", "../ogg/music/IntroRetarded.ogg")
            // ,Embed.getSound("IntroRetarded2", "../ogg/music/IntroRetarded2.ogg") /* unused */
            ,Embed.getSound("Investigation", "../ogg/music/Investigation.ogg")
            ,Embed.getSound("InvestigationGotEm", "../ogg/music/InvestigationGotEm.ogg")
            ,Embed.getSound("InvestigationOnToSomething", "../ogg/music/InvestigationOnToSomething.ogg")
            // ,Embed.getSound("JingelLong", "../ogg/music/JingelLong.ogg") /* unused */
            // ,Embed.getSound("JingelRingShort", "../ogg/music/JingelRingShort.ogg") /* unused */
            //,Embed.getSound("Mem", "../ogg/music/Mem.ogg") /*unused */
            ,Embed.getSound("NotComfySong", "../ogg/music/NotComfySong.ogg")
            ,Embed.getSound("NotSoComfySong", "../ogg/music/NotSoComfySong.ogg")
            ,Embed.getSound("SynthWave1", "../ogg/music/SynthWave1.ogg")
            // ,Embed.getSound("Unused1", "../ogg/MUSIC/Unused1.ogg") /* unused */
            // ,Embed.getSound("Unused2", "../ogg/MUSIC/Unused2.ogg") /* unused */
            
            // ,Embed.getSound("Alarm", "../ogg/sfx/Alarm.ogg") /* unused */
            ,Embed.getSound("BootUp", "../ogg/sfx/BootUp.ogg")
            // ,Embed.getSound("BootUp2", "../ogg/sfx/BootUp2.ogg") /* unused */
            ,Embed.getSound("CasettePlay", "../ogg/sfx/CasettePlay.ogg")
            ,Embed.getSound("CasetteStop", "../ogg/sfx/CasetteStop.ogg")
            ,Embed.getSound("Click", "../ogg/sfx/Click.ogg")
            ,Embed.getSound("Click2", "../ogg/sfx/Click2.ogg")
            ,Embed.getSound("ClickError", "../ogg/sfx/ClickError.ogg")
            ,Embed.getSound("MenuClick", "../ogg/sfx/MenuClick.ogg")
            ,Embed.getSound("MenuThump", "../ogg/sfx/MenuThump.ogg")
            ,Embed.getSound("RingtoneShort", "../ogg/sfx/RingtoneShort.ogg")
            // ,Embed.getSound("Scan", "../ogg/sfx/Scan.ogg") /* unused */
            // ,Embed.getSound("SelectVideoGamey", "../ogg/sfx/SelectVideoGamey.ogg") /* unused */
            ,Embed.getSound("Shutdown1", "../ogg/sfx/Shutdown1.ogg")
            ,Embed.getSound("Shutdown2", "../ogg/sfx/Shutdown2.ogg")
            // ,Embed.getSound("ShutdownBig", "../ogg/sfx/ShutdownBig.ogg") /* unused */
            ,Embed.getSound("TapeRewind", "../ogg/sfx/TapeRewind.ogg")
            ,Embed.getSound("TurnOffPCDisplay", "../ogg/sfx/TurnOffPCDisplay.ogg")
            ,Embed.getSound("Typewriter1", "../ogg/sfx/Typewriter1.ogg")
            ,Embed.getSound("Typewriter2", "../ogg/sfx/Typewriter2.ogg")
            ,Embed.getSound("Typewriter3", "../ogg/sfx/Typewriter3.ogg")
            ,Embed.getSound("Typewriter4", "../ogg/sfx/Typewriter4.ogg")
            ,Embed.getSound("Typewriter5", "../ogg/sfx/Typewriter5.ogg")
            ,Embed.getSound("ZoomIn", "../ogg/sfx/ZoomIn.ogg")
            ,Embed.getSound("ZoomOut", "../ogg/sfx/ZoomOut.ogg")
#end
            
            ,Pal.bind()
          ].concat((cast Scenario.binds():Array<Asset>))
          .concat((cast City.binds():Array<Asset>))
          .concat((cast UI.binds():Array<Asset>))
          .concat((cast Fig.binds():Array<Asset>)))
        ,Keyboard
        ,Mouse
        // To enable enter for console (also see Debug.hx):
        //,Console
        //,ConsoleRemote("localhost", 8001)
      ]);
    am = assetManager;
    story = Scenario.start();
    Music.init();
#if BUILD_FLASH
    preloader = new DummyPreloader(this, "intro");
#else
    preloader = new sk.thenet.app.TNPreloader(this, "intro");
#end
    addState(new SIntro(this));
    addState(new SGame(this));
    addState(new SEnding(this));
    addState(new SPMTape(this));
    #if flash
    haxe.Log.setColor(0xFFFFFF);
    #end
    mainLoop();
  }
}
