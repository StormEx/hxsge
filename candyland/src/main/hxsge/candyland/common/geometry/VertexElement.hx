package hxsge.candyland.common.geometry;

class VertexElement {
	public var name:String;
	public var data:VertexData;
	public var offset:Int;

	public function new(name:String, data:VertexData) {
		this.name = name;
		this.data = data;
	}
}
