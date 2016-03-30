package hxsge.dataprovider;

class DataProviderInfo {
	public var url(default, null):String;
	public var data(default, null):Dynamic;

	public function new(url:String, data:Dynamic = null) {
		this.url = url;
		this.data = data;
	}
}
