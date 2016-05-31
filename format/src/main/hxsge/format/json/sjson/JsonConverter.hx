package hxsge.format.json.sjson;

import haxe.io.BytesOutput;
import hxsge.core.debug.Debug;
import haxe.io.Bytes;

class JsonConverter {
	var _names:Map<String, Int>;
	var _namesCount:Int = 0;

	var _string:String;
	var _pos:Int;

	public function new() {
	}

	public function convert(json:String):Bytes {
		var dataBlock:BytesOutput = new BytesOutput();
		var out:BytesOutput = new BytesOutput();
		var size:Float = 0;

		_names = new Map();
		_namesCount = 0;
		_string = json;
		_pos = 0;

		var res:SJsonBlock = null;
		try {
			res = parseJson();
		}
		catch(e:Dynamic) {
			Debug.trace("SJSON parse failed");
		}

		if(out != null) {
			out.writeString(SJson.HEADER);
			for(k in _names.keys()) {
				size += (2 + k.length);
			}
			// write name's table size
			size += 4;
			out.writeFloat(size);
			// write count of names
			out.writeInt16(_namesCount);
			for(k in _names.keys()) {
				out.writeUInt16(_names.get(k));
				// write name's length
				out.writeUInt16(k.length);
				// write name
				out.writeString(k);
			}
			SJsonBlock.write(res, out);
		}

		return out.getBytes();
	}

	function parseJson(nameIndex:Int = -1):SJsonBlock {
		while(true) {
			var c = nextChar();

			switch(c) {
				case ' '.code, '\r'.code, '\n'.code, '\t'.code:
					// loop
				case '{'.code:
					var val = [], block:SJsonBlock = null, field = null, comma : Null<Bool> = null;
					while( true ) {
						var c = nextChar();
						switch( c ) {
							case ' '.code, '\r'.code, '\n'.code, '\t'.code:
								// loop
							case '}'.code:
								if( field != null || comma == false )
									invalidChar();

								return new SJsonBlock(SJsonBlockType.SJSON_BT_MAP_UINT32, val, nameIndex);
							case ':'.code:
								if( field == null )
									invalidChar();
								block = parseJson(getNameIndex(field));
								val.push(block);
								field = null;
								comma = true;
							case ','.code:
								if( comma ) comma = false else invalidChar();
							case '"'.code:
								if( comma ) invalidChar();
								field = parseString();
								setName(field);
							default:
								invalidChar();
						}
					}
				case '['.code:
					var val = [], comma : Null<Bool> = null;
					while( true ) {
						var c = nextChar();
						switch( c ) {
							case ' '.code, '\r'.code, '\n'.code, '\t'.code:
								// loop
							case ']'.code:
								if( comma == false ) invalidChar();
								return new SJsonBlock(SJsonBlockType.SJSON_BT_ARRAY_UINT32, val, nameIndex);
							case ','.code:
								if( comma ) comma = false else invalidChar();
							default:
								if( comma ) invalidChar();
								_pos--;
								val.push(parseJson());
								comma = true;
						}
					}
				case 't'.code:
					var save = _pos;
					if(nextChar() != 'r'.code || nextChar() != 'u'.code || nextChar() != 'e'.code) {
						_pos = save;
						invalidChar();
					}
					return new SJsonBlock(SJsonBlockType.SJSON_BT_TRUE, true, nameIndex);
				case 'f'.code:
					var save = _pos;
					if(nextChar() != 'a'.code || nextChar() != 'l'.code || nextChar() != 's'.code || nextChar() != 'e'.code) {
						_pos = save;
						invalidChar();
					}
					return new SJsonBlock(SJsonBlockType.SJSON_BT_FALSE, false, nameIndex);
				case 'n'.code:
					var save = _pos;
					if(nextChar() != 'u'.code || nextChar() != 'l'.code || nextChar() != 'l'.code) {
						_pos = save;
						invalidChar();
					}
					return new SJsonBlock(SJsonBlockType.SJSON_BT_NULL, null, nameIndex);
				case '"'.code:
					var str:String = parseString();
					return new SJsonBlock(SJsonBlockType.SJSON_BT_STRING_UINT32, str, nameIndex);
				case '0'.code, '1'.code, '2'.code, '3'.code, '4'.code, '5'.code, '6'.code, '7'.code, '8'.code, '9'.code, '-'.code:
					var num:Dynamic = parseNumber(c);
					return new SJsonBlock(SJsonBlockType.SJSON_BT_STRING_UINT32, num, nameIndex);
				default:
					invalidChar();
			}
		}
	}

	function parseJsonObject(nameIndex:Int = -1):SJsonBlock {
		var val:Array<SJsonBlock> = [];
		var block:SJsonBlock;
		var size:Float = 0;
		var field:String = null;
		var comma:Null<Bool> = null;

		while(true) {
			var c = nextChar();

			switch( c ) {
				case ' '.code, '\r'.code, '\n'.code, '\t'.code:
					// loop
				case '}'.code:
					if(field != null || comma == false) {
						invalidChar();
					}

					return new SJsonBlock(SJsonBlockType.SJSON_BT_MAP_UINT32, val, nameIndex);
				case ':'.code:
					if(field == null) {
						invalidChar();
					}
					block = parseJson(nameIndex);
					size += block.size;
					val.push(block);
					field = null;
					comma = true;
				case ','.code:
					if(comma) {
						comma = false;
					}
					else {
						invalidChar();
					}
				case '"'.code:
					if(comma) {
						invalidChar();
					}
					field = parseString();
					setName(field);
					nameIndex = getNameIndex(field);
				default:
					invalidChar();
			}
		}
	}

