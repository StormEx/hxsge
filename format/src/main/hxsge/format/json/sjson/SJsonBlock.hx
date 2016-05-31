package hxsge.format.json.sjson;

import haxe.io.BytesInput;
import hxsge.format.json.sjson.SJsonBlock;
import haxe.io.Bytes;
import hxsge.format.json.sjson.SJsonBlockType;
import haxe.io.BytesOutput;

using hxsge.core.utils.StringTools;

class SJsonBlock {
	public var type:SJsonBlockType;
	public var data:Dynamic;
	public var nameIndex:Int;
	public var size(get, never):Float;

	public function new(type:SJsonBlockType = SJsonBlockType.SJSON_BT_NULL, data:Dynamic = null, nameIndex:Int = -1) {
		this.type = type;
		this.data = data;
		this.nameIndex = nameIndex;
	}

	static public function write(block:SJsonBlock, out:BytesOutput) {
		var ival:Int;
		var fval:Float;
		var sval:String = "";
		var bval:Bytes = null;
		var aval:Array<SJsonBlock> = [];

		switch(block.type) {
			case SJsonBlockType.SJSON_BT_NULL |
					SJsonBlockType.SJSON_BT_FALSE |
					SJsonBlockType.SJSON_BT_TRUE |
					SJsonBlockType.SJSON_BT_ESTRING:
				out.writeInt8(block.type);
				out.writeInt16(block.nameIndex);
			case SJsonBlockType.SJSON_BT_UINT8 |
					SJsonBlockType.SJSON_BT_UINT16 |
					SJsonBlockType.SJSON_BT_UINT32 |
					SJsonBlockType.SJSON_BT_UINT64:
			case SJsonBlockType.SJSON_BT_INT8:
				ival = cast block.data;

				out.writeInt8(block.type);
				out.writeInt16(block.nameIndex);
				out.writeInt8(ival);
			case SJsonBlockType.SJSON_BT_INT16:
				ival = cast block.data;

				out.writeInt8(block.type);
				out.writeInt16(block.nameIndex);
				out.writeInt16(ival);
			case SJsonBlockType.SJSON_BT_INT32:
				ival = cast block.data;

				out.writeInt8(block.type);
				out.writeInt16(block.nameIndex);
				out.writeInt32(ival);
			case SJsonBlockType.SJSON_BT_INT64:
			case SJsonBlockType.SJSON_BT_FLOAT32:
				fval = cast block.data;

				out.writeInt8(block.type);
				out.writeInt16(block.nameIndex);
				out.writeFloat(fval);
			case SJsonBlockType.SJSON_BT_FLOAT64:
				var fval = cast block.data;

				out.writeInt8(block.type);
				out.writeInt16(block.nameIndex);
				out.writeDouble(fval);
			case SJsonBlockType.SJSON_BT_STRING_UINT8 |
					SJsonBlockType.SJSON_BT_STRING_UINT16 |
					SJsonBlockType.SJSON_BT_STRING_UINT32 |
					SJsonBlockType.SJSON_BT_STRING_UINT64:
				sval = Std.string(block.data);

				out.writeInt8(block.type);
				out.writeInt16(block.nameIndex);
				out.writeInt32(sval.length);
				out.writeString(sval);
			case SJsonBlockType.SJSON_BT_BINARY_UINT8 |
					SJsonBlockType.SJSON_BT_BINARY_UINT16 |
					SJsonBlockType.SJSON_BT_BINARY_UINT32 |
					SJsonBlockType.SJSON_BT_BINARY_UINT64:
				var val:BytesOutput = cast block.data;
				bval = val.getBytes();

				out.writeInt8(block.type);
				out.writeInt16(block.nameIndex);
				out.writeInt32(bval.length);
				out.writeBytes(bval, 0, bval.length);
			case SJsonBlockType.SJSON_BT_ARRAY_UINT8 |
					SJsonBlockType.SJSON_BT_ARRAY_UINT16 |
					SJsonBlockType.SJSON_BT_ARRAY_UINT32 |
					SJsonBlockType.SJSON_BT_ARRAY_UINT64 |
					SJsonBlockType.SJSON_BT_MAP_UINT8 |
					SJsonBlockType.SJSON_BT_MAP_UINT16 |
					SJsonBlockType.SJSON_BT_MAP_UINT32 |
					SJsonBlockType.SJSON_BT_MAP_UINT64:
				aval = cast block.data;

				out.writeInt8(block.type);
				out.writeInt16(block.nameIndex);
				out.writeFloat(block.size);
				out.writeInt32(aval.length);
				for(i in aval) {
					SJsonBlock.write(i, out);
				}
			default:
		}
	}

