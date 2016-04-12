package hxsge.format.sounds;

#if js
typedef SoundImpl = js.html.Audio;
#elseif flash
typedef SoundImpl = flash.media.Sound;
#end
