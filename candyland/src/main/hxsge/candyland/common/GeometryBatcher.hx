package hxsge.candyland.common;

class GeometryBatcher {
	var _render:IRender;
	var _geometry:IGeometry;

	public function new(render:IRender) {
		_render = render;
		_geometry = _render.createGeometry();
	}
}
