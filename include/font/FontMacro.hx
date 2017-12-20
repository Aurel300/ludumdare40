package font;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;

class FontMacro {
  public static macro function build(
    params:{
       id:String, loc:String, chW:Int, chH:Int, offX:Int, offY:Int
      ,ascii:Int, chars:Int
    }
  ):Array<Field> {
    var pos = Context.currentPos();
    return [{
         access: [APublic, AStatic, AInline]
        ,doc: null
        ,kind: FVar(macro : String, macro $v{params.id})
        ,meta: null
        ,name: "ASSET_ID"
        ,pos: pos
      }, {
         access: [APublic, AStatic, AInline]
        ,kind: FVar(macro : String, macro $v{params.loc})
        ,name: "ASSET_LOC"
        ,pos: pos
      }, {
         access: [APublic, AStatic]
        ,kind: FFun({
             args: []
            ,expr: macro {
                return sk.thenet.app.Embed.getBitmap($v{params.id}, $v{params.loc});
              }
            ,params: []
            ,ret: macro : sk.thenet.app.asset.Bitmap
          })
        ,name: "embed"
        ,pos: pos
      }, {
         access: [APublic, AStatic, AInline]
        ,kind: FFun({
            args: [
               {name: "am", type: macro : sk.thenet.app.AssetManager}
              ,{name: "colour", type: macro : sk.thenet.bmp.Colour}
              ,{name: "shadow", opt: true, type: macro : sk.thenet.bmp.Colour}
              ,{name: "glow", opt: true, type: macro : sk.thenet.bmp.Colour}
              ,{name: "shadowX", opt: true, type: macro : Int, value: macro 1}
              ,{name: "shadowY", opt: true, type: macro : Int, value: macro 0}
              ,{name: "offX", opt: true, type: macro : Int, value: macro 0}
              ,{name: "offY", opt: true, type: macro : Int, value: macro 0}
            ]
            ,expr: macro {
                return FontBase.init(
                     am.getBitmap(ASSET_ID), $v{params.chW}, $v{params.chH}
                    ,colour, shadow, glow
                    ,shadowX, shadowY
                    ,$v{params.offX} + offX, $v{params.offY} + offY
                    ,$v{params.ascii}, $v{params.chars}
                    ,false
                  );
              }
            ,params: []
            ,ret: macro : sk.thenet.bmp.Font
          })
        ,name: "init"
        ,pos: pos
      }, {
         access: [APublic, AStatic, AInline]
        ,kind: FFun({
            args: [
               {name: "am", type: macro : sk.thenet.app.AssetManager}
              ,{name: "colour", type: macro : sk.thenet.bmp.Colour}
              ,{name: "shadow", opt: true, type: macro : sk.thenet.bmp.Colour}
              ,{name: "glow", opt: true, type: macro : sk.thenet.bmp.Colour}
              ,{name: "shadowX", opt: true, type: macro : Int, value: macro 1}
              ,{name: "shadowY", opt: true, type: macro : Int, value: macro 0}
              ,{name: "offX", opt: true, type: macro : Int, value: macro 0}
              ,{name: "offY", opt: true, type: macro : Int, value: macro 0}
            ]
            ,expr: macro {
                return FontBase.init(
                     am.getBitmap(ASSET_ID), $v{params.chW}, $v{params.chH}
                    ,colour, shadow, glow
                    ,shadowX, shadowY
                    ,offX, $v{params.offY} + offY
                    ,$v{params.ascii}, $v{params.chars}
                    ,true
                  );
              }
            ,params: []
            ,ret: macro : sk.thenet.bmp.Font
          })
        ,name: "initAuto"
        ,pos: pos
      }];
  }
}

#end
