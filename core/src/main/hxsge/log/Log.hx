package hxsge.log;

class Log {
	static var _logs:Array<ILogger> = [];

	public function new() {
	}

	public static function addLogger(logger:ILogger) {
		_logs.push(logger);
	}

	public static function log(info:String, level:LogLevelType = LogLevelType.DEBUG) {
		for(l in _logs) {
			l.log(info, level);
		}
	}
}
