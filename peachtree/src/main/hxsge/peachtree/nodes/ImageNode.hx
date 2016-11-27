package hxsge.peachtree.nodes;

import hxsge.candyland.common.material.Material;
import hxsge.candyland.common.Image;

class ImageNode extends SceneNode {
	public var image(get, set):Image;

	var _image:Image = null;
	var _material:Material = null;
	var _geometryData:Array<Float> = [];

	var x:Int = Std.int(100 * Math.random());
	var y:Int = Std.int(100 * Math.random());
	var cx:Int = Std.int(100 * Math.random());
	var cy:Int = Std.int(100 * Math.random());

	public function new() {
		super();

		_material = new Material();

		updateMaterial();
	}

	override function visit(flags:Int, renderer:Renderer) {
		super.visit(flags, renderer);

		updateGeometryData();

		renderer.setState(_material, 4);
		renderer.addQuad(_geometryData, _material);
	}

	function updateGeometryData() {
		_geometryData = [
			x, y + cy, 0, 1,
			x, y, 0, 0,
			x + cx, y, 1, 0,
			x + cx, y + cy, 1, 1
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
