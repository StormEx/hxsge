package hxsge.format.tson.parts;

import haxe.Int64;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.BytesOutput;

using hxsge.core.utils.StringTools;
using hxsge.format.tson.TsonTools;
using hxsge.format.tson.parts.TsonValueTypeTools;
using hxsge.core.utils.ArrayTools;

class TsonBlock {
	public var array(default, null):Array<TsonBlock> = null;

	public var type:TsonValueType;
	public var data(default, set):Dynamic;
	public var nameIndex:Int = -1;
	public var name:String;
	public var size(get, never):Int;

	public function new(type:TsonValueType = TsonValueType.TSON_BT_NULL, data:Dynamic = null, nameIndex:Int = -1,
						name:String = null) {
		this.type = type;
		this.data = data;
		this.nameIndex = nameIndex;
		this.name = name;
	}

	public function clone():TsonBlock {
		var block:TsonBlock = new TsonBlock(type, null, nameIndex, name);
		if(array != null) {
			block.array = [];
			for(a in array) {
				block.array.push(a.clone());
			}
			block.data = block.array;
		}
		else {
			block.data = data;
		}

		return block;
	}

	public function write(out:BytesOutput, header:TsonHeader) {
		var ival:Int;
		var ival64:Int64;
		var fval:Float;
		var sval:String = "";
		var bval:Bytes = null;

		switch(type) {
			case TsonValueType.TSON_BT_NULL:
				writeTypeInfo(out, header);
			case TsonValueType.TSON_BT_FALSE:
				writeTypeInfo(out, header);
			case TsonValueType.TSON_BT_TRUE:
				writeTypeInfo(out, header);
			case TsonValueType.TSON_BT_ESTRING:
				writeTypeInfo(out, header);
			case TsonValueType.TSON_BT_UINT8:
				ival = cast data;

				writeTypeInfo(out, header);
				out.writeByte(ival);
			case TsonValueType.TSON_BT_UINT16:
				ival = cast data;

				writeTypeInfo(out, header);
				out.writeUInt16(ival);
			case TsonValueType.TSON_BT_UINT32:
				ival = cast data;

				writeTypeInfo(out, header);
				out.writeInt32(ival);
			case TsonValueType.TSON_BT_UINT64:
				ival64 = cast data;

				writeTypeInfo(out, header);
				out.writeInt32(ival64.low);
				out.writeInt32(ival64.high);
			case TsonValueType.TSON_BT_INT8:
				ival = cast data;

				writeTypeInfo(out, header);
				out.writeInt8(ival);
			case TsonValueType.TSON_BT_INT16:
				ival = cast data;

				writeTypeInfo(out, header);
				out.writeInt16(ival);
			case TsonValueType.TSON_BT_INT32:
				ival = cast data;

				writeTypeInfo(out, header);
				out.writeInt32(ival);
			case TsonValueType.TSON_BT_INT64:
				ival64 = cast data;

				writeTypeInfo(out, header);
				out.writeInt32(ival64.low);
				out.writeInt32(ival64.high);
			case TsonValueType.TSON_BT_FLOAT32:
				fval = cast data;

				writeTypeInfo(out, header);
				out.writeFloat(fval);
			case TsonValueType.TSON_BT_FLOAT64:
				var fval = cast data;

				writeTypeInfo(out, header);
				out.writeDouble(fval);
			case TsonValueType.TSON_BT_STRING_UINT8:
				sval = Std.string(data);

				writeTypeInfo(out, header);
				out.writeByte(sval.length);
				out.writeString(sval);
			case TsonValueType.TSON_BT_STRING_UINT16:
				sval = Std.string(data);

				writeTypeInfo(out, header);
				out.writeUInt16(sval.length);
				out.writeString(sval);
			case TsonValueType.TSON_BT_STRING_UINT32:
				sval = Std.string(data);

				writeTypeInfo(out, header);
				out.writeInt32(sval.length);
				out.writeString(sval);
			case TsonValueType.TSON_BT_STRING_UINT64:
				sval = Std.string(data);

				writeTypeInfo(out, header);
				out.writeInt32(sval.length);
				out.writeString(sval);
			case TsonValueType.TSON_BT_BINARY_UINT8:
				bval = cast data;

				writeTypeInfo(out, header);
				out.writeByte(bval.length);
				out.writeBytes(bval, 0, bval.length);
			case TsonValueType.TSON_BT_BINARY_UINT16:
				bval = cast data;

				writeTypeInfo(out, header);
				out.writeUInt16(bval.length);
				out.writeBytes(bval, 0, bval.length);
			case TsonValueType.TSON_BT_BINARY_UINT32:
				bval = cast data;

				writeTypeInfo(out, header);
				out.writeInt32(bval.length);
				out.writeBytes(bval, 0, bval.length);
			case TsonValueType.TSON_BT_BINARY_UINT64:
				bval = cast data;

				writeTypeInfo(out, header);
				out.writeInt32(bval.length);
				out.writeBytes(bval, 0, bval.length);
			case TsonValueType.TSON_BT_ARRAY_UINT8 |
					TsonValueType.TSON_BT_ARRAY_UINT16 |
					TsonValueType.TSON_BT_ARRAY_UINT32 |
					TsonValueType.TSON_BT_ARRAY_UINT64 |
					TsonValueType.TSON_BT_MAP_UINT8 |
					TsonValueType.TSON_BT_MAP_UINT16 |
					TsonValueType.TSON_BT_MAP_UINT32 |
					TsonValueType.TSON_BT_MAP_UINT64:
				writeTypeInfo(out, header);
				out.writeInt32(size);
				out.writeInt32(array.length);
				for(i in array) {
					i.write(out, header);
				}
			default:
		}
	}

