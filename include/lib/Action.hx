package lib;

enum Action {
  ReadAbout(topic:String);
  Record(event:String);
  TalkTo(char:String);
  Skip;
}
