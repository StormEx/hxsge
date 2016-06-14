package hxsge.format.tson.parts;

import Type.ValueType;

class TsonDataEditTools {
	inline static public function change(data:TsonData, type:TsonValueType, data:Dynamic) {
		switch(Type.typeof(data)) {
			case ValueType.TNull:
		}
		data.type = type;
		data.data = data;
	}
}
