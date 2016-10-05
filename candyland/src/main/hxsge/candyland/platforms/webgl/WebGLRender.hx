package hxsge.candyland.platforms.webgl;

#if js
import hxsge.math.Matrix4;
import hxsge.candyland.common.material.BlendFactor;
import hxsge.candyland.common.TextureFormat;
import hxsge.candyland.common.geometry.VertexStructure;
import hxsge.candyland.common.material.IShader;
import hxsge.candyland.common.material.ITexture;
import hxsge.candyland.common.geometry.IGeometry;
import hxsge.core.debug.Debug;
import hxsge.memory.Memory;
import js.html.webgl.RenderingContext;
import js.html.CanvasElement;
import js.html.Element;
import js.Browser;
import hxsge.candyland.common.AntialiasType;
import hxsge.photon.Signal;
import hxsge.candyland.common.IRender;

class WebGLRender implements IRender {
	public var info(get, never):String;
	public var isLost(get, never):Bool;
	public var antialias(default, set):AntialiasType;

	public var initialized(default, null):Signal1<Bool>;
	public var restored(default, null):Signal0;

	var _canvas:CanvasElement;
	var _context:RenderingContext;

	public function new(idElement:String = "glcanvas") {
		initialized = new Signal1();
		restored = new Signal0();

		_canvas = cast Browser.document.getElementById(idElement);
	}

	public function dispose() {
		Memory.dispose(restored);
		Memory.dispose(initialized);

		_context = null;
		_canvas = null;
	}

	public function clear(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 1) {
		if(_context != null) {
			_context.clearColor(r, g, b, a);
		}
	}

	public function initialize() {
		if(_canvas != null) {
			var options = {
				alpha: false,
				antialias: false,
				depth: false,
				premultipliedAlpha: false,
				stencil: false,
				preserveDrawingBuffer: false
			};
			_context = _canvas.getContextWebGL(options);

			if(_context != null) {
				Debug.trace("webgl context was created successfully");
			}
			else {
				Debug.trace("can't create webgl context: context is null");
			}
			initialized.emit(_context != null);
		}
		else {
			Debug.trace("can't create webgl context: canvas is null");
			initialized.emit(false);
		}
	}

	public function begin() {
	}

	public function present() {

	}

	public function drawIndexedTriangles(count:Int) {

	}

	public function resize(width:Int, height:Int) {

	}

	public function createGeometry(vs:VertexStructure):IGeometry {
		return null;
	}

	public function createTexture(width:Int, height:Int, format:TextureFormat):ITexture {
		return null;
	}

	public function createShader():IShader {
		return null;
	}

	public function setGeometry(geometry:IGeometry) {

	}

	public function setTexture(texture:ITexture, index:Int = 0) {

	}

	public function setShader(shader:IShader) {

	}

	public function setBlendMode(src:BlendFactor, dst:BlendFactor) {

	}

	public function setMatrix(view:Matrix4) {

	}

	public function setScissor(x:Float, y:Float, width:Float, height:Float) {

	}

	inline function get_info():String {
		return "";
	}

	inline function get_isLost():Bool {
		return false;
	}

	inline function set_antialias(value:AntialiasType):AntialiasType {
		return value;
	}
}
#end