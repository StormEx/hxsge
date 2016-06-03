package hxsge.format.tson.parts;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;

using hxsge.core.utils.StringTools;

class TsonHeader {
	public var format(default, null):String;
	public var keys(default, null):Map<Int, String>;
	public var names(default, null):Map<String, Int>;

	public var isSuccess(get, never):Bool;

	public function new(names:Map<String, Int> = null) {
		format = Tson.HEADER;

		this.names = names;
		if(names != null) {
			keys = new Map();
			for(k in names.keys()) {
				keys.set(names.get(k), k);
			}
		}
		else {
			this.keys = null;
		}
	}

	static public function read(stream:BytesInput):TsonHeader {
		var header:TsonHeader = new TsonHeader();
		var size:Float;
		var count:Int;
		var length:Int;
		var key:Int;
		var str:String;

		try {
			header.format = stream.readString(Tson.HEADER.length);
			if(header.isSuccess) {
				size = stream.readFloat();
				count = stream.readInt16();
				header.names = new Map();
				header.keys = new Map();
				for(i in 0...count) {
					key = stream.readUInt16();
					length = stream.readUInt16();
					str = stream.readString(length);
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
		var size:Float = 0;
		var count:Int = 0;

		stream.writeString(Tson.HEADER);
		for(k in names.keys()) {
			size += (2 + k.length);
			count++;
		}
		// write name's table size
		size += 4;
		stream.writeFloat(size);
		// write count of names
		stream.writeInt16(count);
		for(k in names.keys()) {
			stream.writeUInt16(names.get(k));
			// write name's length
			stream.writeUInt16(k.length);
			// write name
			stream.writeString(k);
		}
	}

	inline function get_isSuccess():Bool {
		return format == Tson.HEADER;
	}
}
