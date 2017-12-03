package lib;

enum TapeRecord {
  Event(event:String);
  Dialogue(actions:Array<Action>);
}
