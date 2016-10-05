package hxsge.candyland.common.geometry;

import hxsge.memory.IDisposable;
import haxe.io.Bytes;

interface IGeometry extends IDisposable {
	public var vertexStructure(default, null):VertexStructure;
	public var numTriangles(get, never):Int;

	public function uploadVertices(bytes:Bytes, bytesLength:Int = 0, bytesOffset:Int = 0):Void;
	public function uploadIndices(bytes:Bytes, bytesLength:Int = 0, bytesOffset:Int = 0):Void;
}
