package hxsge.format.tools.tson.data;

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
			case TsonValueType.NULL:
				TsonPropertyDataType.NULL;
			case TsonValueType.FALSE |
			TsonValueType.TRUE:
				TsonPropertyDataType.BOOL;
			case TsonValueType.UINT8 |
			TsonValueType.UINT16 |
			TsonValueType.UINT32 |
			TsonValueType.UINT64 |
			TsonValueType.INT8 |
			TsonValueType.INT16 |
			TsonValueType.INT32 |
			TsonValueType.INT64:
				TsonPropertyDataType.INT;
			case TsonValueType.FLOAT32 |
			TsonValueType.FLOAT64:
				TsonPropertyDataType.FLOAT;
			case TsonValueType.BINARY_UINT8 |
			TsonValueType.BINARY_UINT16 |
			TsonValueType.BINARY_UINT32 |
			TsonValueType.BINARY_UINT64:
				TsonPropertyDataType.BINARY;
			case TsonValueType.ESTRING |
			TsonValueType.STRING_UINT8 |
			TsonValueType.STRING_UINT16 |
			TsonValueType.STRING_UINT32 |
			TsonValueType.STRING_UINT64:
				TsonPropertyDataType.STRING;
			case TsonValueType.ARRAY_UINT8 |
			TsonValueType.ARRAY_UINT16 |
			TsonValueType.ARRAY_UINT32 |
			TsonValueType.ARRAY_UINT64:
				TsonPropertyDataType.ARRAY;
			case TsonValueType.MAP_UINT8 |
			TsonValueType.MAP_UINT16 |
			TsonValueType.MAP_UINT32 |
			TsonValueType.MAP_UINT64:
				TsonPropertyDataType.OBJECT;
			default:
				TsonPropertyDataType.NULL;
		}
	}
}
