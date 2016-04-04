package hxsge.loaders.base;

import hxsge.core.debug.error.Error;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.core.debug.Debug;
import msignal.Signal;

using hxsge.core.utils.StringTools;

class BaseLoader implements ILoader {
	public var url(default, null):String;
	public var errors(default, null):ErrorHolder;
	public var finished(default, null):Signal1<ILoader>;
	public var isCanceled(default, null):Bool;
	public var isSuccess(default, null):Bool;
	public var progress(get, never):Float;

	var _content:Dynamic;

	public function new(url:String) {
		Debug.assert(url.isNotEmpty());

		this.url = url;
		errors = new ErrorHolder();
		isCanceled = false;
		isSuccess = false;
		finished = new Signal1();
	}

	public function dispose() {
		cancel();
		cleanup();
		performDispose();

		_content = null;
		errors = null;
		if(finished != null) {
			finished.removeAll();
			finished = null;
		}
	}

	public function load() {
		performLoad();
	}

	function cleanup() {
		performCleanup();
	}

	public function cancel() {
		performCancel();

		isCanceled = true;
		performComplete();
	}

	public function getContent<T>(type:Class<T>):T {
		var t:T = null;

		if(isSuccess && _content != null && Std.is(_content, type)) {
			t = cast _content;
		}

		return t;
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
		errors.addError(Error.create(message));

		cancel();
	}

	function performComplete() {
		cleanup();

		if(finished != null) {
			finished.dispatch(this);
		}
	}

	function performDispose() {
	}

	function calculateProgress():Float {
		return 0;
	}
}
