package hxsge.examples.dataprovider;

import flash.events.Event;
import hxsge.peachtree.Peachtree;
import hxsge.candyland.platforms.webgl.WebGLRender;
import hxsge.candyland.common.IRender;
import hxsge.candyland.platforms.stage3d.Stage3dRender;
import haxe.Timer;
import hxsge.format.common.IReader;
import hxsge.format.common.BaseReader;
import hxsge.loaders.extensions.LoaderExtension;
import hxsge.assets.data.bundle.Bundle;
import hxsge.assets.format.bdl.provider.ZipBundleDataProviderProxy;
import hxsge.assets.format.bdl.provider.TsonBundleDataProviderProxy;
import hxsge.assets.format.bdl.provider.JsonBundleDataProviderProxy;
import hxsge.assets.sound.SoundAssetProxy;
import hxsge.assets.image.ImageAssetProxy;
import hxsge.assets.image.ImageAsset;
import hxsge.assets.data.IAsset;
import hxsge.assets.sound.SoundAsset;
import hxsge.assets.data.Asset;
import hxsge.format.sounds.SoundReader;
import haxe.io.BytesOutput;
import hxsge.loaders.common.LoadersBatch;
import hxsge.core.batch.Batch;
import hxsge.memory.Memory;
import hxsge.core.debug.Debug;
import hxsge.format.json.Json;
import hxsge.core.debug.Debug;
import hxsge.dataprovider.providers.sounds.SoundDataProvider;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.photon.SignalMacro;
import hxsge.dataprovider.providers.swf.SwfDataProviderProxy;
import hxsge.dataprovider.providers.swf.SwfDataProvider;
import hxsge.dataprovider.providers.sounds.SoundDataProviderProxy;
import hxsge.assets.AssetManager;
import hxsge.dataprovider.providers.images.ImageDataProviderProxy;
import hxsge.dataprovider.DataProviderManager;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.zip.ZipDataProviderProxy;
import hxsge.photon.Signal;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import hxsge.loaders.common.ILoader;
import hxsge.swamp.Macro;
import hxsge.loaders.binary.DataLoader;
import hxsge.dataprovider.providers.common.ProviderBatch;
import hxsge.core.debug.error.Error;
import hxsge.dataprovider.providers.common.DataProvider;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.data.DataProviderInfo;
import haxe.macro.Expr;
import hxsge.core.log.TraceLogger;
import hxsge.core.log.Log;

#if (js || nodejs)
import hxsge.loaders.binary.js.NodeJsDataLoader;
import hxsge.loaders.binary.js.JsDataLoader;
import js.html.Uint8Array;
#end

#if flash
import flash.system.System;
import flash.events.MouseEvent;
import flash.display.PixelSnapping;
import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.Lib;
import flash.display.Sprite;
#end

using hxsge.core.utils.ArrayTools;
using hxsge.loaders.extensions.LoaderExtension;
using StringTools;
using hxsge.photon.SignalTools;

class DataProviderExample {
	static var _manager:AssetManager;
	static var _bundle:Bundle;
#if flash
	static var _root:Sprite;
#end
	static var _render:IRender;
	static var _tree:Peachtree;
	static var _color:Float = 0;

	public function new() {
	}

	static function getDataProvider(info:IDataProviderInfo) {
		checkDataProvider(DataProviderManager.get(info), info);
	}

	static function checkDataProvider(dp:IDataProvider, info:IDataProviderInfo) {
		if(dp != null) {
			Memory.dispose(dp);
			Log.log("disposed: " + info.url);
		}
		else {
			Log.log("can't create data provider: " + info.url);
		}
	}

