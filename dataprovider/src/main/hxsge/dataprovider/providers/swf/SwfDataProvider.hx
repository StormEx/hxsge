package hxsge.dataprovider.providers.swf;

import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.DataProvider;

class SwfDataProvider extends DataProvider {
	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override function prepareData() {
		finished.emit(this);
	}
}
