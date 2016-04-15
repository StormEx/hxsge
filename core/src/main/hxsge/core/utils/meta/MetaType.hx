package hxsge.core.utils.meta;

@:enum abstract MetaType(Int) from Int to Int {
	var UNKNOWN:Int = -1;
	var JSON:Int = 0;
	var XML:Int = 1;
}
