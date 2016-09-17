package hxsge.io.object;

interface IObjectInput {
	function readField<T>(path:String):T;
	function readFields(path:String):Array<String>;
}
