package hxsge.format.tson.data;

import hxsge.core.memory.Memory;
import hxsge.core.IDisposable;
import hxsge.format.tson.data.TsonData;

using hxsge.format.tson.data.TsonValueTypeTools;
using hxsge.format.tson.data.TsonDataTools;

@:allow(hxsge.format.tson.data.TsonDataTools)
class TsonData implements IDisposable {
	public var parent(default, null):TsonData = null;

	public var type(default, null):TsonValueType;
	public var data(default, null):Dynamic;

	public var name(default, set):String;

	public static function create(data:Dynamic, name:String = null, parent:TsonData = null):TsonData {
		return (new TsonData(parent, TsonValueType.getDefault(), null, name)).changeByData(data);
	}

	public function new(parent:TsonData = null, type:TsonValueType = TsonValueType.getDefault(), data:Dynamic = null, name:String = null) {
		change(type, data);

		this.name = name;
		this.parent = parent;
	}

	public function dispose() {
		if(type.isIterable()) {
			var arr:Array<TsonData> = cast data;
			Memory.disposeIterable(arr);
			data = null;
		}
	}

	public function clone():TsonData {
		return new TsonData(parent, data, name);
	}

	public function change(type:TsonValueType, data:Dynamic) {
		this.type = type;
		this.data = data;

		if(type.isIterable()) {
			var arr:Array<TsonData> = cast data;
			for(i in arr) {
				i.parent = this;
			}
		}
	}
	inline function set_name(value:String):String {
		if(name != value) {
			name = value;
			if(name == null) {
				name = "default";
			}
		}

		return name;
	}
}
