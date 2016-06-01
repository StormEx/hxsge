package hxsge.io.object.json.sjson;

import hxsge.format.json.sjson.SJsonTools;
import hxsge.format.json.sjson.parts.SJsonBlock;
import haxe.io.Path;

using hxsge.format.json.sjson.SJsonTools;

class SJsonObjectInput implements IObjectInput {
	var _root:SJsonBlock;

	public function new(block:SJsonBlock) {
		_root = block;
	}

	public function readField<T>(path:String):T {
		return _readField(path).getData();
	}

	public function readFields(path:String):Array<String> {
		return _readField(path).names();
	}

	function _readField(path:String):SJsonBlock {
		var levels:Array<String> = Path.normalize(path).split("/");
		var field:SJsonBlock = _root;

		for(l in levels) {
			field = field.blockByName(l);
			if(field == null) {
				return null;
			}
		}

		return field;
	}
}
