package hxsge.assets.bundle.dataprovider;

import haxe.io.Path;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.DataProviderProxy;

class BundleDataProviderProxy extends DataProviderProxy {
	public function new() {
		super("bundle");
	}

	override public function check(info:IDataProviderInfo):Bool {
		var ext:String = Path.extension(info.url);

		return ext == "bundle" || ext == "zip";
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		return new BundleDataProvider(info);
	}
}
