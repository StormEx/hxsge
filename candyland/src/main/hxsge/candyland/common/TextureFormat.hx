package hxsge.candyland.common;

@:enum abstract TextureFormat(Int) to Int {
	var BGRA_8888 = 0;

	var ATF_BGRA = 10;
	var ATF_COMPRESSED = 11;
	var ATF_COMPRESSED_ALPHA = 12;
}