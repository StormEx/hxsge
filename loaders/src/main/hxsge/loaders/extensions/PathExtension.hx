package hxsge.loaders.extensions;

class PathExtension {
	static inline public function isLocalPath(value:String):Bool {
		return value.indexOf("http:") != -1 || value.indexOf("https:") != -1;
	}
}
