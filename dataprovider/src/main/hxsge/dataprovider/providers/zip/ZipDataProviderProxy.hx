package hxsge.dataprovider.providers.zip;

import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.DataProviderProxy;

class ZipDataProviderProxy extends DataProviderProxy {
	public function new() {
		super("zip");
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		return new ZipDataProvider(info);
	}
}
