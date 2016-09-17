package hxsge.peachtree;

import hxsge.candyland.common.IRender;
import hxsge.peachtree.nodes.Root;

class Peachtree {
	var _renderer:Renderer;
	var _root:Root;

	public function new(render:IRender) {
		_root = new Root();
		_renderer = new Renderer(render);
	}

	public function update() {
		_root.update(_renderer);
	}
}
