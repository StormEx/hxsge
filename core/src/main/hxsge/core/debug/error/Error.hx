package hxsge.core.debug.error;

import haxe.macro.Expr;

class Error implements IError {
	public var info(get, null):String;

	public var error(default, null):ErrorValue;

	var _info:String;
	var _file:String;

	macro static public function create(e:Expr, error:ErrorValue = null):Expr {
		return macro {
			@:privateAccess new hxsge.core.debug.error.Error($e, hxsge.swamp.Macro.fileInfo($e), $error);
		}
	}

	function new(info:String = "default error", file:String = "", error:ErrorValue = null) {
		_file = file;
		_info = info;

		this.error = error;
	}

	public function throwError() {
		throw _info;
	}

	inline function get_info():String {
		return _file + " " + _info;
	}
}
