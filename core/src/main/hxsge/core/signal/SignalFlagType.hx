package hxsge.core.signal;

@:enum abstract SignalFlagType(Int) from Int to Int {
	var NONE:Int = 0 << 1;
	var ONCE:Int = 0 << 2;
}
