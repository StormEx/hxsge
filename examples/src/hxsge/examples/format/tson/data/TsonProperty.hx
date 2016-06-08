package hxsge.examples.format.tson.data;

class TsonProperty {
	public var id:String;
	public var description:String;
	public var data:Dynamic;
	public var readOnly:Bool;

	public function new(id:String = "", description:String = "", data:Dynamic = null, readOnly:Bool = false) {
		this.id = id;
		this.description = description;
		this.data = data;
		this.readOnly = readOnly;
	}
}
