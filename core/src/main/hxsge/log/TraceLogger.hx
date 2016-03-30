package hxsge.log;

class TraceLogger extends BaseLogger {
	override function handleLog(info:String, level:LogLevelType) {
		trace(info);
	}
}
