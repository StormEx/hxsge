package hxsge.format.images.platforms.flash;

#if flash
import hxsge.format.images.common.Image;
import hxsge.format.images.common.ImageData;
import haxe.io.Bytes;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.display.LoaderInfo;
import hxsge.core.debug.error.Error;
import flash.events.SecurityErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.Event;
import flash.display.Loader;
import flash.system.LoaderContext;
import flash.system.ImageDecodingPolicy;

class FlashImageReader extends ImageReader {
	var _flashLoader:Loader;

	public function new(data:Bytes) {
		super(data);
	}

	override public function dispose() {
		super.dispose();

		if(_flashLoader != null) {
			_flashLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
			_flashLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_flashLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_flashLoader = null;
		}
	}

	override function readData() {
		_flashLoader = new Loader();
		_flashLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
		_flashLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		_flashLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

		var lc:LoaderContext = new LoaderContext();
		lc.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
		_flashLoader.loadBytes(_data.getData(), lc);
	}

	function onImageLoaded(_) {
		var li:LoaderInfo = _flashLoader.contentLoaderInfo;
		var bitmap:Bitmap = Std.instance(li.content, Bitmap);
		var bitmapData:BitmapData = bitmap != null ? bitmap.bitmapData : null;
		if(bitmapData == null) {
			errors.addError(Error.create("Can't get bitmap data from Bitmap..."));
		}
		else {
			image = new Image(new ImageData(bitmapData));
		}


		finished.emit(this);
	}

	function onError(e:Event) {
		errors.addError(Error.create(e.toString()));

		finished.emit(this);
	}
}
#end