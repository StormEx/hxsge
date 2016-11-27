package hxsge.math.extentions;

class MathIntExtension {
	inline public static function clamp(value:Int, min:Int, max:Int):Int {
		return value < min ? min : (value > max ? max : value);
	}
}
