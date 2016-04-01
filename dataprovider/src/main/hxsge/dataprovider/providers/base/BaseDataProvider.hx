package hxsge.dataprovider.providers.base;

import hxsge.core.log.Log;
import hxsge.core.debug.error.ErrorHolder;
import msignal.Signal;

class BaseDataProvider implements IDataProvider {
	public var info(default, null):DataProviderInfo;
	public var errors(default, null):ErrorHolder;
	public var isSuccess(get, null):Bool;

	public var finished(default, null):Signal1<IDataProvider>;

	public function new(info:DataProviderInfo) {
		finished = new Signal1();
		Log.log("base data provider created");
	}

	public function dispose() {
		if(finished != null) {
			finished.removeAll();
			finished = null;
		}
	}

	public function check(info:DataProviderInfo):Bool {
		return false;
	}

	inline function get_isSuccess():Bool {
		return !errors.isError;
	}
}
