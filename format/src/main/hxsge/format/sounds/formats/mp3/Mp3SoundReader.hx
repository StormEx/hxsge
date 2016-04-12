package hxsge.format.sounds.formats.mp3;

#if flash
import hxsge.format.sounds.platforms.flash.FlashSoundReader;

typedef Mp3SoundReader = FlashSoundReader;
#else
import hxsge.format.sounds.DummySoundReader;

typedef Mp3SoundReader = DummySoundReader;
#end