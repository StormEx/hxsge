package hxsge.candyland.common;

import hxsge.candyland.common.material.ITexture;
import hxsge.candyland.common.material.IShader;
import hxsge.candyland.common.material.BlendFactor;
import hxsge.candyland.common.geometry.VertexStructure;
import hxsge.candyland.common.geometry.IGeometry;
import hxsge.math.Matrix4;
import hxsge.memory.IDisposable;
import hxsge.photon.Signal;

interface IRender extends IDisposable {
	public var info(get, never):String;
	public var isLost(get, never):Bool;
	public var antialias(default, set):AntialiasType;

	public var initialized(default, null):Signal1<Bool>;
	public var restored(default, null):Signal0;

	public function clear(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 1):Void;
	public function initialize():Void;
	public function begin():Void;
	public function present():Void;
	public function drawIndexedTriangles(count:Int):Void;
	public function resize(width:Int, height:Int):Void;

	public function createGeometry(vs:VertexStructure):IGeometry;
	public function createTexture(width:Int, height:Int, format:TextureFormat):ITexture;
	public function createShader():IShader;

	public function setGeometry(geometry:IGeometry):Void;
	public function setTexture(texture:ITexture, index:Int = 0):Void;
	public function setShader(shader:IShader):Void;
	public function setBlendMode(src:BlendFactor, dst:BlendFactor):Void;
	public function setMatrix(view:Matrix4):Void;
	public function setScissor(x:Float, y:Float, width:Float, height:Float):Void;
}
