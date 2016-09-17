package hxsge.math.geometry;

class Rectangle {
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	public var left (get, set):Float;
	public var right (get, set):Float;
	public var top (get, set):Float;
	public var bottom (get, set):Float;
	public var centerX (get, null):Float;
	public var centerY (get, null):Float;

	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0) {
		set(x, y, width, height);
	}

	inline public function set(x:Float, y:Float, width:Float, height:Float):Void {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	public function contains(x:Float, y:Float):Bool {
		// A little more complicated than usual due to proper handling of negative widths/heights

		x -= this.x;
		if (width >= 0) {
			if (x < 0 || x > width) {
				return false;
			}
		} else if (x > 0 || x < width) {
			return false;
		}

		y -= this.y;
		if (height >= 0) {
			if (y < 0 || y > height) {
				return false;
			}
		} else if (y > 0 || y < height) {
			return false;
		}

		return true;
	}

/**
		 * Creates a copy of this rectangle.
		 */

	public function clone(?result:Rectangle):Rectangle {
		if (result == null) {
			result = new Rectangle();
		}
		result.set(x, y, width, height);
		return result;
	}

	public function equals(other:Rectangle):Bool {
		return x == other.x && y == other.y && width == other.width && height == other.height;
	}

	public function copyFrom(other:Rectangle) {
		x = other.x;
		y = other.y;
		width = other.width;
		height = other.height;
	}

	public function toString():String {
		return '($x, $y, $width x $height)';
	}

	inline private function get_left():Float {
		return x;
	}

	inline private function set_left(value:Float):Float {
		width -= value - x;
		x = value;
		return value;
	}

	inline private function get_top():Float {
		return y;
	}

	inline private function set_top(value:Float):Float {
		height -= value - y;
		y = value;
		return value;
	}

	inline function get_right():Float {
		return x + width;
	}

	inline function set_right(value:Float):Float {
		width = value - x;
		return value;
	}

	inline function get_bottom():Float {
		return y + height;
	}

	inline function set_bottom(value:Float):Float {
		height = value - y;
		return value;
	}

	inline function get_centerX():Float {
		return x + width / 2;
	}

	inline function get_centerY():Float {
		return y + height / 2;
	}
}
