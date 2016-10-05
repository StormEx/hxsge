package hxsge.candyland.platforms.stage3d;

#if flash
import hxsge.candyland.common.geometry.VertexStructure;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import haxe.io.Bytes;
import hxsge.candyland.common.geometry.IGeometry;

class Stage3dGeometry implements IGeometry {
	public var vertexStructure(default, null):VertexStructure;
	public var numTriangles(get, never):Int;

	public var vertexBuffer(default, null):VertexBuffer3D;
	public var vertexBytesAllocated(default, null):Int;
	public var vertexBytesLength(default, null):Int;

	public var indexBuffer(default, null):IndexBuffer3D;
	public var indexBytesAllocated(default, null):Int;
	public var indexBytesLength(default, null):Int;

	var _render:Stage3dRender;
	var _numTriangles:Int;

	public function new(render:Stage3dRender, vertexStructure:VertexStructure) {
		this.vertexStructure = vertexStructure;

		_render = render;
	}

	public function dispose() {
		reallocIndexBuffer(0);
		reallocVertexBuffer(0);
	}

	public function uploadVertices(bytes:Bytes, bytesLength:Int = 0, bytesOffset:Int = 0) {
		resizeVertexBuffer(bytesLength);
		vertexBuffer.uploadFromByteArray(bytes.getData(), bytesOffset, 0, Std.int(vertexBytesLength / vertexStructure.stride));
	}

	public function uploadIndices(bytes:Bytes, bytesLength:Int = 0, bytesOffset:Int = 0) {
		resizeIndexBuffer(bytesLength);
		_numTriangles = Std.int((bytesOffset + bytes.length) / 12);
		indexBuffer.uploadFromByteArray(bytes.getData(), bytesOffset, 0, indexBytesLength >>> 1);
	}

	function reallocVertexBuffer(size:Int) {
		if(vertexBuffer != null) {
			vertexBuffer.dispose();
			vertexBuffer = null;
			vertexBytesAllocated = 0;
			vertexBytesLength = 0;
		}
		if(size > 0) {
			var stride = vertexStructure.stride;
			var numVertices = Std.int(size / stride);
			var data32PerVertex = stride >>> 2;
			var context = _render._context3D;
			if(untyped (context.createVertexBuffer.length) == 3) {
				vertexBuffer = context.createVertexBuffer(numVertices, data32PerVertex, untyped "dynamicDraw");
			}
			else {
				vertexBuffer = context.createVertexBuffer(numVertices, data32PerVertex);
			}

			vertexBytesAllocated = size;
		}
	}

	inline function resizeVertexBuffer(size:Int) {
		if(size > vertexBytesAllocated) {
			reallocVertexBuffer(size);
		}
		vertexBytesLength = size;
	}

	function reallocIndexBuffer(size:Int) {
		if(indexBuffer != null) {
			indexBuffer.dispose();
			indexBuffer = null;
			indexBytesAllocated = 0;
			indexBytesLength = 0;
		}
		if(size > 0) {
			var numIndices = size >>> 1;
			var context = _render._context3D;

			if(untyped (context.createIndexBuffer.length) == 2) {
				indexBuffer = context.createIndexBuffer(numIndices, untyped "dynamicDraw");
			}
			else {
				indexBuffer = context.createIndexBuffer(numIndices);
			}

			indexBytesAllocated = size;
		}
	}

	inline function resizeIndexBuffer(size:Int) {
		if(size > indexBytesAllocated) {
			reallocIndexBuffer(size);
		}
		indexBytesLength = size;
	}

	inline function get_numTriangles():Int {
		return _numTriangles;
	}
}
#end
