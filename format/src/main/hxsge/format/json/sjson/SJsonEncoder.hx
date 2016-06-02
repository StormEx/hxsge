package hxsge.format.json.sjson;

import hxsge.format.json.sjson.parts.SJsonHeader;
import hxsge.format.json.sjson.converters.SJsonFromBlockConverter;
import hxsge.format.json.sjson.parts.SJsonBlock;
import hxsge.format.json.sjson.converters.SJsonFromJsonConverter;
import hxsge.format.json.sjson.converters.ISJsonConverter;
import haxe.io.Bytes;

using hxsge.core.utils.StringTools;

class SJsonEncoder {
	var _names:Map<String, Int>;
	var _namesCount:Int = 0;

	var _string:String;
	var _pos:Int;

	var _converter:ISJsonConverter;

	public function new() {
	}

	public function fromDynamic(json:String):Bytes {
		return null;
	}

	public function fromJson(json:String):Bytes {
		_converter = new SJsonFromJsonConverter(json);

		return _converter.sjson;
	}

	public static function fromBlock(header:SJsonHeader, block:SJsonBlock) {
		return (new SJsonFromBlockConverter(header, block)).sjson;
	}
}
