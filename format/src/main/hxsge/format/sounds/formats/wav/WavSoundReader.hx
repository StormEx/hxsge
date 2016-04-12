package hxsge.format.sounds.formats.wav;

#if flash
import hxsge.format.sounds.platforms.flash.FlashSoundReader;

typedef WavSoundReader = FlashSoundReader;
#else
import hxsge.format.sounds.DummySoundReader;

typedef WavSoundReader = DummySoundReader;
#end