package hxsge.candyland.platforms.stage3d;

import flash.display3D.Program3D;
import flash.utils.ByteArray;
import flash.display3D.Context3DProgramType;
import haxe.io.Bytes;
import hxsge.candyland.common.material.IShader;

class Stage3dShader implements IShader {
	public var impl:Program3D = null;
	public var vertexAttributeCount(default, null):Int = 0;

	var _render:Stage3dRender;

	var _fc:ByteArray;
	var _vc:ByteArray;

	public function new(render:Stage3dRender) {
		_render = render;
	}

	public function dispose() {
		_render = null;
		vertexAttributeCount = 0;
	}

	public function initialize(data:Bytes) {
		if(data == null) {
			data = Stage3dShaderExtension.createShaderData(
				"m44 op, va0, vc0\nmov v0, va1\nmov v1, va2\nmov v2, va3",
				"tex ft0, v0, fs0 <2d, linear, nomip, clamp>\nmul oc, ft0, v1"
			);
		}

		var pos:Int = 0;
		var size:Int = data.getInt32(0);
		var vc:String = data.getString(4, size);

		pos += 4 + size;

		size = data.getInt32(pos);
		var fc:String = data.getString(pos + 4, size);

		var vp:AGALMiniAssembler = new AGALMiniAssembler();
		var fp:AGALMiniAssembler = new AGALMiniAssembler();

		while(vc.indexOf("va" + vertexAttributeCount) > 0) {
			++vertexAttributeCount;
		}

		vp.assemble(Context3DProgramType.VERTEX, vc);
		fp.assemble(Context3DProgramType.FRAGMENT, fc);

		_vc = vp.agalcode;
		_fc = fp.agalcode;

		impl = _render._context3D.createProgram();
		impl.upload(_vc, _fc);
	}
}
