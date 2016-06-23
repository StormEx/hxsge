package hxsge.assets.bundle;

import hxsge.core.memory.Memory;
import hxsge.photon.Signal;
import hxsge.core.IDisposable;

class Bundle implements IDisposable {
	public var url(get, never):String;
	public var finished(default, null):Signal1<Bundle>;
	public var isSuccess(get, null):Bool;
	public var progress(get, never):Float;

	var _impl:BundleImpl;
	var _isLoaded:Bool;

	public function new(impl:BundleImpl) {
		_impl = impl;
		_impl.finished.addOnce(onBundleFinished);

		finished = new Signal1();
	}

	public function dispose() {
		Memory.dispose(finished);
		if(_impl != null) {
			_impl.unload();
			_impl = null;
		}
	}

	public function load() {
		if(_impl != null && !_isLoaded) {
			_isLoaded = true;
			_impl.load();
		}
	}

	function onBundleFinished(bundle:BundleImpl) {
		_isLoaded = true;
		if(finished != null) {
			finished.emit(this);
		}
	}

	inline function get_url():String {
		return _impl == null ? "" : _impl.url;
	}

	inline function get_isSuccess():Bool {
		return _impl == null ? false : !_impl.errors.isError;
	}

	inline function get_progress():Float {
		return _impl == null ? 0 : _impl.progress;
	}
}
