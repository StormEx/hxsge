package hxsge.examples.dataprovider;

import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.providers.base.BaseDataProviderProxy;
import hxsge.dataprovider.DataProviderManager;
import hxsge.dataprovider.providers.base.BaseDataProvider;

class Test {
	public function new() {
	}

	public static function main() {
		trace("begin: data provider example.");
		DataProviderManager.add(new BaseDataProviderProxy());
		trace("end: data provider example.");
	}
}
