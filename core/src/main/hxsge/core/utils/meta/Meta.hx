package hxsge.core.utils.meta;

import hxsge.core.debug.Debug;

class Meta<T:Dynamic> {
	public var data(default, null):T;

	public static function parse<T>(data:String, cls:Class<T>, type:MetaType = MetaType.JSON):Meta<T> {
		var meta:Meta<T> = null;

		switch(type) {
			case MetaType.JSON:
				meta = new Meta(hxsge.core.utils.Json.build(data, cls));
			case MetaType.XML:
				Debug.error("[Meta] parsing of XML meta type not implemented...");
			default:
				Debug.error("[Meta] parsing of UNKNOWN meta type not implemented...");
		}

		return meta;
	}

	public function new(data:T) {
		this.data = data;
	}
}
