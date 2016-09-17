package hxsge.memory.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.ExprDef;

class DisposableMacro {
	macro public static function build():Array<Field> {
		var flds:Array<Field> = Context.getBuildFields();

		var arrExpr;
		var cls;

//		switch(Context.getLocalType()) {
//			case TInst(t, _):
//				cls = t.get().superClass != null;
//				if(cls != null) {
//					trace(cls);
//					return flds;
//				}
//			default:
//		}

		for(f in flds) {
//			if(f.name == "__disposable_counter__") {
////				trace(f.name);
//				counter = f;
//			}
			switch(f.kind) {
				case FFun(v):
					if(f.name == "new") {
						switch(v.expr.expr) {
							case EBlock(e):
								arrExpr = e;
							default:
						}
					}
				default:
			}
		}

//		if(counter == null) {
//			var ff:Field = {
//				name: "__disposable_counter__",
//				doc: null,
//				access: [haxe.macro.Expr.Access.APrivate, haxe.macro.Expr.Access.AStatic],
//				kind: FVar(macro :Array<hxsge.memory.IDisposable>),
//				pos: Context.currentPos(),
//				meta: null
//			};
////			flds.unshift(ff);
//		}
		if(arrExpr != null) {
			arrExpr.unshift(macro {
				hxsge.memory.IDisposable.DisposableStats.instances.set(this, true);
				var cnt:Int = 0;
				for(v in hxsge.memory.IDisposable.DisposableStats.instances) {
					cnt++;
				}
				trace(Type.typeof(this) + ": " + cnt);
			});
		}

		return flds;
	}
}
#end