	function parseJsonArray(nameIndex:Int = -1):SJsonBlock {
		var val:Array<SJsonBlock> = [];
		var block:SJsonBlock;
		var size:Float = 0;
		var comma:Null<Bool> = null;

		while(true) {
			var c = nextChar();
			switch( c ) {
				case ' '.code, '\r'.code, '\n'.code, '\t'.code:
					// loop
				case ']'.code:
					if(comma == false) {
						invalidChar();
					}

					return new SJsonBlock(SJsonBlockType.SJSON_BT_ARRAY_UINT32, val, nameIndex);
				case ','.code:
					if(comma) {
						comma = false;
					}
					else {
						invalidChar();
					}
				default:
					if(comma) {
						invalidChar();
					}
					_pos--;
					block = parseJson();
					size += block.size;
					val.push(block);
					comma = true;
			}
		}
	}

	function parseString() {
		var start = _pos;
		var buf = null;
		while(true) {
			var c = nextChar();
			if(c == '"'.code)
				break;
			if(c == '\\'.code) {
				if(buf == null) {
					buf = new StringBuf();
				}
				buf.addSub(_string, start, _pos - start - 1);
				c = nextChar();
				switch( c ) {
					case "r".code: buf.addChar("\r".code);
					case "n".code: buf.addChar("\n".code);
					case "t".code: buf.addChar("\t".code);
					case "b".code: buf.addChar(8);
					case "f".code: buf.addChar(12);
					case "/".code, '\\'.code, '"'.code: buf.addChar(c);
					case 'u'.code:
						var uc = Std.parseInt("0x" + _string.substr(_pos, 4));
						_pos += 4;
						#if (neko || php || cpp)
						if(uc <= 0x7F)
							buf.addChar(uc);
						else if(uc <= 0x7FF) {
							buf.addChar(0xC0 | (uc >> 6));
							buf.addChar(0x80 | (uc & 63));
						} else if(uc <= 0xFFFF) {
							buf.addChar(0xE0 | (uc >> 12));
							buf.addChar(0x80 | ((uc >> 6) & 63));
							buf.addChar(0x80 | (uc & 63));
						} else {
							buf.addChar(0xF0 | (uc >> 18));
							buf.addChar(0x80 | ((uc >> 12) & 63));
							buf.addChar(0x80 | ((uc >> 6) & 63));
							buf.addChar(0x80 | (uc & 63));
						}
						#else
						buf.addChar(uc);
					#end
					default:
						throw "Invalid escape sequence \\" + String.fromCharCode(c) + " at position " + (_pos - 1);
				}
				start = _pos;
			}
				#if (neko || php || cpp)
				// ensure utf8 chars are not cut
			else if(c >= 0x80) {
				_pos++;
				if(c >= 0xFC) _pos += 4;
				else if(c >= 0xF8) _pos += 3;
				else if(c >= 0xF0) _pos += 2;
				else if(c >= 0xE0) _pos++;
			}
				#end
			else if(StringTools.isEof(c))
				throw "Unclosed string";
		}
		if(buf == null) {
			return _string.substr(start, _pos - start - 1);
		}
		else {
			buf.addSub(_string, start, _pos - start - 1);
			return buf.toString();
		}
	}

	inline function parseNumber(c:Int):Dynamic {
		var start = _pos - 1;
		var minus = c == '-'.code, digit = !minus, zero = c == '0'.code;
		var point = false, e = false, pm = false, end = false;
		while(true) {
			c = nextChar();
			switch( c ) {
				case '0'.code :
					if(zero && !point) {
						invalidNumber(start);
					}
					if(minus) {
						minus = false; zero = true;
					}
					digit = true;
				case '1'.code, '2'.code, '3'.code, '4'.code, '5'.code, '6'.code, '7'.code, '8'.code, '9'.code :
					if(zero && !point) {
						invalidNumber(start);
					}
					if(minus) {
						minus = false;
					}
					digit = true;
					zero = false;
				case '.'.code :
					if(minus || point) {
						invalidNumber(start);
					}
					digit = false;
					point = true;
				case 'e'.code, 'E'.code :
					if(minus || zero || e) {
						invalidNumber(start);
					}
					digit = false;
					e = true;
				case '+'.code, '-'.code :
					if(!e || pm) {
						invalidNumber(start);
					}
					digit = false;
					pm = true;
				default :
					if(!digit) {
						invalidNumber(start);
					}
					_pos--;
					end = true;
			}
			if(end) {
				break;
			}
		}
		var f = Std.parseFloat(_string.substr(start, _pos - start));
		var i = Std.int(f);

		return (i == f ? i : f);
	}

	function setName(name:String) {
		if(!_names.exists(name)) {
			_names.set(name, _namesCount);
			_namesCount++;
		}
	}

	function getNameIndex(name:String):Int {
		if(_names.exists(name)) {
			return _names.get(name);
		}

		return -1;
	}

	inline function nextChar() {
		return StringTools.fastCodeAt(_string, _pos++);
	}

	function invalidChar() {
		_pos--; // rewind
		throw "Invalid char " + StringTools.fastCodeAt(_string, _pos) + " at position " + _pos;
	}

	function invalidNumber(start:Int) {
		throw "Invalid number at position " + start + ": " + _string.substr(start, _pos - start);
	}
}
