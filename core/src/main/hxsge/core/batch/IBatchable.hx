package hxsge.core.batch;

import msignal.Signal;

interface IBatchable extends IProccessable extends IDisposable {
	public var isSuccess(get, null):Bool;

	public function handle():Void;
}
