package hxsge.format.tools.bundle;

import hxsge.core.log.TraceLogger;
import hxsge.core.log.Log;

class Main {
	public static function main() {
		Log.addLogger(new TraceLogger());
		new BundleManager();
	}
}
