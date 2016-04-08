package hxsge.assets;

import hxsge.assets.data.bundle.dataprovider.BundleDataProviderProxy;
import hxsge.dataprovider.DataProviderManager;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.core.debug.Debug;
import hxsge.core.memory.Memory;
import hxsge.core.IDisposable;
import hxsge.assets.data.bundle.BundleImpl;
import hxsge.assets.data.bundle.Bundle;

using hxsge.core.utils.StringTools;

class AssetManager implements IDisposable {
	var _bundles:Map<String, BundleImpl>;

	public function new() {
		DataProviderManager.add(new BundleDataProviderProxy());

		_bundles = new Map();
	}

	public function dispose() {
		for(b in _bundles) {
			Memory.dispose(b);
		}
		_bundles = null;
	}

	public function getBundle(url:String, version:String = null):Bundle {
		var bundle:BundleImpl = null;

		Debug.assert(url.isNotEmpty());

		bundle = _bundles.get(url);

		if(bundle == null) {
			bundle = new BundleImpl(url, version);
			bundle.finished.addOnce(onBundleFinished);
			bundle.updated.add(onBundleUpdated);

			_bundles.set(url, bundle);
		}

		return new Bundle(bundle);
	}

	function registerResources(resources:Array<IDataProvider>) {
	}

	function unregisterResources(resources:Array<IDataProvider>) {
	}

	function onBundleChanged(bundle:BundleImpl) {
		if(bundle.refCount == 0) {
			_bundles.remove(bundle.url);

			Debug.trace("Bundle unloaded: " + bundle.url);
			unregisterResources(bundle.resources);
			Memory.dispose(bundle);
		}
	}

	function onBundleFinished(bundle:BundleImpl) {
		if(!bundle.errors.isError) {
			Debug.trace("bundle " + bundle.url + " loaded successfuly...");
			registerResources(bundle.resources);
		}
	}

	function onBundleUpdated(resources:Array<IDataProvider>) {
		registerResources(resources);
	}
}
