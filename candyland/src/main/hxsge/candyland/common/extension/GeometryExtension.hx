package hxsge.candyland.common.extension;

import hxsge.candyland.common.geometry.IGeometry;

class GeometryExtension {
	inline public static function isValid(g:IGeometry):Bool {
		return g != null;
	}
}
