package lib;

enum DayEvent {
  Action(a:Action);
  Call(fromCell:String, from:String, to:String, st:String);
  Meeting(id:String, t1:Int, t2:Int, a:Action);
  CharReachable(id:String, r:Bool);
  CharInCity(id:String, r:Bool);
  CharAlive(id:String, r:Bool);
  CharArmed(id:String, r:Bool);
  CharMove(id:String, from:String, to:String, ?speed:Float);
  CharLocation(id:String, loc:String);
  Conditional(c:StoryCondition, e:DayEvent);
  At(t:Int, e:DayEvent);
  Music(id:String);
  Sound(id:String);
  Lock(l:Bool);
}
