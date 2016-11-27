package hxsge.candyland.platforms.stage3d;

import haxe.io.BytesOutput;
import haxe.io.Bytes;

class Stage3dShaderExtension {
	static public function createShaderData(vertexCode:String, fragmentCode:String):Bytes {
		var bo:BytesOutput = new BytesOutput();
		bo.writeInt32(vertexCode.length);
		bo.writeString(vertexCode);
		bo.writeInt32(fragmentCode.length);
		bo.writeString(fragmentCode);

		return bo.getBytes();
	}
}
