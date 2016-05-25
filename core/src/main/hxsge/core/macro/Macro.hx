package hxsge.core.macro;

import haxe.macro.Context;
import haxe.macro.Expr;

class Macro {
	macro static public function defines():Expr {
		trace(Context.getDefines());
		return macro {
			null;
		};
	}
}
