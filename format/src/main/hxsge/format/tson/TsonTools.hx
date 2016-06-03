package hxsge.format.tson;

import hxsge.format.tson.parts.TsonBlock;
import hxsge.format.tson.parts.TsonBlockType;

using hxsge.core.utils.StringTools;
using hxsge.core.utils.ArrayTools;

class TsonTools {
	public static function add(block:TsonBlock, newBlock:TsonBlock):Bool {
		if(newBlock == null) {
			return false;
		}

		if(isMap(block) && newBlock.name.isEmpty()) {
			return false;
		}
		else {
			if(isArray(block)) {
				newBlock.nameIndex = -1;
			}
		}
		block.array.push(newBlock);

		return true;
	}

	public static function change(block:TsonBlock, type:TsonBlockType, data:Dynamic) {
		@:privateAccess block.type = type;
		@:privateAccess block.data = data;
	}

	public static function blockByName(block:TsonBlock, name:String):TsonBlock {
		if(block == null) {
			return null;
		}

		if(isMap(block)) {
			for(e in block.array) {
				if(e.name == name) {
					return e;
				}
			}
		}

		return null;
	}

	public static function blockByIndex(block:TsonBlock, index:Int):TsonBlock {
		if(isArray(block) && index >= 0) {
			if(index < block.array.length) {
				return block.array[index];
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
			for(e in block.array) {
				if(e.name.isNotEmpty()) {
					arr.push(e.name);
				}
			}
		}

		return arr;
	}

	public static function blocks(block:TsonBlock):Array<TsonBlock> {
		if(isArray(block) || isMap(block)) {
			return block.array;
		}

		return [];
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
				for(val in block.array) {
					arr.push(toDynamic(val, names));
				}
				arr;
			case TsonBlockType.TSON_BT_MAP_UINT8 |
			TsonBlockType.TSON_BT_MAP_UINT16 |
			TsonBlockType.TSON_BT_MAP_UINT32 |
			TsonBlockType.TSON_BT_MAP_UINT64:
				var res:Dynamic = {};
				for(val in block.array) {
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
		return block == null ? false : (TsonBlockType.isMap(block.type) && block.array.isNotEmpty());
	}

	public static function isArray(block:TsonBlock):Bool {
		return block == null ? false : (TsonBlockType.isArray(block.type) && block.array.isNotEmpty());
	}
}
