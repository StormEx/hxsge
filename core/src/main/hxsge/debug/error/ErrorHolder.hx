package hxsge.debug.error;

class ErrorHolder implements IError {
	public var errors(default, null):Array<Error> = [];

	public var isError(get, never):Bool;

	public function new() {
	}

	public function reset() {
		errors = [];
	}

	public function addError(error:Error) {
		errors.push(error);
	}

	inline function checkError():Bool {
		var error:Bool = false;

		for(e in errors) {
			if(e.isError) {
				error = true;

				break;
			}
		}

		return false;
	}

	inline function get_isError():Bool {
		return checkError();
	}
}
