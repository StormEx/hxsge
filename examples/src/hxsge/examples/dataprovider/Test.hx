package hxsge.examples.dataprovider;

import hxsge.core.signal.SignalMacro;
import hxsge.core.signal.Signal2;
import hxsge.core.signal.Signal1;
import hxsge.core.signal.Signal0;
import haxe.crypto.Base64;
import hxsge.loaders.base.LoaderStateType;
import hxsge.loaders.data.NodeJsDataLoader;
import haxe.io.BytesData;
import haxe.io.Bytes;
import haxe.io.Bytes;
import hxsge.loaders.base.ILoader;
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

using hxsge.core.utils.ArrayTools;
using hxsge.loaders.utils.LoaderTools;
using StringTools;

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
//		myMacro("foo", a, b, c);

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
//		var loader:DataLoader = new DataLoader("https://cvs-stage2-by.stagehosts.com/stage/cs_fb_en/assets/cid_" + Std.string(Date.now().getTime()) + "/assets/paytable_1000.zip");
		var loader:DataLoader = new DataLoader("c:/Downloads/horseshoe_feed.jpg");
		loader.finished.addOnce(onLoaded);
		loader.load();

		Log.log("base 64");
		var raw:String = "eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjE0NTk5NTEyMDAsImlzc3VlZF9hdCI6MTQ1OTk0NDI4Niwib2F1dGhfdG9rZW4iOiJDQUFXUVZ5bThWRU1CQU9EMjZtMzdlSmV6ZHcyZE5nQnNsWElEdllodEo2QnRqME5lV1AyWXB2RGpqSElzNG44S3dDSzNFc09FWFRKSEhaQWMzN0NOM2kwcldyNkFPNnFaQlI5NTJWWkNaQ09HOHc5aHlQR2ZybzdyS3JXRXdUWHZ5RlREMUtWakN2dkpLMVpCYUQyeUJyYm52OVpCRVBpOUdDWkFhdkloSU9wZlpBTmVKSGhzcWFycE54ZDljY0tCcWlaQ3hoUjliRlBscWNubGZ2T2E5SlFSWkEiLCJ0b2tlbl9mb3JfYnVzaW5lc3MiOiJBYndhdlpvTl85bS1JbG00IiwidXNlciI6eyJjb3VudHJ5IjoiYnkiLCJsb2NhbGUiOiJydV9SVSIsImFnZSI6eyJtaW4iOjIxfX0sInVzZXJfaWQiOiI4NDMxMzQ1MzkwOTUzMjMifQ";
		raw = raw.replace("-", "+").replace("_", "/").trim();
		var data:String = Base64.decode(raw).toString();
		Log.log(data);

		Log.log("signal test");
		var signal0:Signal0 = new Signal0();
		signal0.add(toSignal0);
		SignalMacro.smartEmit(signal0);
		SignalMacro.smartEmit(signal0);
		Memory.dispose(signal0);
		SignalMacro.smartEmit(signal0);
		var signal1:Signal1<Int> = new Signal1();
		signal1.addOnce(function(value:Int){Log.log("executed closure: " + value);});
		signal1.emit(10);
		signal1.emit(10);
		var signal2:Signal2<Float, String> = new Signal2();
		signal2.add(toSignal2);
		signal2.addOnce(toSignal2);
		signal2.emit(10, "cool");
		signal2.emit(20, "cool");
		Memory.dispose(signal2);
	}

	static function toSignal0() {
		Log.log("for signal 0");
	}

	static function toSignal2(f:Float, s:String) {
		Log.log(f + " : " + s);
	}

	static function onLoaded(l:ILoader) {
		if(l.isSuccess()) {
			var b:Bytes = Bytes.ofData(l.content);
			if(b != null) {
				Log.log("Info loaded successfuly: " + b.length);
			}
		}
		else {
			Log.log("Can't load data: " + l.errors.toString());
		}
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
