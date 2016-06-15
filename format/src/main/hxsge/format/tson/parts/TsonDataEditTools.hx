package hxsge.format.tson.parts;

class TsonDataEditTools {
	inline static public function change(data:TsonData, type:TsonValueType, data:Dynamic) {
		data.type = type;
		data.data = data;
	}
}
