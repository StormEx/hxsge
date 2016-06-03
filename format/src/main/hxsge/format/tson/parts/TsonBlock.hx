package hxsge.format.tson.parts;

import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.BytesOutput;

using hxsge.core.utils.StringTools;
using hxsge.format.tson.TsonTools;

class TsonBlock {
	public var array(default, null):Array<TsonBlock> = null;

	public var type:TsonBlockType;
	public var data(default, set):Dynamic;
	public var nameIndex:Int;
	public var name:String;
	public var size(get, never):Float;

	public function new(type:TsonBlockType = TsonBlockType.TSON_BT_NULL, data:Dynamic = null, nameIndex:Int = -1,
						name:String = null) {
		this.type = type;
		this.data = data;
		this.nameIndex = nameIndex;
	}

	public function write(out:BytesOutput) {
		var ival:Int;
		var fval:Float;
		var sval:String = "";
		var bval:Bytes = null;

		switch(type) {
			case TsonBlockType.TSON_BT_NULL |
					TsonBlockType.TSON_BT_FALSE |
					TsonBlockType.TSON_BT_TRUE |
					TsonBlockType.TSON_BT_ESTRING:
				out.writeInt8(type);
				out.writeInt16(nameIndex);
			case TsonBlockType.TSON_BT_UINT8 |
					TsonBlockType.TSON_BT_UINT16 |
					TsonBlockType.TSON_BT_UINT32 |
					TsonBlockType.TSON_BT_UINT64:
			case TsonBlockType.TSON_BT_INT8:
				ival = cast data;

				out.writeInt8(type);
				out.writeInt16(nameIndex);
				out.writeInt8(ival);
			case TsonBlockType.TSON_BT_INT16:
				ival = cast data;

				out.writeInt8(type);
				out.writeInt16(nameIndex);
				out.writeInt16(ival);
			case TsonBlockType.TSON_BT_INT32:
				ival = cast data;

				out.writeInt8(type);
				out.writeInt16(nameIndex);
				out.writeInt32(ival);
			case TsonBlockType.TSON_BT_INT64:
			case TsonBlockType.TSON_BT_FLOAT32:
				fval = cast data;

				out.writeInt8(type);
				out.writeInt16(nameIndex);
				out.writeFloat(fval);
			case TsonBlockType.TSON_BT_FLOAT64:
				var fval = cast data;

				out.writeInt8(type);
				out.writeInt16(nameIndex);
				out.writeDouble(fval);
			case TsonBlockType.TSON_BT_STRING_UINT8 |
					TsonBlockType.TSON_BT_STRING_UINT16 |
					TsonBlockType.TSON_BT_STRING_UINT32 |
					TsonBlockType.TSON_BT_STRING_UINT64:
				sval = Std.string(data);

				out.writeInt8(type);
				out.writeInt16(nameIndex);
				out.writeInt32(sval.length);
				out.writeString(sval);
			case TsonBlockType.TSON_BT_BINARY_UINT8 |
					TsonBlockType.TSON_BT_BINARY_UINT16 |
					TsonBlockType.TSON_BT_BINARY_UINT32 |
					TsonBlockType.TSON_BT_BINARY_UINT64:
				var val:BytesOutput = cast data;
				bval = val.getBytes();

				out.writeInt8(type);
				out.writeInt16(nameIndex);
				out.writeInt32(bval.length);
				out.writeBytes(bval, 0, bval.length);
			case TsonBlockType.TSON_BT_ARRAY_UINT8 |
					TsonBlockType.TSON_BT_ARRAY_UINT16 |
					TsonBlockType.TSON_BT_ARRAY_UINT32 |
					TsonBlockType.TSON_BT_ARRAY_UINT64 |
					TsonBlockType.TSON_BT_MAP_UINT8 |
					TsonBlockType.TSON_BT_MAP_UINT16 |
					TsonBlockType.TSON_BT_MAP_UINT32 |
					TsonBlockType.TSON_BT_MAP_UINT64:
				out.writeInt8(type);
				out.writeInt16(nameIndex);
				out.writeFloat(size);
				out.writeInt32(array.length);
				for(i in array) {
					i.write(out);
				}
			default:
		}
	}

