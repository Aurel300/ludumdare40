package lib;

enum StoryCondition {
  Always;
  Never;
  Not(s:StoryCondition);
  All(a:Array<StoryCondition>);
  Any(a:Array<StoryCondition>);
  Func(f:Story->Bool);
  
  Alive(char:String);
  Recorded(event:String);
}
