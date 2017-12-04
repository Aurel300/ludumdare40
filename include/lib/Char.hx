package lib;

class Char {
  public var id:String;
  public var name:String;
  public var portrait:Int; // y pos
  public var frames:Map<String, Int>; // x pos
  public var alive:Bool = true;
  public var dialogue:Dialogue;
  public var reachable:Bool = true;
  public var inCity:Bool = true;
  public var armed:Bool = false;
  public var location:String;
  public var female:Bool;
  public var vnum:String;
  public var vnumSecret:Bool = false;
  public var seen:Bool = false;
  
  public function new(
     id:String, name:String, portrait:Int, frames:Map<String, Int>
    ,dialogue:Dialogue, ?female:Bool = false, ?vnumSecret:Bool = false
  ) {
    this.id = id;
    this.name = name;
    this.portrait = portrait;
    this.frames = frames;
    this.dialogue = dialogue;
    this.female = female;
    vnum = [ for (i in 0...4) ((name.charCodeAt(i) + name.charCodeAt(name.length - i - 1)) * 7) % 256 ].map(Std.string).join(".");
    this.vnumSecret = vnumSecret;
  }
}
