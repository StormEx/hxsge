package hxsge.assets.data.bundle;

import hxsge.dataprovider.providers.images.ImageDataProvider;
import hxsge.assets.data.SoundAsset;
import hxsge.dataprovider.providers.sounds.SoundDataProvider;
import hxsge.core.batch.Batch;
import hxsge.core.memory.Memory;
import hxsge.core.debug.error.Error;
import hxsge.dataprovider.data.DataProviderInfo;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.photon.Signal;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.assets.data.bundle.dataprovider.BundleDataProvider;
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
		_provider = new BundleDataProvider(new DataProviderInfo(url));
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

	function createAssets(data:Array<IDataProvider>):Array<IAsset> {
		var res:Array<IAsset> = [];

		if(data.isNotEmpty()) {
			for(d in data) {
				if(d != null && !d.errors.isError) {
					var item:IAsset = null;

					try {
						if(Std.is(d, SoundDataProvider)) {
							item = new SoundAsset(d.info.url, d);
						}
						if(Std.is(d, ImageDataProvider)) {
							item = new Asset(d.info.url, d);
						}
					}
					catch(e:Dynamic) {
						item = null;
					}

					if(item != null) {
						res.push(item);
						resources.push(item);
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
