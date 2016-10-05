package hxsge.peachtree;

import hxsge.candyland.common.geometry.VertexData;
import hxsge.candyland.common.geometry.VertexStructure;
import hxsge.candyland.common.IRender;
import hxsge.peachtree.nodes.Root;

class Peachtree {
	var _renderer:Renderer;
	var _root:Root;

	public function new(render:IRender) {
		var vs = new VertexStructure();
		vs.add("position", VertexData.FloatN(2));
		vs.add("texCoord", VertexData.FloatN(2));
		vs.add("colorMultiplier", VertexData.PackedColor);
		vs.add("colorOffser", VertexData.PackedColor);
		vs.compile();

		_root = new Root();
		_renderer = new Renderer(render, vs);
	}

	public function update() {
		_root.update(_renderer);
	}
}
