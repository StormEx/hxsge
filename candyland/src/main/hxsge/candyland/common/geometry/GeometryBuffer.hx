package hxsge.candyland.common.geometry;

import flash.utils.ByteArray;
import hxsge.core.debug.Debug;
import hxsge.memory.IDisposable;
import haxe.io.Bytes;

class GeometryBuffer implements IDisposable {
	public var indices(default, null):Bytes;
	public var vertices(default, null):Bytes;

	public var indicesCount(default, null):Int = 0;
	public var indexPosition(default, null):Int = 0;
	public var verticesCount(default, null):Int = 0;
	public var vertexPosition(default, null):Int = 0;

	public function new() {
		indices = Bytes.alloc(0xFFFF);
		vertices = Bytes.alloc(0x100000);
	}

	public function dispose() {
		indices = null;
		vertices = null;
	}

	public function upload(geometry:IGeometry) {
		Debug.assert(geometry != null);

		geometry.uploadVertices(vertices, vertexPosition);
		geometry.uploadIndices(indices, indexPosition);
	}

	inline public function reset() {
		indicesCount = 0;
		indexPosition = 0;
		verticesCount = 0;
		vertexPosition = 0;
	}

	inline public function grow(verticesCount:Int, indicesCount:Int, verticesSize:Int, indicesSize:Int) {
		this.indicesCount += indicesCount;
		this.verticesCount += verticesCount;

		indexPosition += indicesSize;
		vertexPosition += verticesSize;
	}
}
