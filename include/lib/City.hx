package lib;

import haxe.ds.Vector;
import sk.thenet.app.Asset;
import sk.thenet.app.asset.Bind as AssetBind;
import sk.thenet.bmp.*;
import sk.thenet.geom.*;
import sk.thenet.bmp.manip.*;

class City {
  public static var CW = 66;
  public static var CH = 60;
  
  public static function binds():Array<Asset> {
    return [new AssetBind(["city"], (am, _) -> {
        var c = am.getBitmap("city");
        var ret = new City();
        var build = c.fluent >> new Cut(0, 0, 66, 60);
        var power = c.fluent >> new Cut(66, 0, 66, 60);
        var builds:Array<{id:String, name:String, dis:String, ?desc:String}> = [
             {id: "road", name: "", dis: ""}
            ,{id: "pp4", name: "Kasimov Power Plant", dis: "Kasimov"}
            ,{id: "dis", name: "Disconnected Store", dis: "Military"}
            ,{id: "c4", name: "Central Manger", dis: "Central"}
            ,{id: "park", name: "", dis: ""}
            ,{id: "cell4", name: "CELL-4", dis: "Kasimov"
              ,desc: "CELL pp4 d4p gs2 gs3 gs1 c2 d5p d2p"}
            ,{id: "ai", name: "AICO", dis: "Central"}
            ,{id: "d4p", name: "Casinov", dis: "Kasimov"}
            ,{id: "f2", name: "Drones 'r Us", dis: "Military"}
            ,{id: "road", name: "", dis: ""}
            ,{id: "cell1", name: "CELL-1", dis: "Central"
              ,desc: "CELL th ai pp1 c1 d1p c4"}
            ,{id: "pp1", name: "Central Power Plant", dis: "Central"}
            ,{id: "mrts", name: "Military Research Test Site", dis: "Military"}
            ,{id: "gs2", name: "Isaa", dis: "Kasimov"}
            ,{id: "gs3", name: "Mallmart", dis: "Kasimov"}
            ,{id: "park", name: "", dis: ""}
            ,{id: "th", name: "Town Hall", dis: "Central"}
            ,{id: "gs1", name: "Milton Motel", dis: "Kasimov"} // getaways / trains
            ,{id: "pp3", name: "Wave Compressor 1", dis: "Harbour"}
            ,{id: "c3", name: "Otherside", dis: "Central"}
            ,{id: "d1p", name: "Dee Koi Bank", dis: "Central"}
            ,{id: "c2", name: "Twixt Parx", dis: "Kasimov"}
            ,{id: "park", name: "", dis: ""}
            ,{id: "road", name: "", dis: ""}
            ,{id: "park", name: "", dis: ""}
            ,{id: "mrf", name: "Military Research Facility", dis: "Military"}
            ,{id: "c1", name: "Township Sushi", dis: "Central"}
            ,{id: "park", name: "", dis: ""}
            ,{id: "gs5", name: "Army Shop", dis: "Harbour"}
            ,{id: "d3p", name: "Militant Bank", dis: "Military"}
            ,{id: "d2p", name: "Neo-grocers", dis: "Manor"}
            ,{id: "d5p", name: "Neo-coffee", dis: "Kasimov"}
            ,{id: "mrs", name: "Military Research Support", dis: "Military"}
            ,{id: "road", name: "", dis: ""}
            ,{id: "cell2", name: "CELL-2", dis: "Manor"
              ,desc: "CELL gs4 pp2 d6p d7p d8p a12 a11 a10 a9 a8 a7 a6 a5 a4 a3 a2 a1"}
            ,{id: "cell3", name: "CELL-3", dis: "Military"
              ,desc: "CELL f2 mrts pp3 c3 mrf gs5 d3p mrs f3 f1 f4 f5 pp5"}
            ,{id: "gs4", name: "Powerfoods", dis: "Manor"}
            ,{id: "pp2", name: "Manor Nuclear Reactor", dis: "Manor"}
            ,{id: "a6", name: "Residential Apartments J", dis: "Manor"}
            ,{id: "a5", name: "Residential Apartments 3", dis: "Manor"}
            ,{id: "a4", name: "Residential Apartments 9", dis: "Manor"}
            ,{id: "d7p", name: "Residential Apartments 3-b", dis: "Manor"}
            ,{id: "a3", name: "Residential Apartments 3-b-ii", dis: "Manor"}
            ,{id: "a2", name: "Residential Apartments 7", dis: "Manor"}
            ,{id: "a1", name: "Residential Apartments", dis: "Manor"}
            ,{id: "park", name: "", dis: ""}
            ,{id: "f3", name: "Fish and Ships", dis: "Harbour"}
            ,{id: "f1", name: "Ships and Boats", dis: "Harbour"}
            ,{id: "f4", name: "Boats and Rafts", dis: "Harbour"}
            ,{id: "d6p", name: "IKEO", dis: "Manor"}
            ,{id: "park", name: "", dis: ""}
            ,{id: "a12", name: "Residential Apartments 52", dis: "Manor"}
            ,{id: "a11", name: "Residence Apartments", dis: "Manor"}
            ,{id: "d8p", name: "Residential Apartments 25", dis: "Manor"}
            ,{id: "a10", name: "Residential Block", dis: "Manor"}
            ,{id: "a9", name: "Residential Apartments 11", dis: "Manor"}
            ,{id: "a8", name: "Residential Apartments RA", dis: "Manor"}
            ,{id: "a7", name: "Residential Apartments Corner", dis: "Manor"}
            ,{id: "f5", name: "Rafts and Fish", dis: "Harbour"}
            ,{id: "pp5", name: "Fish Treadmill Power Plant", dis: "Harbour"}
          ];
        var vec = build.getVector();
        var vi = 0;
        var bc = 0;
        for (y in 0...CH) for (x in 0...CW) {
          var col = vec[vi] & 0xFFFFFF;
          if (col == 0x0000FF) {
            ret.sea.push(new Point2DF(x, y));
          } else if (col == 0x00FFFF) {
            ret.walk[vi] = true;
          } else if (!vec[vi].isTransparent && col != 0x111111) {
            var shape = Flood.floodOpaque(vec, CW, CH, x, y, 0xFF111111, true);
            var bdat = builds.shift();
            var bldg = Building.make(x, y, shape.fill, shape.minX, shape.minY, bdat.id, switch (col) {
                case 0xFF00FF: Road;
                case 0x00FF00: ret.walk[vi] = true; Park;
                case 0xFF0000: Cell;
                case 0xFFFF00: Power;
                case _: Normal;
              });
            bldg.name = bdat.name;
            bldg.dis = bdat.dis;
            bldg.desc = bdat.desc;
            ret.idMap[bdat.id] = bldg;
            ret.buildings.push(bldg);
            if (bldg.type != Road && bldg.type != Park) {
              var fi = 0;
              var fvec = shape.fill.getVector();
              for (fy in 0...shape.fill.height) for (fx in 0...shape.fill.width) {
                if (!fvec[fi].isTransparent) {
                  ret.map[shape.minX + fx + (shape.minY + fy) * CW] = bldg;
                }
                fi++;
              }
            }
            build.blitAlpha(shape.fill, shape.minX, shape.minY);
            vec = build.getVector();
            bc++;
          }
          vi++;
        }
        Main.city = ret;
        for (b in ret.buildings) {
          b.createPrefix();
        }
        false;
      })];
  }
  
  public var buildings:Array<Building> = [];
  public var sea:Array<Point2DF> = [];
  public var map:Vector<Building>;
  public var idMap:Map<String, Building>;
  public var walk:Vector<Bool>;
  
  public function new() {
    map = new Vector(CW * CH);
    idMap = new Map();
    walk = new Vector(CW * CH);
    for (i in 0...walk.length) walk[i] = false;
  }
}
