package hxsge.core.math;

class MathFloatTools {
	inline public static function clamp(value:Float, min:Float, max:Float):Float {
		return value < min ? min : (value > max ? max : value);
	}
}
