package hxsge.dataprovider.data;

import hxsge.core.debug.Debug;
import haxe.io.Path;

using hxsge.core.utils.StringTools;

class DataProviderInfo implements IDataProviderInfo {
	public var id(default, null):String;
	public var url(default, null):String;
	public var data(default, set):Dynamic;
	public var meta(default, null):Dynamic;

	public var ext(get, null):String;

	public var isNeedToLoad(get, never):Bool;

	public function new(id:String, url:String, data:Dynamic = null, meta:Dynamic = null) {
		this.id = id;
		this.url = url;
		this.data = data;
		this.meta = meta;
	}

	public function clear() {
		data = null;
	}

	inline function set_data(value:Dynamic):Dynamic {
//		Debug.assert(data == null, "Try to rewrite existing data");
		data = value;

		return data;
	}

	inline function get_ext():String {
		return url.isEmpty() ? "" : Path.extension(url);
	}

	inline function get_isNeedToLoad():Bool {
		return url.isNotEmpty() && data == null;
	}
}
