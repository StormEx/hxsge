package hxsge.core.signal;

class Signal1<A> extends Signal<A->Void>{
	public function new() {
		super();
	}

	inline public function emit(a:A) {
		SignalMacro.emitBuild(a);
	}
}
