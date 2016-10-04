package hxsge.candyland.common;

import haxe.io.Bytes;

interface IGeometry {
	public function uploadVertices(bytes:Bytes, bytesLength:Int = 0, bytesOffset:Int = 0):Void;
	public function uploadIndices(bytes:Bytes, bytesLength:Int = 0, bytesOffset:Int = 0):Void;
}
