package hxsge.photon;

import haxe.Constraints.Function;

class SignalTools {
	public static inline function unsafeAdd<T:Function>(signal:Signal<T>, func:T, type:SignalFlagType = SignalFlagType.NONE) {
		signal.addSlot(func, type);
	}
}
