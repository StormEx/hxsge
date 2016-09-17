package hxsge.core.utils;

class StringTools {
	inline public static function isEmpty(a:String):Bool {
		return a == null || a.length == 0;
	}

	inline public static function isNotEmpty(a:String):Bool {
		return !isEmpty(a);
	}
}
