package hxsge.format.tson;

import hxsge.core.debug.Debug;
import hxsge.format.tson.parts.TsonHeader;
import hxsge.format.tson.parts.TsonBlock;
import hxsge.format.tson.parts.TsonValueType;

using hxsge.core.utils.StringTools;
using hxsge.core.utils.ArrayTools;
using hxsge.format.tson.parts.TsonValueTypeTools;

class TsonTools {
//	public static function add(block:TsonBlock, newBlock:TsonBlock):Bool {
//		if(newBlock == null) {
//			return false;
//		}
//
//		if(isMap(block) && newBlock.name.isEmpty()) {
//			return false;
//		}
//		else {
//			if(isArray(block)) {
//				newBlock.nameIndex = -1;
//			}
//		}
//		block.array.push(newBlock);
//
//		return true;
//	}
//
//	public static function change(block:TsonBlock, type:TsonValueType, data:Dynamic) {
//		@:privateAccess block.type = type;
//		@:privateAccess block.data = data;
//	}
//
//	public static function changeType(block:TsonBlock, type:TsonValueType) {
//
//	}
//
//	public static function blockByName(block:TsonBlock, name:String):TsonBlock {
//		if(block == null) {
//			return null;
//		}
//
//		if(isMap(block)) {
//			for(e in block.array) {
//				if(e.name == name) {
//					return e;
//				}
//			}
//		}
//
//		return null;
//	}
//
//	public static function blockByIndex(block:TsonBlock, index:Int):TsonBlock {
//		if(isArray(block) && index >= 0) {
//			if(index < block.array.length) {
//				return block.array[index];
//			}
//		}
//
//		return null;
//	}
//
//	public static function names(block:TsonBlock):Array<String> {
//		var arr:Array<String> = [];
//
//		if(block == null) {
//			return arr;
//		}
//
//		if(isMap(block)) {
//			for(e in block.array) {
//				if(e.name.isNotEmpty()) {
//					arr.push(e.name);
//				}
//			}
//		}
//
//		return arr;
//	}
//
//	public static function blocks(block:TsonBlock):Array<TsonBlock> {
//		if(isArray(block) || isMap(block)) {
//			return block.array;
//		}
//
//		return [];
//	}
//
//	public static function toDynamic(block:TsonBlock, names:Map<Int, String>):Dynamic {
//		if(block == null) {
//			return null;
//		}
//
//		return switch(block.type) {
//			case TsonValueType.TSON_BT_NULL:
//				null;
//			case TsonValueType.TSON_BT_FALSE:
//				false;
//			case TsonValueType.TSON_BT_TRUE:
//				true;
//			case TsonValueType.TSON_BT_ESTRING:
//				"";
//			case TsonValueType.TSON_BT_ARRAY_UINT8 |
//			TsonValueType.TSON_BT_ARRAY_UINT16 |
//			TsonValueType.TSON_BT_ARRAY_UINT32 |
//			TsonValueType.TSON_BT_ARRAY_UINT64:
//				var arr:Array<Dynamic> = [];
//				for(val in block.array) {
//					arr.push(toDynamic(val, names));
//				}
//				arr;
//			case TsonValueType.TSON_BT_MAP_UINT8 |
//			TsonValueType.TSON_BT_MAP_UINT16 |
//			TsonValueType.TSON_BT_MAP_UINT32 |
//			TsonValueType.TSON_BT_MAP_UINT64:
//				var res:Dynamic = {};
//				for(val in block.array) {
//					Reflect.setField(res, names.get(val.nameIndex), toDynamic(val, names));
//				}
//				res;
//			default:
//				block.data;
//		}
//	}
//
//	public static function createHeader(block:TsonBlock):TsonHeader {
//		var names:Array<String> = block.getNames();
//
//		return new TsonHeader(names);
//	}
//
//	public static function getData<T>(block:TsonBlock):T {
//		return block == null ? null : cast block.data;
//	}
//
//	public static function isMap(block:TsonBlock):Bool {
//		return block == null ? false : (block.type.isMap() && block.array != null);
//	}
//
//	public static function isArray(block:TsonBlock):Bool {
//		return block == null ? false : (block.type.isArray() && block.array != null);
//	}
//
//	public static function isIterable(block:TsonBlock):Bool {
//		return block == null ? false : block.type.isIterable();
//	}
}
