package hxsge.assets.data;

class Asset implements IAsset {
	public var id(default, null):String;

	public function new(id:String) {
		this.id = id;
	}

	public function dispose() {
		id = null;
	}
}
