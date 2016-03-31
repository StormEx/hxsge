package hxsge.core.debug;

class Debug {
	function new() {
	}

	public static function assert(condition:Bool, message:String = "assert: condition failed") {
		if(!condition) {
			throw message;
		}
	}
}
