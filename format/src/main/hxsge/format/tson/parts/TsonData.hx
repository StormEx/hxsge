package hxsge.format.tson.parts;

import hxsge.core.memory.Memory;
import hxsge.core.IDisposable;
import haxe.io.Bytes;
import Type.ValueType;
import hxsge.format.tson.parts.TsonData;

using hxsge.format.tson.parts.TsonValueTypeTools;

@:allow(hxsge.format.tson.parts.TsonDataEditTools)
class TsonData implements IDisposable {
	public var parent(default, null):TsonData = null;

	public var type(default, null):TsonValueType;
	public var data(default, set):Dynamic;

	public var name(default, set):String;

	public function new(parent:TsonData, data:Dynamic = null, name:String = null) {
		this.data = data;

		this.name = name;
		this.parent = parent;
	}

	public function dispose() {
		if(type.isIterable()) {
			var arr:Array<TsonData> = cast data;
			Memory.disposeIterable(arr);
			data = null;
		}
	}

	public function clone():TsonData {
		return new TsonData(parent, data, name);
	}

	inline function typeByData(data:Dynamic):TsonValueType {
		return switch(Type.typeof(data)) {
			case ValueType.TNull:
				TsonValueType.TSON_BT_NULL;
			case ValueType.TInt:
				if((data & 0x000000FF) == data) {
					data < 0 ? TsonValueType.TSON_BT_INT8 : TsonValueType.TSON_BT_UINT8;
				}
				else if((data & 0x0000FFFF) == data) {
					data < 0 ? TsonValueType.TSON_BT_INT16 : TsonValueType.TSON_BT_UINT16;
				}
				else {
					data < 0 ? TsonValueType.TSON_BT_INT32 : TsonValueType.TSON_BT_UINT32;
				}
			case ValueType.TFloat:
				TsonValueType.TSON_BT_FLOAT64;
			case ValueType.TBool:
				data == true ? TsonValueType.TSON_BT_TRUE : TsonValueType.TSON_BT_FALSE;
//			case ValueType.TObject:
//				var len:Int = data.data == null ? 0 : data.data.length;
//				if(len < 0xFF) {
//					TsonValueType.TSON_BT_MAP_UINT8;
//				}
//				else if(len < 0xFFFF) {
//					TsonValueType.TSON_BT_MAP_UINT16;
//				}
//				else {
//					TsonValueType.TSON_BT_MAP_UINT32;
//				}
			case ValueType.TClass(t):
				if(Std.is(data, Array)) {
					var len:Int = data == null ? 0 : data.length;
					if(len < 0xFF) {
						TsonValueType.TSON_BT_ARRAY_UINT8;
					}
					else if(len < 0xFFFF) {
						TsonValueType.TSON_BT_ARRAY_UINT16;
					}
					else {
						TsonValueType.TSON_BT_ARRAY_UINT32;
					}
				}
				else if(Std.is(data, Bytes)) {
					var len:Int = data.length;
					if(len < 0xFF) {
						TsonValueType.TSON_BT_BINARY_UINT8;
					}
					else if(len < 0xFFFF) {
						TsonValueType.TSON_BT_BINARY_UINT16;
					}
					else {
						TsonValueType.TSON_BT_BINARY_UINT32;
					}
				}
				else if(Std.is(data, String)) {
					var len:Int = data.length;
					if(len == 0) {
						TsonValueType.TSON_BT_ESTRING;
					}
					else if(len < 0xFF) {
						TsonValueType.TSON_BT_STRING_UINT8;
					}
					else if(len < 0xFFFF) {
						TsonValueType.TSON_BT_STRING_UINT16;
					}
					else {
						TsonValueType.TSON_BT_STRING_UINT32;
					}
				}
				else {
					TsonValueType.TSON_BT_NULL;
				}
			default:
				TsonValueType.TSON_BT_NULL;
		}
	}

	inline function set_name(value:String):String {
		if(name != value) {
			name = value;
			if(name == null) {
				name = "default";
			}
		}

		return name;
	}

	inline function set_data(value:Dynamic):Dynamic {
		this.type = typeByData(value);
		this.data = type == TsonValueType.TSON_BT_NULL ? null : value;

		return data;
	}
}
