package hxsge.format.json.sjson;

import haxe.io.Bytes;

using hxsge.core.utils.StringTools;

class SJsonEncoder {
	var _names:Map<String, Int>;
	var _namesCount:Int = 0;

	var _string:String;
	var _pos:Int;

	public function new() {
	}

	public static function fromDynamic(json:String):Bytes {
		return null;
	}

	static public function fromJson(json:String):Bytes {
		var bytes:Bytes = null;
		var converter:JsonConverter = null;

		if(json.isNotEmpty()) {
			converter = new JsonConverter();
			bytes = converter.convert(json);
		}

		return bytes;
	}

	static public function toJson(data:Bytes):String {
		return "";
	}
}
