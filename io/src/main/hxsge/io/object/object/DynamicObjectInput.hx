package hxsge.io.object.object;

import haxe.io.Path;

class DynamicObjectInput implements IObjectInput {
	public var object:Dynamic;

	public function new(obj:Dynamic) {
		object = obj;
	}

	public function readField<T>(path:String):T {
		return cast _readField(path);
	}

	public function readFields(path:String):Array<String> {
		var field:Dynamic = _readField(path);

		return field == null ? [] : Reflect.fields(field);
	}

	function _readField(path:String):Dynamic {
		var levels:Array<String> = Path.normalize(path).split("/");
		var field:Dynamic;

		for(l in levels) {
			field = Reflect.field(object, l);
			if(field == null) {
				return null;
			}
		}

		return field;
	}
}
