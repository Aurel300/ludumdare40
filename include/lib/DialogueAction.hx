package lib;

enum DialogueAction {
  SP(txt:String, ?snd:String); // player says
  S(txt:String, ?snd:String); // other says
  SO(from:String, txt:String, ?snd:String); // other says
  Choice(cs:Array<{txt:String, res:String, ?label:String}>);
  GoToState(st:String);
  GoToLabel(n:String);
  GoToStateLabel(st:String, n:String);
  Label(n:String);
  Conditional(c:StoryCondition, a:DialogueAction);
  Wait(f:Int);
  Pause; // wait for click through
  Sound(snd:String); // non interruptible
  Ending(e:String);
  // Show
  // ShowBuilding
  // FreeAction // when interrogating / asking?
}