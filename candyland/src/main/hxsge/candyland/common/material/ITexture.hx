package hxsge.candyland.common.material;

import hxsge.core.utils.Color32;
import hxsge.memory.IDisposable;

interface ITexture extends IDisposable {
	public var width(get, never):Int;
	public var height(get, never):Int;
	public var format(get, never):TextureFormat;

	public function fill(color:Color32):Void;
}
