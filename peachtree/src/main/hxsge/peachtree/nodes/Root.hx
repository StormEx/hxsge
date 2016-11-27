package hxsge.peachtree.nodes;

import hxsge.core.debug.Debug;
import flash.Lib;

class Root extends SceneNode {
	public function new() {
		super();
	}

	public function update(renderer:Renderer) {
//		renderer.clear(1, 0, 0, 1.0);
		renderer.setViewport(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);

		renderer.clear(0, 0, 1, 1);
		renderer.begin();
		visit(0, renderer);
		renderer.end();
	}
}
