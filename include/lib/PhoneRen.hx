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

class PhoneRen extends CRTRen {
  static var charList = [
       "may"
      ,"aim"
      ,"d1"
      ,"d2"
      ,"d8"
      ,"rl"
      ,"d4"
      ,"d5"
      ,"ml1"
      ,"d6"
      ,"ml2"
      ,"d3"
    ];
  
  public var selectedText:Bitween;
  public var selectedNum:Int = 0;
  
  public function new(x:Int, y:Int, w:Int, h:Int) {
    super(x, y, w, h);
    selectedText = new Bitween(30);
    selectedText.setTo(true);
  }
  
  public function call():Void {
    var c = Main.story.charMap[charList[selectedNum]];
    var canCall = (c.vnumSeen && c.alive);
    if (canCall) {
      SFX.s("RingtoneShort");
      Main.ui.renView = City;
      Main.story.talkTo(c.id);
    } else {
      SFX.s("ClickError");
    }
  }
  
  public function flip(delta:Int):Void {
    selectedNum = (selectedNum + delta).clampI(0, charList.length - 1);
    selectedText.setTo(false, true);
    selectedText.setTo(true);
    SFX.s("Click2");
  }
  
  public function render(to:Bitmap):Void {
    prerender();
    var c = Main.story.charMap[charList[selectedNum]];
    var canCall = (c.vnumSeen && c.alive);
    var callCol = (canCall ? 0x9900FF00 : 0x99FFAA00);
    var frameCol = (c.seen ? c.alive : true) ? 0x9900FF00 : 0x99FF0000;
    var vec = to.getVectorRect(x, y, w, h);
    pitch = 1;
    scale = 1;
    angle = 0;
    line(vec, frameCol, -40, 95, -100, 95, 0, 0, 0);
    line(vec, frameCol, -40, 95, -40, 15, 0, 0, 0);
    line(vec, frameCol, -40, 15, -100, 15, 0, 0, 0);
    line(vec, frameCol, -100, 95, -100, 15, 0, 0, 0);
    line(vec, 0x9900FF00, -160, 0, -140, 15, 0, 0, 0);
    line(vec, 0x9900FF00, -160, 0, -140, -15, 0, 0, 0);
    line(vec, 0x9900FF00, 160, 0, 140, 15, 0, 0, 0);
    line(vec, 0x9900FF00, 160, 0, 140, -15, 0, 0, 0);
    line(vec, callCol, 40, -60, 40, -80, 0, 0, 0);
    line(vec, callCol, -40, -60, -40, -80, 0, 0, 0);
    line(vec, callCol, 40, -60, -40, -60, 0, 0, 0);
    line(vec, callCol, 40, -80, -40, -80, 0, 0, 0);
    to.setVectorRect(x, y, w, h, vec);
    var log = c.prefix + "\nV-Number: " + (c.vnumSeen ? c.vnum : "?");
    UI.f_fonts[0].render(
         to, x + 50, y + 20
        ,log.substr(0, Timing.quadInOut.getI(selectedText.valueF, log.length + 1))
        ,UI.f_fonts
      );
    if (!c.vnumSeen) {
      UI.f_fonts[0].render(to, x + wh - 64, 150, "V-Number missing!");
    } else if (!c.alive) {
      UI.f_fonts[0].render(to, x + wh - 64, 150, "Not alive!");
    } else {
      UI.f_fonts[0].render(to, x + wh - 24, 180, "C A L L");
    }
    if (c.portrait > -1) to.blitAlpha(UI.b_portraits[c.portrait], x + 180, y + 20);
    selectedText.tick();
  }
}
