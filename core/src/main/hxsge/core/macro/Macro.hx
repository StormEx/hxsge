package hxsge.core.macro;

import haxe.macro.Context;
import haxe.macro.Expr;

class Macro {
	function new() {
	}

	macro static public function fileInfo():Expr {
		var info:String = Std.string(Context.currentPos());
		var beg:Int = info.indexOf("(") + 1;
		info = "[" + info.substr(beg, info.indexOf(" ") - beg - 1) + "]";

		return {
			expr: ExprDef.EConst(Constant.CString(info)),
			pos: Context.currentPos()
		};
	}
}
