package hxsge.assets.data.bundle.format.bundle;

import hxsge.core.serialize.ISerializable;
import hxsge.core.platforms.Platforms;
using hxsge.core.utils.StringTools;

class BundleData implements ISerializable {
	public var requiredAppVersion:String;
	public var name:String;
	public var version:String;
	public var platforms:Array<String> = [];
	public var dependencies:Array<String> = [];
	public var resources:Array<BundleResourceGroup> = [];

	public var isHasDependencies(get, never):Bool;
	public var isHasResources(get, never):Bool;

	public function new() {
	}

	public function checkPlatform():Bool {
		return platforms.indexOf(Platforms.getCurrentPlatform()) != -1;
	}

	public function checkVersion(baseVersion:String):Bool {
		if(baseVersion.isNotEmpty()) {
			var tsubversions:Array<String> = baseVersion.split(".");
			var ssubversions:Array<String> = requiredAppVersion.split(".");
			var count:Int = tsubversions.length > ssubversions.length ? tsubversions.length : ssubversions.length;

			for(i in 0...count) {
				if(Std.parseInt(tsubversions[i]) > Std.parseInt(ssubversions[i])) {

					return false;
				}
			}
		}

		return true;
	}

	inline function get_isHasDependencies():Bool {
		return dependencies != null && dependencies.length > 0;
	}

	inline function get_isHasResources():Bool {
		return resources != null && resources.length > 0;
	}
}
