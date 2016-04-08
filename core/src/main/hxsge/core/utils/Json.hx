package hxsge.core.utils;

class Json {
	inline public static function parse(data:String):Dynamic {
#if flash
		return flash.utils.JSON.parse(data);
#elseif js
		return untyped JSON.parse(data);
#else
		return haxe.Json.parse(data);
#end
	}


	inline public static function stringify(data:Dynamic, pretty:Bool = false):String {
#if flash
		return flash.utils.JSON.stringify(data, null, pretty ? 2 : null);
#elseif js
		return untyped JSON.stringify(data, null, pretty ? 2 : null);
#else
		return haxe.Json.stringify(data, null, pretty ? "  " : null);
#end
	}

	public static function build<T>(data:String, cls:Class<T>):T {
		var res:T = Type.createInstance(cls, []);

		return res;
	}
}
