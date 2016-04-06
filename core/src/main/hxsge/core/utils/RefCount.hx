package hxsge.core.utils;

class RefCount {
	public var refCount(default, null):Int = 0;

	public function new() {
	}

	public function dispose() {
		clearRef();
	}

	inline function clearRef() {
		refCount = 0;
	}

	inline function incRef():Int {
		refCount++;

		return refCount;
	}

	inline function decRef():Int {
		refCount--;
		if(refCount < 0) {
			refCount = 0;
		}

		return refCount;
	}
}
