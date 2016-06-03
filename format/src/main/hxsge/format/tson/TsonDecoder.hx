package hxsge.format.tson;

import hxsge.format.json.Json;
import hxsge.format.tson.parts.TsonBlock;
import hxsge.format.tson.parts.TsonHeader;
import haxe.io.BytesInput;
import haxe.io.Bytes;

using hxsge.format.tson.TsonTools;

class TsonDecoder {
	public var header(default, null):TsonHeader;
	public var root(default, null):TsonBlock;

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
		var block:TsonBlock = null;

		try {
			if(reader != null) {
				header = TsonHeader.read(reader);
				if(header.isSuccess) {
					block = TsonBlock.read(reader, header);
				}
			}
		}
		catch(e:Dynamic) {
			block = null;
		}

		root = block;
	}
}
