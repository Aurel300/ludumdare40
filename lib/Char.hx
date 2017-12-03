package lib;

class Char {
  public var id:String;
  public var name:String;
  public var portrait:Int; // y pos
  public var frames:Map<String, Int>; // x pos
  public var alive:Bool = true;
  public var dialogue:Dialogue;
  
  public function new(
     id:String, name:String, portrait:Int, frames:Map<String, Int>
    ,dialogue:Dialogue
  ) {
    this.id = id;
    this.name = name;
    this.portrait = portrait;
    this.frames = frames;
    this.dialogue = dialogue;
  }
}
