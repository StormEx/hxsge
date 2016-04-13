package hxsge.assets.data.bundle.dataprovider;

import hxsge.dataprovider.providers.base.ProviderBatch;
import hxsge.core.debug.error.Error;
import hxsge.dataprovider.DataProviderManager;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.core.batch.Batch;
import hxsge.dataprovider.providers.base.ProviderBatch;
import hxsge.core.debug.Debug;
import hxsge.core.memory.Memory;
import hxsge.core.signal.Signal.Signal1;
import hxsge.assets.data.bundle.dataprovider.structure.ZipBundleStructure;
import hxsge.assets.data.bundle.dataprovider.structure.BundleStructure;
import haxe.io.Path;
import hxsge.assets.data.bundle.format.bundle.BundleData;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.BaseDataProvider;

class BundleDataProvider extends BaseDataProvider {
	public var data(get, never):BundleData;
	public var dependencies(get, never):Array<String>;

	public var prepared(default, null):Signal1<BundleDataProvider>;

	var _structure:BundleStructure;
	var _syncBatch:ProviderBatch;
	var _asyncBatch:ProviderBatch;

	public function new(info:IDataProviderInfo) {
		super(info);

		prepared = new Signal1();
	}

	public override function dispose() {
		super.dispose();

		Memory.dispose(prepared);
	}

	override function prepareData() {
		if(Path.extension(info.url) == "zip") {
			_structure = new ZipBundleStructure(info);
		}
		else {
			_structure = new BundleStructure(info);
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
		_asyncBatch = new ProviderBatch();
		loadBatch(_asyncBatch, _structure.asyncData, onAsyncBatchLoaded);
	}

	function onAsyncBatchLoaded(batch:Batch<IDataProvider>) {
		finished.emit(this);
	}

	override function calculateProgress():Float {
		return _structure != null ? 1 : 0;
	}

	inline function get_data():BundleData {
		return _structure != null ? _structure.data : null;
	}

	inline function get_dependencies():Array<String> {
		return _structure != null ? _structure.dependencies : [];
	}
}
