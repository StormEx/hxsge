package hxsge.format.swf.platforms.flash;

#if flash
import hxsge.format.sounds.ISoundData;
import hxsge.format.sounds.platforms.flash.FlashSoundData;
import hxsge.format.sounds.Sound;
import hxsge.format.images.Image;
import hxsge.format.sounds.SoundData;
import hxsge.format.images.ImageData;
import flash.display.BitmapData;
import flash.display.Bitmap;
import hxsge.core.debug.Debug;
import flash.system.ApplicationDomain;
import hxsge.core.debug.error.Error;
import flash.display.LoaderInfo;
import flash.system.ImageDecodingPolicy;
import flash.system.LoaderContext;
import flash.events.SecurityErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.Event;
import flash.display.Loader;
import haxe.io.Bytes;

using hxsge.core.utils.StringTools;

class FlashSwfReader extends BaseSwfReader {
	var _flashLoader:Loader;
	var _appDomain:ApplicationDomain;

	public function new(data:Bytes) {
		super(data);
	}

	override public function dispose() {
		super.dispose();

		if(_flashLoader != null) {
			_flashLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onContentLoaded);
			_flashLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_flashLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_flashLoader = null;
		}
	}

	override function readData() {
		_flashLoader = new Loader();
		_flashLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onContentLoaded);
		_flashLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		_flashLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

		var lc:LoaderContext = new LoaderContext();
		lc.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
		_flashLoader.loadBytes(_data.getData(), lc);
	}

	function onContentLoaded(_) {
		if(_flashLoader != null && _flashLoader.contentLoaderInfo != null) {
			frameRate = _flashLoader.contentLoaderInfo.frameRate;
			_appDomain = _flashLoader.contentLoaderInfo.applicationDomain;
		}

		finished.emit(this);
	}

	function onError(e:Event) {
		errors.addError(Error.create(e.toString()));

		finished.emit(this);
	}

	function createInstance(name:String):Dynamic {
		if(_appDomain == null) {
			return null;
		}

		if(name.isEmpty()) {
			return _flashLoader.content;
		}

		if(!_appDomain.hasDefinition(name)) {
			Debug.trace('SWF File: $name not found');
		}
		var def:Class<Dynamic> = null;
		try {
			def = _appDomain.getDefinition(name);
		}
		catch(e:Dynamic) {
			return null;
		}

		try {
			var res:Dynamic = Type.createInstance(def, []);

			return res;
		}
		catch(e:Dynamic) {

		}

		return null;
	}

	override public function getImage(symbolName:String):Image {
		var bitmap:Bitmap = Std.instance(createInstance(symbolName), Bitmap);
		var bitmapData:BitmapData = bitmap != null ? bitmap.bitmapData : null;
		if(bitmapData == null) {
			errors.addError(Error.create("Can't get bitmap data from Bitmap..."));
		}
		else {
			return new hxsge.format.images.Image(new ImageData(bitmapData));
		}

		return null;
	}

	override public function getSound(symbolName:String):ISoundData {
		var snd:flash.media.Sound = Std.instance(cast createInstance(symbolName), flash.media.Sound);
		if(snd == null) {
			errors.addError(Error.create("Can't get sound data from Sound..."));
		}
		else {
			return new FlashSoundData(snd);
		}

		return null;
	}
}
#end