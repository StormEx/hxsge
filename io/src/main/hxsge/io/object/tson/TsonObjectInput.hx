package hxsge.io.object.tson;

class TsonObjectInput implements IObjectInput {
//	var _root:TsonBlock;

	public function new(/*block:TsonBlock*/) {
//		_root = block;
	}

	public function readField<T>(path:String):T {
		return null/*_readField(path).getData()*/;
	}

	public function readFields(path:String):Array<String> {
		return []/*_readField(path).names()*/;
	}

//	function _readField(path:String):TsonBlock {
//		var levels:Array<String> = Path.normalize(path).split("/");
//		var field:TsonBlock = _root;
//
//		for(l in levels) {
//			field = field.blockByName(l);
//			if(field == null) {
//				return null;
//			}
//		}
//
//		return field;
//	}
}
