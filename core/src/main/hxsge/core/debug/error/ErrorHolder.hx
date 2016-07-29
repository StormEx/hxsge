package hxsge.core.debug.error;

class ErrorHolder implements IDisposable implements IError {
	public var errors(default, null):Array<Error> = [];

	public var isError(get, never):Bool;

	public function new() {
	}

	public function dispose() {
		errors = [];
	}

	public function reset() {
		errors = [];
	}

	public function concat(holder:ErrorHolder):ErrorHolder {
		var eh:ErrorHolder = new ErrorHolder();
		for(e in errors) {
			eh.addError(e);
		}
		for(e in holder.errors) {
			eh.addError(e);
		}

		return eh;
	}

	public function addError(error:Error) {
		errors.push(error);
	}

	inline public function toString():String {
		var res:String = "";

		for(err in errors) {
			res += err.info + "\n";
		}

		return res;
	}

	inline function checkError():Bool {
		return errors.length > 0;
	}

	inline function get_isError():Bool {
		return checkError();
	}
}
