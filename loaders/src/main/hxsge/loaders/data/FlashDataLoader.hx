package hxsge.loaders.data;

#if flash
import hxsge.core.debug.Debug;
import hxsge.loaders.base.BaseLoader;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.IOErrorEvent;
import flash.net.URLRequestMethod;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLLoader;

class FlashDataLoader extends BaseLoader {
	var _loader:URLLoader;
	var _urlRequest:URLRequest;
	var _progress:Float = 0;

	public function new(url:String) {
		super(url);
	}

	override function performLoad() {
		if(_loader != null) {
			performComplete();
		}

		_urlRequest = new URLRequest(url);
		_urlRequest.method = URLRequestMethod.GET;

		_loader = new URLLoader();
		_loader.dataFormat = URLLoaderDataFormat.BINARY;
		_loader.addEventListener(Event.COMPLETE, onComplete);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		_loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
		_loader.load(_urlRequest);
	}

	override function calculateProgress():Float {
		return _progress;
	}

	override function cleanup() {
		if(_loader != null) {
			try {
				_loader.removeEventListener(Event.COMPLETE, onComplete);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				_loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			}
			catch(e:Dynamic) {}
		}
	}

	override function performCancel() {
		if(_loader != null) {
			try {
				_loader.close();
			}
			catch(e:Dynamic) {
				Debug.trace(e);
			}
		}
	}

	override function performDispose() {
		_urlRequest = null;
		_loader = null;
	}

	function onComplete(e:Event) {
		content = _loader.data;

		performComplete();
	}

	function onError(e:Event) {
		performFail(e.toString());
	}

	function onProgress(e:ProgressEvent) {
		_progress = e.bytesTotal > 0 ? (e.bytesLoaded / e.bytesTotal) : 0;
	}
}
#end
