package hxsge.candyland.common.material;

import haxe.io.Bytes;
import hxsge.memory.IDisposable;

interface IShader extends IDisposable {
	public function initialize(data:Bytes):Void;
}
