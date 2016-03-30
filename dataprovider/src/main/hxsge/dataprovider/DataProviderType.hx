package hxsge.dataprovider;

class DataProviderType {
	public var name(default, null):String = "UNKNOWN";
	public var id(default, null):Int = 0;

	public function new(name:String = "UNKNOWN", id:Int = 0) {
		this.name = name;
		this.id = id;
	}
}
