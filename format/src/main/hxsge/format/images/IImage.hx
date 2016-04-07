package hxsge.format.images;

import hxsge.core.IDisposable;

interface IImage extends IDisposable {
	public var width(get, never):Int;
	public var height(get, never):Int;
}
