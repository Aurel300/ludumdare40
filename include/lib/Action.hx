package lib;

enum Action {
  None;
  ReadAbout(topic:String);
  Record(event:String);
  TalkTo(char:String);
  TalkToState(char:String, st:String);
  Skip;
}
