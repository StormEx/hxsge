package hxsge.format.json.sjson;

import haxe.io.BytesInput;
import haxe.io.Bytes;

class SJsonDecoder {
	var _data:Bytes;
	var _block:SJsonBlock;
	var _names:Map<Int, String>;

	public function new(data:Bytes) {
		_data = data;
	}

	public static function toDynamic(data:Bytes):Dynamic {
		var decoder:SJsonDecoder = new SJsonDecoder(data);

		return decoder._toDynamic();
	}

	public static function toJson(data:Bytes):String {
		return Json.stringify(toDynamic(data));
	}

	function _toDynamic():Dynamic {
		var res:Dynamic = {};

		readData();

		if(_block != null) {
			res = _block.toObject(_names);
		}

		return res;
	}

	function readData() {
		var reader:BytesInput = new BytesInput(_data);
		var str:String;
		var size:Float;
		var count:Int;
		var length:Int;
		var key:Int;
		var block:SJsonBlock = null;

		try {
			if(reader != null) {
				str = reader.readString(SJson.HEADER.length);
				if(str == SJson.HEADER) {
					size = reader.readFloat();
					count = reader.readInt16();
					_names = new Map();
					for(i in 0...count) {
						key = reader.readUInt16();
						str = readString(reader);
						_names.set(key, str);
					}
					block = SJsonBlock.read(reader);
				}
			}
		}
		catch(e:Dynamic) {
			block = null;
		}

		_block = block;
	}

	function readString(reader:BytesInput):String {
		var len:Int = reader.readUInt16();

		return reader.readString(len);
	}
}
