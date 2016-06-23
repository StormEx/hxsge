package hxsge.assets.bundle.dataprovider.meta;

import haxe.io.Path;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.providers.base.DataProviderProxy;

class BundleDataProviderProxy extends DataProviderProxy {
	public function new() {
		super("bundle");
	}

	override public function check(info:IDataProviderInfo):Bool {
		var ext:String = Path.extension(info.url);

		return ext == "bundle" || ext == "tson";
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		var ext:String = Path.extension(info.url);
		var provider:IDataProvider;

		switch(ext) {
			case "tson":
				provider =  new TsonMetaBundleDataProvider(info);
			default:
				provider = new JsonMetaBundleDataProvider(info);
		}

		return provider;
	}
}
