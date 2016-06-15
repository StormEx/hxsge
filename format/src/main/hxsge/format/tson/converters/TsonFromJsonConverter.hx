package hxsge.format.tson.converters;

import hxsge.format.tson.data.TsonDataWriter;
import hxsge.format.tson.data.TsonData;
import hxsge.format.tson.data.TsonHeader;
import haxe.io.BytesOutput;
import hxsge.core.debug.Debug;
import haxe.io.Bytes;

class TsonFromJsonConverter implements ITsonConverter {
	public var tson(default, null):Bytes;

	var _names:Array<String>;

	var _string:String;
	var _pos:Int;

	public function new(json:String) {
		tson = convert(json);
	}

	function convert(json:String):Bytes {
		var out:BytesOutput = new BytesOutput();
		var header:TsonHeader;

		_names = [];
		_string = json;
		_pos = 0;

		var res:TsonData = null;
		try {
			res = parseJson();
			if(out != null) {
				TsonDataWriter.write(res, out);
			}
		}
		catch(e:Dynamic) {
			Debug.trace("TSON parse failed");
		}

		return out.getBytes();
	}

	function parseJson(name:String = null, parent:TsonData = null):TsonData {
		while(true) {
			var c = nextChar();

			switch(c) {
				case ' '.code, '\r'.code, '\n'.code, '\t'.code:
					// loop
				case '{'.code:
					var val = [], block:TsonData = null, field = null, comma : Null<Bool> = null;
					while( true ) {
						var c = nextChar();
						switch( c ) {
							case ' '.code, '\r'.code, '\n'.code, '\t'.code:
								// loop
							case '}'.code:
								if( field != null || comma == false )
									invalidChar();

								return TsonData.create(val, name, parent);
							case ':'.code:
								if( field == null )
									invalidChar();
								block = parseJson(field);
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
								return TsonData.create(val, name, parent);
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
					return TsonData.create(true, name, parent);
				case 'f'.code:
					var save = _pos;
					if(nextChar() != 'a'.code || nextChar() != 'l'.code || nextChar() != 's'.code || nextChar() != 'e'.code) {
						_pos = save;
						invalidChar();
					}
					return TsonData.create(false, name, parent);
				case 'n'.code:
					var save = _pos;
					if(nextChar() != 'u'.code || nextChar() != 'l'.code || nextChar() != 'l'.code) {
						_pos = save;
						invalidChar();
					}
					return TsonData.create(null, name, parent);
				case '"'.code:
					var str:String = parseString();
					return TsonData.create(str, name, parent);
				case '0'.code, '1'.code, '2'.code, '3'.code, '4'.code, '5'.code, '6'.code, '7'.code, '8'.code, '9'.code, '-'.code:
					var num:Dynamic = parseNumber(c);
					return TsonData.create(num, name, parent);
				default:
					invalidChar();
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
		if(_names.indexOf(name) == -1) {
			_names.push(name);
		}
	}

	function getNameIndex(name:String):Int {
		return _names.indexOf(name);
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
