package hxsge.format.bundle;

@:enum abstract BundleResourceType(String) from String to String {
	var REQUIRED:String = "required";
	var ASYNCHRONOUS:String = "asynchronous";
}
