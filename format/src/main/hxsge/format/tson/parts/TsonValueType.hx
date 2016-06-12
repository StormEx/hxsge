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

	public inline static function getDefault():TsonValueType {
		return TSON_BT_NULL;
	}
}
