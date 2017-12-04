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
            
            ,Embed.getSound("Action1", "../wav/IgnoranceIsBliss/Music/Action1.wav")
            ,Embed.getSound("Action2", "../wav/IgnoranceIsBliss/Music/Action2.wav")
            ,Embed.getSound("ActionChaos", "../wav/IgnoranceIsBliss/Music/ActionChaos.wav")
            ,Embed.getSound("ActionChaos2", "../wav/IgnoranceIsBliss/Music/ActionChaos2.wav")
            ,Embed.getSound("ComfySong", "../wav/IgnoranceIsBliss/Music/ComfySong.wav")
            ,Embed.getSound("DroneChill", "../wav/IgnoranceIsBliss/Music/DroneChill.wav")
            ,Embed.getSound("EasterEgg", "../wav/IgnoranceIsBliss/Music/EasterEgg.wav")
            ,Embed.getSound("EndingRampantClueless", "../wav/IgnoranceIsBliss/Music/EndingRampantClueless.wav")
            ,Embed.getSound("EndingRampantMarch", "../wav/IgnoranceIsBliss/Music/EndingRampantMarch.wav")
            ,Embed.getSound("EndingRampantRebellion", "../wav/IgnoranceIsBliss/Music/EndingRampantRebellion.wav")
            ,Embed.getSound("EndingRampantRebellionNoVoice", "../wav/IgnoranceIsBliss/Music/EndingRampantRebellionNoVoice.wav")
            ,Embed.getSound("EndingSad", "../wav/IgnoranceIsBliss/Music/EndingSad.wav")
            ,Embed.getSound("EndingTriumph", "../wav/IgnoranceIsBliss/Music/EndingTriumph.wav")
            ,Embed.getSound("HackerConversation", "../wav/IgnoranceIsBliss/Music/HackerConversation.wav")
            ,Embed.getSound("IntenseExo", "../wav/IgnoranceIsBliss/Music/IntenseExo.wav")
            ,Embed.getSound("Intro", "../wav/IgnoranceIsBliss/Music/Intro.wav")
            ,Embed.getSound("IntroRetarded", "../wav/IgnoranceIsBliss/Music/IntroRetarded.wav")
            ,Embed.getSound("IntroRetarded2", "../wav/IgnoranceIsBliss/Music/IntroRetarded2.wav")
            ,Embed.getSound("Investigation", "../wav/IgnoranceIsBliss/Music/Investigation.wav")
            ,Embed.getSound("InvestigationGotEm", "../wav/IgnoranceIsBliss/Music/InvestigationGotEm.wav")
            ,Embed.getSound("InvestigationOnToSomething", "../wav/IgnoranceIsBliss/Music/InvestigationOnToSomething.wav")
            ,Embed.getSound("JingelLong", "../wav/IgnoranceIsBliss/Music/JingelLong.wav")
            ,Embed.getSound("JingelRingShort", "../wav/IgnoranceIsBliss/Music/JingelRingShort.wav")
            ,Embed.getSound("Mem", "../wav/IgnoranceIsBliss/Music/Mem.wav")
            ,Embed.getSound("NotComfySong", "../wav/IgnoranceIsBliss/Music/NotComfySong.wav")
            ,Embed.getSound("NotSoComfySong", "../wav/IgnoranceIsBliss/Music/NotSoComfySong.wav")
            ,Embed.getSound("SynthWave1", "../wav/IgnoranceIsBliss/Music/SynthWave1.wav")
            //,Embed.getSound("Unused1", "../wav/MUSIC/Unused1.wav")
            //,Embed.getSound("Unused2", "../wav/MUSIC/Unused2.wav")
            
            ,Embed.getSound("Alarm", "../wav/IgnoranceIsBliss/SFX/Alarm.wav")
            ,Embed.getSound("BootUp", "../wav/IgnoranceIsBliss/SFX/BootUp.wav")
            ,Embed.getSound("BootUp2", "../wav/IgnoranceIsBliss/SFX/BootUp2.wav")
            ,Embed.getSound("CasettePlay", "../wav/IgnoranceIsBliss/SFX/CasettePlay.wav")
            ,Embed.getSound("CasetteStop", "../wav/IgnoranceIsBliss/SFX/CasetteStop.wav")
            ,Embed.getSound("Click", "../wav/IgnoranceIsBliss/SFX/Click.wav")
            ,Embed.getSound("Click2", "../wav/IgnoranceIsBliss/SFX/Click2.wav")
            ,Embed.getSound("ClickError", "../wav/IgnoranceIsBliss/SFX/ClickError.wav")
            ,Embed.getSound("MenuClick", "../wav/IgnoranceIsBliss/SFX/MenuClick.wav")
            ,Embed.getSound("MenuThump", "../wav/IgnoranceIsBliss/SFX/MenuThump.wav")
            ,Embed.getSound("RingtoneShort", "../wav/IgnoranceIsBliss/SFX/RingtoneShort.wav")
            ,Embed.getSound("Scan", "../wav/IgnoranceIsBliss/SFX/Scan.wav")
            ,Embed.getSound("SelectVideoGamey", "../wav/IgnoranceIsBliss/SFX/SelectVideoGamey.wav")
            ,Embed.getSound("Shutdown1", "../wav/IgnoranceIsBliss/SFX/Shutdown1.wav")
            ,Embed.getSound("Shutdown2", "../wav/IgnoranceIsBliss/SFX/Shutdown2.wav")
            ,Embed.getSound("ShutdownBig", "../wav/IgnoranceIsBliss/SFX/ShutdownBig.wav")
            ,Embed.getSound("TapeRewind", "../wav/IgnoranceIsBliss/SFX/TapeRewind.wav")
            ,Embed.getSound("TurnOffPCDisplay", "../wav/IgnoranceIsBliss/SFX/TurnOffPCDisplay.wav")
            ,Embed.getSound("Typewriter1", "../wav/IgnoranceIsBliss/SFX/Typewriter1.wav")
            ,Embed.getSound("Typewriter2", "../wav/IgnoranceIsBliss/SFX/Typewriter2.wav")
            ,Embed.getSound("Typewriter3", "../wav/IgnoranceIsBliss/SFX/Typewriter3.wav")
            ,Embed.getSound("Typewriter4", "../wav/IgnoranceIsBliss/SFX/Typewriter4.wav")
            ,Embed.getSound("Typewriter5", "../wav/IgnoranceIsBliss/SFX/Typewriter5.wav")
            ,Embed.getSound("ZoomIn", "../wav/IgnoranceIsBliss/SFX/ZoomIn.wav")
            ,Embed.getSound("ZoomOut", "../wav/IgnoranceIsBliss/SFX/ZoomOut.wav")
            
            ,Pal.bind()
          ].concat((cast Scenario.binds():Array<Asset>))
          .concat((cast City.binds():Array<Asset>))
          .concat((cast UI.binds():Array<Asset>))
          .concat((cast Fig.binds():Array<Asset>)))
        ,Keyboard
        ,Mouse
        ,Console
        ,ConsoleRemote("localhost", 8001)
      ]);
    am = assetManager;
    story = Scenario.start();
    Music.init();
    preloader = new DummyPreloader(this, "game");
    addState(new SGame(this));
    addState(new SEnding(this));
    #if flash
    haxe.Log.setColor(0xFFFFFF);
    #end
    mainLoop();
  }
}
