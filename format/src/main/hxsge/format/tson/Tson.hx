package hxsge.format.tson;

import hxsge.format.tson.converters.TsonFromDataConverter;
import hxsge.format.tson.data.TsonData;
import hxsge.format.tson.converters.TsonFromJsonConverter;
import hxsge.format.json.Json;
import haxe.io.BytesInput;
import hxsge.format.tson.data.TsonDataReader;
import haxe.io.Bytes;

using hxsge.format.tson.data.TsonDataTools;

class Tson {
	inline public static var HEADER:String = "TSON";

	static public function parse(data:Bytes):Dynamic {
		return TsonDataReader.read(new BytesInput(data)).toDynamic();
	}

	static public function stringify(data:Bytes):String {
		return Json.stringify(parse(data));
	}

	static public function convertJson(json:String):Bytes {
		return (new TsonFromJsonConverter(json)).tson;
	}

	static public function convertData(data:TsonData):Bytes {
		return (new TsonFromDataConverter(data)).tson;
	}
}
