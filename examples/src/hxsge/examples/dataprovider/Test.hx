package hxsge.examples.dataprovider;

import hxsge.core.batch.IBatchable;
import hxsge.core.batch.Batch;
import hxsge.dataprovider.providers.base.BaseDataProvider;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.core.memory.Memory;
import hxsge.dataprovider.DataProviderInfo;
import haxe.macro.Expr;
import hxsge.core.log.TraceLogger;
import hxsge.core.log.Log;
import hxsge.dataprovider.providers.base.BaseDataProviderProxy;
import hxsge.dataprovider.DataProviderManager;
import msignal.Signal;

class BB implements IBatchable {
	public var isSuccess(get, null):Bool;

	public var finished(default, null):Signal1<IBatchable>;

	public function new() {
		finished = new Signal1();
	}

	public function dispose() {

	}

	public function handle() {
		Log.log("bb handle");
		finished.dispatch(this);
	}

	function get_isSuccess():Bool {
		return true;
	}
}

class Test {
	public function new() {
	}

	public static function main() {
		Log.addLogger(new TraceLogger());

		Log.log("begin: data provider example.");
		DataProviderManager.add(new BaseDataProviderProxy());
		var dp:IDataProvider = DataProviderManager.get(new DataProviderInfo("asdlfkj.base"));
		if(dp != null) {
			Memory.dispose(dp);
			Log.log("disposed");
		}
		Log.log("end: data provider example.");

//		Memory.dispose(10);

		Log.log("macro test");
		var a:Int = 0;
		var b:String = "boo";
		var c:DataProviderInfo = new DataProviderInfo("");
		myMacro("foo", a, b, c);

		Log.log("batch test");
		var batch:Batch<BB> = new Batch();
		batch.add(new BB());
		batch.add(new BB());
		batch.handle();
	}

	macro static function myMacro(e1:Expr, extra:Array<Expr>) {
		for (e in extra) {
			trace(e);
		}
		return macro {
			Log.log(${e1});
			var d:Array<Dynamic> = $a{extra};
			for (e in d) {
				Log.log(e);
			}

			call($a{extra});
		};
	}

	static function call(a:Int, b:String, c:DataProviderInfo) {
		Log.log("call");
	}

//	macro static function generateClass<T>(name:String) {
//		var c = macro class BatchableExtends extends T {
//			public function new() {
//
//			}
//		}
//	}
}
