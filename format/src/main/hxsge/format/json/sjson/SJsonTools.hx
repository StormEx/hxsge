package hxsge.format.json.sjson;

import hxsge.format.json.sjson.parts.SJsonBlock;
import hxsge.format.json.sjson.parts.SJsonBlockType;

using hxsge.core.utils.StringTools;

class SJsonTools {
	public static function blockByName(block:SJsonBlock, name:String):SJsonBlock {
		if(block == null) {
			return null;
		}

		if(isMap(block)) {
			var arr:Array<SJsonBlock> = cast block.data;
			for(e in arr) {
				if(e.name == name) {
					return e;
				}
			}
		}

		return null;
	}

	public static function names(block:SJsonBlock):Array<String> {
		var arr:Array<String> = [];

		if(block == null) {
			return arr;
		}

		if(isMap(block)) {
			var vals:Array<SJsonBlock> = cast block.data;
			for(e in vals) {
				if(e.name.isNotEmpty()) {
					arr.push(e.name);
				}
			}
		}

		return arr;
	}

	public static function toDynamic(block:SJsonBlock, names:Map<Int, String>):Dynamic {
		if(block == null) {
			return null;
		}

		return switch(block.type) {
			case SJsonBlockType.SJSON_BT_NULL:
				null;
			case SJsonBlockType.SJSON_BT_FALSE:
				false;
			case SJsonBlockType.SJSON_BT_TRUE:
				true;
			case SJsonBlockType.SJSON_BT_ESTRING:
				"";
			case SJsonBlockType.SJSON_BT_ARRAY_UINT8 |
			SJsonBlockType.SJSON_BT_ARRAY_UINT16 |
			SJsonBlockType.SJSON_BT_ARRAY_UINT32 |
			SJsonBlockType.SJSON_BT_ARRAY_UINT64:
				var arr:Array<Dynamic> = [];
				var from:Array<SJsonBlock> = block.data;
				for(val in from) {
					arr.push(toDynamic(val, names));
				}
				arr;
			case SJsonBlockType.SJSON_BT_MAP_UINT8 |
			SJsonBlockType.SJSON_BT_MAP_UINT16 |
			SJsonBlockType.SJSON_BT_MAP_UINT32 |
			SJsonBlockType.SJSON_BT_MAP_UINT64:
				var arr:Array<SJsonBlock> = cast block.data;
				var res:Dynamic = {};
				for(val in arr) {
					Reflect.setField(res, names.get(val.nameIndex), toDynamic(val, names));
				}
				res;
			default:
				block.data;
		}
	}

	public static function getData<T>(block:SJsonBlock):T {
		return block == null ? null : cast block.data;
	}

	public static function isMap(block:SJsonBlock):Bool {
		return block == null ? false : (block.type == SJsonBlockType.SJSON_BT_MAP_UINT8 ||
			block.type == SJsonBlockType.SJSON_BT_MAP_UINT16 ||
			block.type == SJsonBlockType.SJSON_BT_MAP_UINT32 ||
			block.type == SJsonBlockType.SJSON_BT_MAP_UINT64);
	}

	public static function isArray(block:SJsonBlock):Bool {
		return block == null ? false : (block.type == SJsonBlockType.SJSON_BT_ARRAY_UINT8 ||
			block.type == SJsonBlockType.SJSON_BT_ARRAY_UINT16 ||
			block.type == SJsonBlockType.SJSON_BT_ARRAY_UINT32 ||
			block.type == SJsonBlockType.SJSON_BT_ARRAY_UINT64);
	}
}
