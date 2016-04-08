package hxsge.core.platforms;

@:enum abstract PlatformType(String) from String to String {
	var CPP:String = "cpp";
	var JS:String = "js";
	var JAVA:String = "java";
	var CS:String = "cs";
	var FLASH:String = "flash";

	var UNKNOWN:String = "unknown";
}
