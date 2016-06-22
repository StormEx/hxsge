package hxsge.assets.data;

@:enum abstract AssetChangeType(Int) from Int to Int {
	var CREATED = 0;
	var RESTORED = 1;
	var REMOVED = 2;
	var LOSTED = 3;
}
