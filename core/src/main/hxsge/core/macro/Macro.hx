package hxsge.core.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.ComplexType;

class Macro {
	function new() {
	}

	macro static public function defines():Expr {
		trace(Context.getDefines());
		return macro {
			null;
		};
	}

	macro static public function fileInfo(e:Expr = null):Expr {
		var info:String = Std.string(e.pos);
		var beg:Int = info.indexOf("(") + 1;
		info = "[" + info.substr(beg, info.indexOf(" ") - beg - 1) + "]";

		return {
			expr: ExprDef.EConst(Constant.CString(info)),
			pos: Context.currentPos()
		};
	}

#if macro
	public static function isSimpleType(fld:Field):Bool {
		return TypePathMacro.isSimpleType(TypePathMacro.fromComplexType(getComplexType(fld)));
	}

	public static function isAbstract(fld:Field):Bool {
		return TypePathMacro.isAbstract(TypePathMacro.fromComplexType(getComplexType(fld)));
	}

	public static function isArray(fld:Field):Bool {
		return TypePathMacro.isArray(TypePathMacro.fromComplexType(getComplexType(fld)));
	}

	public static function isMap(fld:Field):Bool {
		return TypePathMacro.isMap(TypePathMacro.fromComplexType(getComplexType(fld)));
	}

	public static function getComplexType(fld:Field):ComplexType {
		return switch(fld.kind) {
			case FieldType.FVar(t, _):
				t;
			case FieldType.FProp(_, ps, t, _):
				ps == "never" ? null : t;
			default:
				return null;
		}
	}
#end
}
