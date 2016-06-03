package hxsge.format.tson;

import hxsge.format.tson.parts.TsonBlock;
import hxsge.format.tson.parts.TsonBlockType;

using hxsge.core.utils.StringTools;

class TsonTools {
	public static function change(block:TsonBlock, type:TsonBlockType, data:Dynamic) {
		@:privateAccess block.type = type;
		@:privateAccess block.data = data;
	}

	public static function blockByName(block:TsonBlock, name:String):TsonBlock {
		if(block == null) {
			return null;
		}

		if(isMap(block)) {
			var arr:Array<TsonBlock> = cast block.data;
			for(e in arr) {
				if(e.name == name) {
					return e;
				}
			}
		}

		return null;
	}

	public static function names(block:TsonBlock):Array<String> {
		var arr:Array<String> = [];

		if(block == null) {
			return arr;
		}

		if(isMap(block)) {
			var vals:Array<TsonBlock> = cast block.data;
			for(e in vals) {
				if(e.name.isNotEmpty()) {
					arr.push(e.name);
				}
			}
		}

		return arr;
	}

	public static function toDynamic(block:TsonBlock, names:Map<Int, String>):Dynamic {
		if(block == null) {
			return null;
		}

		return switch(block.type) {
			case TsonBlockType.TSON_BT_NULL:
				null;
			case TsonBlockType.TSON_BT_FALSE:
				false;
			case TsonBlockType.TSON_BT_TRUE:
				true;
			case TsonBlockType.TSON_BT_ESTRING:
				"";
			case TsonBlockType.TSON_BT_ARRAY_UINT8 |
			TsonBlockType.TSON_BT_ARRAY_UINT16 |
			TsonBlockType.TSON_BT_ARRAY_UINT32 |
			TsonBlockType.TSON_BT_ARRAY_UINT64:
				var arr:Array<Dynamic> = [];
				var from:Array<TsonBlock> = block.data;
				for(val in from) {
					arr.push(toDynamic(val, names));
				}
				arr;
			case TsonBlockType.TSON_BT_MAP_UINT8 |
			TsonBlockType.TSON_BT_MAP_UINT16 |
			TsonBlockType.TSON_BT_MAP_UINT32 |
			TsonBlockType.TSON_BT_MAP_UINT64:
				var arr:Array<TsonBlock> = cast block.data;
				var res:Dynamic = {};
				for(val in arr) {
					Reflect.setField(res, names.get(val.nameIndex), toDynamic(val, names));
				}
				res;
			default:
				block.data;
		}
	}

	public static function getData<T>(block:TsonBlock):T {
		return block == null ? null : cast block.data;
	}

	public static function isMap(block:TsonBlock):Bool {
		return block == null ? false : (block.type == TsonBlockType.TSON_BT_MAP_UINT8 ||
			block.type == TsonBlockType.TSON_BT_MAP_UINT16 ||
			block.type == TsonBlockType.TSON_BT_MAP_UINT32 ||
			block.type == TsonBlockType.TSON_BT_MAP_UINT64);
	}

	public static function isArray(block:TsonBlock):Bool {
		return block == null ? false : (block.type == TsonBlockType.TSON_BT_ARRAY_UINT8 ||
			block.type == TsonBlockType.TSON_BT_ARRAY_UINT16 ||
			block.type == TsonBlockType.TSON_BT_ARRAY_UINT32 ||
			block.type == TsonBlockType.TSON_BT_ARRAY_UINT64);
	}
}
