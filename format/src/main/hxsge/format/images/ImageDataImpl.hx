package hxsge.format.images;

#if (js || nodejs)
typedef ImageDataImpl = js.html.ImageElement;
#elseif flash
typedef ImageDataImpl = flash.display.BitmapData;
#else
typedef ImageDataImpl = RawImage;
#end
