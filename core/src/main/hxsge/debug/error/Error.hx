package hxsge.debug.error;

class Error implements IError {
	public var info(default, null):String;

	public var isError(get, never):Bool;

	var _isError:Bool = false;

	public function new(isError:Bool = false, info:String = null) {
		_isError = isError;
		this.info = info;
	}

	inline public function setError(isError:Bool, info:String = null) {
		_isError = isError;
		this.info = info;
	}

	inline function get_isError():Bool {
		return _isError;
	}
}
