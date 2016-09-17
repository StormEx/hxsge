package hxsge.format.tson.data;

import Type.ValueType;
import haxe.io.Bytes;

using hxsge.core.utils.StringTools;
using hxsge.format.tson.data.TsonValueTypeTools;

class TsonDataTools {
	inline static public function changeByData(data:TsonData, value:Dynamic):TsonData {
		switch(Type.typeof(value)) {
			case ValueType.TNull:
				data.type = TsonValueType.NULL;
				data.data = null;
			case ValueType.TInt:
				if((value & 0x000000FF) == value) {
					data.type = value < 0 ? TsonValueType.INT8 : TsonValueType.UINT8;
				}
				else if((value & 0x0000FFFF) == value) {
					data.type = value < 0 ? TsonValueType.INT16 : TsonValueType.UINT16;
				}
				else {
					data.type = value < 0 ? TsonValueType.INT32 : TsonValueType.UINT32;
				}

				data.data = value;
			case ValueType.TFloat:
				data.type = TsonValueType.FLOAT64;
				data.data = value;
			case ValueType.TBool:
				data.type = value == true ? TsonValueType.TRUE : TsonValueType.FALSE;
				data.data = value;
			case ValueType.TObject:
				var len:Int = value.data == null ? 0 : value.data.length;
				if(len < 0xFF) {
					data.type = TsonValueType.MAP_UINT8;
				}
				else if(len < 0xFFFF) {
					data.type = TsonValueType.MAP_UINT16;
				}
				else {
					data.type = TsonValueType.MAP_UINT32;
				}

				data.data = value.data;
				var arr:Array<TsonData> = cast value.data;
				for(i in arr) {
					i.parent = data;
				}
			case ValueType.TClass(_):
				if(Std.is(value, Array)) {
					var len:Int = value == null ? 0 : value.length;
					if(len < 0xFF) {
						data.type = TsonValueType.ARRAY_UINT8;
					}
					else if(len < 0xFFFF) {
						data.type = TsonValueType.ARRAY_UINT16;
					}
					else {
						data.type = TsonValueType.ARRAY_UINT32;
					}

					data.data = len == 0 ? [] : value;
					var arr:Array<TsonData> = cast value;
					for(i in arr) {
						i.parent = data;
					}
				}
				if(Std.is(value, Bytes)) {
					var len:Int = value.length;
					if(len < 0xFF) {
						data.type = TsonValueType.BINARY_UINT8;
					}
					else if(len < 0xFFFF) {
						data.type = TsonValueType.BINARY_UINT16;
					}
					else {
						data.type = TsonValueType.BINARY_UINT32;
					}

					data.data = value;
				}
				if(Std.is(value, String)) {
					var len:Int = value.length;
					if(len == 0) {
						data.type = TsonValueType.ESTRING;
					}
					else if(len < 0xFF) {
						data.type = TsonValueType.STRING_UINT8;
					}
					else if(len < 0xFFFF) {
						data.type = TsonValueType.STRING_UINT16;
					}
					else {
						data.type = TsonValueType.STRING_UINT32;
					}

					data.data = value;
				}
			default:
				data.type = TsonValueType.NULL;
				data.data = null;
		}

		return data;
	}

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
			case TsonValueType.NULL:
				null;
			case TsonValueType.FALSE:
				false;
			case TsonValueType.TRUE:
				true;
			case TsonValueType.ESTRING:
				"";
			case TsonValueType.ARRAY_UINT8 |
			TsonValueType.ARRAY_UINT16 |
			TsonValueType.ARRAY_UINT32 |
			TsonValueType.ARRAY_UINT64:
				var arr:Array<Dynamic> = [];
				var children:Array<TsonData> = cast data.data;
				for(val in children) {
					arr.push(toDynamic(val));
				}
				arr;
			case TsonValueType.MAP_UINT8 |
			TsonValueType.MAP_UINT16 |
			TsonValueType.MAP_UINT32 |
			TsonValueType.MAP_UINT64:
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
