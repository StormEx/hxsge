package hxsge.core.log;

class BaseLogger implements ILogger {
	var _filter:Int = LogLevelType.ALL;

	public function new() {
	}

	public function setLevelFilter(filter:Int) {
		_filter = filter;
	}

	public function log(info:String, level:LogLevelType) {
		if((_filter & level) != 0) {
			handleLog(info, level);
		}
	}

	function handleLog(info:String, level:LogLevelType) {
		throw("need to override");
	}
}
