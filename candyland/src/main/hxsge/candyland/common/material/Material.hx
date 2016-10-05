package hxsge.candyland.common.material;

import hxsge.core.IClonable;

class Material implements IClonable<Material> {
	public var texture:ITexture;
	public var shader:IShader;
	public var blend:BlendMode;

	public function new(shader:IShader = null, texture:ITexture = null) {
		this.texture = texture;
		this.shader = shader;

		blend = BlendMode.createAlpha();
	}

	public function clone():Material {
		var mat:Material = new Material(shader, texture);
		mat.blend = blend;

		return mat;
	}
}