	inline function writeTypeInfo(out:BytesOutput, header:TsonHeader) {
		out.writeInt8(type);
		if(header.names.exists(name)) {
			out.writeInt16(header.names.get(name));
		}
	}

	static function readTypeInfo(stream:BytesInput, block:TsonBlock, withName:Bool) {
		if(withName) {
			block.nameIndex = stream.readInt16();
		}
	}

	static public function read(stream:BytesInput, header:TsonHeader, withName:Bool = true):TsonBlock {
		var ival:Int;
		var fval:Float;
		var count:Int;
		var sval:String = "";
		var bval:Bytes = null;

		var res:TsonBlock = new TsonBlock();
		res.type = stream.readInt8();

		switch(res.type) {
			case TsonValueType.TSON_BT_NULL:
				readTypeInfo(stream, res, withName);
				res.data = null;
			case TsonValueType.TSON_BT_FALSE:
				readTypeInfo(stream, res, withName);
				res.data = false;
			case TsonValueType.TSON_BT_TRUE:
				readTypeInfo(stream, res, withName);
				res.data = true;
			case TsonValueType.TSON_BT_ESTRING:
				readTypeInfo(stream, res, withName);
				res.data = "";
			case TsonValueType.TSON_BT_UINT8:
				readTypeInfo(stream, res, withName);
				ival = stream.readByte();
				res.data = ival;
			case TsonValueType.TSON_BT_UINT16:
				readTypeInfo(stream, res, withName);
				ival = stream.readUInt16();
				res.data = ival;
			case TsonValueType.TSON_BT_UINT32:
				readTypeInfo(stream, res, withName);
				ival = stream.readInt32();
				res.data = ival;
			case TsonValueType.TSON_BT_UINT64:
				readTypeInfo(stream, res, withName);
				ival = stream.readInt32();
				res.data = ival;
			case TsonValueType.TSON_BT_INT8:
				readTypeInfo(stream, res, withName);
				ival = stream.readInt8();
				res.data = ival;
			case TsonValueType.TSON_BT_INT16:
				readTypeInfo(stream, res, withName);
				ival = stream.readInt16();
				res.data = ival;
			case TsonValueType.TSON_BT_INT32:
				readTypeInfo(stream, res, withName);
				ival = stream.readInt32();
				res.data = ival;
			case TsonValueType.TSON_BT_INT64:
				readTypeInfo(stream, res, withName);
				ival = stream.readInt32();
				res.data = ival;
			case TsonValueType.TSON_BT_FLOAT32:
				readTypeInfo(stream, res, withName);
				fval = stream.readFloat();
				res.data = fval;
			case TsonValueType.TSON_BT_FLOAT64:
				readTypeInfo(stream, res, withName);
				fval = stream.readDouble();
				res.data = fval;
			case TsonValueType.TSON_BT_STRING_UINT8:
				readTypeInfo(stream, res, withName);
				ival = stream.readByte();
				sval = stream.readString(ival);
				res.data = sval;
			case TsonValueType.TSON_BT_STRING_UINT16:
				readTypeInfo(stream, res, withName);
				ival = stream.readUInt16();
				sval = stream.readString(ival);
				res.data = sval;
			case TsonValueType.TSON_BT_STRING_UINT32 |
					TsonValueType.TSON_BT_STRING_UINT64:
				readTypeInfo(stream, res, withName);
				ival = stream.readInt32();
				sval = stream.readString(ival);
				res.data = sval;
			case TsonValueType.TSON_BT_BINARY_UINT8:
				readTypeInfo(stream, res, withName);
				ival = stream.readByte();
				bval = Bytes.alloc(ival);
				stream.readBytes(bval, 0, ival);
				res.data = bval;
			case TsonValueType.TSON_BT_BINARY_UINT16:
				readTypeInfo(stream, res, withName);
				ival = stream.readUInt16();
				bval = Bytes.alloc(ival);
				stream.readBytes(bval, 0, ival);
				res.data = bval;
			case TsonValueType.TSON_BT_BINARY_UINT32 |
					TsonValueType.TSON_BT_BINARY_UINT64:
				readTypeInfo(stream, res, withName);
				ival = stream.readInt32();
				bval = Bytes.alloc(ival);
				stream.readBytes(bval, 0, ival);
				res.data = bval;
			case TsonValueType.TSON_BT_ARRAY_UINT8 |
					TsonValueType.TSON_BT_ARRAY_UINT16 |
					TsonValueType.TSON_BT_ARRAY_UINT32 |
					TsonValueType.TSON_BT_ARRAY_UINT64:
				res.array = [];
				readTypeInfo(stream, res, withName);
				ival = stream.readInt32();
				count = stream.readInt32();
				for(i in 0...count) {
					res.array.push(TsonBlock.read(stream, header, false));
				}
				res.data = res.array;
			case TsonValueType.TSON_BT_MAP_UINT8 |
					TsonValueType.TSON_BT_MAP_UINT16 |
					TsonValueType.TSON_BT_MAP_UINT32 |
					TsonValueType.TSON_BT_MAP_UINT64:
				res.array = [];
				readTypeInfo(stream, res, withName);
				ival = stream.readInt32();
				count = stream.readInt32();
				for(i in 0...count) {
					res.array.push(TsonBlock.read(stream, header, true));
				}
				res.data = res.array;
			default:
		}

		if(res.nameIndex != -1) {
			res.name = header.keys.get(res.nameIndex);
		}

		return res;
	}

