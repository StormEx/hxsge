package hxsge.format.tson.parts;

import haxe.io.Bytes;
import haxe.Int64;
import hxsge.core.debug.Debug;
import hxsge.format.tson.parts.TsonHeader;
import haxe.io.BytesOutput;

using hxsge.core.utils.StringTools;
using hxsge.core.utils.ArrayTools;
using hxsge.format.tson.parts.TsonValueTypeTools;
using hxsge.format.tson.parts.TsonDataTools;

class TsonDataWriter {
	public static function write(data:TsonData, stream:BytesOutput) {
		Debug.assert(data != null);

		var header:TsonHeader = writeHeader(data, stream);

		if(header == null) {
			throw "can't create header by tson data...";
		}

		writeBlock(header, data, stream, false);
	}

	static function writeBlock(header:TsonHeader, data:TsonData, stream:BytesOutput, isName:Bool) {
		var ival:Int;
		var ival64:Int64;
		var fval:Float;
		var sval:String = "";
		var bval:Bytes = null;

		var type:TsonValueType = handleType(data);

		if(!type.isValid()) {
			Debug.trace("not valid tson data type for writing...");

			return;
		}

		stream.writeInt8(data.type);
		if(isName) {
			stream.writeInt16(data.name.isEmpty() ? -1 : header.names.get(data.name));
		}

		switch(type) {
			case TsonValueType.TSON_BT_UINT8:
				stream.writeByte(data.data);
			case TsonValueType.TSON_BT_UINT16:
				stream.writeUInt16(data.data);
			case TsonValueType.TSON_BT_UINT32:
				stream.writeInt32(data.data);
			case TsonValueType.TSON_BT_UINT64:
				stream.writeInt32(data.data.low);
				stream.writeInt32(data.data.high);
			case TsonValueType.TSON_BT_INT8:
				stream.writeInt8(data.data);
			case TsonValueType.TSON_BT_INT16:
				stream.writeInt16(data.data);
			case TsonValueType.TSON_BT_INT32:
				stream.writeInt32(data.data);
			case TsonValueType.TSON_BT_INT64:
				stream.writeInt32(data.data.low);
				stream.writeInt32(data.data.high);
			case TsonValueType.TSON_BT_FLOAT32:
				stream.writeFloat(data.data);
			case TsonValueType.TSON_BT_FLOAT64:
				stream.writeDouble(data.data);
			case TsonValueType.TSON_BT_STRING_UINT8:
				stream.writeByte(data.data.length);
				stream.writeString(data.data);
			case TsonValueType.TSON_BT_STRING_UINT16:
				stream.writeUInt16(data.data.length);
				stream.writeString(data.data);
			case TsonValueType.TSON_BT_STRING_UINT32 |
			TsonValueType.TSON_BT_STRING_UINT64:
				stream.writeInt32(data.data.length);
				stream.writeString(data.data);
			case TsonValueType.TSON_BT_BINARY_UINT8:
				stream.writeByte(data.data.length);
				stream.writeBytes(data.data, 0, data.data.length);
			case TsonValueType.TSON_BT_BINARY_UINT16:
				stream.writeUInt16(data.data.length);
				stream.writeBytes(data.data, 0, data.data.length);
			case TsonValueType.TSON_BT_BINARY_UINT32 |
			TsonValueType.TSON_BT_BINARY_UINT64:
				stream.writeInt32(data.data.length);
				stream.writeBytes(data.data, 0, data.data.length);
			case TsonValueType.TSON_BT_ARRAY_UINT8:
				stream.writeInt32(data.size());
				stream.writeByte(data.data.length);
				var arr:Array<TsonData> = data.data;
				for(d in arr) {
					writeBlock(header, d, stream, false);
				}
			case TsonValueType.TSON_BT_ARRAY_UINT16:
				stream.writeInt32(data.size());
				stream.writeUInt16(data.data.length);
				var arr:Array<TsonData> = data.data;
				for(d in arr) {
					writeBlock(header, d, stream, false);
				}
			case TsonValueType.TSON_BT_ARRAY_UINT32 |
					TsonValueType.TSON_BT_ARRAY_UINT64:
				stream.writeInt32(data.size());
				stream.writeInt32(data.data.length);
				var arr:Array<TsonData> = data.data;
				for(d in arr) {
					writeBlock(header, d, stream, false);
				}
			case TsonValueType.TSON_BT_MAP_UINT8:
				stream.writeInt32(data.size());
				stream.writeByte(data.data.length);
				var arr:Array<TsonData> = data.data;
				for(d in arr) {
					writeBlock(header, d, stream, true);
				}
			case TsonValueType.TSON_BT_MAP_UINT16:
				stream.writeInt32(data.size());
				stream.writeUInt16(data.data.length);
				var arr:Array<TsonData> = data.data;
				for(d in arr) {
					writeBlock(header, d, stream, true);
				}
			case TsonValueType.TSON_BT_MAP_UINT32 |
					TsonValueType.TSON_BT_MAP_UINT64:
				stream.writeInt32(data.size());
				stream.writeInt32(data.data.length);
				var arr:Array<TsonData> = data.data;
				for(d in arr) {
					writeBlock(header, d, stream, true);
				}
			default:
		}
	}

