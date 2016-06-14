package hxsge.format.tson.parts;

import hxsge.core.debug.Debug;
import haxe.io.Bytes;
import haxe.Int64;
import hxsge.format.tson.parts.TsonHeader;
import haxe.io.BytesInput;

using hxsge.format.tson.parts.TsonValueTypeTools;
using hxsge.format.tson.parts.TsonDataEditTools;
using hxsge.core.utils.StringTools;

class TsonDataReader {
	public static function read(stream:BytesInput, parent:TsonData):TsonBlock {
		var header:TsonHeader = readHeader();

		if(header == null) {
			throw "wrong header of tson data...";
		}

		readBlock(stream, parent, false);
	}

	static function readBlock(stream:BytesInput, parent:TsonData, isName:Bool) {
		var res:TsonData = null;
		var type:TsonValueType;
		var children:Array<TsonData> = [];

		type = stream.readInt8();
		if(!type.isValid()) {
			throw "not valid tson data type..."
		}

		res = new TsonData(parent);
		if(isName) {
			var index:Int = stream.readInt16();
			res.name = header.keys.exists(index) ? header.keys.get(index) : "default";
		}

		switch(type) {
			case TsonValueType.TSON_BT_FALSE:
				res.change(type, false);
			case TsonValueType.TSON_BT_TRUE:
				res.change(type, true);
			case TsonValueType.TSON_BT_ESTRING:
				res.change(type, "");
			case TsonValueType.TSON_BT_UINT8:
				res.change(type, stream.readByte());
			case TsonValueType.TSON_BT_UINT16:
				res.change(type, stream.readUInt16());
			case TsonValueType.TSON_BT_UINT32:
				res.change(type, stream.readInt32());
			case TsonValueType.TSON_BT_UINT64:
				var low:Int = stream.readInt32();
				var high:Int = stream.readInt32();

				res.change(type, Int64.make(high, low));
			case TsonValueType.TSON_BT_INT8:
				res.change(type, stream.readInt8());
			case TsonValueType.TSON_BT_INT16:
				res.change(type, stream.readInt16());
			case TsonValueType.TSON_BT_INT32:
				res.change(type, stream.readInt32());
			case TsonValueType.TSON_BT_INT64:
				var low:Int = stream.readInt32();
				var high:Int = stream.readInt32();

				res.change(type, Int64.make(high, low));
			case TsonValueType.TSON_BT_FLOAT32:
				res.change(type, stream.readFloat());
			case TsonValueType.TSON_BT_FLOAT64:
				res.change(type, stream.readDouble());
			case TsonValueType.TSON_BT_STRING_UINT8:
				var size:Int = stream.readByte();
				res.change(type, stream.readString(size));
			case TsonValueType.TSON_BT_STRING_UINT16:
				var size:Int = stream.readUInt16();
				res.change(type, stream.readString(size));
			case TsonValueType.TSON_BT_STRING_UINT32 |
			TsonValueType.TSON_BT_STRING_UINT64:
				var size:Int = stream.readInt32();
				res.change(type, stream.readString(size));
			case TsonValueType.TSON_BT_BINARY_UINT8:
				var size:Int = stream.readByte();
				var b:Bytes = Bytes.alloc(size);
				stream.readBytes(b, 0, size);
				res.change(type, b);
			case TsonValueType.TSON_BT_BINARY_UINT16:
				var size:Int = stream.readUInt16();
				var b:Bytes = Bytes.alloc(size);
				stream.readBytes(b, 0, size);
				res.change(type, b);
			case TsonValueType.TSON_BT_BINARY_UINT32 |
			TsonValueType.TSON_BT_BINARY_UINT64:
				var size:Int = stream.readInt32();
				var b:Bytes = Bytes.alloc(size);
				stream.readBytes(b, 0, size);
				res.change(type, b);
			case TsonValueType.TSON_BT_ARRAY_UINT8:
				var size:Int = stream.readInt32();
				var len:Int = stream.readByte();
				for(i in 0...len) {
					children.push(TsonDataReader.read(header, stream, res, false));
				}
				res.change(type, children);
				children = null;
			case TsonValueType.TSON_BT_ARRAY_UINT16:
				var size:Int = stream.readInt32();
				var len:Int = stream.readUInt16();
				for(i in 0...len) {
					children.push(TsonDataReader.read(header, stream, res, false));
				}
				res.change(type, children);
				children = null;
			case TsonValueType.TSON_BT_ARRAY_UINT32 |
			TsonValueType.TSON_BT_ARRAY_UINT64:
				var size:Int = stream.readInt32();
				var len:Int = stream.readByte();
				for(i in 0...len) {
					children.push(TsonDataReader.read(header, stream, res, false));
				}
				res.change(type, children);
				children = null;
			case TsonValueType.TSON_BT_MAP_UINT8:
				var size:Int = stream.readInt32();
				var len:Int = stream.readByte();
				for(i in 0...len) {
					children.push(TsonDataReader.read(header, stream, res, false));
				}
				res.change(type, children);
				children = null;
			case TsonValueType.TSON_BT_MAP_UINT16:
				var size:Int = stream.readInt32();
				var len:Int = stream.readUInt16();
				for(i in 0...len) {
					children.push(TsonDataReader.read(header, stream, res, false));
				}
				res.change(type, children);
				children = null;
			case TsonValueType.TSON_BT_MAP_UINT32 |
			TsonValueType.TSON_BT_MAP_UINT64:
				var size:Int = stream.readInt32();
				var len:Int = stream.readByte();
				for(i in 0...len) {
					children.push(TsonDataReader.read(header, stream, res, true));
				}
				res.change(type, children);
				children = null;
			default:
				res.data = null;
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
			case TsonValueType.TSON_BT_UINT8:
				stream.readByte();
			case TsonValueType.TSON_BT_UINT16:
				stream.readUInt16();
			default:
				stream.readInt32();
		}
	}

	static function readName(stream:BytesInput, type:TsonValueType):String {
		var len:Int;

		switch(type) {
			case TsonValueType.TSON_BT_STRING_UINT8:
				len = stream.readInt8();
			case TsonValueType.TSON_BT_STRING_UINT16:
				len = stream.readUInt16();
			default:
				len = stream.readInt32();
		}

		return stream.readString(len);
	}
}
