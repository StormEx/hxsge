package hxsge.assets.bundle;

import hxsge.dataprovider.DataProviderManager;
import hxsge.core.debug.Debug;
import hxsge.assets.bundle.dataprovider.BundleDataProvider;
import hxsge.assets.base.IAsset;
import hxsge.core.batch.Batch;
import hxsge.core.memory.Memory;
import hxsge.core.debug.error.Error;
import hxsge.dataprovider.data.DataProviderInfo;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.photon.Signal;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.core.utils.RefCount;

using hxsge.core.utils.ArrayTools;

class BundleImpl extends RefCount {
	public var url(default, null):String;
	public var errors(default, null):ErrorHolder;
	public var progress(get, never):Float;
	public var resources(default, null):Array<IAsset> = [];

	public var changed(default, null):Signal1<BundleImpl>;
	public var initialized(default, null):Signal1<BundleImpl>;
	public var updated(default, null):Signal1<Array<IAsset>>;
	public var finished(default, null):Signal1<BundleImpl>;

	var _provider:BundleDataProvider;
	var _version:String;
	var _depBatch:BundleBatch;

	public function new(url:String, version:String = null) {
		super();

		this.url = url;
		errors = new ErrorHolder();
		_version = version;

		finished = new Signal1();
		updated = new Signal1();
		changed = new Signal1();
		initialized = new Signal1();
	}

	override public function dispose() {
		super.dispose();

		Memory.dispose(_depBatch);
		Memory.dispose(_provider);

		Memory.dispose(finished);
		Memory.dispose(updated);
		Memory.dispose(changed);
		Memory.dispose(initialized);
		errors = null;
	}

	public function load() {
		incRef();

		changed.emit(this);

		loadBundle();
	}

	public function unload() {
		if(refCount == 0) {
			return;
		}

		if(decRef() == 0) {

		}

		changed.emit(this);
	}

	function loadBundle() {
		if(_provider == null) {
			_provider = cast DataProviderManager.get(new DataProviderInfo(url, null));
			if(_provider == null) {
				performFail("Can't receive data provider for load bundle data...");
			}
			else {
				_provider.prepared.addOnce(onBundlePrepared);
				_provider.initialized.addOnce(onBundleInitialized);
				_provider.updated.add(onBundleItemLoaded);
				_provider.finished.addOnce(onBundleLoaded);
				_provider.load();
			}
		}
		else {
			finished.emit(this);
		}
	}

	function createAssets(data:Array<IDataProvider>):Array<IAsset> {
		var res:Array<IAsset> = [];

		if(data.isNotEmpty()) {
			for(d in data) {
				if(d != null && !d.errors.isError) {
					try {
						var items:Array<IAsset> = AssetManager.assets.createAssets(d);

						for(i in items) {
							res.push(i);
							resources.push(i);
						}
					}
					catch(e:Dynamic) {
						Debug.trace("Can't create assets from: " + d.info.url);
					}
				}
			}
		}

		return res;
	}

	function onBundlePrepared(provider:BundleDataProvider) {
		if(provider.errors.isError) {
			performFail("Can't prepare base bundle data...");

			return;
		}

		_depBatch = new BundleBatch();
		for(d in provider.dependencies) {
			_depBatch.add(AssetManager.assets.getBundle(d));
		}
		_depBatch.finished.addOnce(onDependenciesLoaded);
		_depBatch.handle();
	}

	function onBundleInitialized(data:Array<IDataProvider>) {
		createAssets(data);
		initialized.emit(this);
	}

	function onBundleItemLoaded(item:IDataProvider) {
		updated.emit(createAssets([item]));
	}

	function onDependenciesLoaded(batch:Batch<Bundle>) {
		if(!checkBatch()) {
			performFail("Can't load all dependencies of bundle...");

			return;
		}

		_provider.loadBatches();
	}

	function checkBatch():Bool {
		for(i in _depBatch.items) {
			if(!i.isSuccess) {
				return false;
			}
		}

		return true;
	}

	function performFail(message:String) {
		errors.addError(Error.create(message));

		finished.emit(this);
	}

	function onBundleLoaded(provider:IDataProvider) {
		if(provider.errors.isError) {
			performFail("Can't load bundle...");
		}

		finished.emit(this);
	}

	inline function get_progress():Float {
		return 1;
	}
}
