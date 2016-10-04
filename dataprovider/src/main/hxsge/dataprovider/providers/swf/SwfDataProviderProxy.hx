package hxsge.dataprovider.providers.swf;

import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.common.DataProviderProxy;

class SwfDataProviderProxy extends DataProviderProxy {
	public function new() {
		super("swf");
	}

	override public function create(info:IDataProviderInfo, parent:IDataProvider = null):IDataProvider {
		return new SwfDataProvider(info, parent);
	}
}
