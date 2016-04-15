package hxsge.assets.data.bundle.dataprovider.meta;

import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.providers.base.DataProviderProxy;

class MetaBundleDataProviderProxy extends DataProviderProxy {
	public function new() {
		super("bundle");
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		return new BundleDataProvider(info);
	}
}
