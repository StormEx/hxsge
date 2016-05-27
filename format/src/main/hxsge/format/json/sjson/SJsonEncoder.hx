package hxsge.format.json.sjson;

import haxe.io.BytesOutput;
import hxsge.core.debug.Debug;
import haxe.io.Bytes;

using hxsge.core.utils.StringTools;

class SJsonEncoder {
	var _obj:Dynamic;
	var _names:Map<String, Int>;
	var _namesCount:Int = 0;
	var _sjson:BytesOutput;

	public function new() {

	}

	public static function fromDynamic(json:String):Bytes {
		return null;
	}

	static public function fromJson(json:String):Bytes {
		var obj:Dynamic = Json.parse(json);
		var bytes:Bytes = null;
		var converter:SJsonEncoder = null;

		if(obj != null) {
			converter = new SJsonEncoder();
			bytes = converter._fromJson(json);
		}

		return bytes;
	}

	static public function toJson(data:Bytes):String {
		return "";
	}

	function _fromJson(json:String):Bytes {
		_obj = Json.parse(json);

		if(_obj != null) {
			Debug.trace("SJSON: " + json);
			buildNamesTabel();
		}

		_sjson = new BytesOutput();
		_sjson.writeString(SJson.HEADER);
		_sjson.writeUInt16(_namesCount);
		if(_sjson != null) {
			for(k in _names.keys()) {
				_sjson.writeUInt16(k.length);
				_sjson.writeString(k);
			}
		}

		SJson.stringify(_sjson.getBytes());

		return null;
	}

	function buildNamesTabel() {
		_names = new Map();
		getNames(_obj);
	}

	function getNames(obj:Dynamic, name:String = null) {
		if(name.isNotEmpty() && !_names.exists(name)) {
			_names.set(name, _namesCount);
			_namesCount++;
		}

		for(f in Reflect.fields(obj)) {
			getNames(Reflect.field(obj, f), f);
		}
	}
}
