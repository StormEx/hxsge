package hxsge.dataprovider.providers.tson;

import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.providers.common.DataProviderProxy;

class TsonDataProviderProxy extends DataProviderProxy {
	public function new() {
		super("tson");
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		return new TsonDataProvider(info);
	}
}
