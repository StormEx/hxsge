package hxsge.peachtree;

import hxsge.core.utils.Color32;
import hxsge.candyland.common.RenderManager;
import haxe.io.Bytes;
import hxsge.candyland.common.geometry.VertexStructure;
import hxsge.candyland.common.geometry.GeometryBatcher;
import hxsge.candyland.common.material.Material;

class Renderer extends GeometryBatcher {
	public function new(render:RenderManager, vs:VertexStructure) {
		super(render, vs);
	}

	inline public function clear(r:Float, g:Float, b:Float, a:Float) {
		_render.clear(r, g, b, a);
	}

	public function setViewport(x:Int, y:Int, width:Int, height:Int) {
		_render.setOrtho2D(x, y, width, height);
	}

	public function addQuad(data:Array<Float>, material:Material) {
		var pos:Int = _buffer.vertexPosition;
		var vertices:Bytes = _buffer.vertices;

		vertices.setFloat(pos + 0,  data[0]);
		vertices.setFloat(pos + 4,  data[1]);
		vertices.setFloat(pos + 8,  data[2]);
		vertices.setFloat(pos + 12, data[3]);
		vertices.setInt32(pos + 16, 0xFFFFFFFF);
		vertices.setInt32(pos + 20, 0xFFFFFFFF);

		vertices.setFloat(pos + 24, data[4]);
		vertices.setFloat(pos + 28, data[5]);
		vertices.setFloat(pos + 32, data[6]);
		vertices.setFloat(pos + 36, data[7]);
		vertices.setInt32(pos + 40, 0xFFFFFFFF);
		vertices.setInt32(pos + 44, 0xFFFFFFFF);

		vertices.setFloat(pos + 48, data[ 8]);
		vertices.setFloat(pos + 52, data[ 9]);
		vertices.setFloat(pos + 56, data[10]);
		vertices.setFloat(pos + 60, data[11]);
		vertices.setInt32(pos + 64, 0xFFFFFFFF);
		vertices.setInt32(pos + 68, 0xFFFFFFFF);

		vertices.setFloat(pos + 72, data[12]);
		vertices.setFloat(pos + 76, data[13]);
		vertices.setFloat(pos + 80, data[14]);
		vertices.setFloat(pos + 84, data[15]);
		vertices.setInt32(pos + 88, 0xFFFFFFFF);
		vertices.setInt32(pos + 92, 0xFFFFFFFF);

		pos = _buffer.indexPosition;
		var indices:Bytes = _buffer.indices;
		indices.setUInt16(pos     , 0);
		indices.setUInt16(pos + 2 , 1);
		indices.setUInt16(pos + 4 , 2);
		indices.setUInt16(pos + 6 , 2);
		indices.setUInt16(pos + 8 , 3);
		indices.setUInt16(pos + 10, 0);

		_buffer.grow(4, 6, 96, 12);
	}
}
