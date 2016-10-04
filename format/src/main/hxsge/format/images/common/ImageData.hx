package hxsge.format.images.common;

#if flash
import flash.utils.ByteArray;
import flash.display.BitmapData;
#elseif (js || nodejs)
import haxe.crypto.Base64;
import js.html.ImageElement;
import js.Browser;
#else
#end

import haxe.io.Bytes;

class ImageData implements IImage {
	public var bytes(get, never):Bytes;
	public var width(get, never):Int;
	public var height(get, never):Int;

	public var data(default, null):ImageDataImpl;

	var _bytes:Bytes;

	public static function fromBytes(width:Int, height:Int, bytes:Bytes, callback:ImageData->Void, ext:String = "jpeg") {
#if flash
		var img:ImageData = null;
		var bd:BitmapData = new BitmapData(width, height, true, 0xFFFF0000);
		var ba:ByteArray = bytes.getData();
		ba.position = 0;
		for(j in 0...height) {
			for(i in 0...width) {
				bd.setPixel32(i, j, ba.readUnsignedInt());
			}
		}

		img = new ImageData(bd);
		img._bytes = bytes;

		callback(img);
#elseif (js || nodejs)
		var elem = Browser.document.createImageElement();

		elem.onload = function(_) {
		var img:ImageData = new ImageData(elem);
		img._bytes = bytes;

		callback(img);
		};
		elem.onerror = function(_) {
		callback(null);
		};
		elem.src = "data:image/" + ext + ";base64," + Base64.encode(bytes);
#else
		var img:ImageData = new ImageData(new RawImage(bytes, width, height));
		image._bytes = bytes;

		callback(image);
#end
	}

	public function new(data:ImageDataImpl) {
		this.data = data;
	}

	public function dispose() {
#if flash
		data.dispose();
#elseif js
#end
		data = null;
		_bytes = null;
	}

	function get_bytes():Bytes {
		return _bytes;
	}

	function get_width():Int {
		return data.width;
	}

	function get_height():Int {
		return data.height;
	}
}