package hxsge.peachtree.nodes;

import hxsge.candyland.common.material.Material;
import hxsge.candyland.common.Image;

class ImageNode extends SceneNode {
	public var image(get, set):Image;

	var _image:Image = null;
	var _material:Material = null;
	var _geometryData:Array<Float> = [];

	public function new() {
		super();

		_material = new Material();

		updateMaterial();
	}

	override function visit(flags:Int, renderer:Renderer) {
		super.visit(flags, renderer);

		updateGeometryData();

		renderer.addQuad(_geometryData, _material);
	}

	function updateGeometryData() {
		_geometryData = [
			10, 310, 0, 1, 1, 1, 1, 1,
			10, 10, 0, 0, 1, 1, 1, 1,
			310, 10, 1, 0, 1, 1, 1, 1,
			310, 310, 1, 1, 1, 1, 1, 1
		];
	}

	function updateMaterial() {
	}

	inline function get_image():Image {
		return _image;
	}

	inline function set_image(value:Image):Image {
		if(_image != value) {
			_image = value;

			_material.texture = _image.texture;
		}

		return _image;
	}
}
