package hxsge.peachtree;

import hxsge.candyland.common.RenderManager;
import hxsge.candyland.common.geometry.VertexData;
import hxsge.candyland.common.geometry.VertexStructure;
import hxsge.candyland.common.IRender;
import hxsge.peachtree.nodes.Root;

class Peachtree {
	public var root(default, null):Root;

	var _renderer:Renderer;
	var _manager:RenderManager;
	var _vs:VertexStructure;

	public function new(render:IRender) {
		_vs = new VertexStructure();
		_vs.add("position", VertexData.FloatN(2));
		_vs.add("texCoord", VertexData.FloatN(2));
		_vs.add("colorMultiplier", VertexData.PackedColor);
		_vs.add("colorOffser", VertexData.PackedColor);
		_vs.compile();

		root = new Root();
		_manager = new RenderManager(render);
		_manager.initialized.addOnce(onRenderManagerInitialized);
		_manager.initialize();
	}

	public function update() {
		if(_renderer != null) {
			root.update(_renderer);
		}
	}

	function onRenderManagerInitialized() {
		_renderer = new Renderer(_manager, _vs);
	}
}
