package hxsge.assets;

import hxsge.core.signal.Signal.Signal1;
import hxsge.core.log.Log;
import hxsge.assets.data.IAsset;
import hxsge.core.debug.Debug;
import hxsge.core.memory.Memory;
import hxsge.core.IDisposable;
import hxsge.assets.data.bundle.BundleImpl;
import hxsge.assets.data.bundle.Bundle;

using hxsge.core.utils.StringTools;
using hxsge.core.utils.ArrayTools;

class AssetManager implements IDisposable {
	static public var assets:AssetManager = new AssetManager();

	public var registered(default, null):Signal1<Array<String>>;
	public var unregistered(default, null):Signal1<Array<String>>;

	var _bundles:Map<String, BundleImpl>;
	var _assets:Map<String, IAsset>;

	public function new() {
		_bundles = new Map();
		_assets = new Map();

		registered = new Signal1();
		unregistered = new Signal1();
	}

	public function dispose() {
		Memory.dispose(registered);
		Memory.dispose(unregistered);

		Memory.disposeIterable(_bundles);
		Memory.disposeIterable(_assets);
	}

	public function getBundle(url:String, version:String = null):Bundle {
		var bundle:BundleImpl = null;

		Debug.assert(url.isNotEmpty());

		bundle = _bundles.get(url);

		if(bundle == null) {
			bundle = new BundleImpl(url, version);
			bundle.initialized.addOnce(onBundleInitialized);
			bundle.updated.add(onBundleUpdated);
			bundle.finished.addOnce(onBundleFinished);

			_bundles.set(url, bundle);
		}

		return new Bundle(bundle);
	}

	public function getAsset<T>(id:String, type:Class<T>):T {
		var item:IAsset = _assets.get(id);

		if(Std.is(item, type)) {
			return cast item;
		}

		return null;
	}

	function registerResources(resources:Array<IAsset>) {
		var res:Array<String> = [];

		if(resources.isEmpty()) {
			return;
		}

		for(r in resources) {
			if(r == null || r.id.isEmpty()) {
				Log.log("[AssetManager] try to register invalid asset");
			}
			else {
				if(_assets.exists(r.id)) {
					Log.log("[AssetManager] try to register duplicate asset: " + r.id);
				}
				else {
					Debug.trace("[AssetManager] asset registered: " + r.id);
					_assets.set(r.id, r);
					res.push(r.id);
				}
			}
		}

		if(res.isNotEmpty()) {
			registered.emit(res);
		}
	}

	function unregisterResources(resources:Array<IAsset>) {
		for(r in resources) {
			_assets.remove(r.id);
		}
	}

	function onBundleChanged(bundle:BundleImpl) {
		if(bundle.refCount == 0) {
			_bundles.remove(bundle.url);

			Debug.trace("Bundle unloaded: " + bundle.url);
			unregisterResources(bundle.resources);
			Memory.dispose(bundle);
		}
	}

	function onBundleInitialized(bundle:BundleImpl) {
		var res:Array<String> = [];

		registerResources(bundle.resources);
	}

	function onBundleFinished(bundle:BundleImpl) {
		if(!bundle.errors.isError) {
			Debug.trace("bundle " + bundle.url + " loaded successfuly...");
		}
		else {
			Debug.trace("bundle " + bundle.url + " loaded with errors: " + bundle.errors.toString());
		}
	}

	function onBundleUpdated(resources:Array<IAsset>) {
		registerResources(resources);
	}
}
