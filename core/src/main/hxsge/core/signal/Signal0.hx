package hxsge.core.signal;

class Signal0 extends Signal<Void->Void> {
	public function new() {
		super();
	}

	inline public function emit() {
		SignalMacro.emitBuild();
	}
}
