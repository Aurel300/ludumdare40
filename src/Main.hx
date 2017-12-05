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
            ,FontBasic3x9.embed()
            ,new AssetBind([CFont.ASSET_ID], (am, _) -> {
                consoleFont = CFont.initAuto(am, 0xFFFFFFFF, null, 0xFF999999);
                false;
              })
            ,Embed.getBitmap("city", "../png/city.png")
            ,Embed.getBitmap("interface", "../png/interface.png")
            ,Embed.getBitmap("portraits", "../png/portraits.png")
            
            ,Embed.getSound("Action1", "../wav/music/Action1.wav")
            ,Embed.getSound("Action2", "../wav/music/Action2.wav")
            ,Embed.getSound("ActionChaos", "../wav/music/ActionChaos.wav")
            ,Embed.getSound("ActionChaos2", "../wav/music/ActionChaos2.wav")
            ,Embed.getSound("ComfySong", "../wav/music/ComfySong.wav")
            ,Embed.getSound("DroneChill", "../wav/music/DroneChill.wav")
            ,Embed.getSound("EasterEgg", "../wav/music/EasterEgg.wav")
            ,Embed.getSound("EndingRampantClueless", "../wav/music/EndingRampantClueless.wav")
            ,Embed.getSound("EndingRampantMarch", "../wav/music/EndingRampantMarch.wav")
            ,Embed.getSound("EndingRampantRebellion", "../wav/music/EndingRampantRebellion.wav")
            ,Embed.getSound("EndingRampantRebellionNoVoice", "../wav/music/EndingRampantRebellionNoVoice.wav")
            ,Embed.getSound("EndingSad", "../wav/music/EndingSad.wav")
            //,Embed.getSound("EndingTriumph", "../wav/music/EndingTriumph.wav")
            ,Embed.getSound("HackerConversation", "../wav/music/HackerConversation.wav")
            ,Embed.getSound("IntenseExo", "../wav/music/IntenseExo.wav")
            //,Embed.getSound("Intro", "../wav/music/Intro.wav")
            ,Embed.getSound("IntroRetarded", "../wav/music/IntroRetarded.wav")
            //,Embed.getSound("IntroRetarded2", "../wav/music/IntroRetarded2.wav")
            ,Embed.getSound("Investigation", "../wav/music/Investigation.wav")
            ,Embed.getSound("InvestigationGotEm", "../wav/music/InvestigationGotEm.wav")
            ,Embed.getSound("InvestigationOnToSomething", "../wav/music/InvestigationOnToSomething.wav")
            //,Embed.getSound("JingelLong", "../wav/music/JingelLong.wav")
            //,Embed.getSound("JingelRingShort", "../wav/music/JingelRingShort.wav")
            ,Embed.getSound("Mem", "../wav/music/Mem.wav")
            ,Embed.getSound("NotComfySong", "../wav/music/NotComfySong.wav")
            ,Embed.getSound("NotSoComfySong", "../wav/music/NotSoComfySong.wav")
            ,Embed.getSound("SynthWave1", "../wav/music/SynthWave1.wav")
            //,Embed.getSound("Unused1", "../wav/MUSIC/Unused1.wav")
            //,Embed.getSound("Unused2", "../wav/MUSIC/Unused2.wav")
            
            //,Embed.getSound("Alarm", "../wav/IgnoranceIsBliss/SFX/Alarm.wav")
            ,Embed.getSound("BootUp", "../wav/sfx/BootUp.mp3")
            //,Embed.getSound("BootUp2", "../wav/IgnoranceIsBliss/SFX/BootUp2.wav")
            ,Embed.getSound("CasettePlay", "../wav/sfx/CasettePlay.mp3")
            ,Embed.getSound("CasetteStop", "../wav/sfx/CasetteStop.mp3")
            ,Embed.getSound("Click", "../wav/sfx/Click.mp3")
            ,Embed.getSound("Click2", "../wav/sfx/Click2.mp3")
            ,Embed.getSound("ClickError", "../wav/sfx/ClickError.mp3")
            ,Embed.getSound("MenuClick", "../wav/sfx/MenuClick.mp3")
            ,Embed.getSound("MenuThump", "../wav/sfx/MenuThump.mp3")
            ,Embed.getSound("RingtoneShort", "../wav/sfx/RingtoneShort.mp3")
            //,Embed.getSound("Scan", "../wav/sfx/Scan.mp3")
            //,Embed.getSound("SelectVideoGamey", "../wav/sfx/SelectVideoGamey.mp3")
            ,Embed.getSound("Shutdown1", "../wav/sfx/Shutdown1.mp3")
            ,Embed.getSound("Shutdown2", "../wav/sfx/Shutdown2.mp3")
            //,Embed.getSound("ShutdownBig", "../wav/sfx/ShutdownBig.mp3")
            ,Embed.getSound("TapeRewind", "../wav/sfx/TapeRewind.wav")
            ,Embed.getSound("TurnOffPCDisplay", "../wav/sfx/TurnOffPCDisplay.mp3")
            ,Embed.getSound("Typewriter1", "../wav/sfx/Typewriter1.mp3")
            ,Embed.getSound("Typewriter2", "../wav/sfx/Typewriter2.mp3")
            ,Embed.getSound("Typewriter3", "../wav/sfx/Typewriter3.mp3")
            ,Embed.getSound("Typewriter4", "../wav/sfx/Typewriter4.mp3")
            ,Embed.getSound("Typewriter5", "../wav/sfx/Typewriter5.mp3")
            ,Embed.getSound("ZoomIn", "../wav/sfx/ZoomIn.mp3")
            ,Embed.getSound("ZoomOut", "../wav/sfx/ZoomOut.mp3")
            
            ,Pal.bind()
          ].concat((cast Scenario.binds():Array<Asset>))
          .concat((cast City.binds():Array<Asset>))
          .concat((cast UI.binds():Array<Asset>))
          .concat((cast Fig.binds():Array<Asset>)))
        ,Keyboard
        ,Mouse
        //,Console
        //,ConsoleRemote("localhost", 8001)
      ]);
    am = assetManager;
    story = Scenario.start();
    Music.init();
    preloader = new DummyPreloader(this, "intro");
    addState(new SIntro(this));
    addState(new SGame(this));
    addState(new SEnding(this));
    #if flash
    haxe.Log.setColor(0xFFFFFF);
    #end
    mainLoop();
  }
}
