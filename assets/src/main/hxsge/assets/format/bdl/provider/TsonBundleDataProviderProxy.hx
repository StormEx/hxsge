package hxsge.assets.format.bdl.provider;

import hxsge.assets.format.bdl.provider.data.TsonBundleStructure;
import hxsge.assets.bundle.dataprovider.BundleDataProvider;
import hxsge.dataprovider.providers.common.DataProviderProxy;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;
import haxe.io.Path;

class TsonBundleDataProviderProxy extends DataProviderProxy {
	public function new() {
		super("tson bundle");
	}

	override public function check(info:IDataProviderInfo):Bool {
		var ext:String = Path.extension(info.url);

		return ext == "tbdl";
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		return new BundleDataProvider(new TsonBundleStructure(), info);
	}
}
