package hxsge.dataprovider.data;

interface IDataProviderInfo {
	public var id(default, null):String;
	public var url(default, null):String;
	public var data(default, set):Dynamic;
	public var meta(default, null):Dynamic;

	public var isNeedToLoad(get, never):Bool;
}
