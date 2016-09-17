package hxsge.math;

class Vector2 {
	public static var REG_0(default, null):Vector2 = new Vector2();

	public var x:Float;
	public var y:Float;

	public function new(x:Float = 0, y:Float = 0) {
		this.x = x;
		this.y = y;
	}

	public function set(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	public function normalize() {
		var m = magnitude();
		x /= m;
		y /= m;
	}

	public function dot(x:Float, y:Float):Float {
		return this.x * x + this.y * y;
	}

	public function multiply(n:Float):Vector2 {
		x *= n;
		y *= n;
		return this;
	}

	public function substract(p:Vector2):Vector2 {
		x -= p.x;
		y -= p.y;
		return this;
	}

	public function magnitude():Float {
		return Math.sqrt(x * x + y * y);
	}

	public function distanceTo(x:Float, y:Float):Float {
		return Math.sqrt(distanceToSquared(x, y));
	}

	public function distanceToSquared(x:Float, y:Float):Float {
		var dx = this.x - x;
		var dy = this.y - y;
		return dx * dx + dy * dy;
	}

	public function clone(?result:Vector2):Vector2 {
		if (result == null) {
			return new Vector2(x, y);
		}
		result.set(x, y);
		return result;
	}

	public function equals(other:Vector2):Bool {
		return x == other.x && y == other.y;
	}

	public function trunc():Vector2 {
		x = Std.int(x);
		y = Std.int(y);
		return this;
	}

	public function toString():String {
		return '($x, $y)';
	}

	public function setDelta(begin:Vector2, end:Vector2, k:Float = 1.0):Vector2 {
		x = k*(end.x - begin.x);
		y = k*(end.y - begin.y);
		return this;
	}
}
