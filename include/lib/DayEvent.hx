package lib;

enum DayEvent {
  Action(a:Action);
  Call(id:String);
  Meeting(id:String);
  Conditional(c:StoryCondition, e:DayEvent);
  At(t:Int, e:DayEvent);
}
