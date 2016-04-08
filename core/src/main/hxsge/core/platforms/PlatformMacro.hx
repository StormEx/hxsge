package hxsge.core.platforms;

import haxe.macro.Expr;
import haxe.macro.Context;

class PlatformMacro {
	macro public static inline function getPlatform():Expr {
		var defs:Map<String,String> = Context.getDefines();
		var res:String = PlatformType.UNKNOWN;

		for(p in Platforms.platforms) {
			if(defs.get(p) != null) {
				res = p;
			}
		}

		return macro {
			$v{res};
		}
	}
}