	static function handleType(data:TsonData):TsonValueType {
		var type:TsonValueType = TsonValueType.getDefault();

		if(type.isInt()) {
			var value:Int = data.data;
			if((value & 0x000000FF) == value) {
				return value < 0 ? TsonValueType.TSON_BT_INT8 : TsonValueType.TSON_BT_UINT8;
			}
			else if((value & 0x0000FFFF) == value) {
				return value < 0 ? TsonValueType.TSON_BT_INT16 : TsonValueType.TSON_BT_UINT16;
			}
			else {
				return value < 0 ? TsonValueType.TSON_BT_INT32 : TsonValueType.TSON_BT_UINT32;
			}
		}
		else if(type.isFloat()) {
			return TsonValueType.TSON_BT_FLOAT64;
		}
		else if(type.isString()) {
			var str:String = data.data;
			if(str.length == 0) {
				return TsonValueType.TSON_BT_ESTRING;
			}
			else if(str.length < 0xFF) {
				return TsonValueType.TSON_BT_STRING_UINT8;
			}
			else if(str.length < 0xFFFF) {
				return TsonValueType.TSON_BT_STRING_UINT16;
			}
			else {
				return TsonValueType.TSON_BT_STRING_UINT32;
			}
		}
		else if(type.isBinary()) {
			var len:Int = data.data.length;
			if(len < 0xFF) {
				return TsonValueType.TSON_BT_BINARY_UINT8;
			}
			else if(len < 0xFFFF) {
				return TsonValueType.TSON_BT_BINARY_UINT16;
			}
			else {
				return TsonValueType.TSON_BT_BINARY_UINT32;
			}
		}
		else if(type.isArray()) {
			var len:Int = data.data == null ? 0 : data.data.length;
			if(len < 0xFF) {
				return TsonValueType.TSON_BT_ARRAY_UINT8;
			}
			else if(len < 0xFFFF) {
				return TsonValueType.TSON_BT_ARRAY_UINT16;
			}
			else {
				return TsonValueType.TSON_BT_ARRAY_UINT32;
			}
		}
		else if(type.isMap()) {
			var len:Int = data.data == null ? 0 : data.data.length;
			if(len < 0xFF) {
				return TsonValueType.TSON_BT_MAP_UINT8;
			}
			else if(len < 0xFFFF) {
				return TsonValueType.TSON_BT_MAP_UINT16;
			}
			else {
				return TsonValueType.TSON_BT_MAP_UINT32;
			}
		}

		return type;
	}

	static function writeHeader(data:TsonData, stream:BytesOutput):TsonHeader {
		var size:Int = 0;
		var len:Int = 0;
		var maxLen:Int = 0;
		var names:Array<String> = getUniqueNames(data);
		var keyType:TsonValueType = getKeyType(names);
		var keyTypeSize:Int = keyType.getSizeInBytes();
		var nameType:TsonValueType;
		var header:TsonHeader = new TsonHeader(names);

		stream.writeString(Tson.HEADER);
		for(n in names) {
			len = n.length;
			if(len > maxLen) {
				maxLen = len;
			}
			size += (keyTypeSize + len);
		}
		nameType = getNameType(maxLen);
		stream.writeInt32(size);
		stream.writeInt8(keyType);
		stream.writeInt8(nameType);
		// write count of names
		stream.writeInt32(names.length);

		for(i in 0...names.length) {
			writeKey(stream, keyType, header.names.get(names[i]));
			writeName(stream, nameType, names[i]);
		}

		return header;
	}

	static function writeKey(stream:BytesOutput, type:TsonValueType, key:Int) {
		return switch(type) {
			case TsonValueType.TSON_BT_UINT8:
				stream.writeInt8(key);
			case TsonValueType.TSON_BT_UINT16:
				stream.writeInt16(key);
			default:
				stream.writeInt32(key);
		}
	}

	static function writeName(stream:BytesOutput, type:TsonValueType, name:String) {
		switch(type) {
			case TsonValueType.TSON_BT_STRING_UINT8:
				stream.writeInt8(name.length);
			case TsonValueType.TSON_BT_STRING_UINT16:
				stream.writeInt16(name.length);
			default:
				stream.writeInt32(name.length);
		}
		stream.writeString(name);
	}

	static function getKeyType(names:Array<String>):TsonValueType  {
		var type:TsonValueType = TsonValueType.TSON_BT_UINT32;
		var count:Int = 0;

		for(i in names) {
			count++;
		}

		if(count < 0xFF) {
			type = TsonValueType.TSON_BT_UINT8;
		}
		else if(count < 0xFFFF) {
			type = TsonValueType.TSON_BT_UINT16;
		}
		else if(count >= 0xFFFFFFFF) {
			throw "can't write more than 0xFFFFFFFF unique fields...";
		}

		return type;
	}

	static function getNameType(size:Int):TsonValueType  {
		var type:TsonValueType = TsonValueType.TSON_BT_UINT32;

		if(size < 0xFF) {
			type = TsonValueType.TSON_BT_UINT8;
		}
		else if(size < 0xFFFF) {
			type = TsonValueType.TSON_BT_UINT16;
		}
		else if(size >= 0xFFFFFFFF) {
			throw "key can't be greater than 4 bytes...";
		}

		return type;
	}

	static function getUniqueNames(data:TsonData, out:Array<String> = null):Array<String> {
		var res:Array<String> = (out == null ? [] : out);

		if(data.name.isNotEmpty() && res.indexOf(data.name) == -1) {
			res.push(data.name);
		}
		if(data.type.isIterable() && data.data != null) {
			var arr:Array<TsonData> = data.data;
			for(d in arr) {
				getUniqueNames(d, res);
			}
		}

		return res;
	}
}
