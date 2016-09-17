package hxsge.loaders.common;

@:enum abstract LoaderStateType(Int) from Int to Int {
	var NONE:Int = 1 << 0;
	var LOADING:Int = 1 << 1;
	var SUCCESS:Int = 1 << 2;
	var CANCEL:Int = 1 << 3;
	var FAIL:Int = 1 << 4;
}
