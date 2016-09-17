package hxsge.format.images.formats.jpg;

#if flash
import hxsge.format.images.platforms.flash.FlashImageReader;

typedef JpgImageReader = FlashImageReader;
#else
typedef JpgImageReader = DummyImageReader;
#end