	public function getNames():Array<String> {
		var res:Array<String> = [];
		var temp:Array<String> = [];

		if(name.isNotEmpty() && res.indexOf(name) == -1) {
			res.push(name);
		}
		if(array.isNotEmpty()) {
			for(a in array) {
				temp = a.getNames();
				for(t in temp) {
					if(res.indexOf(t) == -1) {
						res.push(t);
					}
				}
			}
		}

		return res;
	}

	function get_size():Int {
		var bval:Bytes;
		var sval:String;

		return switch(type) {
			case TsonValueType.TSON_BT_UINT8 | TsonValueType.TSON_BT_INT8:
				(1 + (nameIndex == -1 ? 0 : 2) + 1);
			case TsonValueType.TSON_BT_UINT16 | TsonValueType.TSON_BT_INT16:
				(1 + (nameIndex == -1 ? 0 : 2) + 2);
			case TsonValueType.TSON_BT_UINT32 |
					TsonValueType.TSON_BT_UINT64 |
					TsonValueType.TSON_BT_INT32 |
					TsonValueType.TSON_BT_INT64 |
					TsonValueType.TSON_BT_FLOAT32:
				(1 + (nameIndex == -1 ? 0 : 2) + 4);
			case TsonValueType.TSON_BT_FLOAT64:
				(1 + (nameIndex == -1 ? 0 : 2) + 8);
			case TsonValueType.TSON_BT_STRING_UINT8:
				sval = cast data;
				(1 + (nameIndex == -1 ? 0 : 2) + 1 + sval.length);
			case TsonValueType.TSON_BT_STRING_UINT16:
				sval = cast data;
				(1 + (nameIndex == -1 ? 0 : 2) + 2 + sval.length);
			case TsonValueType.TSON_BT_STRING_UINT32 |
					TsonValueType.TSON_BT_STRING_UINT64:
				sval = cast data;
				(1 + (nameIndex == -1 ? 0 : 2) + 4 + sval.length);
			case TsonValueType.TSON_BT_BINARY_UINT8:
				bval = Std.instance(data, Bytes);
				(1 + (nameIndex == -1 ? 0 : 2) + 1 + (bval == null ? 0 : bval.length));
			case TsonValueType.TSON_BT_BINARY_UINT16:
				bval = Std.instance(data, Bytes);
				(1 + (nameIndex == -1 ? 0 : 2) + 2 + (bval == null ? 0 : bval.length));
			case TsonValueType.TSON_BT_BINARY_UINT32 |
					TsonValueType.TSON_BT_BINARY_UINT64:
				bval = Std.instance(data, Bytes);
				(1 + (nameIndex == -1 ? 0 : 2) + 4 + (bval == null ? 0 : bval.length));
			case TsonValueType.TSON_BT_ARRAY_UINT8 |
					TsonValueType.TSON_BT_ARRAY_UINT16 |
					TsonValueType.TSON_BT_ARRAY_UINT32 |
					TsonValueType.TSON_BT_ARRAY_UINT64 |
					TsonValueType.TSON_BT_MAP_UINT8 |
					TsonValueType.TSON_BT_MAP_UINT16 |
					TsonValueType.TSON_BT_MAP_UINT32 |
					TsonValueType.TSON_BT_MAP_UINT64:
				var res:Int = 0;

				for(i in array) {
					res += i.size;
				}
				(1 + (nameIndex == -1 ? 0 : 2) + 4 + 4 + res);
			default:
				(1 + (nameIndex == -1 ? 0 : 2));
		}
	}

	function set_data(value:Dynamic):Dynamic {
		data = value;
		if(type.isArray() || type.isMap()) {
			this.array = cast this.data;
		}

		return data;
	}
}
