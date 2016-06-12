package hxsge.format.tson.parts;

class TsonValueTypeTools {
	public inline static function isValue(type:TsonValueType):Bool {
		return type == TsonValueType.TSON_BT_NULL ||
				type == TsonValueType.TSON_BT_FALSE ||
				type == TsonValueType.TSON_BT_TRUE ||
				type == TsonValueType.TSON_BT_ESTRING;
	}

	public inline static function isSimple(type:TsonValueType):Bool {
		return type == TsonValueType.TSON_BT_UINT8 ||
				type == TsonValueType.TSON_BT_UINT16 ||
				type == TsonValueType.TSON_BT_UINT32 ||
				type == TsonValueType.TSON_BT_UINT64 ||
				type == TsonValueType.TSON_BT_INT8 ||
				type == TsonValueType.TSON_BT_INT16 ||
				type == TsonValueType.TSON_BT_INT32 ||
				type == TsonValueType.TSON_BT_INT64 ||
				type == TsonValueType.TSON_BT_FLOAT32 ||
				type == TsonValueType.TSON_BT_FLOAT64;
	}

	public inline static function isString(type:TsonValueType):Bool {
		return type == TsonValueType.TSON_BT_STRING_UINT8 ||
				type == TsonValueType.TSON_BT_STRING_UINT16 ||
				type == TsonValueType.TSON_BT_STRING_UINT32 ||
				type == TsonValueType.TSON_BT_STRING_UINT64;
	}

	public inline static function isBinary(type:TsonValueType):Bool {
		return type == TsonValueType.TSON_BT_BINARY_UINT8 ||
				type == TsonValueType.TSON_BT_BINARY_UINT16 ||
				type == TsonValueType.TSON_BT_BINARY_UINT32 ||
				type == TsonValueType.TSON_BT_BINARY_UINT64;
	}

	public inline static function isArray(type:TsonValueType):Bool {
		return type == TsonValueType.TSON_BT_ARRAY_UINT8 ||
				type == TsonValueType.TSON_BT_ARRAY_UINT16 ||
				type == TsonValueType.TSON_BT_ARRAY_UINT32 ||
				type == TsonValueType.TSON_BT_ARRAY_UINT64;
	}

	public inline static function isMap(type:TsonValueType):Bool {
		return type == TsonValueType.TSON_BT_MAP_UINT8 ||
				type == TsonValueType.TSON_BT_MAP_UINT16 ||
				type == TsonValueType.TSON_BT_MAP_UINT32 ||
				type == TsonValueType.TSON_BT_MAP_UINT64;
	}

	public inline static function isIterable(type:TsonValueType):Bool {
		return isMap(type) || isArray(type);
	}

	public inline static function getSizeInBytes(type:TsonValueType):Int {
		return switch(type) {
			case TsonValueType.TSON_BT_NULL |
					TsonValueType.TSON_BT_FALSE |
					TsonValueType.TSON_BT_TRUE |
					TsonValueType.TSON_BT_ESTRING:
				0;
			case TsonValueType.TSON_BT_UINT8 |
					TsonValueType.TSON_BT_INT8 |
					TsonValueType.TSON_BT_STRING_UINT8 |
					TsonValueType.TSON_BT_BINARY_UINT8 |
					TsonValueType.TSON_BT_ARRAY_UINT8 |
					TsonValueType.TSON_BT_MAP_UINT8:
				1;
			case TsonValueType.TSON_BT_UINT16 |
					TsonValueType.TSON_BT_INT16 |
					TsonValueType.TSON_BT_STRING_UINT16 |
					TsonValueType.TSON_BT_BINARY_UINT16 |
					TsonValueType.TSON_BT_ARRAY_UINT16 |
					TsonValueType.TSON_BT_MAP_UINT16:
				2;
			case TsonValueType.TSON_BT_UINT32 |
					TsonValueType.TSON_BT_INT32 |
					TsonValueType.TSON_BT_FLOAT32 |
					TsonValueType.TSON_BT_STRING_UINT32 |
					TsonValueType.TSON_BT_BINARY_UINT32 |
					TsonValueType.TSON_BT_ARRAY_UINT32 |
					TsonValueType.TSON_BT_MAP_UINT32:
				4;
			case TsonValueType.TSON_BT_UINT64 |
					TsonValueType.TSON_BT_INT64 |
					TsonValueType.TSON_BT_FLOAT64 |
					TsonValueType.TSON_BT_STRING_UINT64 |
					TsonValueType.TSON_BT_BINARY_UINT64 |
					TsonValueType.TSON_BT_ARRAY_UINT64 |
					TsonValueType.TSON_BT_MAP_UINT64:
				8;
			default:
				0;
		}
	}

	public inline static function toString(type:TsonValueType):String {
		return switch(type) {
			case TsonValueType.TSON_BT_NULL:
				"null";
			case TsonValueType.TSON_BT_FALSE:
				"false";
			case TsonValueType.TSON_BT_TRUE:
				"true";
			case TsonValueType.TSON_BT_ESTRING:
				"empty string";
			case TsonValueType.TSON_BT_UINT8:
				"uint8";
			case TsonValueType.TSON_BT_INT8:
				"int8";
			case TsonValueType.TSON_BT_STRING_UINT8:
				"string uint8";
			case TsonValueType.TSON_BT_BINARY_UINT8:
				"binary uint8";
			case TsonValueType.TSON_BT_ARRAY_UINT8:
				"array uint8";
			case TsonValueType.TSON_BT_MAP_UINT8:
				"object uint8";
			case TsonValueType.TSON_BT_UINT16:
				"uint16";
			case TsonValueType.TSON_BT_INT16:
				"int16";
			case TsonValueType.TSON_BT_STRING_UINT16:
				"string uint16";
			case TsonValueType.TSON_BT_BINARY_UINT16:
				"binary uint16";
			case TsonValueType.TSON_BT_ARRAY_UINT16:
				"array uint16";
			case TsonValueType.TSON_BT_MAP_UINT16:
				"object uint16";
			case TsonValueType.TSON_BT_UINT32:
				"uint32";
			case TsonValueType.TSON_BT_INT32:
				"int32";
			case TsonValueType.TSON_BT_FLOAT32:
				"float32";
			case TsonValueType.TSON_BT_STRING_UINT32:
				"string uint32";
			case TsonValueType.TSON_BT_BINARY_UINT32:
				"binary uint32";
			case TsonValueType.TSON_BT_ARRAY_UINT32:
				"array uint32";
			case TsonValueType.TSON_BT_MAP_UINT32:
				"object uint32";
			case TsonValueType.TSON_BT_UINT64:
				"uint64";
			case TsonValueType.TSON_BT_INT64:
				"int64";
			case TsonValueType.TSON_BT_FLOAT64:
				"float64";
			case TsonValueType.TSON_BT_STRING_UINT64:
				"string uint64";
			case TsonValueType.TSON_BT_BINARY_UINT64:
				"binary uint64";
			case TsonValueType.TSON_BT_ARRAY_UINT64:
				"array uint64";
			case TsonValueType.TSON_BT_MAP_UINT64:
				"object uint64";
			default:
				"unknown";
		}
	}
}
