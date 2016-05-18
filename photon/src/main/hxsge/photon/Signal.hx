package hxsge.photon;

import haxe.Constraints.Function;

class Signal<T:Function> {
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

class Signal0 extends Signal<Void->Void> {
	public function new() {
		super();
	}

	inline public function emit() {
		SignalMacro.emitBuild();
	}
}

class Signal1<A> extends Signal<A->Void>{
	public function new() {
		super();
	}

	inline public function emit(a:A) {
		SignalMacro.emitBuild(a);
	}
}

class Signal2<A, B> extends Signal<A->B->Void> {
	public function new() {
		super();
	}

	inline public function emit(a:A, b:B) {
		SignalMacro.emitBuild(a, b);
	}
}
