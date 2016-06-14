package hxsge.format.tson.parts;

import haxe.io.Bytes;
using hxsge.core.utils.StringTools;
using hxsge.format.tson.parts.TsonValueTypeTools;

class TsonDataTools {
	inline static public function size(data:TsonData):Int {
		var bval:Bytes;
		var sval:String;
		var dataSize:Int = 1 + (isNamed(data) ? 2 : 0) + data.type.getSizeInBytes();

		if(data.type.isString()) {
			sval = cast data;
			dataSize += sval.length;
		}
		else if(data.type.isBinary()) {
			bval = Std.instance(data, Bytes);
			dataSize += (bval == null ? 0 : bval.length);
		}
		else if(data.type.isIterable()) {
			for(i in data.children) {
				dataSize += size(i);
			}
			dataSize += 4;
		}

		return dataSize;
	}

	inline static public function isNamed(data:TsonData):Bool {
		return data.name.isNotEmpty();
	}

	inline static public function isRoot(data:TsonData):Bool {
		return data.parent == null;
	}
}