	public static function main() {
		var zip_url:String = "http://cvs-stage2-by.stagehosts.com/stage/cs_fb_en/assets/cid_" + Std.string(Date.now().getTime()) + "/assets/paytable_1000.zip";
		var zip_file:String = "d:/Downloads/bundles/preloader/preloader.zip";
		var jpg_file:String = "d:/Downloads/horseshoe_jackpot.jpg";
		var jpg_url:String = "https://cvs-stage2-by.stagehosts.com/stage/cs_fb_en/assets/cid_" + Std.string(Date.now().getTime()) + "/common/img/og/jackpot/1029_jackpot.jpg";
		var png_file:String = "d:/Downloads/logo_alt.png";
		var png_url:String = "https://cvs-stage2-by.stagehosts.com/stage/cs_fb_en/assets/cid_" + Std.string(Date.now().getTime()) + "/common/img/og/jackpot/horseshoe_jackpot.png";
		var jxr_file:String = "d:/Downloads/bundles/preloader/gfx/preloader.jxr";
		var jxr_url:String = "https://cvs-stage2-by.stagehosts.com/stage/cs_fb_en/assets/cid_" + Std.string(Date.now().getTime()) + "/assets/game/10Ten10.jxr";
		var bundle_file:String = "d:/StormEx/temp/game_1000_1011/meta.bundle";
		var zbundle_file:String = "d:/StormEx/temp/game_1000_1011/game_1000_1011.zip";
		var tbundle_file:String = "d:/StormEx/temp/game_1000_1011/meta.jbdl";
		var zbundle_url:String = "https://cvs-stage2-by.stagehosts.com/stage/cs_fb_en/assets/cid_" + Std.string(Date.now().getTime()) + "/game_1000_1011/game_1000_1011.zip";
		var tbundle_url:String = "https://cvs-stage2-by.stagehosts.com/stage/cs_fb_en/assets/cid_" + Std.string(Date.now().getTime()) + "/game_1000_1011/meta.jbdl";
		var mp3_file:String = "d:/Downloads/bundles/mega_bonus/sfx/bonanza_bonus/win_plaque.mp3";
		var mp3_url:String = "https://cvs-stage2-by.stagehosts.com/stage/cs_fb_en/assets/cid_" + Std.string(Date.now().getTime()) + "/assets/sfx/bonanza_bonus/win_plaque.mp3";
		var wav_file:String = "d:/Downloads/bonusintro.wav";
		var ogg_file:String = "d:/Downloads/bonanza_win.ogg";
		var bmp_file:String = "d:/Downloads/b.bmp";
		var gif_file:String = "d:/Downloads/SneakPeek_unlocked_new_game_AnimationV03.gif";

		Log.addLogger(new TraceLogger());

		Log.log("==============================================================================");
		Log.log("begin: data provider example.");
//		DataProviderManager.add(new ZipDataProviderProxy());
		DataProviderManager.add(new ImageDataProviderProxy());
		DataProviderManager.add(new SoundDataProviderProxy());
		DataProviderManager.add(new SwfDataProviderProxy());
		getDataProvider(new DataProviderInfo("", "111111111111111.base"));
		getDataProvider(new DataProviderInfo("", "222222222222222.zip"));
		getDataProvider(new DataProviderInfo("", png_file));
//		var dp:IDataProvider = DataProviderManager.get(new DataProviderInfo(mp3_file));

		_manager = new AssetManager();

		_manager.addAssetProxy(new SoundAssetProxy());
		_manager.addAssetProxy(new ImageAssetProxy());

//#if flash
//		var spath:String = mp3_file;
//#else
//		var spath:String = "https://cvs-stage2-by.stagehosts.com/stage/cs_fb_en/assets/cid_" + Std.string(Date.now().getTime()) + "/bonanza_win.ogg";
//#end
//		var dp:IDataProvider = DataProviderManager.get(new DataProviderInfo("", spath));
//		if(dp != null) {
//			dp.finished.addOnce(onDPFinished);
//			dp.load();
//		}
//		Log.log("end: data provider example.");
//		Log.log("==============================================================================");
//
////		Memory.dispose(10);
//
//		Log.log("macro test");
//		var a:Int = 0;
//		var b:String = "boo";
//		var c:DataProviderInfo = new DataProviderInfo("", "");
////		myMacro("foo", a, b, c);
//		Log.log("==============================================================================");
//
//		Log.log("batch test");
//		var batch:ProviderBatch = new ProviderBatch();
//		batch.add(DataProviderManager.get(new DataProviderInfo("", zip_url)));
//		batch.add(DataProviderManager.get(new DataProviderInfo("", zip_file)));
//		batch.add(DataProviderManager.get(new DataProviderInfo("", jpg_file)));
//		batch.add(DataProviderManager.get(new DataProviderInfo("", png_url)));
//		batch.add(DataProviderManager.get(new DataProviderInfo("", png_file)));
//		batch.add(DataProviderManager.get(new DataProviderInfo("", jxr_file)));
//		batch.add(DataProviderManager.get(new DataProviderInfo("", jxr_url)));
//		batch.add(DataProviderManager.get(new DataProviderInfo("", gif_file)));
//		batch.add(DataProviderManager.get(new DataProviderInfo("", bmp_file)));
//		batch.add(DataProviderManager.get(new DataProviderInfo("", zbundle_file)));
////		batch.add(DataProviderManager.get(new DataProviderInfo("", mp3_file)));
////		batch.add(DataProviderManager.get(new DataProviderInfo("", mp3_url)));
//		batch.add(DataProviderManager.get(new DataProviderInfo("", wav_file)));
//		batch.add(DataProviderManager.get(new DataProviderInfo("", ogg_file)));
//		batch.itemFinished.add(function(data:IDataProvider){Log.log((data.errors.isError ? "error" : "success") + ": " + data.info.url);});
//		batch.finished.addOnce(function(_){Log.log("batch finished.");});
//		batch.handle();
//		Log.log("==============================================================================");
//
//		Log.log("error test");
//		var err1:hxsge.core.debug.error.Error = hxsge.core.debug.error.Error.create("some error");
//		var err2:hxsge.core.debug.error.Error = hxsge.core.debug.error.Error.create("some error");
//		Log.log(err1.info);
//		Log.log(err2.info);
//		Log.log("==============================================================================");
//
//		Log.log("test dispose");
//		var arr:Array<DataProvider> = [];
//		arr.push(new DataProvider(new DataProviderInfo("", "asdf")));
//		Log.log("is not empty: " + Std.string(arr.isNotEmpty()));
//		Memory.disposeIterable(arr);
//		Log.log("is not empty: " + Std.string(arr.isNotEmpty()));
//		Log.log("==============================================================================");
//
//		Log.log("test loader");
//		hxsge.core.macro.Macro.defines();
////		var loader:DataLoader = new DataLoader("https://cvs-stage2-by.stagehosts.com/stage/cs_fb_en/assets/cid_" + Std.string(Date.now().getTime()) + "/assets/paytable_1000.zip");
//		var loader:DataLoader = new DataLoader("d:/Downloads/horseshoe_feed.jpg");
//		loader.finished.addOnce(onLoaded);
//		loader.load();
//		Log.log("==============================================================================");
//
//		Log.log("base 64");
//		var raw:String = "eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjE0NTk5NTEyMDAsImlzc3VlZF9hdCI6MTQ1OTk0NDI4Niwib2F1dGhfdG9rZW4iOiJDQUFXUVZ5bThWRU1CQU9EMjZtMzdlSmV6ZHcyZE5nQnNsWElEdllodEo2QnRqME5lV1AyWXB2RGpqSElzNG44S3dDSzNFc09FWFRKSEhaQWMzN0NOM2kwcldyNkFPNnFaQlI5NTJWWkNaQ09HOHc5aHlQR2ZybzdyS3JXRXdUWHZ5RlREMUtWakN2dkpLMVpCYUQyeUJyYm52OVpCRVBpOUdDWkFhdkloSU9wZlpBTmVKSGhzcWFycE54ZDljY0tCcWlaQ3hoUjliRlBscWNubGZ2T2E5SlFSWkEiLCJ0b2tlbl9mb3JfYnVzaW5lc3MiOiJBYndhdlpvTl85bS1JbG00IiwidXNlciI6eyJjb3VudHJ5IjoiYnkiLCJsb2NhbGUiOiJydV9SVSIsImFnZSI6eyJtaW4iOjIxfX0sInVzZXJfaWQiOiI4NDMxMzQ1MzkwOTUzMjMifQ";
//		raw = raw.replace("-", "+").replace("_", "/").trim();
//		var data:String = Base64.decode(raw).toString();
//		Log.log(data);
//		Log.log("==============================================================================");
//
//		Log.log("signal test");
//		var signal0:Signal0 = new Signal0();
//		signal0.add(toSignal0);
//		SignalMacro.safeEmit(signal0);
//		SignalMacro.safeEmit(signal0);
//		Memory.dispose(signal0);
//		SignalMacro.safeEmit(signal0);
//		var signal1:Signal1<Int> = new Signal1();
//		signal1.addOnce(function(value:Int){Log.log("executed closure: " + value);});
//		signal1.emit(10);
//		signal1.emit(10);
//		var signal2:Signal2<Float, String> = new Signal2();
//		signal2.add(toSignal2);
//		signal2.addOnce(toSignal2);
//		signal2.emit(10, "cool");
//		signal2.emit(20, "cool");
//		Memory.dispose(signal2);
//		Log.log("==============================================================================");

		DataProviderManager.add(new JsonBundleDataProviderProxy());
		DataProviderManager.add(new TsonBundleDataProviderProxy());
		DataProviderManager.add(new ZipBundleDataProviderProxy());
//#if flash
//		Log.log("assets test");
////		var manager:AssetManager = new AssetManager();
////		var bundle:Bundle = null;
//		haxe.ui.toolkit.core.Toolkit.init();
//		haxe.ui.toolkit.core.Toolkit.openFullscreen(function(root:haxe.ui.toolkit.core.Root) {
//			var button:haxe.ui.toolkit.controls.Button = new haxe.ui.toolkit.controls.Button();
//			var ubutton:haxe.ui.toolkit.controls.Button = new haxe.ui.toolkit.controls.Button();
//			ubutton.text = "unload";
//			ubutton.x = 49;
//			button.text = "load";
//			var ti:haxe.ui.toolkit.controls.TextInput = new haxe.ui.toolkit.controls.TextInput();
//			ti.text = zbundle_url;
//			ti.x = 112;
//			ti.width = 800;
//			ti.height = button.height;
//			button.addEventListener(MouseEvent.CLICK, function(e) {
//				loadBundle(ti.text);
////				bundle = manager.getBundle(ti.text);
////				bundle.finished.addOnce(function(b:Bundle){Log.log("bundle loaded: " + b.url + (b.isSuccess ? "" : " with errors..."));});
////				bundle.load();
//			});
//			ubutton.addEventListener(MouseEvent.CLICK, function(e) {
//				Memory.dispose(_bundle);
//			});
//			root.addChild(button);
//			root.addChild(ubutton);
//			root.addChild(ti);
//
//			var playbtn:haxe.ui.toolkit.controls.Button = new haxe.ui.toolkit.controls.Button();
//			playbtn.text = "show";
//			playbtn.y = 40;
//			var sti:haxe.ui.toolkit.controls.TextInput = new haxe.ui.toolkit.controls.TextInput();
//			sti.text = "";
//			sti.x = 49;
//			sti.y = 40;
//			sti.width = 863;
//			sti.height = playbtn.height;
//			playbtn.addEventListener(MouseEvent.CLICK, function(e) {
//				showAsset(sti.text);
//			});
//			root.addChild(playbtn);
//			root.addChild(sti);
//		});
//		Log.log("==============================================================================");
//
//		_root = new Sprite();
//		Lib.current.stage.addChild(_root);
//#else
		showMemory();
		loadBundle(tbundle_url, true);

#if flash
		_render = new Stage3dRender();
#elseif js
		_render = new WebGLRender("hxsge");
#end
		_render.initialized.addOnce(onRenderInitialized);
		_render.initialize();
//#end
	}

