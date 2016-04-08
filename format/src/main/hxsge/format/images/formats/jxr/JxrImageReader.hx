package hxsge.format.images.formats.jxr;

#if flash
import hxsge.format.images.platforms.flash.FlashImageReader;

typedef JxrImageReader = FlashImageReader;
#else
typedef JxrImageReader = DummyImageReader;
#end