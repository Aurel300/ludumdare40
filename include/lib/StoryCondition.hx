package lib;

enum StoryCondition {
  Always;
  Never;
  Not(s:StoryCondition);
  All(a:Array<StoryCondition>);
  Any(a:Array<StoryCondition>);
  Func(f:Story->Bool);
  
  FlagBool(id:String);
  
  Reachable(char:String);
  InCity(char:String);
  Alive(char:String);
  Recorded(event:String);
  Location(char:String, loc:String);
}
