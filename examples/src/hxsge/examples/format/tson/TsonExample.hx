package hxsge.examples.format.tson;

import Type.ValueType;
import hxsge.examples.format.tson.models.TsonManagerModel;
import hxsge.examples.format.tson.controllers.TsonManagerController;
import hxsge.dataprovider.providers.swf.SwfDataProviderProxy;
import hxsge.dataprovider.providers.sounds.SoundDataProviderProxy;
import hxsge.dataprovider.providers.images.ImageDataProviderProxy;
import hxsge.dataprovider.providers.sounds.SoundDataProvider;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.core.batch.Batch;
import hxsge.loaders.base.LoadersBatch;
import hxsge.dataprovider.data.DataProviderInfo;
import hxsge.dataprovider.DataProviderManager;
//import hxsge.format.tson.TsonEncoder;
import hxsge.format.tson.parts.TsonValueType;
import haxe.io.BytesOutput;
import hxsge.format.json.Json;
import haxe.io.Bytes;
import hxsge.loaders.base.ILoader;
import hxsge.loaders.data.DataLoader;
import hxsge.format.tson.Tson;
import hxsge.core.debug.Debug;
import hxsge.core.log.TraceLogger;
import hxsge.core.log.Log;
import hxsge.format.tson.parts.TsonBlock;
//import hxsge.format.tson.TsonDecoder;
//import hxsge.io.object.tson.TsonObjectInput;
import hxsge.examples.format.tson.TsonManager;


#if (js || nodejs)
import angular.Angular;
import js.JQuery;
import js.Browser;
import hxsge.loaders.data.NodeJsDataLoader;
import hxsge.loaders.data.JsDataLoader;
import js.html.Uint8Array;
#end

#if flash
import flash.events.MouseEvent;
#end


using hxsge.core.utils.ArrayTools;
using hxsge.loaders.utils.LoaderTools;
using StringTools;
//using hxsge.format.tson.TsonTools;

class TsonExample {
//	static var data:Map<String, TsonBlock>;
//	static var tson:TsonDecoder;

	public function new() {
	}

	static function tracetype(v:Dynamic) {
		switch(Type.typeof(v)) {
			case ValueType.TNull:
				Debug.trace("type: null");
			case ValueType.TInt:
				Debug.trace("type: int");
			case ValueType.TFloat:
				Debug.trace("type: float");
			case ValueType.TBool:
				Debug.trace("type: bool");
			case ValueType.TObject:
				Debug.trace("type: object");
			case ValueType.TFunction:
				Debug.trace("type: function");
			case ValueType.TClass(t):
				if(Std.is(v, Array)) {
					Debug.trace("type: class array");
				}
				if(Std.is(v, Bytes)) {
					Debug.trace("type: class bytes");
				}
				if(Std.is(v, String)) {
					Debug.trace("type: class string");
				}
				if(Std.is(v, Map)) {
					Debug.trace("type: class map");
				}
			case ValueType.TEnum(t):
				Debug.trace("type: enum " + t);
			default:
				Debug.trace("type: unknown");
		}
	}

