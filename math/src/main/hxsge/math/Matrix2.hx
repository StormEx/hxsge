package hxsge.math;

class Matrix2 {
	public var a:Float = 1.0;
	public var b:Float = 0.0;
	public var c:Float = 0.0;
	public var d:Float = 1.0;
	public var tx:Float = 0.0;
	public var ty:Float = 0.0;

	public function new() { }

	public inline function set(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float) {
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.tx = tx;
		this.ty = ty;
	}

	public inline function identity() {
		set(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
	}

	public function compose(x:Float, y:Float, scaleX:Float, scaleY:Float, rotation:Float) {
		var sin = Math.sin(rotation);
		var cos = Math.cos(rotation);
		set(cos * scaleX, sin * scaleX, -sin * scaleY, cos * scaleY, x, y);
	}

	inline public function concat(matrix:Matrix2) {
		Matrix2.multiply(matrix, this, this);
	}

	public function makeTransform(scaleX:Float, scaleY:Float, rotation:Float) {
		var sin = Math.sin(rotation);
		var cos = Math.cos(rotation);
		a = cos * scaleX;
		b = sin * scaleX;
		c = -sin * scaleY;
		d = cos * scaleY;
	}

	public var rotation(get, never):Float;
	function get_rotation():Float {
		var sy = Math.atan2(b, a);
		var sx = Math.atan2(-c, d);
		return sx == sy ? sy : 0;
	}

	public var scaleX(get, never):Float;
	function get_scaleX():Float {
		var oldValue = Math.sqrt(a*a + b*b);
		return a < 0.0 ? -oldValue : oldValue;
	}

	public var scaleY(get, never):Float;
	function get_scaleY():Float {
		var oldValue = Math.sqrt(c*c + d*d);
		return d < 0.0 ? -oldValue : oldValue;
	}

	public function copyFrom(m:Matrix2):Void {
		a = m.a;
		b = m.b;
		c = m.c;
		d = m.d;
		tx = m.tx;
		ty = m.ty;
	}

	public function translate(x:Float, y:Float) {
		tx += a * x + c * y;
		ty += d * y + b * x;
	}

	public function scale(x:Float, y:Float) {
		a *= x;
		b *= x;
		c *= y;
		d *= y;
	}

	public function rotate(rotation:Float) {
		var sin = Math.sin(rotation);
		var cos = Math.cos(rotation);

		var t00 = a * cos + c * sin;
		var t01 = -a * sin + c * cos;
		a = t00;
		c = t01;

		var t10 = d * sin + b * cos;
		var t11 = d * cos - b * sin;
		b = t10;
		d = t11;
	}

/** @return Whether the matrix was inverted. */

	/*public function invert():Bool {
		var det = determinant();
		if (det == 0) {
			return false;
		}
		set(d / det, -c / det, -b / det, a / det,
		(c * ty - d * tx) / det,
		(b * tx - a * ty) / det);
		return true;
	}*/

	public function invert ():Bool {

		var norm = a * d - b * c;

		if (norm == 0) {

			a = b = c = d = 0;
			tx = -tx;
			ty = -ty;
			return false;

		}

		norm = 1.0 / norm;
		var a1 = d * norm;
		d = a * norm;
		a = a1;
		b *= -norm;
		c *= -norm;

		var tx1 = - a * tx - c * ty;
		ty = - b * tx - d * ty;
		tx = tx1;

		return true;

	}

	public function transform(x:Float, y:Float, ?result:Vector2):Vector2 {
		if (result == null) {
			result = new Vector2();
		}
		result.x = x * a + y * c + tx;
		result.y = x * b + y * d + ty;
		return result;
	}

	/*public function transformArray(points:ArrayAccess<Float>, length:Int,
								   result:ArrayAccess<Float>) {
		var ii = 0;
		while (ii < length) {
			var x = points[ii], y = points[ii + 1];
			result[ii++] = x * a + y * c + tx;
			result[ii++] = x * b + y * d + ty;
		}
	}*/

	/**
     * Calculate the determinant of this matrix.
     */
	inline public function determinant():Float {
		return a * d - c * b;
	}

	/**
     * Transforms a point by the inverse of this matrix, or return false if this matrix is not
     * invertible.
     */
	public function inverseTransform(x:Float, y:Float, result:Vector2):Bool {
		var det = determinant();
		if (det == 0) {
			return false;
		}
		x -= tx;
		y -= ty;
		result.x = (x * d - y * c) / det;
		result.y = (y * a - x * b) / det;
		return true;
	}

	/**
     * Multiply two matrices and return the result.
     */
	public inline static function multiply(left:Matrix2, right:Matrix2, result:Matrix2):Void {
		var a = left.a * right.a + left.c * right.b;
		var b = left.b * right.a + left.d * right.b;
		var c = left.a * right.c + left.c * right.d;
		var d = left.b * right.c + left.d * right.d;
		var tx = left.a * right.tx + left.c * right.ty + left.tx;
		var ty = left.b * right.tx + left.d * right.ty + left.ty;

		result.a = a;
		result.c = c;
		result.tx = tx;
		result.b = b;
		result.d = d;
		result.ty = ty;
	}

/**
     * Creates a copy of this matrix.
     */

	public function clone(?result:Matrix2):Matrix2 {
		if (result == null) {
			result = new Matrix2();
		}
		result.set(a, b, c, d, tx, ty);
		return result;
	}

	public inline function equalsCombined(matrix2:Matrix2, translation:Vector2):Bool {
		return  tx == translation.x && ty == translation.y &&
		a == matrix2.a && b == matrix2.b &&
		c == matrix2.c && d == matrix2.d;
	}

	public inline function equals(matrix2:Matrix2):Bool {
		return tx == matrix2.tx && ty == matrix2.ty &&
		a == matrix2.a && b == matrix2.b &&
		c == matrix2.c && d == matrix2.d;
	}

	public inline function copyFromCombined(matrix2:Matrix2, translation:Vector2):Void {
		tx = translation.x;
		ty = translation.y;
		a = matrix2.a;
		b = matrix2.b;
		c = matrix2.c;
		d = matrix2.d;
	}

	public function toString():String {
		return a + " " + c + " " + tx + " \\ " + b + " " + d + " " + ty;
	}

	public static function lerpCombined(start:Matrix2, endMatrix:Matrix2, endPosition:Vector2, ratio:Float, result:Matrix2 = null):Matrix2 {
		if(result == null) {
			result = new Matrix2();
		}
		result.a = start.a + (endMatrix.a - start.a)*ratio;
		result.b = start.b + (endMatrix.b - start.b)*ratio;
		result.c = start.c + (endMatrix.c - start.c)*ratio;
		result.d = start.d + (endMatrix.d - start.d)*ratio;
		result.tx = start.tx + (endPosition.x - start.tx)*ratio;
		result.ty = start.ty + (endPosition.y - start.ty)*ratio;
		return result;
	}

	public static function lerp(start:Matrix2, end:Matrix2, ratio:Float, result:Matrix2 = null):Matrix2 {
		if(result == null) {
			result = new Matrix2();
		}
		result.a = start.a + (end.a - start.a)*ratio;
		result.b = start.b + (end.b - start.b)*ratio;
		result.c = start.c + (end.c - start.c)*ratio;
		result.d = start.d + (end.d - start.d)*ratio;
		result.tx = start.tx + (end.tx - start.tx)*ratio;
		result.ty = start.ty + (end.ty - start.ty)*ratio;
		return result;
	}
}
