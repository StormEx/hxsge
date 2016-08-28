package hxsge.candyland.common;

import hxsge.core.IDisposable;

interface IRender extends IDisposable {
	public function begin():Void;
	public function present():Void;
}
