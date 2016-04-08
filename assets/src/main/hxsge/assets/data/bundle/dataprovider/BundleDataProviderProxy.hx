package hxsge.assets.data.bundle.dataprovider;

import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.BaseDataProviderProxy;

class BundleDataProviderProxy extends BaseDataProviderProxy {
	public function new() {
		super("bundle");
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		return new BundleDataProvider(info);
	}
}
