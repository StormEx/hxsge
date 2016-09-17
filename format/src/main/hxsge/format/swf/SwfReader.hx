package hxsge.format.swf;

#if flash
import hxsge.format.swf.platforms.flash.FlashSwfReader;

typedef SwfReader = FlashSwfReader;
#else
typedef SwfReader = DummySwfReader;
#end
