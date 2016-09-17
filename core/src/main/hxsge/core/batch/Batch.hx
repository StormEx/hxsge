package hxsge.core.batch;

import hxsge.memory.IDisposable;
import hxsge.core.utils.progress.MinMaxProgress;
import hxsge.core.utils.progress.IProgress;
import hxsge.photon.Signal;
import hxsge.memory.Memory;
import hxsge.core.debug.Debug;

using hxsge.core.utils.ArrayTools;

class Batch<T:IDisposable> {
	public var items:Array<T> = [];
	public var progress(get, never):IProgress;
	public var isCompleted(get, never):Bool;

	public var itemFinished(default, null):Signal1<T>;
	public var finished(default, null):Signal1<Batch<T>>;

	var _index:Int;
	var _current(get, never):T;
	var _progress:MinMaxProgress;

	public function new() {
		_index = 0;
		items = [];

		_progress = new MinMaxProgress(0, 1);

		finished = new Signal1();
		itemFinished = new Signal1();
	}

	public function dispose(disposeItems:Bool = true) {
		Memory.dispose(finished);
		Memory.dispose(itemFinished);

		if(disposeItems && items.isNotEmpty()) {
			while(items.length > 0) {
				var i = items[items.length - 1];
				items.splice(items.length - 1, 1);
				Memory.dispose(i);
			}
		}
		items = null;
		_progress = null;
	}

	public function add(item:T) {
		if(item != null) {
			items.push(item);
		}
		else {
			Debug.trace("skipped null item on adding to batch");
		}
	}

	public function handle() {
		if(items.isEmpty()) {
			_progress.finish();
			handleItem();
		}
		else {
			_progress.reset(0, items.length);

			handleItem();
		}
	}

	function handleItem() {
		if(isCompleted) {
			finished.emit(this);

			return;
		}

		startHandleItem();
	}

	function startHandleItem() {
		Debug.error("need to override");
	}

	function onItemHandled(item:T) {
		itemFinished.emit(item);
		_progress.change();
		_index++;

		handleItem();
	}

	inline function get_isCompleted():Bool {
		return items.length == _index;
	}

	inline function get_progress():IProgress {
		return _progress;
	}

	inline function get__current():T {
		return items[_index];
	}
}
