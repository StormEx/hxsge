package hxsge.core.utils;

class Pair<Q, T> {
	public var key:Q;
	public var value:T;

	public function new(?key:Q, ?value:T) {
		this.key = key;
		this.value = value;
	}
}
