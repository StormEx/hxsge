package hxsge.format.sounds.formats.mp3;

#if flash
import hxsge.format.sounds.platforms.flash.FlashSoundReader;

typedef Mp3SoundReader = FlashSoundReader;
#elseif nodejs
import hxsge.format.sounds.platforms.dummy.DummySoundReader;

typedef Mp3SoundReader = DummySoundReader;
#elseif js
import hxsge.format.sounds.platforms.js.JsSoundReader;

typedef Mp3SoundReader = JsSoundReader;
#else
import hxsge.format.sounds.platforms.dummy.DummySoundReader;

typedef Mp3SoundReader = DummySoundReader;
#end