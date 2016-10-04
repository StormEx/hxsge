package hxsge.candyland.common;

import hxsge.core.IClonable;

class Material implements IClonable<Material> {
	public var texture:ITexture;
	public var shader:IShader;

	public function new(shader:IShader = null, texture:ITexture = null) {
		this.texture = texture;
		this.shader = shader;
	}

	public function clone():Material {
		return new Material(shader, texture);
	}
}
