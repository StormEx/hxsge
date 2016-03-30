package hxsge.log;

@:enum abstract LogLevelType(Int) from Int to Int {
	var ASSERT = 1;
	var ERROR = 2;
	var WARNING = 4;
	var INFO = 8;
	var LOG = 16;
	var DEBUG = 32;
	var TRACE = 64;

	public static inline var NONE:Int = 0;
	public static inline var ALL:Int = 0xFFFF;
}
