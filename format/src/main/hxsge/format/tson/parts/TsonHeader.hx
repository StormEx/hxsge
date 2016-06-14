package hxsge.format.tson.parts;

import hxsge.format.tson.parts.TsonValueType;
import haxe.io.BytesOutput;
import haxe.io.BytesInput;

using hxsge.core.utils.StringTools;
using hxsge.format.tson.parts.TsonValueTypeTools;

class TsonHeader {
	public var format(default, null):String;
	public var keys(default, null):Map<Int, String>;
	public var names(default, null):Map<String, Int>;

	public var isValid(get, never):Bool;

	var _nameType:TsonValueType = TsonValueType.TSON_BT_STRING_UINT8;
	var _keyType:TsonValueType = TsonValueType.TSON_BT_STRING_UINT8;

	public function new(names:Array<String> = null) {
		format = Tson.HEADER;

		this.names = new Map();
		this.keys = new Map();
		if(names != null) {
			for(i in 0...names.length) {
				this.keys.set(i, names[i]);
				this.names.set(names[i], i);
			}
		}
	}

	static public function read(stream:BytesInput):TsonHeader {
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
		}

		return header;
	}

	public function write(stream:BytesOutput) {
		var size:Int = 0;
		var count:Int = 0;
		var len:Int = 0;
		var maxLen:Int = 0;
		var keySize:Int;

		_keyType = getKeyType();
		keySize = _keyType.getSizeInBytes();

		stream.writeString(Tson.HEADER);
		for(k in names.keys()) {
			len = k.length;
			if(len > maxLen) {
				maxLen = len;
			}
			size += (keySize + len);
			count++;
		}
		_nameType = getNameType(maxLen);
		stream.writeInt32(size);
		stream.writeInt8(_keyType);
		stream.writeInt8(_nameType);
		// write count of names
		stream.writeInt32(count);
		for(k in names.keys()) {
			writeKey(stream, names.get(k));
			writeName(stream, k);
		}
	}

	function getKeyType():TsonValueType  {
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

	function getNameType(size:Int):TsonValueType  {
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

	function writeKey(stream:BytesOutput, key:Int) {
		return switch(_nameType) {
			case TsonValueType.TSON_BT_UINT8:
				stream.writeInt8(key);
			case TsonValueType.TSON_BT_UINT16:
				stream.writeInt16(key);
			default:
				stream.writeInt32(key);
		}
	}

	function writeName(stream:BytesOutput, name:String) {
		switch(_nameType) {
			case TsonValueType.TSON_BT_STRING_UINT8:
				stream.writeInt8(name.length);
			case TsonValueType.TSON_BT_STRING_UINT16:
				stream.writeInt16(name.length);
			default:
				stream.writeInt32(name.length);
		}
		stream.writeString(name);
	}

	static function readKey(stream:BytesInput, type:TsonValueType):Int {
		return switch(type) {
			case TsonValueType.TSON_BT_UINT8:
				stream.readInt8();
			case TsonValueType.TSON_BT_UINT16:
				stream.readInt16();
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
				len = stream.readInt16();
			default:
				len = stream.readInt32();
		}

		return stream.readString(len);
	}

	inline function get_isValid():Bool {
		return format == Tson.HEADER;
	}
}
