package hxsge.peachtree.nodes;

class Root extends SceneNode {
	public function new() {
		super();
	}

	public function update(renderer:Renderer) {
		visit(0, renderer);
	}
}
