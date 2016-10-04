package hxsge.candyland.platforms.stage3d;

#if flash
import haxe.io.Bytes;
import hxsge.candyland.common.IGeometry;

class Stage3dGeometry implements IGeometry {
	var _render:Stage3dRender;

	public function new(render:Stage3dRender) {
		_render = render;
	}

	public function uploadVertices(bytes:Bytes, bytesLength:Int = 0, bytesOffset:Int = 0) {

	}

	public function uploadIndices(bytes:Bytes, bytesLength:Int = 0, bytesOffset:Int = 0) {

	}
}
#end
