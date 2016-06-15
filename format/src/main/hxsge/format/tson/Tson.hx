package hxsge.format.tson;

import haxe.io.BytesOutput;
import hxsge.format.tson.parts.TsonDataWriter;
import hxsge.format.tson.parts.TsonData;
import hxsge.format.tson.converters.TsonFromJsonConverter;
import hxsge.format.json.Json;
import haxe.io.BytesInput;
import hxsge.format.tson.parts.TsonDataReader;
import haxe.io.Bytes;

using hxsge.format.tson.parts.TsonDataTools;

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
		var stream:BytesOutput = new BytesOutput();
		TsonDataWriter.write(data, stream);

		return stream.getBytes();
	}
}
