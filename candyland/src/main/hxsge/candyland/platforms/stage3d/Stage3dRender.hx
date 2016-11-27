package hxsge.candyland.platforms.stage3d;

#if flash
import hxsge.candyland.common.geometry.VertexElement;
import flash.geom.Matrix3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.VertexBuffer3D;
import flash.display3D.IndexBuffer3D;
import hxsge.math.Matrix4;
import hxsge.candyland.common.material.BlendFactor;
import hxsge.candyland.common.TextureFormat;
import hxsge.candyland.common.material.IShader;
import hxsge.candyland.common.material.ITexture;
import hxsge.candyland.common.geometry.VertexStructure;
import hxsge.candyland.common.geometry.IGeometry;
import flash.display3D.Context3DClearMask;
import hxsge.candyland.common.AntialiasType;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DTriangleFace;
import flash.Vector;
import flash.events.TimerEvent;
import flash.utils.Timer;
import hxsge.memory.Memory;
import hxsge.photon.Signal;
import hxsge.core.debug.Debug;
import flash.errors.Error;
import flash.events.Event;
import flash.events.ErrorEvent;
import flash.Lib;
import flash.display3D.Context3D;
import flash.display.Stage3D;
import hxsge.candyland.common.IRender;

@:allow(hxsge.candyland.platforms.stage3d.Stage3dGeometry)
@:allow(hxsge.candyland.platforms.stage3d.Stage3dShader)
@:allow(hxsge.candyland.platforms.stage3d.Stage3dTexture)
class Stage3dRender implements IRender {
	static var MATRIX:Matrix3D = new Matrix3D();

	public var info(get, never):String;
	public var isLost(get, never):Bool;
	public var antialias(default, set):AntialiasType = AntialiasType.NONE;

	public var initialized(default, null):Signal1<Bool>;
	public var restored(default, null):Signal0;

	var _stage3D:Stage3D = null;
	var _context3D:Context3D = null;
	var _contextTypes:Array<String> = ["baselineExtended", "baseline", "baselineConstrained"];
	var _currentContextType:Int = 0;
	var _mask:UInt = Context3DClearMask.ALL;

	var _currentShader:IShader;

	var _width:Int;
	var _height:Int;

	var _timer:Timer;

	public function new() {
		initialized = new Signal1();
		restored = new Signal0();
	}

	public function dispose() {
		Memory.dispose(restored);
		Memory.dispose(initialized);

		if(_context3D != null) {
			_context3D.dispose(false);
			_context3D = null;
		}
		_timer = null;
	}

	public function initialize() {
		_stage3D = Lib.current.stage.stage3Ds[0];
		_stage3D.addEventListener(ErrorEvent.ERROR, onError);
		_stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);

