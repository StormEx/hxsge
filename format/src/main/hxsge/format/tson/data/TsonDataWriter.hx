package hxsge.format.tson.data;

import haxe.io.Bytes;
import haxe.Int64;
import hxsge.core.debug.Debug;
import hxsge.format.tson.data.TsonHeader;
import haxe.io.BytesOutput;

using hxsge.core.utils.StringTools;
using hxsge.core.utils.ArrayTools;
using hxsge.format.tson.data.TsonValueTypeTools;
using hxsge.format.tson.data.TsonDataTools;

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

		if(!data.type.isValid()) {
			Debug.trace("not valid tson data type for writing...");

			return;
		}

		stream.writeInt8(data.type);
		if(isName) {
			stream.writeInt16(data.name.isEmpty() ? -1 : header.names.get(data.name));
		}

		switch(data.type) {
			case TsonValueType.UINT8:
				stream.writeByte(data.data);
			case TsonValueType.UINT16:
				stream.writeUInt16(data.data);
			case TsonValueType.UINT32:
				stream.writeInt32(data.data);
			case TsonValueType.UINT64:
				stream.writeInt32(data.data.low);
				stream.writeInt32(data.data.high);
			case TsonValueType.INT8:
				stream.writeInt8(data.data);
			case TsonValueType.INT16:
				stream.writeInt16(data.data);
			case TsonValueType.INT32:
				stream.writeInt32(data.data);
			case TsonValueType.INT64:
				stream.writeInt32(data.data.low);
				stream.writeInt32(data.data.high);
			case TsonValueType.FLOAT32:
				stream.writeFloat(data.data);
			case TsonValueType.FLOAT64:
				stream.writeDouble(data.data);
			case TsonValueType.STRING_UINT8:
				stream.writeByte(data.data.length);
				stream.writeString(data.data);
			case TsonValueType.STRING_UINT16:
				stream.writeUInt16(data.data.length);
				stream.writeString(data.data);
			case TsonValueType.STRING_UINT32 |
			TsonValueType.STRING_UINT64:
				stream.writeInt32(data.data.length);
				stream.writeString(data.data);
			case TsonValueType.BINARY_UINT8:
				stream.writeByte(data.data.length);
				stream.writeBytes(data.data, 0, data.data.length);
			case TsonValueType.BINARY_UINT16:
				stream.writeUInt16(data.data.length);
				stream.writeBytes(data.data, 0, data.data.length);
			case TsonValueType.BINARY_UINT32 |
			TsonValueType.BINARY_UINT64:
				stream.writeInt32(data.data.length);
				stream.writeBytes(data.data, 0, data.data.length);
			case TsonValueType.ARRAY_UINT8:
				stream.writeInt32(data.size());
				stream.writeByte(data.data.length);
				var arr:Array<TsonData> = data.data;
				for(d in arr) {
					writeBlock(header, d, stream, false);
				}
			case TsonValueType.ARRAY_UINT16:
				stream.writeInt32(data.size());
				stream.writeUInt16(data.data.length);
				var arr:Array<TsonData> = data.data;
				for(d in arr) {
					writeBlock(header, d, stream, false);
				}
			case TsonValueType.ARRAY_UINT32 |
					TsonValueType.ARRAY_UINT64:
				stream.writeInt32(data.size());
				stream.writeInt32(data.data.length);
				var arr:Array<TsonData> = data.data;
				for(d in arr) {
					writeBlock(header, d, stream, false);
				}
			case TsonValueType.MAP_UINT8:
				stream.writeInt32(data.size());
				stream.writeByte(data.data.length);
				var arr:Array<TsonData> = data.data;
				Debug.trace("len:" + arr.length);
				for(d in arr) {
					writeBlock(header, d, stream, true);
				}
			case TsonValueType.MAP_UINT16:
				stream.writeInt32(data.size());
				stream.writeUInt16(data.data.length);
				var arr:Array<TsonData> = data.data;
				for(d in arr) {
					writeBlock(header, d, stream, true);
				}
			case TsonValueType.MAP_UINT32 |
					TsonValueType.MAP_UINT64:
				stream.writeInt32(data.size());
				stream.writeInt32(data.data.length);
				var arr:Array<TsonData> = data.data;
				for(d in arr) {
					writeBlock(header, d, stream, true);
				}
			default:
		}
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
			case TsonValueType.UINT8:
				stream.writeInt8(key);
			case TsonValueType.UINT16:
				stream.writeInt16(key);
			default:
				stream.writeInt32(key);
		}
	}

	static function writeName(stream:BytesOutput, type:TsonValueType, name:String) {
		switch(type) {
			case TsonValueType.STRING_UINT8:
				stream.writeInt8(name.length);
			case TsonValueType.STRING_UINT16:
				stream.writeInt16(name.length);
			default:
				stream.writeInt32(name.length);
		}
		stream.writeString(name);
	}

	static function getKeyType(names:Array<String>):TsonValueType  {
		var type:TsonValueType = TsonValueType.UINT32;
		var count:Int = 0;

		for(i in names) {
			count++;
		}

		if(count < 0xFF) {
			type = TsonValueType.UINT8;
		}
		else if(count < 0xFFFF) {
			type = TsonValueType.UINT16;
		}
		else if(count >= 0xFFFFFFFF) {
			throw "can't write more than 0xFFFFFFFF unique fields...";
		}

		return type;
	}

	static function getNameType(size:Int):TsonValueType  {
		var type:TsonValueType = TsonValueType.UINT32;

		if(size < 0xFF) {
			type = TsonValueType.UINT8;
		}
		else if(size < 0xFFFF) {
			type = TsonValueType.UINT16;
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
