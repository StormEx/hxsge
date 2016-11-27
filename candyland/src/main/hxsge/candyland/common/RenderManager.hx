package hxsge.candyland.common;

import hxsge.candyland.platforms.stage3d.Stage3dShaderExtension;
import hxsge.core.utils.Color32;
import hxsge.candyland.common.material.Material;
import hxsge.candyland.common.material.ITexture;
import hxsge.candyland.common.material.IShader;
import hxsge.candyland.common.geometry.VertexStructure;
import hxsge.candyland.common.geometry.IGeometry;
import hxsge.math.Matrix4;
import hxsge.photon.Signal;
import hxsge.memory.Memory;
import hxsge.core.debug.Debug;

using hxsge.candyland.common.extension.GeometryExtension;
using hxsge.candyland.common.extension.MaterialExtension;

class RenderManager {
	public var width(default, null):Int = 0;
	public var height(default, null):Int = 0;
	public var isInitialized(default, null):Bool = false;
	public var isContextLost(get, never):Bool;
	public var driverInfo(get, never):String;

	public var trianglesPerFrame(default, null):Int;
	public var drawCallsPerFrame(default, null):Int;

	public var initialized(default, null):Signal0;

	var _render:IRender;

	var _defaultShader:IShader;
	var _blankTexture:ITexture;

	var _cbOnReady:Void->Void;

	var _currentShader:IShader;
	var _currentTexture:ITexture;
	var _currentBlendHash:Int = 0;
	var _currentMesh:IGeometry;

	var _projectionMatrix:Matrix4 = new Matrix4();
	var _modelViewMatrix:Matrix4;
	var _mvpMatrix:Matrix4 = new Matrix4();
	var _dirtyMVP:Bool = true;
	var _needToUploadMVP:Bool = true;

	public function new(device:IRender) {
		_render = device;

		initialized = new Signal0();
	}

	public function initialize() {
		Debug.assert(isInitialized == false);

		isInitialized = true;
		_blankTexture = createTexture(1, 1);
		_blankTexture.fill(Color32.WHITE);

		_defaultShader = createShader();
		_defaultShader.initialize(Stage3dShaderExtension.createShaderData(
			"m44 op, va0, vc0\nmov v0, va1\nmov v1, va2\nmov v2, va3",
			"tex ft0, v0, fs0 <2d, linear, nomip, clamp>\nmul oc, ft0, v1"
		));

//		_render.initialized.add(onDriverInitialized);
		_render.restored.add(onDriverRestored);
//		_render.initialize();

		initialized.emit();
	}

	public function dispose() {
		Memory.dispose(initialized);
		Memory.dispose(_render);

		isInitialized = false;
	}

	inline function guardInitializedState() {
		Debug.assert(_render != null && isInitialized);
	}

	public function clear(r:Float, g:Float, b:Float, a:Float) {
		guardInitializedState();

		_render.clear(r, g, b, a);
	}

	public function begin() {
		guardInitializedState();

		__resetFrameStats();

		_currentShader = null;
		_currentTexture = null;
		_currentMesh = null;
		_currentBlendHash = 0;

		_render.begin();
	}

	public function getScreenBuffer():Dynamic {
		guardInitializedState();

		return null;//_render.getPresentBuffer();
	}

	public function end() {
		guardInitializedState();

		_render.present();
	}

	public function setOrtho2D(x:Int, y:Int, width:Int, height:Int) {
		guardInitializedState();

		_projectionMatrix.setOrtho2D(x, y, width, height);
		_dirtyMVP = true;
	}

	public function setMatrix(modelViewMatrix:Matrix4) {
		guardInitializedState();

		_modelViewMatrix = modelViewMatrix;
		_dirtyMVP = true;
	}

	public function resize(width:Int, height:Int) {
		guardInitializedState();
		Debug.assert(width > 0 && height > 0);

		if(this.width != width || this.height != height) {
			_render.resize(width, height);
			this.width = width;
			this.height = height;
		}
	}

	public function drawGeometry(geometry:IGeometry, material:Material) {
		guardInitializedState();
		Debug.assert(geometry.isValid() && material.isValid());

		if(geometry.isValid() && material.isValid()) {
			try {
				setMaterial(material);
				setModelViewProjection();
				_render.drawGeometry(geometry);
				__trackDrawCall(geometry.numTriangles);
			}
			catch(e:Dynamic) {
				Debug.trace("[RenderManager]: Can't draw mesh...");
			}
		}
	}

	inline public function setScissor(x:Float, y:Float, width:Float, height:Float) {
		guardInitializedState();

		_render.setScissor(x, y, width, height);
	}

//	public function hasTextureFormat(format:TextureFormat):Bool {
//		guardInitializedState();
//		return _render.hasTextureFormat(format);
//	}

	function setModelViewProjection() {
		guardInitializedState();
		if(_dirtyMVP) {
			if(_modelViewMatrix != null) {
				Matrix4.multiply(_projectionMatrix, _modelViewMatrix, _mvpMatrix);
			}
			else {
				_mvpMatrix.copyFrom(_projectionMatrix);
			}
			_dirtyMVP = false;
			_needToUploadMVP = true;
		}
		if(_needToUploadMVP) {
			_render.setMatrix(_mvpMatrix);
			_needToUploadMVP = false;
		}
	}

	function setMaterial(material:Material) {
		guardInitializedState();

		Debug.assert(material != null);
//		Debug.assert(material.shader != null);

		var shader = material.shader;
		if(shader == null) {
			shader = _defaultShader;
		}
		if(shader != _currentShader) {
			_render.setShader(shader);
			_currentShader = shader;
			_needToUploadMVP = true;
		}
		var hash = material.blend.hash;
		if(hash != _currentBlendHash) {
			_render.setBlendMode(material.blend.src, material.blend.dst);
			_currentBlendHash = hash;
		}
		var texture = material.texture;
		if(texture == null) {
			texture = _blankTexture;
		}
		if(texture != _currentTexture) {
			_render.setTexture(texture);
			_currentTexture = texture;
		}
	}

	inline public function createGeometry(vertexStructure:VertexStructure):IGeometry {
		return _render.createGeometry(vertexStructure);
	}

	inline public function createTexture(width:Int, height:Int, format:TextureFormat = TextureFormat.BGRA_8888):ITexture {
		return _render.createTexture(width, height, format);
	}

	inline public function createShader():IShader {
		return _render.createShader();
	}

	function onDriverInitialized(flag:Bool) {
		if(flag) {
			isInitialized = true;
			_blankTexture = createTexture(1, 1);
			_blankTexture.fill(Color32.WHITE);

			initialized.emit();
		}
		else {
			isInitialized = false;
		}
	}

	function onDriverRestored() {
		Debug.trace("RenderManager restored");
	}

	inline function get_isContextLost():Bool {
		return _render.isLost;
	}

	inline function get_driverInfo():String {
		guardInitializedState();

		return _render.info;
	}

	function __resetFrameStats() {
		trianglesPerFrame = 0;
		drawCallsPerFrame = 0;
	}

	function __trackDrawCall(triangles:Int) {
		trianglesPerFrame += triangles;
		++drawCallsPerFrame;
	}
}
