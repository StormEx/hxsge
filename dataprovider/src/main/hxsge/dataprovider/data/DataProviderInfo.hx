package hxsge.dataprovider.data;

import haxe.io.Path;

using hxsge.core.utils.StringTools;

class DataProviderInfo {
	public var url(default, null):String;
	public var data(default, null):Dynamic;

	public var ext(get, null):String;

	public function new(url:String, data:Dynamic = null) {
		this.url = url;
		this.data = data;
	}

	inline function get_ext():String {
		return url.isEmpty() ? "" : Path.extension(url);
	}
}
