package hxsge.peachtree;

import hxsge.candyland.common.GeometryBatcher;
import hxsge.candyland.common.Material;
import hxsge.candyland.common.IRender;

class Renderer {
	var _batcher:GeometryBatcher;

	public function new(render:IRender) {
		_batcher = new GeometryBatcher(render);
	}

	public function addQuad(data:Array<Float>, material:Material) {
	}
}
