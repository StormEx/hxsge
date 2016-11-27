package hxsge.candyland.common.material;

class BlendMode {
	public var dst:BlendFactor;
	public var src:BlendFactor;
	public var hash(get, never):Int;

	public static function createBlendMode(src:BlendFactor, dst:BlendFactor) {
		return new BlendMode(src, dst);
	}

	public static function createAlpha():BlendMode {
		return createBlendMode(BlendFactor.ONE, BlendFactor.ONE_MINUS_SOURCE_ALPHA);
	}

	public static function createAdditive():BlendMode {
		return createBlendMode(BlendFactor.SOURCE_ALPHA, BlendFactor.ONE);
	}

	public function new(src:BlendFactor, dst:BlendFactor) {
		this.src = src;
		this.dst = dst;
	}

	inline function get_hash():Int {
		return (src << 16) | dst;
	}
}
