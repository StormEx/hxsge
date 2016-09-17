package hxsge.core.debug;

import hxsge.core.log.Log;

class Debug {
	function new() {
	}

	inline public static function error(message:String) {
		throw message;
	}

	inline public static function assert(condition:Bool, message:String = "assert: condition failed") {
		if(!condition) {
			error(message);
		}
	}

	inline public static function trace(message:String) {
#if debug
		Log.log("[Debug log] " + message);
#end
	}
}
