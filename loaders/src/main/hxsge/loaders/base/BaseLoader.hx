package hxsge.loaders.base;

import hxsge.core.signal.SignalMacro;
import hxsge.core.signal.Signal;
import hxsge.core.debug.error.Error;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.core.debug.Debug;

using hxsge.core.utils.StringTools;

class BaseLoader implements ILoader {
	public var url(default, null):String;
	public var errors(default, null):ErrorHolder;
	public var finished(default, null):Signal1<ILoader>;
	public var state(default, null):LoaderStateType;
	public var progress(get, never):Float;
	public var content(default, null):Dynamic;

	public function new(url:String) {
		Debug.assert(url.isNotEmpty());

		this.url = url;
		errors = new ErrorHolder();
		state = LoaderStateType.NONE;
		finished = new Signal1();
	}

	public function dispose() {
		if(finished != null) {
			finished.removeAll();
			finished = null;
		}

		cancel();
		cleanup();
		performDispose();

		content = null;
		errors = null;
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

	inline function get_progress():Float {
		return calculateProgress();
	}

	function performCleanup() {
	}

	function performLoad() {
		Debug.error("need to override");
	}

	function performCancel() {
	}

	function performFail(message:String) {
		state = LoaderStateType.FAIL;
		errors.addError(Error.create(message));

		cancel();
	}

	function performComplete() {
		cleanup();

		state = LoaderStateType.SUCCESS;
		SignalMacro.safeEmit(finished, this);
	}

	function performDispose() {
	}

	function calculateProgress():Float {
		return 0;
	}
}
