package hxsge.dataprovider.providers.tson;

import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.providers.base.DataProviderProxy;

class TsonDataProviderProxy extends DataProviderProxy {
	public function new() {
		super("tson");
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		return new TsonDataProvider(info);
	}
}
