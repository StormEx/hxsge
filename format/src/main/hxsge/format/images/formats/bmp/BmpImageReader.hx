package hxsge.format.images.formats.bmp;

#if flash
import hxsge.format.images.platforms.flash.FlashImageReader;

typedef BmpImageReader = FlashImageReader;
#else
typedef BmpImageReader = DummyImageReader;
#end