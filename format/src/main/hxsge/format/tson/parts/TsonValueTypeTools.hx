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

	public inline static function isInt(type:TsonValueType):Bool {
		return type == TsonValueType.TSON_BT_UINT8 ||
				type == TsonValueType.TSON_BT_UINT16 ||
				type == TsonValueType.TSON_BT_UINT32 ||
				type == TsonValueType.TSON_BT_UINT64 ||
				type == TsonValueType.TSON_BT_INT8 ||
				type == TsonValueType.TSON_BT_INT16 ||
				type == TsonValueType.TSON_BT_INT32 ||
				type == TsonValueType.TSON_BT_INT64;
	}

	public inline static function isFloat(type:TsonValueType):Bool {
		return type == TsonValueType.TSON_BT_FLOAT32 ||
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

	public inline static function isValid(type:TsonValueType):Bool {
		var val:Int = type;

		return val >= TsonValueType.min() && val <= TsonValueType.max();
	}
}
