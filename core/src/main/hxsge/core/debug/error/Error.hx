package hxsge.core.debug.error;

import hxsge.core.macro.Macro;
import haxe.macro.Expr;

class Error implements IError {
	public var info(get, null):String;

	var _info:String;
	var _file:String;

	macro static public function create(e:Expr):Expr {
		return macro {
			@:privateAccess new hxsge.core.debug.error.Error($e, hxsge.core.macro.Macro.fileInfo($e));
		}
	}

	function new(info:String = "default error", file:String = "") {
		_file = file;
		_info = info;
	}

	inline function get_info():String {
		return _file + " " + _info;
	}
}
