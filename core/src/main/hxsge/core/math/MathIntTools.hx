package hxsge.core.math;

class MathIntTools {
	inline public static function clamp(value:Int, min:Int, max:Int):Int {
		return value < min ? min : (value > max ? max : value);
	}
}