	static public function read(stream:BytesInput, header:TsonHeader):TsonBlock {
		var ival:Int;
		var fval:Float;
		var sval:String = "";
		var bval:Bytes = null;

		var res:TsonBlock = new TsonBlock();
		res.type = stream.readInt8();

		switch(res.type) {
			case TsonBlockType.TSON_BT_NULL |
					TsonBlockType.TSON_BT_FALSE |
					TsonBlockType.TSON_BT_TRUE |
					TsonBlockType.TSON_BT_ESTRING:
				res.nameIndex = stream.readInt16();
			case TsonBlockType.TSON_BT_UINT8 |
					TsonBlockType.TSON_BT_UINT16 |
					TsonBlockType.TSON_BT_UINT32 |
					TsonBlockType.TSON_BT_UINT64:
			case TsonBlockType.TSON_BT_INT8:
				res.nameIndex = stream.readInt16();
				ival = stream.readInt8();
				res.data = ival;
			case TsonBlockType.TSON_BT_INT16:
				res.nameIndex = stream.readInt16();
				ival = stream.readInt16();
				res.data = ival;
			case TsonBlockType.TSON_BT_INT32:
				res.nameIndex = stream.readInt16();
				ival = stream.readInt32();
				res.data = ival;
			case TsonBlockType.TSON_BT_INT64:
			case TsonBlockType.TSON_BT_FLOAT32:
				res.nameIndex = stream.readInt16();
				fval = stream.readFloat();
				res.data = fval;
			case TsonBlockType.TSON_BT_FLOAT64:
				res.nameIndex = stream.readInt16();
				fval = stream.readDouble();
				res.data = fval;
			case TsonBlockType.TSON_BT_STRING_UINT8 |
					TsonBlockType.TSON_BT_STRING_UINT16 |
					TsonBlockType.TSON_BT_STRING_UINT32 |
					TsonBlockType.TSON_BT_STRING_UINT64:
				res.nameIndex = stream.readInt16();
				ival = stream.readInt32();
				sval = stream.readString(ival);
				res.data = sval;
			case TsonBlockType.TSON_BT_BINARY_UINT8 |
					TsonBlockType.TSON_BT_BINARY_UINT16 |
					TsonBlockType.TSON_BT_BINARY_UINT32 |
					TsonBlockType.TSON_BT_BINARY_UINT64:
				res.nameIndex = stream.readInt16();
				ival = stream.readInt32();
				bval = Bytes.alloc(ival);
				stream.readBytes(bval, 0, ival);
				res.data = new BytesOutput();
				res.data.writeBytes(bval, 0, bval.length);
			case TsonBlockType.TSON_BT_ARRAY_UINT8 |
					TsonBlockType.TSON_BT_ARRAY_UINT16 |
					TsonBlockType.TSON_BT_ARRAY_UINT32 |
					TsonBlockType.TSON_BT_ARRAY_UINT64 |
					TsonBlockType.TSON_BT_MAP_UINT8 |
					TsonBlockType.TSON_BT_MAP_UINT16 |
					TsonBlockType.TSON_BT_MAP_UINT32 |
					TsonBlockType.TSON_BT_MAP_UINT64:
				res.array = [];
				res.nameIndex = stream.readInt16();
				fval = stream.readFloat();
				ival = stream.readInt32();
				for(i in 0...ival) {
					res.array.push(TsonBlock.read(stream, header));
				}
				res.data = res.array;
			default:
		}

		if(res.nameIndex != -1) {
			res.name = header.keys.get(res.nameIndex);
		}

		return res;
	}

	function get_size():Float {
		var oval:BytesOutput;
		var sval:String;

		return switch(type) {
			case TsonBlockType.TSON_BT_UINT8 | TsonBlockType.TSON_BT_INT8:
				(1 + 2 + 1);
			case TsonBlockType.TSON_BT_UINT16 | TsonBlockType.TSON_BT_INT16:
				(1 + 2 + 2);
			case TsonBlockType.TSON_BT_UINT32 |
					TsonBlockType.TSON_BT_UINT64 |
					TsonBlockType.TSON_BT_INT32 |
					TsonBlockType.TSON_BT_INT64 |
					TsonBlockType.TSON_BT_FLOAT32:
				(1 + 2 + 4);
			case TsonBlockType.TSON_BT_FLOAT64:
				(1 + 2 + 8);
			case TsonBlockType.TSON_BT_STRING_UINT8 |
					TsonBlockType.TSON_BT_STRING_UINT16 |
					TsonBlockType.TSON_BT_STRING_UINT32 |
					TsonBlockType.TSON_BT_STRING_UINT64:
				sval = cast data;
				(1 + 2 + 4 + sval.length);
			case TsonBlockType.TSON_BT_BINARY_UINT8 |
					TsonBlockType.TSON_BT_BINARY_UINT16 |
					TsonBlockType.TSON_BT_BINARY_UINT32 |
					TsonBlockType.TSON_BT_BINARY_UINT64:
				oval = Std.instance(data, BytesOutput);
				(1 + 2 + 4 + (oval == null ? 0 : oval.length));
			case TsonBlockType.TSON_BT_ARRAY_UINT8 |
					TsonBlockType.TSON_BT_ARRAY_UINT16 |
					TsonBlockType.TSON_BT_ARRAY_UINT32 |
					TsonBlockType.TSON_BT_ARRAY_UINT64 |
					TsonBlockType.TSON_BT_MAP_UINT8 |
					TsonBlockType.TSON_BT_MAP_UINT16 |
					TsonBlockType.TSON_BT_MAP_UINT32 |
					TsonBlockType.TSON_BT_MAP_UINT64:
				var res:Float = 0;

				for(i in array) {
					res += i.size;
				}
				(1 + 2 + 4 + 4 + res);
			default:
				(1 + 2);
		}
	}

	function set_data(value:Dynamic):Dynamic {
		data = value;
		if(TsonBlockType.isArray(type) || TsonBlockType.isMap(type)) {
			this.array = cast this.data;
		}

		return data;
	}
}
