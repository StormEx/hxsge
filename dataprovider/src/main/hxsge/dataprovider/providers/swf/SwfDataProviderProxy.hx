package hxsge.dataprovider.providers.swf;

import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.common.DataProviderProxy;

class SwfDataProviderProxy extends DataProviderProxy {
	public function new() {
		super("swf");
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		return new SwfDataProvider(info);
	}
}
