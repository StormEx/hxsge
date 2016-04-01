package hxsge.core.debug.error;

import haxe.macro.Context;
import haxe.macro.Expr.Constant;
import haxe.macro.Expr;

class Error implements IError {
	public var info(get, null):String;

	var _info:String;
	var _file:String;

	macro static public function create(e:Expr):Expr {
		var info:String = Std.string(Context.currentPos());
		var beg:Int = info.indexOf("(") + 1;
		info = "[" + info.substr(beg, info.indexOf(" ") - beg - 1) + "]";

		var expr:Expr = {
			expr: ExprDef.EConst(Constant.CString(info)),
			pos: Context.currentPos()
		};

		return macro {
			new hxsge.core.debug.error.Error($e, $expr);
		}
	}

	public function new(info:String = "default error", file:String = "") {
		_file = file;
		_info = info;
	}

	inline function get_info():String {
		return _file + " " + _info;
	}
}
