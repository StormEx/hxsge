package hxsge.format.json;

import hxsge.format.json.sjson.SJsonEncoder;
import hxsge.format.json.sjson.SJsonDecoder;
import haxe.io.Bytes;

class SJson {
	inline public static var HEADER:String = "SJSON";

	static public function parse(data:Bytes):Dynamic {
		return SJsonDecoder.toDynamic(data);
	}

	static public function stringify(data:Bytes):String {
		return SJsonDecoder.toJson(data);
	}

	static public function convert(json:String):Bytes {
		return SJsonEncoder.fromJson(json);
	}
}
