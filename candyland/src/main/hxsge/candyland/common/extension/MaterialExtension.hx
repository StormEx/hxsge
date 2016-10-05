package hxsge.candyland.common.extension;

import hxsge.candyland.common.material.Material;

class MaterialExtension {
	inline public static function isValid(m:Material):Bool {
		return m != null && m.shader != null;
	}
}
