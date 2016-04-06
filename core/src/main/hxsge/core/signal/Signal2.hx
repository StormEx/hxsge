package hxsge.core.signal;

class Signal2<A, B> extends Signal<A->B->Void> {
	public function new() {
		super();
	}

	inline public function emit(a:A, b:B) {
		SignalMacro.emitBuild(a, b);
	}
}
