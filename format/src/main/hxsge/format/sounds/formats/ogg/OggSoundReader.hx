package hxsge.format.sounds.formats.ogg;

#if flash
import hxsge.format.sounds.platforms.flash.FlashSoundReader;

typedef OggSoundReader = FlashSoundReader;
#elseif(js || nodejs)
import hxsge.format.sounds.platforms.js.JsSoundReader;

typedef OggSoundReader = JsSoundReader;
#else
import hxsge.format.sounds.platforms.dummy.DummySoundReader;

typedef OggSoundReader = DummySoundReader;
#end