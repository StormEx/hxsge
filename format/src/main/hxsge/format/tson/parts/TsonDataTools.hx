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
			bval = Std.instance(data.data, Bytes);
			dataSize += (bval == null ? 0 : bval.length);
		}
		else if(data.type.isIterable()) {
			var arr:Array<TsonData> = data.data;
			for(i in arr) {
				dataSize += size(i);
			}
			dataSize += 4;
		}

		return dataSize;
	}

	public static function toDynamic(data:TsonData):Dynamic {
		if(data == null) {
			return null;
		}

		return switch(data.type) {
			case TsonValueType.TSON_BT_NULL:
				null;
			case TsonValueType.TSON_BT_FALSE:
				false;
			case TsonValueType.TSON_BT_TRUE:
				true;
			case TsonValueType.TSON_BT_ESTRING:
				"";
			case TsonValueType.TSON_BT_ARRAY_UINT8 |
			TsonValueType.TSON_BT_ARRAY_UINT16 |
			TsonValueType.TSON_BT_ARRAY_UINT32 |
			TsonValueType.TSON_BT_ARRAY_UINT64:
				var arr:Array<Dynamic> = [];
				var children:Array<TsonData> = cast data.data;
				for(val in children) {
					arr.push(toDynamic(val));
				}
				arr;
			case TsonValueType.TSON_BT_MAP_UINT8 |
			TsonValueType.TSON_BT_MAP_UINT16 |
			TsonValueType.TSON_BT_MAP_UINT32 |
			TsonValueType.TSON_BT_MAP_UINT64:
				var res:Dynamic = {};
				var children:Array<TsonData> = cast data.data;
				for(val in children) {
					Reflect.setField(res, val.name, toDynamic(val));
				}
				res;
			default:
				data.data;
		}
	}

	inline static public function isNamed(data:TsonData):Bool {
		return data.name.isNotEmpty();
	}

	inline static public function isRoot(data:TsonData):Bool {
		return data.parent == null;
	}
}
