package hxsge.assets.format.bdl.provider;

import hxsge.assets.format.bdl.provider.data.JsonBundleStructure;
import hxsge.assets.data.bundle.BundleDataProvider;
import haxe.io.Path;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.common.DataProviderProxy;

class JsonBundleDataProviderProxy extends DataProviderProxy {
	public function new() {
		super("json bundle");
	}

	override public function check(info:IDataProviderInfo):Bool {
		var ext:String = Path.extension(info.url);

		return ext == "jbdl";
	}

	override public function create(info:IDataProviderInfo, parent:IDataProvider = null):IDataProvider {
		return new BundleDataProvider(new JsonBundleStructure(), info, parent);
	}
}
