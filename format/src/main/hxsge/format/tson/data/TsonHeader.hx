package hxsge.format.tson.data;

class TsonHeader {
	public var format:String;
	public var keys:Map<Int, String>;
	public var names:Map<String, Int>;

	public var isValid(get, never):Bool;

	public function new(names:Array<String> = null) {
		format = Tson.HEADER;

		this.names = new Map();
		this.keys = new Map();
		if(names != null) {
			for(i in 0...names.length) {
				this.keys.set(i, names[i]);
				this.names.set(names[i], i);
			}
		}
	}

	inline function get_isValid():Bool {
		return format == Tson.HEADER;
	}
}
