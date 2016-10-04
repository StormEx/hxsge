package hxsge.peachtree.nodes;

import hxsge.candyland.common.Image;

class ImageNode extends SceneNode {
	public var image(get, set):Image;

	var _image:Image = null;

	public function new() {
	}

	override function visit(flags:Int, renderer:Renderer) {

		super.visit(flags, renderer);
	}

	inline function get_image():Image {
		return _image;
	}

	inline function set_image(value:Image):Image {
		if(_image != value) {
			_image = value;
		}

		return _image;
	}
}
