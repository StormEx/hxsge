package hxsge.candyland.platforms.webgl;

import haxe.io.Bytes;
import hxsge.candyland.common.geometry.VertexStructure;
import hxsge.candyland.common.geometry.IGeometry;

class WebGLGeometry implements IGeometry {
	public var vertexStructure(default, null):VertexStructure;
	public var numTriangles(get, never):Int;

	public function new(vertexStructure:VertexStructure) {
		this.vertexStructure = vertexStructure;
	}

	public function dispose() {
		reallocIndexBuffer(0);
		reallocVertexBuffer(0);
	}

	public function uploadVertices(bytes:Bytes, bytesLength:Int = 0, bytesOffset:Int = 0) {
		resizeVertexBuffer(bytesLength);
	}

	public function uploadIndices(bytes:Bytes, bytesLength:Int = 0, bytesOffset:Int = 0) {
		resizeIndexBuffer(bytesLength);
	}

	function reallocVertexBuffer(size:Int) {
	}

	function resizeVertexBuffer(size:Int) {
	}

	function reallocIndexBuffer(size:Int) {
	}

	function resizeIndexBuffer(size:Int) {
	}

	inline function get_numTriangles():Int {
		return 0;
	}
}
