package hxsge.core.batch;

import msignal.Signal;

interface IBatchable extends IDisposable {
	public var isSuccess(get, null):Bool;

	public var finished(default, null):Signal1<IBatchable>;

	public function handle():Void;
}