	static function onRenderInitialized(state:Bool) {
		if(state) {
#if flash
			_render.resize(Lib.current.stage.fullScreenWidth, Lib.current.stage.fullScreenHeight);
#end
			_tree = new Peachtree(_render);
#if flash
			Lib.current.addEventListener(Event.ENTER_FRAME, onFrame);
#end
		}
	}

#if flash
	static function onFrame(e:Event) {
		_color++;
		if(_color > 255) {
			_color = 0;
		}
		_render.clear(0, 0, _color);
		_render.begin();
		_render.present();

		_tree.update();
	}
#end

	static var _prevMemory:Float = 0;
	static function showMemory() {
#if flash
		var mem:Float = System.totalMemory;
		var change:Float = mem - _prevMemory;

		Log.log('memory: ${memoryToString(mem)}[${memoryToString(change)}]');
#end
	}

	static function memoryToString(value:Float):String {
		return Std.string(value / (1024 * 1024));
	}

	static function loadBundle(path:String, autoDispose:Bool = false) {
#if flash
		_bundle = _manager.getBundle(path);
		_bundle.finished.addOnce(function(b:Bundle){
			Log.log("bundle loaded: " + b.url + (b.isSuccess ? "" : " with errors..."));
			showMemory();

			if(autoDispose) {
				Memory.dispose(_bundle);
				onTimer();
			}
		});
		_bundle.load();
#end
	}

