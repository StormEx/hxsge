package hxsge.format.sounds.formats.mp3;

#if flash
import hxsge.format.sounds.platforms.flash.FlashSoundReader;

typedef Mp3SoundReader = FlashSoundReader;
#else
import hxsge.format.sounds.platforms.dummy.DummySoundReader;

typedef Mp3SoundReader = DummySoundReader;
#end