package hxsge.candyland.common.geometry;

import hxsge.math.Matrix4;
import hxsge.core.debug.Debug;
import hxsge.candyland.common.material.Material;
import hxsge.memory.Memory;
import hxsge.memory.IDisposable;
import hxsge.candyland.common.geometry.IGeometry;

class GeometryBatcher implements IDisposable {
	public var isStarted(default, null):Bool = false;
	public var isInitialized(get, never):Bool;

	var _render(default, null):RenderManager;
	var _buffer(default, null):GeometryBuffer;
	var _vertexStructure(default, null):VertexStructure;

	var _geometries:Array<IGeometry> = new Array<IGeometry>();

	var _maxIndex:Int = 0xFFFF - 1;
	var _currentMeshIndex:Int;
	var _currentMesh:IGeometry;
	var _currentMaterial:Material;
	var _currentVertexCount:Int;

	var _modelViewMatrix:Matrix4;

	public function new(render:RenderManager, vs:VertexStructure) {
		Debug.assert(vs != null && vs.stride > 0, 'Invalid vertex declaration!');
		Debug.assert(render != null);

		_render = render;

		_buffer = new GeometryBuffer();
		_vertexStructure = vs;

		_geometries.push(allocMesh());
	}

	public function dispose():Void {
		if(isStarted) {
			end();
		}
		Memory.dispose(_buffer);
		for(mesh in _geometries) {
			mesh.dispose();
		}
		_geometries = null;
		_vertexStructure = null;
		_render = null;
	}

	public function begin():Void {
		Debug.assert(isStarted == false);

		isStarted = true;

		_currentMeshIndex = 0;
		_currentMesh = _geometries[0];
		_currentMaterial = null;
		_currentVertexCount = 0;

		_buffer.reset();
	}

	public function end():Void {
		Debug.assert(isStarted == true);

		renderBatch(false);
		_buffer.reset();
		isStarted = false;

		_render.end();
	}

	public function changeViewModelMatrix(matrix:Matrix4):Void {
		breakBatching();
		// COPY OR DISTURBANCE? (outside modifications)
		_modelViewMatrix = matrix;
	}

	@:extern public inline function setState(material:Material, vertexCount:Int):Void {
		Debug.assert(isStarted == true);
		Debug.assert(material != null && vertexCount > 0);

		if(checkBatchStateChanged(material, vertexCount)) {
			changeMaterial(material);
		}
		_currentVertexCount += vertexCount;
	}

	function renderBatch(nextMeshRequired:Bool):Void {
		if(_currentVertexCount > 0) {
			renderCurrentBatch();
			if(nextMeshRequired) {
				if(++_currentMeshIndex == _geometries.length) {
					_geometries.push(allocMesh());
				}
				_currentMesh = _geometries[_currentMeshIndex];
				_buffer.reset();
			}
		}
	}

	@:extern inline public function breakBatching() {
		if(isStarted) {
			changeMaterial(_currentMaterial);
		}
	}

	@:extern inline function changeMaterial(nextMaterial:Material):Void {
		if(_currentMaterial != null) {
			renderBatch(true);
		}
		_currentMaterial = nextMaterial;
		_currentVertexCount = 0;
	}

	@:extern inline function allocMesh():IGeometry{
		return _render.createGeometry(_vertexStructure);
	}

	@:extern inline function checkBatchStateChanged(material:Material, vertexCount:Int):Bool {
		return _currentMaterial != material || _currentVertexCount + vertexCount > _maxIndex;
	}

	function renderCurrentBatch():Void {
		_buffer.upload(_currentMesh);
		_buffer.reset();

		_render.setMatrix(_modelViewMatrix);
		_render.drawGeometry(_currentMesh, _currentMaterial);

//		_render.end();
	}

	inline function get_isInitialized():Bool {
		return _render.isInitialized;
	}
}
