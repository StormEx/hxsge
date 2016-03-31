package hxsge.examples.dataprovider;

import hxsge.core.log.TraceLogger;
import hxsge.core.log.Log;
import hxsge.dataprovider.providers.base.BaseDataProviderProxy;
import hxsge.dataprovider.DataProviderManager;

class Test {
	public function new() {
	}

	public static function main() {
		Log.addLogger(new TraceLogger());

		Log.log("begin: data provider example.");
		DataProviderManager.add(new BaseDataProviderProxy());
		Log.log("end: data provider example.");
	}
}
