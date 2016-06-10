package hxsge.swamp;

#if macro
import haxe.macro.Context;
import Type.ValueType;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.TypePath;

class TypePathMacro {
	public static function isSimpleType(tp:TypePath):Bool {
		if(tp == null) {
			return false;
		}

		return switch(tp.name) {
			case "Int"
			| "String"
			| "Bool"
			| "Float"
			| "Dynamic":
				true;
			default:
				switch(Type.typeof(tp.name)) {
					case ValueType.TEnum(_)
					| ValueType.TInt
					| ValueType.TBool
					| ValueType.TFloat:
						true;
					default:
						false;
				}
		}
	}

	public static function isAbstract(tp:TypePath):Bool {
		if(tp == null) {
			return false;
		}

		return switch(Type.typeof(tp.name)) {
			case ValueType.TClass(c):
				switch(Context.getType(tp.name)) {
#if (haxe_ver >= 3.3)
					case haxe.macro.Type.TAbstract(_, _):
#else
					case haxe.macro.Type.TAbstract:
#end
						true;
					default:
						false;
				}
			default:
				false;
		}
	}

	public static function isArray(tp:TypePath):Bool {
		if(tp == null) {
			return false;
		}

		return tp.name == "Array";
	}

	public static function isMap(tp:TypePath):Bool {
		if(tp == null) {
			return false;
		}

		return tp.name == "Map";
	}

	public static function fromComplexType(ct:ComplexType):TypePath {
		if(ct == null) {
			return null;
		}

		return switch(ct) {
			case ComplexType.TPath(tp):
				tp;
			default:
				null;
		}
	}

	public static function isTypePath(ct:ComplexType):Bool {
		if(ct == null) {
			return false;
		}

		return switch(ct) {
			case ComplexType.TPath(_):
				true;
			default:
				false;
		}
	}
}
#end