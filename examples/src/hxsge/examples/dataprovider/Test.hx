package hxsge.examples.dataprovider;

import hxsge.core.macro.Macro;
import hxsge.loaders.data.DataLoader;
import hxsge.dataprovider.providers.base.ProviderBatch;
import hxsge.core.debug.error.Error;
import hxsge.dataprovider.providers.base.BaseDataProvider;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.core.memory.Memory;
import hxsge.dataprovider.data.DataProviderInfo;
import haxe.macro.Expr;
import hxsge.core.log.TraceLogger;
import hxsge.core.log.Log;
import hxsge.dataprovider.providers.base.BaseDataProviderProxy;
import hxsge.dataprovider.DataProviderManager;
import msignal.Signal;

using hxsge.core.utils.ArrayTools;

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
		var batch:ProviderBatch = new ProviderBatch();
		batch.add(new BaseDataProvider(null));
		batch.add(new BaseDataProvider(null));
		batch.handle();

		Log.log("error test");
		var err1:hxsge.core.debug.error.Error = hxsge.core.debug.error.Error.create("some error");
		var err2:hxsge.core.debug.error.Error = hxsge.core.debug.error.Error.create("some error");
		Log.log(err1.info);
		Log.log(err2.info);

		Log.log("test dispose");
		var arr:Array<BaseDataProvider> = [];
		arr.push(new BaseDataProvider(null));
		Log.log("is not empty: " + Std.string(arr.isNotEmpty()));
		Memory.disposeArray(arr);
		Log.log("is not empty: " + Std.string(arr.isNotEmpty()));

		Log.log("test loader");
		Macro.defines();
		var loader:DataLoader = new DataLoader("https://cvs-stage2-by.stagehosts.com/stage/cs_fb_en/assets/cid_" + Std.string(Date.now().getTime()) + "/assets/paytable_1000.zip");
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
