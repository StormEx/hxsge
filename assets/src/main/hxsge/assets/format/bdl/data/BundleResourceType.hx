package hxsge.assets.format.bdl.data;

@:enum abstract BundleResourceType(String) from String to String {
	var REQUIRED:String = "required";
	var ASYNCHRONOUS:String = "asynchronous";
}