	public static function main() {
		Log.addLogger(new TraceLogger());

		DataProviderManager.add(new ImageDataProviderProxy());
		DataProviderManager.add(new SoundDataProviderProxy());
		DataProviderManager.add(new SwfDataProviderProxy());

		tracetype(null);
		tracetype(10);
		tracetype(100.12);
		tracetype(true);
		tracetype("asdfasf");
		tracetype(Bytes.alloc(100));
		tracetype({val:"asldkfj"});
		var m:Map<String, Int> = ["asdfasdf"=>10, "asldkfj"=>5];
		tracetype(m);
		tracetype(20);

//		Log.log("==============================================================================");
//		Log.log("begin: TSON example.");
//		var json:String = '{"resources":[{"list":[{"name":"gfx/triple/triplejewels.rage","meta":""},{"name":"gfx/mystery/mystery_jewels.rage"}]},{"list":[{"name":"sfx/menu_buttons/press_spin.mp3"}]},{"list":[{"name":"sfx/reel_spins/reel_spin_1.swf","meta":{"data":[{"name":"SoundSymbol","type":"sound"}]}},{"name":"sfx/reel_spins/reel_spin_2.swf","meta":{"data":[{"name":"SoundSymbol","type":"sound"}]}},{"name":"sfx/reel_spins/reel_spin_3.swf","meta":{"data":[{"name":"SoundSymbol","type":"sound"}]}},{"name":"sfx/reel_spins/reel_spin_4.swf","meta":{"data":[{"name":"SoundSymbol","type":"sound"}]}}],"tags":["sound"]},{"list":[{"name":"sfx/reel_stops/reel_stop1.mp3"},{"name":"sfx/reel_stops/reel_stop2.mp3"},{"name":"sfx/reel_stops/reel_stop3.mp3"},{"name":"sfx/menu_buttons/max_bet.mp3"},{"name":"sfx/bang_ups/credit_bang_3_seconds_small.mp3"},{"name":"sfx/bang_ups/credit_bang_6_seconds_medium.mp3"},{"name":"sfx/bang_ups/credit_bang_10_seconds_large.mp3"},{"name":"sfx/bang_ups/credit_bang_14_seconds_top.mp3"},{"name":"sfx/menu_buttons/decrease_bet1.mp3"},{"name":"sfx/menu_buttons/decrease_bet2.mp3"},{"name":"sfx/menu_buttons/decrease_bet3.mp3"},{"name":"sfx/menu_buttons/decrease_bet4.mp3"},{"name":"sfx/menu_buttons/decrease_bet5.mp3"},{"name":"sfx/menu_buttons/decrease_bet6.mp3"},{"name":"sfx/menu_buttons/decrease_bet7.mp3"},{"name":"sfx/menu_buttons/decrease_bet8.mp3"},{"name":"sfx/menu_buttons/increase_bet1.mp3"},{"name":"sfx/menu_buttons/increase_bet2.mp3"},{"name":"sfx/menu_buttons/increase_bet3.mp3"},{"name":"sfx/menu_buttons/increase_bet4.mp3"},{"name":"sfx/menu_buttons/increase_bet5.mp3"},{"name":"sfx/menu_buttons/increase_bet6.mp3"},{"name":"sfx/menu_buttons/increase_bet7.mp3"},{"name":"sfx/menu_buttons/increase_bet8.mp3"},{"name":"sfx/bonus_triggers/bonus_trigger_1.mp3"},{"name":"sfx/bonus_triggers/bonus_trigger_2.mp3"},{"name":"sfx/bonus_triggers/bonus_trigger_3.mp3"},{"name":"sfx/bonus_triggered/bonus_triggered.mp3"}],"type":"asynchronous"},{"tags":["sound"],"list":[{"name":"sfx/reel_spins/casino_background.swf","meta":{"data":[{"name":"SoundSymbol","type":"sound"}]}}],"type":"asynchronous"}],"platforms":["flash","js"],"name":"game_1000_1011","dependencies":["preloader","common"],"version":"0.0.1","requiredAppVersion":"0.1.17","temp":{"0":{"type":"asynchronous"},"1":{"list":[{"name":"sfx/reel_stops/blabalblablablablablab.mp3"}],"type":"asynchronous"}}}';
//		Debug.trace(Tson.stringify(Tson.convert(json)));
//
//		var ld:DataLoader = new DataLoader("d:/StormEx/temp/game_1000_1011/meta.bundle");
//		ld.finished.addOnce(onBundleDataLoaded);
//		ld.load();
//
//		var sjl:DataLoader = new DataLoader("d:/StormEx/hxsge/examples/build/nodejs/sample.tson");
//		sjl.finished.addOnce(onSJSLoaded);
//		sjl.load();
//		Log.log("end: TSON example.");

//		var jqBody = new JQuery("body");
		new TsonManager();
//#if nodejs
//		new JQuery(Browser.window).ready(onReady);
//#end
	}

