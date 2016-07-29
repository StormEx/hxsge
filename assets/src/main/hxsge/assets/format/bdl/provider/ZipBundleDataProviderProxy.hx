package hxsge.assets.format.bdl.provider;

import hxsge.assets.format.bdl.provider.data.ZipBundleStructure;
import hxsge.assets.data.bundle.BundleDataProvider;
import hxsge.dataprovider.providers.common.DataProviderProxy;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;
import haxe.io.Path;

class ZipBundleDataProviderProxy extends DataProviderProxy {
	public function new() {
		super("zip bundle");
	}

	override public function check(info:IDataProviderInfo):Bool {
		var ext:String = Path.extension(info.url);

		return ext == "zbdl";
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		return new BundleDataProvider(new ZipBundleStructure(), info);
	}
}
