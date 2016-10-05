package hxsge.candyland.common.geometry;

import hxsge.candyland.common.geometry.IGeometry;
class GeometryBatcher {
	public var isStarted(default, null):Bool = false;

	var _render:IRender;
	var _geometry:IGeometry;

	public function new(render:IRender, vs:VertexStructure) {
		_render = render;
		_geometry = _render.createGeometry(vs);
	}
}
