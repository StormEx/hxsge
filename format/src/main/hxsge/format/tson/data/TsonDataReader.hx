package hxsge.format.tson.data;

import hxsge.format.tson.data.TsonValueType;
import hxsge.core.debug.Debug;
import haxe.io.Bytes;
import haxe.Int64;
import hxsge.format.tson.data.TsonHeader;
import haxe.io.BytesInput;

using hxsge.format.tson.data.TsonValueTypeTools;
using hxsge.core.utils.StringTools;

class TsonDataReader {
	public static function read(stream:BytesInput):TsonData {
		var header:TsonHeader = readHeader(stream);

		if(header == null) {
			throw "wrong header of tson data...";
		}

		return readBlock(header, stream, null, false);
	}

	static function readBlock(header:TsonHeader, stream:BytesInput, parent:TsonData, isName:Bool):TsonData {
		var res:TsonData = null;
		var type:TsonValueType;
		var children:Array<TsonData> = [];

		type = stream.readInt8();
		if(!type.isValid()) {
			throw "not valid tson data type...";
		}

		res = new TsonData(parent);
		if(isName) {
			var index:Int = stream.readInt16();
			res.name = header.keys.exists(index) ? header.keys.get(index) : "default";
		}

		switch(type) {
			case TsonValueType.FALSE:
				res.change(type, false);
			case TsonValueType.TRUE:
				res.change(type, true);
			case TsonValueType.ESTRING:
				res.change(type, "");
			case TsonValueType.UINT8:
				res.change(type, stream.readByte());
			case TsonValueType.UINT16:
				res.change(type, stream.readUInt16());
			case TsonValueType.UINT32:
				res.change(type, stream.readInt32());
			case TsonValueType.UINT64:
				var low:Int = stream.readInt32();
				var high:Int = stream.readInt32();

				res.change(type, Int64.make(high, low));
			case TsonValueType.INT8:
				res.change(type, stream.readInt8());
			case TsonValueType.INT16:
				res.change(type, stream.readInt16());
			case TsonValueType.INT32:
				res.change(type, stream.readInt32());
			case TsonValueType.INT64:
				var low:Int = stream.readInt32();
				var high:Int = stream.readInt32();

				res.change(type, Int64.make(high, low));
			case TsonValueType.FLOAT32:
				res.change(type, stream.readFloat());
			case TsonValueType.FLOAT64:
				res.change(type, stream.readDouble());
			case TsonValueType.STRING_UINT8:
				var size:Int = stream.readByte();
				res.change(type, stream.readString(size));
			case TsonValueType.STRING_UINT16:
				var size:Int = stream.readUInt16();
				res.change(type, stream.readString(size));
			case TsonValueType.STRING_UINT32 |
			TsonValueType.STRING_UINT64:
				var size:Int = stream.readInt32();
				res.change(type, stream.readString(size));
			case TsonValueType.BINARY_UINT8:
				var size:Int = stream.readByte();
				var b:Bytes = Bytes.alloc(size);
				stream.readBytes(b, 0, size);
				res.change(type, b);
			case TsonValueType.BINARY_UINT16:
				var size:Int = stream.readUInt16();
				var b:Bytes = Bytes.alloc(size);
				stream.readBytes(b, 0, size);
				res.change(type, b);
			case TsonValueType.BINARY_UINT32 |
			TsonValueType.BINARY_UINT64:
				var size:Int = stream.readInt32();
				var b:Bytes = Bytes.alloc(size);
				stream.readBytes(b, 0, size);
				res.change(type, b);
			case TsonValueType.ARRAY_UINT8:
				var size:Int = stream.readInt32();
				var len:Int = stream.readByte();
				for(i in 0...len) {
					children.push(readBlock(header, stream, res, false));
				}
				res.change(type, children);
			case TsonValueType.ARRAY_UINT16:
				var size:Int = stream.readInt32();
				var len:Int = stream.readUInt16();
				for(i in 0...len) {
					children.push(readBlock(header, stream, res, false));
				}
				res.change(type, children);
			case TsonValueType.ARRAY_UINT32 |
			TsonValueType.ARRAY_UINT64:
				var size:Int = stream.readInt32();
				var len:Int = stream.readByte();
				for(i in 0...len) {
					children.push(readBlock(header, stream, res, false));
				}
				res.change(type, children);
			case TsonValueType.MAP_UINT8:
				var size:Int = stream.readInt32();
				var len:Int = stream.readByte();
				for(i in 0...len) {
					children.push(readBlock(header, stream, res, true));
				}
				res.change(type, children);
			case TsonValueType.MAP_UINT16:
				var size:Int = stream.readInt32();
				var len:Int = stream.readUInt16();
				for(i in 0...len) {
					children.push(readBlock(header, stream, res, true));
				}
				res.change(type, children);
			case TsonValueType.MAP_UINT32 |
			TsonValueType.MAP_UINT64:
				var size:Int = stream.readInt32();
				var len:Int = stream.readByte();
				for(i in 0...len) {
					children.push(readBlock(header, stream, res, true));
				}
				res.change(type, children);
			default:
				res.change(TsonValueType.NULL, null);
		}

		return res;
	}

	static function readHeader(stream:BytesInput):TsonHeader {
		var header:TsonHeader = new TsonHeader();
		var size:Int;
		var count:Int;
		var length:Int;
		var key:Int;
		var str:String;
		var keyType:TsonValueType;
		var nameType:TsonValueType;

		try {
			header.format = stream.readString(Tson.HEADER.length);
			if(header.isValid) {
				size = stream.readInt32();
				keyType = stream.readInt8();
				nameType = stream.readInt8();
				count = stream.readInt32();
				header.names = new Map();
				header.keys = new Map();
				for(i in 0...count) {
					key = readKey(stream, keyType);
					str = readName(stream, nameType);
					if(str.isNotEmpty()) {
						header.names.set(str, key);
						header.keys.set(key, str);
					}
				}
			}
		}
		catch(e:Dynamic) {
			Debug.trace("Error while tson header reading");

			return null;
		}

		return header;
	}

	static function readKey(stream:BytesInput, type:TsonValueType):Int {
		return switch(type) {
			case TsonValueType.UINT8:
				stream.readByte();
			case TsonValueType.UINT16:
				stream.readUInt16();
			default:
				stream.readInt32();
		}
	}

	static function readName(stream:BytesInput, type:TsonValueType):String {
		var len:Int;

		switch(type) {
			case TsonValueType.STRING_UINT8:
				len = stream.readInt8();
			case TsonValueType.STRING_UINT16:
				len = stream.readUInt16();
			default:
				len = stream.readInt32();
		}

		return stream.readString(len);
	}
}
