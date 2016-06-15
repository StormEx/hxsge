package hxsge.examples.format.tson.data;

import hxsge.core.utils.Pair;
import hxsge.format.tson.data.TsonValueType;

using hxsge.format.tson.data.TsonValueTypeTools;

@:enum abstract TsonPropertyDataType(String) from String to String {
	var NULL = "null";
	var OPTIONS = "options";
	var BOOL = "bool";
	var INT = "int";
	var FLOAT = "float";
	var STRING = "string";
	var BINARY = "binary";
	var ARRAY = "array";
	var OBJECT = "object";
	var NUMBER = "number";

	public static inline function getTypesForChoose():Array<TsonPropertyDataType> {
		return [NULL, BOOL, INT, FLOAT, STRING, BINARY, ARRAY, OBJECT];
	}

	public static inline function getTypesMapForChoose():Map<String, String> {
		var map:Map<String, String> = [
			NULL => "null",
			BOOL => "bool",
			INT => "int",
			FLOAT => "float",
			STRING => "string",
			BINARY => "binary",
			ARRAY => "array",
			OBJECT => "object"
		];

		return map;
	}

	public static inline function convertToTsonTypeValuePair(type:TsonPropertyDataType, value:Dynamic):Pair<TsonValueType, Dynamic> {
		var pair:Pair<TsonValueType, Dynamic> = new Pair(TsonValueType.getDefault(), value);

		return pair;
	}

	public static inline function convertType(blockType:TsonValueType):TsonPropertyDataType {
		return switch(blockType) {
			case TsonValueType.TSON_BT_NULL:
				TsonPropertyDataType.NULL;
			case TsonValueType.TSON_BT_FALSE |
			TsonValueType.TSON_BT_TRUE:
				TsonPropertyDataType.BOOL;
			case TsonValueType.TSON_BT_UINT8 |
			TsonValueType.TSON_BT_UINT16 |
			TsonValueType.TSON_BT_UINT32 |
			TsonValueType.TSON_BT_UINT64 |
			TsonValueType.TSON_BT_INT8 |
			TsonValueType.TSON_BT_INT16 |
			TsonValueType.TSON_BT_INT32 |
			TsonValueType.TSON_BT_INT64:
				TsonPropertyDataType.INT;
			case TsonValueType.TSON_BT_FLOAT32 |
			TsonValueType.TSON_BT_FLOAT64:
				TsonPropertyDataType.FLOAT;
			case TsonValueType.TSON_BT_BINARY_UINT8 |
			TsonValueType.TSON_BT_BINARY_UINT16 |
			TsonValueType.TSON_BT_BINARY_UINT32 |
			TsonValueType.TSON_BT_BINARY_UINT64:
				TsonPropertyDataType.BINARY;
			case TsonValueType.TSON_BT_ESTRING |
			TsonValueType.TSON_BT_STRING_UINT8 |
			TsonValueType.TSON_BT_STRING_UINT16 |
			TsonValueType.TSON_BT_STRING_UINT32 |
			TsonValueType.TSON_BT_STRING_UINT64:
				TsonPropertyDataType.STRING;
			case TsonValueType.TSON_BT_ARRAY_UINT8 |
			TsonValueType.TSON_BT_ARRAY_UINT16 |
			TsonValueType.TSON_BT_ARRAY_UINT32 |
			TsonValueType.TSON_BT_ARRAY_UINT64:
				TsonPropertyDataType.ARRAY;
			case TsonValueType.TSON_BT_MAP_UINT8 |
			TsonValueType.TSON_BT_MAP_UINT16 |
			TsonValueType.TSON_BT_MAP_UINT32 |
			TsonValueType.TSON_BT_MAP_UINT64:
				TsonPropertyDataType.OBJECT;
			default:
				TsonPropertyDataType.NULL;
		}
	}
}
