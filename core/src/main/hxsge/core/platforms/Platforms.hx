package hxsge.core.platforms;

class Platforms {
	public static var platforms:Array<PlatformType> = [
		PlatformType.CPP,
		PlatformType.JS,
		PlatformType.JAVA,
		PlatformType.CS,
		PlatformType.FLASH
	];

	inline public static function getCurrentPlatform():String {
		return PlatformMacro.getPlatform();
	}
}
