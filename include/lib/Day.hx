package lib;

class Day {
  static var DOTW = [
       "Monday"
      ,"Tuesday"
      ,"Wednesday"
      ,"Thursday"
      ,"Friday"
      ,"Saturday"
      ,"Sunday"
    ];
  
  public var num:Int;
  public var length:Int;
  public var events:Array<DayEvent>;
  public var actions:Array<Action>;
  
  public function new(events:Array<DayEvent>) {
    this.events = events;
    length = 5;
    actions = [];
  }
  
  public function show():String {
    return 'Day ${num + 1} (${DOTW[(num + 6) % 7]})';
  }
}
