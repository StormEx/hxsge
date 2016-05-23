package hxsge.format.sounds.formats.ogg;

#if flash
import hxsge.format.sounds.platforms.flash.FlashSoundReader;

typedef OggSoundReader = FlashSoundReader;
#else
import hxsge.format.sounds.platforms.dummy.DummySoundReader;

typedef OggSoundReader = DummySoundReader;
#end