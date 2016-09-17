package hxsge.peachtree.nodes;

import hxsge.math.Matrix2;

class SceneNode {
	public var name:String = null;

	public var visible(get, set):Bool;
	public var enable(get, set):Bool;
	public var touchable(get, set):Bool;

	public var matrix(get, set):Matrix2;

	public var width(get, set):Float;
	public var height(get, set):Float;

	var _stage:Root;
	var _parent:SceneNode;
	var _matrix:Matrix2;
	var _worldMatrix:Matrix2;
	var _visible:Bool = true;
	var _enable:Bool = true;
	var _touchable:Bool = false;

	var _children:Array<SceneNode> = [];

	public function new() {
	}

	function visit(flags:Int, renderer:Renderer) {
		for(c in _children) {
			if(c.enable) {
				c.visit(flags, renderer);
			}
		}
	}

	inline function get_visible():Bool {
		return _visible;
	}

	inline function set_visible(value:Bool):Bool {
		return _visible = value;
	}

	inline function get_enable():Bool {
		return _enable;
	}

	inline function set_enable(value:Bool):Bool {
		return _enable = value;
	}

	inline function get_touchable():Bool {
		return _touchable;
	}

	inline function set_touchable(value:Bool):Bool {
		return _touchable = value;
	}

	inline function get_matrix():Matrix2 {
		return _matrix;
	}

	inline function set_matrix(value:Matrix2):Matrix2 {
		return _matrix = value.clone();
	}

	inline function get_width():Float {
		return 0;
	}

	inline function set_width(value:Float):Float {
		return 0;
	}

	inline function get_height():Float {
		return 0;
	}

	inline function set_height(value:Float):Float {
		return 0;
	}
}
