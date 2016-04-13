package hxsge.format.sounds;

#if js
typedef SoundImpl = js.html.Audio;
#elseif flash
typedef SoundImpl = flash.media.Sound;
#else
typedef SoundImpl = Dynamic;
#end
