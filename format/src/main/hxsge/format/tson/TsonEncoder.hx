package hxsge.format.tson;

import hxsge.format.tson.parts.TsonHeader;
import hxsge.format.tson.converters.TsonFromBlockConverter;
import hxsge.format.tson.parts.TsonBlock;
import hxsge.format.tson.converters.TsonFromJsonConverter;
import hxsge.format.tson.converters.ITsonConverter;
import haxe.io.Bytes;

using hxsge.core.utils.StringTools;

class TsonEncoder {
	var _names:Map<String, Int>;
	var _namesCount:Int = 0;

	var _string:String;
	var _pos:Int;

	var _converter:ITsonConverter;

	public function new() {
	}

	public function fromDynamic(json:String):Bytes {
		return null;
	}

	public function fromJson(json:String):Bytes {
		_converter = new TsonFromJsonConverter(json);

		return _converter.tson;
	}

	public static function fromBlock(header:TsonHeader, block:TsonBlock) {
		return (new TsonFromBlockConverter(header, block)).tson;
	}
}
