package hxsge.candyland.platforms.stage3d;

#if flash
import flash.display3D.Context3D;
import flash.display.Stage3D;
import hxsge.candyland.common.IRender;

class Stage3dRender implements IRender {
	var _stage3D:Stage3D = null;
	var _context:Context3D = null;
	var _contextTypes:Array<String> = ["baselineExtended", "baseline", "baselineConstrained"];
	var _currentContext:Int = 0;

	public function new() {
	}

	public function dispose() {

	}

	public function begin() {

	}

	public function present() {

	}
}
#end