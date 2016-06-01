package hxsge.format.json;

import hxsge.format.json.sjson.SJsonEncoder;
import hxsge.format.json.sjson.SJsonDecoder;
import haxe.io.Bytes;

class SJson {
	inline public static var HEADER:String = "SJSON";

	static public function parse(data:Bytes):Dynamic {
		var decoder = new SJsonDecoder(data);

		return decoder.toDynamic();
	}

	static public function stringify(data:Bytes):String {
		var decoder = new SJsonDecoder(data);

		return decoder.toJson();
	}

	static public function convert(json:String):Bytes {
		var encoder = new SJsonEncoder();

		return encoder.fromJson(json);
	}
}
