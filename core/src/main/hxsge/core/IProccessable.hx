package hxsge.core;

import msignal.Signal;

interface IProccessable {
	public var finished(default, null):Signal1<IProccessable>;
}
