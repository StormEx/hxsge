package hxsge.core.signal;

import haxe.macro.Expr;

class SignalMacro {
	macro public static function safeEmit(signal:Expr, e:Array<Expr>):Expr {
		return macro {
			if($signal != null) {
				$signal.emit($a{e});
			}
		}
	}

	macro static public function emitBuild(e:Array<Expr>):Expr {
		return macro {
			for(f in _functions) {
				f($a{e});
			}
			var i:Int = 0;
			while(i < _flags.length) {
				if(_flags[i] == SignalFlagType.ONCE) {
					removeSlot(i);
				}
				else {
					++i;
				}
			}
		}
	}
}
