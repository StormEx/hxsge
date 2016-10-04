package hxsge.format.sounds.platforms.js;

#if (js || nodejs)
import js.html.audio.AudioContext;

class JsSoundManager {
	static var _context:AudioContext = null;

	static var _isWebAudio:Bool = true;

	static public function getContext():AudioContext {
		if(_context == null && _isWebAudio) {
			try {
				_context = new AudioContext();
			}
			catch(e:Dynamic) {
				_isWebAudio = false;
				_context = null;
			}
		}

		return _context;
	}
}
#end
