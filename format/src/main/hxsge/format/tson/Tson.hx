package hxsge.format.tson;

import haxe.io.Bytes;

class Tson {
	inline public static var HEADER:String = "SJSON";

	static public function parse(data:Bytes):Dynamic {
		var decoder = new TsonDecoder(data);

		return decoder.toDynamic();
	}

	static public function stringify(data:Bytes):String {
		var decoder = new TsonDecoder(data);

		return decoder.toJson();
	}

	static public function convert(json:String):Bytes {
		var encoder = new TsonEncoder();

		return encoder.fromJson(json);
	}
}
