package hxsge.format.json.sjson;

import hxsge.format.json.sjson.parts.SJsonBlock;
import hxsge.format.json.sjson.parts.SJsonHeader;
import haxe.io.BytesInput;
import haxe.io.Bytes;

using hxsge.format.json.sjson.SJsonTools;

class SJsonDecoder {
	public var header(default, null):SJsonHeader;
	public var root(default, null):SJsonBlock;

	var _data:Bytes;

	public function new(data:Bytes) {
		_data = data;

		readData();
	}

	public function toJson():String {
		return Json.stringify(toDynamic());
	}

	public function toDynamic():Dynamic {
		var res:Dynamic = {};

		if(root != null) {
			res = root.toDynamic(header.keys);
		}

		return res;
	}

	function readData() {
		var reader:BytesInput = new BytesInput(_data);
		var block:SJsonBlock = null;

		try {
			if(reader != null) {
				header = SJsonHeader.read(reader);
				if(header.isSuccess) {
					block = SJsonBlock.read(reader, header);
				}
			}
		}
		catch(e:Dynamic) {
			block = null;
		}

		root = block;
	}
}
