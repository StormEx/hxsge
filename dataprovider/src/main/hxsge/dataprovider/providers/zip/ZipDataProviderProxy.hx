package hxsge.dataprovider.providers.zip;

import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.BaseDataProviderProxy;

class ZipDataProviderProxy extends BaseDataProviderProxy {
	public function new() {
		super("zip");
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		return new ZipDataProvider(info);
	}
}