	static function onReady(_) {
		new TsonManager();
	}

//	static function onBundleDataLoaded(l:ILoader) {
//		if(l.isSuccess()) {
//			var d:Bytes = Std.instance(l.content, Bytes);
//			var json:Dynamic = Json.parse(d.toString());
//			var res:Array<Dynamic> = Reflect.field(json, "resources");
//			if(res != null) {
//				for(r in res) {
//					var list:Array<Dynamic> = Reflect.field(r, "list");
//					if(list != null) {
//						for(l in list) {
//							if(Reflect.hasField(l, "name") && !Reflect.hasField(l, "data")) {
//								Reflect.setField(l, "data", {});
//							}
//						}
//					}
//				}
//			}
//			var sj:Bytes = Tson.convert(Json.stringify(json));
//			var dec:TsonDecoder = new TsonDecoder(sj);
//			var arr:Array<TsonBlock> = cast dec.root.data;
//			var map:Map<String, TsonBlock> = new Map();
//			for(el in arr) {
//				if(el.name == "resources") {
//					var arrr:Array<TsonBlock> = cast el.data;
//
//					for(ell in arrr) {
//						var bb:Array<TsonBlock> = (new TsonObjectInput(ell)).readField("list");
//						if(bb != null) {
//							var inn:Array<TsonBlock> = bb;
//							for(inel in inn) {
//								var name:String = (new TsonObjectInput(inel)).readField("name");
//								var inres:Array<TsonBlock> = cast inel.data;
//								for(val in inres) {
//									if(val.name == "data") {
//										map.set(name, val);
//									}
//								}
//							}
//						}
//					}
//				}
//			}
//
//			data = map;
//			tson = dec;
//
//			fillTSON();
//		}
//	}
//
//	static function fillTSON() {
//		var batch:LoadersBatch = new LoadersBatch();
//		for(val in data.keys()) {
//			batch.add(new DataLoader("d:/StormEx/temp/game_1000_1011/" + val));
//		}
//		batch.finished.addOnce(onBatchFinished);
//		batch.handle();
//	}
//
//	static function onBatchFinished(batch:Batch<ILoader>) {
//		if(batch.isCompleted) {
//			for(i in batch.items) {
//				if(!i.errors.isError) {
//					var str:String = i.url;
//					str = str.substr("d:/StormEx/temp/game_1000_1011/".length);
//					var obj:TsonBlock = data.get(str);
//					if(obj != null) {
//						obj.change(TsonValueType.TSON_BT_BINARY_UINT32, i.content);
//					}
//				}
//			}
//		}
////		SJsonEncoder.fromBlock(sjson.header, sjson.root);
//
//#if nodejs
//		var bbb:js.node.Buffer = new js.node.Buffer(cast TsonEncoder.fromBlock(tson.root).getData());
//		js.node.Fs.writeFile("build/nodejs/sample.tson", bbb, "binary", onFileWriteFinished);
//#end
//	}
//
//	static function onSJSLoaded(l:ILoader) {
//		var d:Bytes = cast l.content;
//		var dec:TsonDecoder = new TsonDecoder(d);
//		var block:Array<TsonBlock> = (new TsonObjectInput(dec.root)).readField("resources");
//		if(block != null) {
//			var out:TsonBlock = Std.instance(block[3].data[1].data[27].data[1], TsonBlock);
//			if(out != null) {
//				var stream:Bytes = cast out.data;
//				var dp:IDataProvider = DataProviderManager.get(new DataProviderInfo("d:/StormEx/temp/game_1000_1011/" + block[3].data[1].data[27].data[0].data, stream));
//				if(dp != null) {
//					dp.finished.addOnce(onDPFinished);
//					dp.load();
//				}
//			}
//		}
//	}
//
//	static function onFileWriteFinished(e:Dynamic) {
//		Debug.trace("tson file saved successfully...");
////#if nodejs
////		var jsl:NodeJsDataLoader = new NodeJsDataLoader("build/nodejs/sample.sjson");
////		jsl.finished.addOnce(onNodeJsFileLoaded);
////		jsl.load();
////#end
//	}
//
//	static function onDPFinished(provider:IDataProvider) {
//		var sdp:SoundDataProvider = cast provider;
//
//		if(sdp != null && !sdp.errors.isError) {
//			Debug.trace("sound data provider loaded successfuly");
//			sdp.sound.create(1, 0.1).play(0);
//		}
//		else {
//			Debug.trace("can't load sound data provider");
//		}
//	}
}