	static public function read(stream:BytesInput):SJsonBlock {
		var ival:Int;
		var fval:Float;
		var sval:String = "";
		var bval:Bytes = null;
		var aval:Array<SJsonBlock> = [];

		var res:SJsonBlock = new SJsonBlock();
		res.type = stream.readInt8();

		switch(res.type) {
			case SJsonBlockType.SJSON_BT_NULL |
					SJsonBlockType.SJSON_BT_FALSE |
					SJsonBlockType.SJSON_BT_TRUE |
					SJsonBlockType.SJSON_BT_ESTRING:
				res.nameIndex = stream.readInt16();
			case SJsonBlockType.SJSON_BT_UINT8 |
					SJsonBlockType.SJSON_BT_UINT16 |
					SJsonBlockType.SJSON_BT_UINT32 |
					SJsonBlockType.SJSON_BT_UINT64:
			case SJsonBlockType.SJSON_BT_INT8:
				res.nameIndex = stream.readInt16();
				ival = stream.readInt8();
				res.data = ival;
			case SJsonBlockType.SJSON_BT_INT16:
				res.nameIndex = stream.readInt16();
				ival = stream.readInt16();
				res.data = ival;
			case SJsonBlockType.SJSON_BT_INT32:
				res.nameIndex = stream.readInt16();
				ival = stream.readInt32();
				res.data = ival;
			case SJsonBlockType.SJSON_BT_INT64:
			case SJsonBlockType.SJSON_BT_FLOAT32:
				res.nameIndex = stream.readInt16();
				fval = stream.readFloat();
				res.data = fval;
			case SJsonBlockType.SJSON_BT_FLOAT64:
				res.nameIndex = stream.readInt16();
				fval = stream.readDouble();
				res.data = fval;
			case SJsonBlockType.SJSON_BT_STRING_UINT8 |
					SJsonBlockType.SJSON_BT_STRING_UINT16 |
					SJsonBlockType.SJSON_BT_STRING_UINT32 |
					SJsonBlockType.SJSON_BT_STRING_UINT64:
				res.nameIndex = stream.readInt16();
				ival = stream.readInt32();
				sval = stream.readString(ival);
				res.data = sval;
			case SJsonBlockType.SJSON_BT_BINARY_UINT8 |
					SJsonBlockType.SJSON_BT_BINARY_UINT16 |
					SJsonBlockType.SJSON_BT_BINARY_UINT32 |
					SJsonBlockType.SJSON_BT_BINARY_UINT64:
				res.nameIndex = stream.readInt16();
				ival = stream.readInt32();
				bval = Bytes.alloc(ival);
				stream.readBytes(bval, 0, ival);
			case SJsonBlockType.SJSON_BT_ARRAY_UINT8 |
					SJsonBlockType.SJSON_BT_ARRAY_UINT16 |
					SJsonBlockType.SJSON_BT_ARRAY_UINT32 |
					SJsonBlockType.SJSON_BT_ARRAY_UINT64 |
					SJsonBlockType.SJSON_BT_MAP_UINT8 |
					SJsonBlockType.SJSON_BT_MAP_UINT16 |
					SJsonBlockType.SJSON_BT_MAP_UINT32 |
					SJsonBlockType.SJSON_BT_MAP_UINT64:
				aval = [];
				res.nameIndex = stream.readInt16();
				fval = stream.readFloat();
				ival = stream.readInt32();
				for(i in 0...ival) {
					aval.push(SJsonBlock.read(stream));
				}
				res.data = aval;
			default:
		}

		return res;
	}

	public function toObject(names:Map<Int, String>):Dynamic {
		return switch(type) {
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
				var from:Array<SJsonBlock> = data;
				for(val in from) {
					arr.push(val.toObject(names));
				}
				arr;
			case SJsonBlockType.SJSON_BT_MAP_UINT8 |
			SJsonBlockType.SJSON_BT_MAP_UINT16 |
			SJsonBlockType.SJSON_BT_MAP_UINT32 |
			SJsonBlockType.SJSON_BT_MAP_UINT64:
				var arr:Array<SJsonBlock> = cast data;
				var res:Dynamic = {};
				for(val in arr) {
					Reflect.setField(res, names.get(val.nameIndex), val.toObject(names));
				}
				res;
			default:
				data;
		}
	}

	function get_size():Float {
		return switch(type) {
			case SJsonBlockType.SJSON_BT_UINT8 | SJsonBlockType.SJSON_BT_INT8:
				(1 + 2 + 1);
			case SJsonBlockType.SJSON_BT_UINT16 | SJsonBlockType.SJSON_BT_INT16:
				(1 + 2 + 2);
			case SJsonBlockType.SJSON_BT_UINT32 |
					SJsonBlockType.SJSON_BT_UINT64 |
					SJsonBlockType.SJSON_BT_INT32 |
					SJsonBlockType.SJSON_BT_INT64 |
					SJsonBlockType.SJSON_BT_FLOAT32:
				(1 + 2 + 4);
			case SJsonBlockType.SJSON_BT_FLOAT64:
				(1 + 2 + 8);
			case SJsonBlockType.SJSON_BT_STRING_UINT8 |
					SJsonBlockType.SJSON_BT_STRING_UINT16 |
					SJsonBlockType.SJSON_BT_STRING_UINT32 |
					SJsonBlockType.SJSON_BT_STRING_UINT64:
				var val:String = cast data;
				(1 + 2 + 4 + val.length);
			case SJsonBlockType.SJSON_BT_BINARY_UINT8 |
					SJsonBlockType.SJSON_BT_BINARY_UINT16 |
					SJsonBlockType.SJSON_BT_BINARY_UINT32 |
					SJsonBlockType.SJSON_BT_BINARY_UINT64:
				var val:BytesOutput = cast data;
				var b:Bytes = val.getBytes();
				(1 + 2 + 4 + b.length);
			case SJsonBlockType.SJSON_BT_ARRAY_UINT8 |
					SJsonBlockType.SJSON_BT_ARRAY_UINT16 |
					SJsonBlockType.SJSON_BT_ARRAY_UINT32 |
					SJsonBlockType.SJSON_BT_ARRAY_UINT64 |
					SJsonBlockType.SJSON_BT_MAP_UINT8 |
					SJsonBlockType.SJSON_BT_MAP_UINT16 |
					SJsonBlockType.SJSON_BT_MAP_UINT32 |
					SJsonBlockType.SJSON_BT_MAP_UINT64:
				var val:Array<SJsonBlock> = cast data;
				var res:Float = 0;

				for(i in val) {
					res += i.size;
				}
				(1 + 2 + 4 + 4 + res);
			default:
				(1 + 2);
		}
	}
}
