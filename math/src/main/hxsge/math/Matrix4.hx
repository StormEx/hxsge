package hxsge.math;

abstract Matrix4(Array<Float>) from Array<Float> {
	inline public function new() {
		this = new Array();
		for(i in 0...16) {
			this.push(0);
		}
	}

	@:arrayAccess inline public function get(index:Int):Float {
		return this[index];
	}

	@:arrayAccess inline public function set(index:Int, value:Float):Float {
		return this[index] = value;
	}

	public function copyFrom(matrix:Matrix4) {
		for(i in 0...16) {
			this[i] = matrix[i];
		}
	}

	public static function multiply(left:Matrix4, right:Matrix4, destination:Matrix4):Matrix4 {
		var m111:Float = right[0], m121:Float = right[4], m131:Float = right[8], m141:Float = right[12],
		m112:Float = right[1], m122:Float = right[5], m132:Float = right[9], m142:Float = right[13],
		m113:Float = right[2], m123:Float = right[6], m133:Float = right[10], m143:Float = right[14],
		m114:Float = right[3], m124:Float = right[7], m134:Float = right[11], m144:Float = right[15],
		m211:Float = left[0], m221:Float = left[4], m231:Float = left[8], m241:Float = left[12],
		m212:Float = left[1], m222:Float = left[5], m232:Float = left[9], m242:Float = left[13],
		m213:Float = left[2], m223:Float = left[6], m233:Float = left[10], m243:Float = left[14],
		m214:Float = left[3], m224:Float = left[7], m234:Float = left[11], m244:Float = left[15];

		destination[0] = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
		destination[1] = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
		destination[2] = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
		destination[3] = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;

		destination[4] = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
		destination[5] = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
		destination[6] = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
		destination[7] = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;

		destination[8] = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
		destination[9] = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
		destination[10] = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
		destination[11] = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;

		destination[12] = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
		destination[13] = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
		destination[14] = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
		destination[15] = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;

		return destination;
	}

	public function setTransform2D(x:Float, y:Float, scale:Float = 1, rotation:Float = 0) {
		var theta = rotation * Math.PI / 180.0;
		var cs = Math.cos(theta) * scale;
		var sn = Math.sin(theta) * scale;

		this[0] = cs;
		this[1] = -sn;
		this[2] = 0;
		this[3] = 0;

		this[4] = sn;
		this[5] = cs;
		this[6] = 0;
		this[7] = 0;

		this[8] = 0;
		this[9] = 0;
		this[10] = 1;
		this[11] = 0;

		this[12] = x;
		this[13] = y;
		this[14] = 0;
		this[15] = 1;
	}

	public function setOrtho2D(x:Float, y:Float, width:Float, height:Float, zNear:Float = -1000, zFar:Float = 1000) {
		// what... normal 2d requirements :|
		setOrthoProjection(x, x + width, y + height, y, zNear, zFar);
	}

	function setOrthoProjection(x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float) {
		var sx = 1.0 / (x1 - x0);
		var sy = 1.0 / (y1 - y0);
		var sz = 1.0 / (zFar - zNear);

		this[0] = 2.0 * sx;
		this[1] = 0;
		this[2] = 0;
		this[3] = 0;

		this[4] = 0;
		this[5] = 2.0 * sy;
		this[6] = 0;
		this[7] = 0;

		this[8] = 0;
		this[9] = 0;
		this[10] = -2.0 * sz;
		this[11] = 0;

		this[12] = -(x0 + x1) * sx;
		this[13] = -(y0 + y1) * sy;
		this[14] = -(zNear + zFar) * sz;
		this[15] = 1;
	}

	@:from public static function fromArray(array:Array<Float>):Matrix4 {
		var matrix = new Matrix4();
		matrix = array.concat([]);

		return matrix;
	}
}