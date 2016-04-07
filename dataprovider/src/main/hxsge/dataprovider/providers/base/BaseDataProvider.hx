package hxsge.dataprovider.providers.base;

import hxsge.core.memory.Memory;
import hxsge.core.signal.Signal;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.core.debug.Debug;
import hxsge.core.debug.error.ErrorHolder;

class BaseDataProvider implements IDataProvider {
	public var info(default, null):IDataProviderInfo;
	public var errors(default, null):ErrorHolder;
	public var progress(get, never):Float;

	public var finished(default, null):Signal1<IDataProvider>;
	public var dataNeeded(default, null):Signal2<IDataProvider, IDataProviderInfo>;

	public function new(info:IDataProviderInfo) {
		finished = new Signal1();
		dataNeeded = new Signal2();
	}

	public function dispose() {
		Memory.dispose(finished);
		Memory.dispose(dataNeeded);
	}

	public function load() {
		finished.emit(this);
	}

	public function provideRequestedData(provider:IDataProvider) {
		Debug.error("need to override");
	}

	inline function get_progress():Float {
		return 0;
	}
}
