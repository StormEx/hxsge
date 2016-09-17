package hxsge.format.tson.data;

class TsonValueTypeTools {
	public inline static function isValue(type:TsonValueType):Bool {
		return type == TsonValueType.NULL ||
				type == TsonValueType.FALSE ||
				type == TsonValueType.TRUE ||
				type == TsonValueType.ESTRING;
	}

	public inline static function isSimple(type:TsonValueType):Bool {
		return type == TsonValueType.UINT8 ||
				type == TsonValueType.UINT16 ||
				type == TsonValueType.UINT32 ||
				type == TsonValueType.UINT64 ||
				type == TsonValueType.INT8 ||
				type == TsonValueType.INT16 ||
				type == TsonValueType.INT32 ||
				type == TsonValueType.INT64 ||
				type == TsonValueType.FLOAT32 ||
				type == TsonValueType.FLOAT64;
	}

	public inline static function isInt(type:TsonValueType):Bool {
		return type == TsonValueType.UINT8 ||
				type == TsonValueType.UINT16 ||
				type == TsonValueType.UINT32 ||
				type == TsonValueType.UINT64 ||
				type == TsonValueType.INT8 ||
				type == TsonValueType.INT16 ||
				type == TsonValueType.INT32 ||
				type == TsonValueType.INT64;
	}

	public inline static function isFloat(type:TsonValueType):Bool {
		return type == TsonValueType.FLOAT32 ||
				type == TsonValueType.FLOAT64;
	}

	public inline static function isString(type:TsonValueType):Bool {
		return type == TsonValueType.STRING_UINT8 ||
				type == TsonValueType.STRING_UINT16 ||
				type == TsonValueType.STRING_UINT32 ||
				type == TsonValueType.STRING_UINT64;
	}

	public inline static function isBinary(type:TsonValueType):Bool {
		return type == TsonValueType.BINARY_UINT8 ||
				type == TsonValueType.BINARY_UINT16 ||
				type == TsonValueType.BINARY_UINT32 ||
				type == TsonValueType.BINARY_UINT64;
	}

	public inline static function isArray(type:TsonValueType):Bool {
		return type == TsonValueType.ARRAY_UINT8 ||
				type == TsonValueType.ARRAY_UINT16 ||
				type == TsonValueType.ARRAY_UINT32 ||
				type == TsonValueType.ARRAY_UINT64;
	}

	public inline static function isMap(type:TsonValueType):Bool {
		return type == TsonValueType.MAP_UINT8 ||
				type == TsonValueType.MAP_UINT16 ||
				type == TsonValueType.MAP_UINT32 ||
				type == TsonValueType.MAP_UINT64;
	}

	public inline static function isIterable(type:TsonValueType):Bool {
		return isMap(type) || isArray(type);
	}

	public inline static function getSizeInBytes(type:TsonValueType):Int {
		return switch(type) {
			case TsonValueType.NULL |
					TsonValueType.FALSE |
					TsonValueType.TRUE |
					TsonValueType.ESTRING:
				0;
			case TsonValueType.UINT8 |
					TsonValueType.INT8 |
					TsonValueType.STRING_UINT8 |
					TsonValueType.BINARY_UINT8 |
					TsonValueType.ARRAY_UINT8 |
					TsonValueType.MAP_UINT8:
				1;
			case TsonValueType.UINT16 |
					TsonValueType.INT16 |
					TsonValueType.STRING_UINT16 |
					TsonValueType.BINARY_UINT16 |
					TsonValueType.ARRAY_UINT16 |
					TsonValueType.MAP_UINT16:
				2;
			case TsonValueType.UINT32 |
					TsonValueType.INT32 |
					TsonValueType.FLOAT32 |
					TsonValueType.STRING_UINT32 |
					TsonValueType.BINARY_UINT32 |
					TsonValueType.ARRAY_UINT32 |
					TsonValueType.MAP_UINT32:
				4;
			case TsonValueType.UINT64 |
					TsonValueType.INT64 |
					TsonValueType.FLOAT64 |
					TsonValueType.STRING_UINT64 |
					TsonValueType.BINARY_UINT64 |
					TsonValueType.ARRAY_UINT64 |
					TsonValueType.MAP_UINT64:
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
