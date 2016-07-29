package hxsge.assets.bundle.dataprovider;

import hxsge.assets.bundle.dataprovider.structure.TsonBundleStructure;
import hxsge.assets.bundle.dataprovider.structure.JsonBundleStructure;
import hxsge.core.utils.progress.IProgress;
import hxsge.dataprovider.providers.common.ProviderBatch;
import hxsge.dataprovider.DataProviderManager;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.core.batch.Batch;
import hxsge.core.debug.Debug;
import hxsge.core.memory.Memory;
import hxsge.photon.Signal;
import hxsge.assets.bundle.dataprovider.structure.ZipBundleStructure;
import hxsge.assets.bundle.dataprovider.structure.BundleStructure;
import haxe.io.Path;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.common.DataProvider;

class BundleDataProvider extends DataProvider {
	public var dependencies(get, never):Array<String>;

	public var prepared(default, null):Signal1<BundleDataProvider>;
	public var initialized(default, null):Signal1<Array<IDataProvider>>;
	public var updated(default, null):Signal1<IDataProvider>;

	var _structure:BundleStructure;
	var _syncBatch:ProviderBatch;
	var _asyncBatch:ProviderBatch;

	public function new(info:IDataProviderInfo) {
		super(info);

		prepared = new Signal1();
		initialized = new Signal1();
		updated = new Signal1();
	}

	public override function dispose() {
		super.dispose();

		Memory.dispose(prepared);
		Memory.dispose(initialized);
		Memory.dispose(updated);
	}

	override function prepareData() {
		var ext:String = Path.extension(info.url);
		switch(ext) {
			case "zip":
				_structure = new ZipBundleStructure(info);
			case "tson":
				_structure = new TsonBundleStructure(info);
			default:
				_structure = new JsonBundleStructure(info);
		}
		_structure.finished.addOnce(onDataPrepared);
		_structure.load();
	}

	function onDataPrepared(structure:BundleStructure) {
		if(_structure.errors.isError) {
			errors.concat(_structure.errors);

			finished.emit(this);
		}
		else {
			Debug.trace("Data for bundle prepared...");
			prepared.emit(this);
		}
	}

	public function loadBatches() {
		_syncBatch = new ProviderBatch();
		loadBatch(_syncBatch, _structure.syncData, onSyncBatchLoaded);
	}

	function loadBatch(batch:ProviderBatch, data:Array<IDataProviderInfo>, callback:Batch<IDataProvider>->Void) {
		var dp:IDataProvider = null;

		for(s in data) {
			dp = DataProviderManager.get(s);
			if(dp == null) {
//				TODO: need to uncomment it and remove next string after error adding
//				errors.addError(Error.create("Can't find data provider for: " + s.url));
				batch.add(dp);
			}
			else {
				batch.add(dp);
			}
		}

		if(errors.isError) {
			finished.emit(this);
		}
		else {
			batch.finished.addOnce(callback);
			batch.handle();
		}
	}

	function onSyncBatchLoaded(batch:Batch<IDataProvider>) {
		initialized.emit(_syncBatch.items);

		_asyncBatch = new ProviderBatch();
		_asyncBatch.itemFinished.add(onAsyncItemLoaded);
		loadBatch(_asyncBatch, _structure.asyncData, onAsyncBatchLoaded);
	}

	function onAsyncItemLoaded(item:IDataProvider) {
		updated.emit(item);
	}

	function onAsyncBatchLoaded(batch:Batch<IDataProvider>) {
		finished.emit(this);
	}

	override function calculateProgress():IProgress {
		if(_progress != null) {
			_progress.set(_structure != null ? 1 : 0);
		}

		return _progress;
	}

	inline function get_dependencies():Array<String> {
		return _structure != null ? _structure.dependencies : [];
	}
}
