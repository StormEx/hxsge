package hxsge.candyland.common;

import hxsge.memory.IDisposable;

class Image implements IDisposable {
	public var texture(default, null):ITexture = null;
	public var ub(default, null):Float = 0;
	public var ue(default, null):Float = 1;
	public var vb(default, null):Float = 0;
	public var ve(default, null):Float = 1;

	public function new(ub:Float = 0, ue:Float = 1, vb:Float = 0, ve:Float = 1, texture:ITexture) {
		this.ub = ub;
		this.ue = ue;
		this.vb = vb;
		this.ve = ve;
		this.texture = texture;
	}

	public function dispose() {
		texture = null;
	}
}
