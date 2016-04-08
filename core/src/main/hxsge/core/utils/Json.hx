package hxsge.core.utils;

class Json {
	inline public static function parse(data:String):Dynamic {
#if flash
		return flash.utils.JSON.parse(text);
#elseif js
		return untyped JSON.parse(text);
#else
		return haxe.Json.parse(text);
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
}
