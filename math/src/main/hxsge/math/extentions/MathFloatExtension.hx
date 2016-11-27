package hxsge.math.extentions;

class MathFloatExtension {
	inline public static function clamp(value:Float, min:Float, max:Float):Float {
		return value < min ? min : (value > max ? max : value);
	}

	inline public static function format(value:Float, precision:Int = 2):String {
		if (precision < 0) {
			precision = 0;
		}
		else if (precision > 8) {
			precision = 8;
		}

		var res:String = "";
		var str:String = Std.string(value);
		var val:Int = str.lastIndexOf('.');

		if (val == -1) {
			val = str.length - 1;
		}
		else {
			res = str.substr(val, precision + 1);
		}

		while (val > 2) {
			res = (val != 3 ? "," : "") + str.substring(val - 3, val) + res;
			val -= 3;
		}
		res = str.substring(0, val) + res;

		return res;
	}
}
