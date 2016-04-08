package hxsge.assets.data.bundle;

import hxsge.core.memory.Memory;
import hxsge.core.debug.error.Error;
import hxsge.dataprovider.data.DataProviderInfo;
import hxsge.dataprovider.DataProviderManager;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.core.signal.Signal.Signal1;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.assets.data.bundle.dataprovider.BundleDataProvider;
import hxsge.core.IDisposable;
import hxsge.core.utils.RefCount;

class BundleImpl extends RefCount implements IDisposable {
	public var url(default, null):String;
	public var errors(default, null):ErrorHolder;
	public var progress(get, never):Float;
	public var resources(default, null):Array<IDataProvider> = [];

	public var updated(default, null):Signal1<Array<IDataProvider>>;
	public var changed(default, null):Signal1<BundleImpl>;
	public var finished(default, null):Signal1<BundleImpl>;

	var _provider:BundleDataProvider;
	var _version:String;

	public function new(url:String, version:String = null) {
		super();

		this.url = url;
		errors = new ErrorHolder();
		_version = version;

		finished = new Signal1();
		updated = new Signal1();
		changed = new Signal1();
	}

	override public function dispose() {
		super.dispose();

		Memory.dispose(finished);
		Memory.dispose(updated);
		Memory.dispose(changed);
		errors = null;
	}

	public function load() {
		incRef();

		changed.emit(this);

		loadMeta();
	}

	public function unload() {
		if(refCount == 0) {
			return;
		}

		if(decRef() == 0) {

		}

		changed.emit(this);
	}

	function loadMeta() {
		_provider = Std.instance(DataProviderManager.get(new DataProviderInfo(url)), BundleDataProvider);
		if(_provider == null) {
			errors.addError(Error.create("Can't receive data provider for load bundle data..."));

			finished.emit(this);
		}
		else {
			_provider.finished.addOnce(onMetaLoaded);
			_provider.load();
		}
	}

	function onMetaLoaded(provider:IDataProvider) {
		finished.emit(this);
	}

	inline function get_progress():Float {
		return 1;
	}
}