		try {
			if(untyped (_stage3D.requestContext3D.length) == 1) {
				_stage3D.requestContext3D(cast "auto");
			}
			else {
				_stage3D.requestContext3D(cast "auto", cast _contextTypes[_currentContextType]);
			}
		}
		catch (e:Error) {
			Debug.trace("Can't request stage3d context " + _contextTypes[_currentContextType]);

			tryToInitializeNextContextType();
		}
	}

	public function clear(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 1) {
		if(_context3D == null) {
			return;
		}

		_context3D.clear(r, g, b, a, 1, 0, _mask);
	}

	public function begin() {
		if(_context3D == null) {
			return;
		}
	}

	public function present() {
		_context3D.present();
	}

	public function drawGeometry(geometry:IGeometry) {
		var geom:Stage3dGeometry = Std.instance(geometry, Stage3dGeometry);
		var ib:IndexBuffer3D = geom.indexBuffer;
		var vb:VertexBuffer3D = geom.vertexBuffer;
		var vs = geometry.vertexStructure;
		var stride:Int = vs.stride;
		var shader:Stage3dShader = Std.instance(_currentShader, Stage3dShader);

		if(shader != null) {
			var attrs:Int = shader.vertexAttributeCount;
			for(i in 0...attrs) {
				var ve:VertexElement = vs.elements[i];
				_context3D.setVertexBufferAt(i, vb, ve.offset >>> 2, Stage3DTypes.getVertexBufferFormat(ve.data));
			}

			_context3D.drawTriangles(ib, 0, geom.numTriangles);
		}
	}

	public function resize(width:Int, height:Int) {
		if(_context3D == null) {
			return;
		}

		var stage = Lib.current.stage;

		if(width < 32) {
			width = 32;
			stage.stageWidth = 32;
		}
		if(height < 32) {
			height = 32;
			stage.stageHeight = 32;
		}

		_width = width;
		_height = height;

		configureBackBuffer();
	}

	public function createGeometry(vs:VertexStructure):IGeometry {
		return new Stage3dGeometry(this, vs);
	}

	public function createTexture(width:Int, height:Int, format:TextureFormat):ITexture {
		return new Stage3dTexture(this, width, height, format);
	}

	public function createShader():IShader {
		return new Stage3dShader(this);
	}

	public function setTexture(texture:ITexture, index:Int = 0) {
		var tex:Stage3dTexture = Std.instance(texture, Stage3dTexture);
		_context3D.setTextureAt(index, tex.impl);
	}

	public function setShader(shader:IShader) {
		var val:Stage3dShader = Std.instance(shader, Stage3dShader);
		_currentShader = val;
		_context3D.setProgram(val.impl);
	}

	public function setBlendMode(src:BlendFactor, dst:BlendFactor) {
		_context3D.setBlendFactors(Stage3DTypes.getBlendFactor(src), Stage3DTypes.getBlendFactor(dst));
	}

	public function setMatrix(view:Matrix4) {
		var arr:Array<Float> = view;
		var vec:Vector<Float> = new Vector(arr.length, true);
		for(i in 0...arr.length) {
			vec[i] = arr[i];
		}
		MATRIX.rawData = vec;
		_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, MATRIX, true);
	}

	public function setScissor(x:Float, y:Float, width:Float, height:Float) {

	}

	function configureBackBuffer() {
		try {
			var countArgs:Int = untyped (_context3D.configureBackBuffer.length);
			switch(countArgs) {
				case 3:
					_context3D.configureBackBuffer(_width, _height, transformAntialias());
				case 4:
					_context3D.configureBackBuffer(_width, _height, transformAntialias(), false);
				default:
					_context3D.configureBackBuffer(_width, _height, transformAntialias(), false, true);
			}
		}
		catch(e:Error) {
			Debug.trace("Can't resize stage3D backbuffer to: " + Std.string(_width) + "x" + Std.string(_height));
		}
	}

	inline function transformAntialias():Int {
		return switch(antialias) {
			case AntialiasType.LOW:
				0;
			case AntialiasType.MID:
				2;
			case AntialiasType.HIGH:
				4;
			default:
				16;
		}
	}

	function tryToInitializeNextContextType() {
		++_currentContextType;

		if(_contextTypes.length == _currentContextType) {
			if(_timer != null) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleted);
				_timer = null;
			}

			Debug.trace("Creation of stage3d context failed...");

			initialized.emit(false);
		}
		else {
			if(_stage3D != null && _stage3D.context3D != null) {
				_stage3D.context3D.dispose(false);
			}

			if(_timer == null) {
				_timer = new Timer(1000, 1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleted);
			}
			_timer.reset();
			_timer.start();
		}
	}

	function setup() {
		_context3D = _stage3D.context3D;

		_context3D.enableErrorChecking = true;

		_context3D.setCulling(Context3DTriangleFace.NONE);
		_context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
	}

	function onError(e:ErrorEvent) {
		Debug.trace("Can't create stage3d context " + _contextTypes[_currentContextType]);

		tryToInitializeNextContextType();
	}

	function onContextCreated(e:Event) {
		_stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		_stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextRestored);

		setup();

		Debug.trace("Stage3D created successfuly with profile: " + _contextTypes[_currentContextType]);
		Debug.trace("Stage3D driver info: " + info);

		initialized.emit(true);
	}

	function onContextRestored(e:Event) {
		Debug.trace("Stage3D restored...");
		setup();

		restored.emit();
	}

	function onTimerCompleted(e:TimerEvent) {
		_timer.stop();
		initialize();
	}

	inline function get_info():String {
		return _context3D != null ? _context3D.driverInfo : "not initialized";
	}

	inline function get_isLost():Bool {
		return _context3D != null && _context3D.driverInfo == "Disposed";
	}

	inline function set_antialias(value:AntialiasType):AntialiasType {
		if(value != antialias) {
			antialias = value;

			if(_context3D != null) {
				configureBackBuffer();
			}
		}

		return antialias;
	}
}
#end