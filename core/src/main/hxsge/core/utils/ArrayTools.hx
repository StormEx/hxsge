package hxsge.core.utils;

class ArrayTools {
	inline public static function isEmpty<T>(a:Array<T>):Bool {
		return a == null || a.length == 0;
	}

	inline public static function isNotEmpty<T>(a:Array<T>):Bool {
		return !isEmpty(a);
	}

	inline public static function last<T>(a:Array<T>):Null<T> {
		var r:Null<T> = null;
		if (a != null && a.length > 0) {
			r = a[a.length - 1];
		}
		return r;
	}
}
