package hxsge.dataprovider.data;

interface IDataProviderInfo {
	public var url(default, null):String;
	public var data(default, set):Dynamic;
	public var meta(default, null):String;

	public var isNeedToLoad(get, never):Bool;
}
