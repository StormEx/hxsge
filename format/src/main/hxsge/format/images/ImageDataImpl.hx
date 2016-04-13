package hxsge.format.images;

#if js
typedef ImageDataImpl = js.html.ImageElement;
#elseif flash
typedef ImageDataImpl = flash.display.BitmapData;
#else
typedef ImageDataImpl = Dynamic;
#end
