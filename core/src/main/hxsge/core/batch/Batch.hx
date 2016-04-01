package hxsge.core.batch;

import hxsge.core.debug.Debug;
import hxsge.core.memory.Memory;
import msignal.Signal;

class Batch<T:IBatchable> implements IDisposable {
	public var items:Array<T> = [];
	public var progress(get, never):Float;
	public var isLoading(default, null):Bool = false;
	public var isCompleted(get, never):Bool;

	public var itemFinished(default, null):Signal1<IProccessable>;
	public var finished(default, null):Signal1<Batch<T>>;

	var _current:Int;

	public function new() {
		_current = 0;
		items = [];

		finished = new Signal1();
		itemFinished = new Signal1();
	}

	public function dispose() {
		if(finished != null) {
			finished.removeAll();
			finished = null;
		}
		if(itemFinished != null) {
			itemFinished.removeAll();
			itemFinished = null;
		}

		for(i in items) {
			Memory.dispose(i);
		}
		items = null;
	}

	public function add(item:T) {
		Debug.assert(item != null);

		items.push(item);
	}

	public function handle() {
		Debug.assert(items != null);

		if(isCompleted || isLoading) {
			finished.dispatch(this);

			return;
		}

		handleItem();
	}

	function handleItem() {
		if(items[_current].finished == null) {
			onItemHandled(items[_current]);
		}
		else {
			items[_current].finished.addOnce(onItemHandled);
			items[_current].handle();
		}
	}

	function onItemHandled(item:IProccessable) {
		itemFinished.dispatch(item);
		_current++;

		if(isCompleted) {
			finished.dispatch(this);
		}
		else {
			handleItem();
		}
	}

	inline function get_isCompleted():Bool {
		return items.length == _current;
	}

	inline function get_progress():Float {
		return isCompleted ? 1 : _current / items.length;
	}
}
