package hxsge.dataprovider.providers.base;

import haxe.io.Path;

class BaseDataProviderProxy implements IDataProviderProxy {
	public var type(default, null):String;

	public function new(type:String = "base") {
		this.type = type;
	}

	public function check(info:DataProviderInfo):Bool {
		var ext:String = Path.extension(info.url);

		return ext == type;
	}

	public function create(info:DataProviderInfo):IDataProvider {
		return new BaseDataProvider(info);
	}
}
