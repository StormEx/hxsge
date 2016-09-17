package hxsge.photon;

@:enum abstract SignalFlagType(Int) from Int to Int {
	var NONE:Int = 1 << 0;
	var ONCE:Int = 1 << 1;
}
