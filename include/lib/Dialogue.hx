package lib;

class Dialogue {
  public var start:String;
  public var states:Map<String, Array<DialogueAction>>;
  
  public function new(start:String, states:Map<String, Array<DialogueAction>>) {
    this.start = start;
    this.states = states;
  }
}
