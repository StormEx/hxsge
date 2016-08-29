package hxsge.candyland.common;

@:enum abstract AntialiasType(Int) from Int to Int {
	var NONE = 0;
	var LOW = 1;
	var MID = 2;
	var HIGH = 3;
}
