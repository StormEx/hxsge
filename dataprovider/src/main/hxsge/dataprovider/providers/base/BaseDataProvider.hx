package hxsge.dataprovider.providers.base;

import hxsge.log.Log;
import hxsge.debug.error.ErrorHolder;
import msignal.Signal;

class BaseDataProvider implements IDataProvider {
	public var info(default, null):DataProviderInfo;
	public var errors(default, null):ErrorHolder;
	public var isSuccess(get, null):Bool;

	public var finished(default, null):Signal1<IDataProvider>;

	public function new(info:DataProviderInfo) {
		Log.log("base data provider created");
	}

	public function check(info:DataProviderInfo):Bool {
		return false;
	}

	inline function get_isSuccess():Bool {
		return !errors.isError;
	}
}
