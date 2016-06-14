package hxsge.format.tson.parts;

import hxsge.format.tson.parts.TsonData;

@:allow(hxsge.format.tson.parts.TsonDataEditTools)
class TsonData {
	public var parent(default, null):TsonData = null;

	public var type(default, null):TsonValueType;
	public var data(default, null):Dynamic;

	public var name(default, set):String;

	public function new(parent:TsonData, data:Dynamic = null, name:String = null) {
		change(data);
//		this.type = type;
//		this.data = data;

		this.name = name;
	}

	public function change(data:Dynamic) {
//		switch(Type.typeof(data)) {
//			case ValueType.TNull:
//		}
//		data.type = type;
//		data.data = data;
	}

	function set_name(value:String):String {
		if(name != value) {
			name = value;
		}

		return name;
	}
}
