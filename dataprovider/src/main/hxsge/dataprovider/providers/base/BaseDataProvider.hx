package hxsge.dataprovider.providers.base;

import hxsge.core.log.Log;
import hxsge.core.signal.SignalMacro;
import hxsge.core.debug.error.Error;
import hxsge.loaders.base.ILoader;
import hxsge.loaders.base.BaseLoader;
import hxsge.loaders.data.DataLoader;
import hxsge.core.memory.Memory;
import hxsge.core.signal.Signal;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.core.debug.Debug;
import hxsge.core.debug.error.ErrorHolder;

using hxsge.loaders.utils.LoaderTools;

class BaseDataProvider implements IDataProvider {
	public var info(default, null):IDataProviderInfo;
	public var errors(default, null):ErrorHolder;
	public var progress(get, never):Float;

	public var finished(default, null):Signal1<IDataProvider>;
	public var dataNeeded(default, null):Signal2<IDataProvider, IDataProviderInfo>;

	var _loader:ILoader;

	public function new(info:IDataProviderInfo) {
		Debug.assert(info != null, "DataProviderInfo must be not null");

		finished = new Signal1();
		dataNeeded = new Signal2();
		errors = new ErrorHolder();
		this.info = info;
	}

	public function dispose() {
		cleanup();

		info = null;
		errors = null;
		Memory.dispose(finished);
		Memory.dispose(dataNeeded);
	}

	function cleanup() {
		performCleanup();

		if(_loader != null && _loader.isLoading()) {
			_loader.cancel();
		}
		Memory.dispose(_loader);
	}

	function performCleanup() {}

	public function load() {
		if(progress == 1) {
			finished.emit(this);

			return;
		}

		if(info.isNeedToLoad) {
			performLoad();
		}
		else {
			prepareData();
		}
	}

	function performLoad() {
		if(_loader == null) {
			_loader = createLoader(info.url);
			_loader.finished.addOnce(onDataLoaded);
			_loader.load();
		}
	}

	function prepareData() {
		throw("Need to overload");
		finished.emit(this);
	}

	function createLoader(url:String):BaseLoader {
		return new DataLoader(url);
	}

	public function provideRequestedData(provider:IDataProvider) {
		Debug.error("need to override");
	}

	function calculateProgress():Float {
		return _loader != null ? _loader.progress : 0;
	}

	function onDataLoaded(loader:ILoader) {
		if(!loader.isSuccess()) {
			Log.log(loader.url);
			errors.addError(Error.create("Can't load data."));

			SignalMacro.safeEmit(finished, this);
		}
		else {
			info.data = loader.content;
			prepareData();
		}

		cleanup();
	}

	inline function get_progress():Float {
		return calculateProgress();
	}
}
