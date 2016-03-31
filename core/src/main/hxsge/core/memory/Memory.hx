package hxsge.core.memory;

import haxe.macro.Expr;

class Memory {
	function new() {
	}

	macro public static function dispose(val:Expr) {
		return macro {
			if($val != null) {
				$val.dispose();
				$val = null;
			}
		};
	}
}
