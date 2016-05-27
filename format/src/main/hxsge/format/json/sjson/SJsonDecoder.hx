package hxsge.format.json.sjson;

import haxe.io.BytesInput;
import haxe.io.Bytes;

class SJsonDecoder {
	var _data:Bytes;
	var _names:Map<Int, String>;

	public function new(data:Bytes) {
		_data = data;
	}

	public static function toDynamic(data:Bytes):Dynamic {
		return {};
	}

	public static function toJson(data:Bytes):String {
		var decoder:SJsonDecoder = new SJsonDecoder(data);

		return decoder._toJson();
	}

	function _toJson():String {
		var header:String = "";
		var str:String;
		var size:Int;
		var count:Int;
		var temp:Int = 0;
		var ib:BytesInput = new BytesInput(_data);

		_names = new Map();

		header = ib.readString(5);
		if(header == SJson.HEADER) {
			count = ib.readUInt16();
			temp = 0;
			for(i in 0...count) {
				size = ib.readUInt16();
				str = ib.readString(size);

				_names.set(temp, str);
				temp++;
			}
		}

		return "";
	}
}
