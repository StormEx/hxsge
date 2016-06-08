package hxsge.format.tson.parts;

@:enum abstract TsonValueType(Int) from Int to Int {
	var TSON_BT_NULL = 0;
	var TSON_BT_FALSE = 1;
	var TSON_BT_TRUE = 2;
	var TSON_BT_ESTRING = 3;

	var TSON_BT_UINT8 = 4;
	var TSON_BT_UINT16 = 5;
	var TSON_BT_UINT32 = 6;
	var TSON_BT_UINT64 = 7;

	var TSON_BT_INT8 = 8;
	var TSON_BT_INT16 = 9;
	var TSON_BT_INT32 = 10;
	var TSON_BT_INT64 = 11;

	var TSON_BT_FLOAT32 = 12;
	var TSON_BT_FLOAT64 = 13;

	var TSON_BT_STRING_UINT8 = 14;
	var TSON_BT_STRING_UINT16 = 15;
	var TSON_BT_STRING_UINT32 = 16;
	var TSON_BT_STRING_UINT64 = 17;

	var TSON_BT_BINARY_UINT8 = 18;
	var TSON_BT_BINARY_UINT16 = 19;
	var TSON_BT_BINARY_UINT32 = 20;
	var TSON_BT_BINARY_UINT64 = 21;

	var TSON_BT_ARRAY_UINT8 = 22;
	var TSON_BT_ARRAY_UINT16 = 23;
	var TSON_BT_ARRAY_UINT32 = 24;
	var TSON_BT_ARRAY_UINT64 = 25;

	var TSON_BT_MAP_UINT8 = 26;
	var TSON_BT_MAP_UINT16 = 27;
	var TSON_BT_MAP_UINT32 = 28;
	var TSON_BT_MAP_UINT64 = 29;

	public inline static function isValue(type:TsonValueType):Bool {
		return type == TSON_BT_NULL ||
				type == TSON_BT_FALSE ||
				type == TSON_BT_TRUE ||
				type == TSON_BT_ESTRING;
	}

	public inline static function isSimple(type:TsonValueType):Bool {
		return type == TSON_BT_UINT8 ||
				type == TSON_BT_UINT16 ||
				type == TSON_BT_UINT32 ||
				type == TSON_BT_UINT64 ||
				type == TSON_BT_INT8 ||
				type == TSON_BT_INT16 ||
				type == TSON_BT_INT32 ||
				type == TSON_BT_INT64 ||
				type == TSON_BT_FLOAT32 ||
				type == TSON_BT_FLOAT64;
	}

	public inline static function isString(type:TsonValueType):Bool {
		return type == TSON_BT_STRING_UINT8 ||
				type == TSON_BT_STRING_UINT16 ||
				type == TSON_BT_STRING_UINT32 ||
				type == TSON_BT_STRING_UINT64;
	}

	public inline static function isBinary(type:TsonValueType):Bool {
		return type == TSON_BT_BINARY_UINT8 ||
				type == TSON_BT_BINARY_UINT16 ||
				type == TSON_BT_BINARY_UINT32 ||
				type == TSON_BT_BINARY_UINT64;
	}

	public inline static function isArray(type:TsonValueType):Bool {
		return type == TSON_BT_ARRAY_UINT8 ||
				type == TSON_BT_ARRAY_UINT16 ||
				type == TSON_BT_ARRAY_UINT32 ||
				type == TSON_BT_ARRAY_UINT64;
	}

	public inline static function isMap(type:TsonValueType):Bool {
		return type == TSON_BT_MAP_UINT8 ||
				type == TSON_BT_MAP_UINT16 ||
				type == TSON_BT_MAP_UINT32 ||
				type == TSON_BT_MAP_UINT64;
	}

	public inline static function isIterable(type:TsonValueType):Bool {
		return isMap(type) || isArray(type);
	}

	public inline static function getSizeInBytes(type:TsonValueType):Int {
		return switch(type) {
			case TSON_BT_NULL |
					TSON_BT_FALSE |
					TSON_BT_TRUE |
					TSON_BT_ESTRING:
				0;
			case TSON_BT_UINT8 |
					TSON_BT_INT8 |
					TSON_BT_STRING_UINT8 |
					TSON_BT_BINARY_UINT8 |
					TSON_BT_ARRAY_UINT8 |
					TSON_BT_MAP_UINT8:
				1;
			case TSON_BT_UINT16 |
					TSON_BT_INT16 |
					TSON_BT_STRING_UINT16 |
					TSON_BT_BINARY_UINT16 |
					TSON_BT_ARRAY_UINT16 |
					TSON_BT_MAP_UINT16:
				2;
			case TSON_BT_UINT32 |
					TSON_BT_INT32 |
					TSON_BT_FLOAT32 |
					TSON_BT_STRING_UINT32 |
					TSON_BT_BINARY_UINT32 |
					TSON_BT_ARRAY_UINT32 |
					TSON_BT_MAP_UINT32:
				4;
			case TSON_BT_UINT64 |
					TSON_BT_INT64 |
					TSON_BT_FLOAT64 |
					TSON_BT_STRING_UINT64 |
					TSON_BT_BINARY_UINT64 |
					TSON_BT_ARRAY_UINT64 |
					TSON_BT_MAP_UINT64:
				8;
			default:
				0;
		}
	}

	public inline static function toString(type:TsonValueType):String {
		return switch(type) {
			case TSON_BT_NULL:
				"null";
			case TSON_BT_FALSE:
				"false";
			case TSON_BT_TRUE:
				"true";
			case TSON_BT_ESTRING:
				"empty string";
			case TSON_BT_UINT8:
				"uint8";
			case TSON_BT_INT8:
				"int8";
			case TSON_BT_STRING_UINT8:
				"string uint8";
			case TSON_BT_BINARY_UINT8:
				"binary uint8";
			case TSON_BT_ARRAY_UINT8:
				"array uint8";
			case TSON_BT_MAP_UINT8:
				"object uint8";
			case TSON_BT_UINT16:
				"uint16";
			case TSON_BT_INT16:
				"int16";
			case TSON_BT_STRING_UINT16:
				"string uint16";
			case TSON_BT_BINARY_UINT16:
				"binary uint16";
			case TSON_BT_ARRAY_UINT16:
				"array uint16";
			case TSON_BT_MAP_UINT16:
				"object uint16";
			case TSON_BT_UINT32:
				"uint32";
			case TSON_BT_INT32:
				"int32";
			case TSON_BT_FLOAT32:
				"float32";
			case TSON_BT_STRING_UINT32:
				"string uint32";
			case TSON_BT_BINARY_UINT32:
				"binary uint32";
			case TSON_BT_ARRAY_UINT32:
				"array uint32";
			case TSON_BT_MAP_UINT32:
				"object uint32";
			case TSON_BT_UINT64:
				"uint64";
			case TSON_BT_INT64:
				"int64";
			case TSON_BT_FLOAT64:
				"float64";
			case TSON_BT_STRING_UINT64:
				"string uint64";
			case TSON_BT_BINARY_UINT64:
				"binary uint64";
			case TSON_BT_ARRAY_UINT64:
				"array uint64";
			case TSON_BT_MAP_UINT64:
				"object uint64";
			default:
				"unknown";
		}
	}
}
