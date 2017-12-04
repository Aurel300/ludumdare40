package lib;

enum TapeRecord {
  LabelStart(m:String);
  Text(str:String);
  LabelEnd(m:String);
  Sound(snd:String);
}
