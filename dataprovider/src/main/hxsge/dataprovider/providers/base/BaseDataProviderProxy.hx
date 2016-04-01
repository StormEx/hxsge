package hxsge.dataprovider.providers.base;

import hxsge.dataprovider.data.IDataProviderInfo;
import haxe.io.Path;

class BaseDataProviderProxy implements IDataProviderProxy {
	public var type(default, null):String;

	public function new(type:String = "base") {
		this.type = type;
	}

	public function check(info:IDataProviderInfo):Bool {
		var ext:String = Path.extension(info.url);

		return ext == type;
	}

	public function create(info:IDataProviderInfo):IDataProvider {
		return new BaseDataProvider(info);
	}
}
