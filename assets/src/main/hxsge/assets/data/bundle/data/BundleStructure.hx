package hxsge.assets.data.bundle.data;

import haxe.io.Path;
import hxsge.core.debug.Debug;
import hxsge.memory.Memory;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.photon.Signal.Signal1;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.memory.IDisposable;

class BundleStructure implements IDisposable {
	public var errors(default, null):ErrorHolder;

	public var dependencies(default, null):Array<String> = [];
	public var syncData(default, null):Array<IDataProviderInfo> = [];
	public var asyncData(default, null):Array<IDataProviderInfo> = [];

	public var finished(default, null):Signal1<BundleStructure>;

	var _info:IDataProviderInfo;
	var _provider:IDataProvider;

	public function new() {
		errors = new ErrorHolder();
		finished = new Signal1();
	}

	public function dispose() {
		Memory.dispose(finished);
		Memory.dispose(_provider);

		_info = null;
		syncData = null;
		asyncData = null;
		dependencies = null;
		errors = null;
	}

	public function load(info:IDataProviderInfo) {
		Debug.assert(info != null);

		_info = info;

		if(_provider == null) {
			performLoad();
		}
		else {
			if(_provider.progress.isFinished) {
				finished.emit(this);
			}
		}
	}

	function prepareData() {
		Debug.error("need to override...");
	}

	function performLoad() {
		Debug.error("need to override...");
	}

	function getDependencyUrl(name:String):String {
		return Path.normalize(Path.directory(_info.url) + "/" + name);
	}
}
