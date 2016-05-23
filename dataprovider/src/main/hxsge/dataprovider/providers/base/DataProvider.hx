package hxsge.dataprovider.providers.base;

import hxsge.photon.SignalMacro;
import hxsge.core.utils.progress.Progress;
import hxsge.core.utils.progress.IProgress;
import hxsge.core.log.Log;
import hxsge.core.debug.error.Error;
import hxsge.loaders.base.ILoader;
import hxsge.loaders.base.BaseLoader;
import hxsge.loaders.data.DataLoader;
import hxsge.core.memory.Memory;
import hxsge.photon.Signal;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.core.debug.Debug;
import hxsge.core.debug.error.ErrorHolder;

using hxsge.loaders.utils.LoaderTools;

class DataProvider implements IDataProvider {
	public var info(default, null):IDataProviderInfo;
	public var errors(default, null):ErrorHolder;
	public var progress(get, never):IProgress;

	public var finished(default, null):Signal1<IDataProvider>;
	public var dataNeeded(default, null):Signal2<IDataProvider, IDataProviderInfo>;

	var _loader:ILoader;
	var _progress:IProgress;
	var _data:Dynamic;

	public function new(info:IDataProviderInfo) {
		Debug.assert(info != null, "DataProviderInfo must be not null");

		finished = new Signal1();
		dataNeeded = new Signal2();
		errors = new ErrorHolder();
		_progress = new Progress();
		this.info = info;
	}

	public function dispose() {
		cleanup();

		info = null;
		errors = null;
		_progress = null;
		Memory.dispose(finished);
		Memory.dispose(dataNeeded);
	}

	function cleanup() {
		performCleanup();

		if(_loader != null && _loader.isLoading()) {
			_loader.cancel();
		}
		Memory.dispose(_loader);
		_data = null;
	}

	function performCleanup() {}

	public function load() {
		if(progress.isFinished) {
			finished.emit(this);

			return;
		}

		if(info.isNeedToLoad) {
			performLoad();
		}
		else {
			_data = info.data;
			prepareData();
		}
	}

	public function clear() {
		cleanup();

		_progress.reset();
		errors.reset();
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

	function calculateProgress():IProgress {
		_progress.set(_loader != null ? _loader.progress.progress : 0);

		return _progress;
	}

	function onDataLoaded(loader:ILoader) {
		if(!loader.isSuccess()) {
			Log.log(loader.url);
			errors.addError(Error.create("Can't load data."));

			SignalMacro.safeEmit(finished, this);
		}
		else {
			info.data = loader.content;
			_data = loader.content;
			prepareData();
		}

		cleanup();
	}

	inline function get_progress():IProgress {
		return calculateProgress();
	}
}
