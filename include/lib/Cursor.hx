package lib;

@:enum
abstract Cursor(Int) from Int to Int {
  var Normal = 0;
  var Active = 1;
  var Active2 = 2;
  var Active3 = 3;
  var Move = 4;
  var Wait = 5;
  var TurnLeft = 6;
  var TurnRight = 7;
}