	static function onTimer() {
		showMemory();
		Timer.delay(onTimer, 2000);
	}

	static function showAsset(id:String) {
		var a:IAsset = _manager.getAsset(id, Asset);

		if(a == null) {
			Debug.trace("Can't find asset...");

			return;
		}

		if(Std.is(a, SoundAsset)) {
			var sa:SoundAsset = Std.instance(a, SoundAsset);
			sa.create(1, 1).play();
		}
		else if(Std.is(a, ImageAsset)) {
			var ia:ImageAsset = Std.instance(a, ImageAsset);
#if flash
			var bmp = new Bitmap(ia.image.data.data, PixelSnapping.AUTO, true);
			bmp.y = 80;
			while(_root.numChildren > 0) {
				_root.removeChildAt(0);
			}
			_root.addChild(bmp);
#end
		}
	}

	static function toSignal0() {
		Log.log("for signal 0");
	}

	static function toSignal2(f:Float, s:String) {
		Log.log(f + " : " + s);
	}

	static function onLoaded(l:ILoader) {
		if(l.isSuccess()) {
			var b:Bytes = l.content;
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

	static function onDPFinished(provider:IDataProvider) {
		var sdp:SoundDataProvider = cast provider;

		if(sdp != null && !sdp.errors.isError) {
			Debug.trace("sound data provider loaded successfuly");
			sdp.sound.create(1, 0.1).play(0);
		}
		else {
			Debug.trace("can't load sound data provider");
		}
	}

	static function onFileWriteFinished(e:Dynamic) {
		Debug.trace("tson file saved successfully...");
	}

//	macro static function generateClass<T>(name:String) {
//		var c = macro class BatchableExtends extends T {
//			public function new() {
//
//			}
//		}
//	}
}
