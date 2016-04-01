package hxsge.dataprovider.providers.base;

import hxsge.dataprovider.data.DataProviderInfo;
import hxsge.core.debug.error.ErrorHolder;
import msignal.Signal;

class BaseDataProvider implements IDataProvider {
	public var info(default, null):DataProviderInfo;
	public var errors(default, null):ErrorHolder;
	public var isSuccess(get, null):Bool;

	public var finished(default, null):Signal1<IDataProvider>;
	public var dataNeeded(default, null):Signal2<IDataProvider, DataProviderInfo>;

	public function new(info:DataProviderInfo) {
		finished = new Signal1();
		dataNeeded = new Signal2();
	}

	public function dispose() {
		if(finished != null) {
			finished.removeAll();
			finished = null;
		}
		if(dataNeeded != null) {
			dataNeeded.removeAll();
			dataNeeded = null;
		}
	}

	public function load() {
		finished.dispatch(this);
	}

	inline function get_isSuccess():Bool {
		return !errors.isError;
	}
}
