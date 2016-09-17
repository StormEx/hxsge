package hxsge.loaders.common;

import hxsge.memory.Memory;
import hxsge.photon.SignalMacro;
import hxsge.core.utils.progress.Progress;
import hxsge.core.utils.progress.IProgress;
import hxsge.photon.Signal;
import hxsge.core.debug.error.Error;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.core.debug.Debug;

using hxsge.core.utils.StringTools;

class BaseLoader implements ILoader {
	public var url(default, null):String;
	public var errors(default, null):ErrorHolder;
	public var finished(default, null):Signal1<ILoader>;
	public var state(default, null):LoaderStateType;
	public var progress(get, never):IProgress;
	public var content(default, null):Dynamic;

	var _progress:Progress;

	public function new(url:String) {
		Debug.assert(url.isNotEmpty());

		this.url = url;
		errors = new ErrorHolder();
		state = LoaderStateType.NONE;
		finished = new Signal1();
		_progress = new Progress();
	}

	public function dispose() {
		Memory.dispose(finished);

		cancel();
		cleanup();
		performDispose();

		content = null;
		errors = null;
		_progress = null;
	}

	public function load() {
		state = LoaderStateType.LOADING;
		performLoad();
	}

	function cleanup() {
		performCleanup();
	}

	public function cancel() {
		performCancel();
		cleanup();

		state = LoaderStateType.CANCEL;
		SignalMacro.safeEmit(finished, this);
	}

	inline function get_progress():IProgress {
		return calculateProgress();
	}

	function performCleanup() {
	}

	function performLoad() {
		Debug.error("need to override");
	}

	function performCancel() {
	}

	function performFail(message:String, errorValue:Dynamic = null) {
		state = LoaderStateType.FAIL;
		errors.addError(Error.create(message, errorValue));

		cancel();
	}

	function performComplete() {
		cleanup();

		state = LoaderStateType.SUCCESS;
		SignalMacro.safeEmit(finished, this);
	}

	function performDispose() {
	}

	function calculateProgress():IProgress {
		return _progress;
	}
}
