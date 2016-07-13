package hxsge.dataprovider.providers.common;

import hxsge.dataprovider.data.IDataProviderInfo;
import haxe.io.Path;

class DataProviderProxy implements IDataProviderProxy {
	public var type(default, null):String;
	public var info(get, never):String;

	public function new(type:String = "common") {
		this.type = type;
	}

	public function check(info:IDataProviderInfo):Bool {
		var ext:String = Path.extension(info.url);

		return ext == type;
	}

	public function create(info:IDataProviderInfo):IDataProvider {
		return new DataProvider(info);
	}

	function get_info():String {
		return type;
	}
}
