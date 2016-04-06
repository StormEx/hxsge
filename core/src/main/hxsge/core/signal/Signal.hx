package hxsge.core.signal;

import hxsge.core.debug.Debug;
import haxe.Constraints.Function;

class Signal<T:Function> implements IDisposable {
	var _functions:Array<T> = [];
	var _flags:Array<SignalFlagType> = [];

	public function new() {
	}

	inline public function dispose() {
		removeAll();
	}

	inline function check(func:T) {
		var res:Int = -1;
		for(i in 0..._functions.length) {
			if(_functions[i] == func) {
				res = i;

				break;
			}
		}

		return res;
	}

	public function add(func:T, type:SignalFlagType = SignalFlagType.NONE) {
		if(check(func) == -1) {
			_functions.push(func);
			_flags.push(type);
		}
		else {
			Debug.trace("try to add existing function...");
		}
	}

	inline public function addOnce(func:T) {
		add(func, SignalFlagType.ONCE);
	}

	inline public function remove(func:T) {
		for(i in 0..._functions.length) {
			if(_functions[i] == func) {
				removeSlot(i);

				break;
			}
		}
	}

	inline public function removeAll() {
		_functions = [];
		_flags = [];
	}

	inline function removeSlot(index:Int) {
		_functions.splice(index, 1);
		_flags.splice(index, 1);
	}
}
