package hxsge.format.tson.data;

@:enum abstract TsonValueType(Int) from Int to Int {
	var NULL = 0;
	var FALSE = 1;
	var TRUE = 2;
	var ESTRING = 3;

	var UINT8 = 4;
	var UINT16 = 5;
	var UINT32 = 6;
	var UINT64 = 7;

	var INT8 = 8;
	var INT16 = 9;
	var INT32 = 10;
	var INT64 = 11;

	var FLOAT32 = 12;
	var FLOAT64 = 13;

	var STRING_UINT8 = 14;
	var STRING_UINT16 = 15;
	var STRING_UINT32 = 16;
	var STRING_UINT64 = 17;

	var BINARY_UINT8 = 18;
	var BINARY_UINT16 = 19;
	var BINARY_UINT32 = 20;
	var BINARY_UINT64 = 21;

	var ARRAY_UINT8 = 22;
	var ARRAY_UINT16 = 23;
	var ARRAY_UINT32 = 24;
	var ARRAY_UINT64 = 25;

	var MAP_UINT8 = 26;
	var MAP_UINT16 = 27;
	var MAP_UINT32 = 28;
	var MAP_UINT64 = 29;

	public inline static function getDefault():TsonValueType {
		return NULL;
	}

	public inline static function min():Int {
		return NULL;
	}

	public inline static function max():Int {
		return MAP_UINT64;
	}
}
