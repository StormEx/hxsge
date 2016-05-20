package hxsge.format.swf;

#if flash
	typedef SwfReader = FlashSwfReader;
#else
	typedef SwfReader = DummySwfReader;
#end
