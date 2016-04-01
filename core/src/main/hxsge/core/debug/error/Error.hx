package hxsge.core.debug.error;

class Error implements IError {
	public var info(default, null):String;

	public function new(isError:Bool = false, info:String = null) {
		this.info = info;
	}
}
