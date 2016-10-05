package hxsge.peachtree;

import hxsge.candyland.common.geometry.VertexStructure;
import hxsge.candyland.common.geometry.GeometryBatcher;
import hxsge.candyland.common.material.Material;
import hxsge.candyland.common.IRender;

class Renderer {
	var _batcher:GeometryBatcher;

	public function new(render:IRender, vs:VertexStructure) {
		_batcher = new GeometryBatcher(render, vs);
	}

	public function addQuad(data:Array<Float>, material:Material) {
	}
}
