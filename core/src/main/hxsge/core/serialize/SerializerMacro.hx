package hxsge.core.serialize;

#if macro
import haxe.macro.Expr.Binop;
import haxe.macro.Type.ClassType;
import haxe.macro.Context;
import hxsge.core.macro.TypePathMacro;
import hxsge.core.macro.Macro;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.Function;
import haxe.macro.Expr;

class SerializerMacro {
	macro public static function build():Array<Field> {
		var flds:Array<Field> = Context.getBuildFields();

		flds.push(buildSerialize());
		flds.push(buildDeserialize());

		return flds;
	}

	static function buildSerialize():Field {
		var knd:Function = {
			args: [{name:"type", type:macro :String}],
			ret: macro :Dynamic,
			expr: buildSerializeExpr()
		};
		var fld:Field = {
			name: "serialize",
			doc: null,
			access: [APublic],
			kind: FFun(knd),
			pos: Context.currentPos()
		};

		return fld;
	}

	static function buildSerializeExpr():Expr {
		return macro {
			return null;
		};
	}

	static function buildDeserialize():Field {
		var knd:Function = {
			args: [{name:"data", type:macro :Dynamic}],
			ret: macro :Void,
			expr: buildDeserializeExpr()
		};
		var fld:Field = {
			name: "deserialize",
			doc: null,
			access: [APublic],
			kind: FFun(knd),
			pos: Context.currentPos()
		};

		return fld;
	}

	static function isSerializableClass(ct:ClassType):Bool {
		for(i in ct.interfaces) {
			if(i.t.toString() == "hxsge.core.serialize.ISerializable") {
				return true;
			}
		}

		return false;
	}

	static function buildDeserializeExpr():Expr {
		var flds:Array<Field> = Context.getBuildFields();
		var exprs:Array<Expr> = [];

		exprs.push(macro var obj:Dynamic = data);
		for(f in flds) {
			if(Macro.isSimpleType(f)) {
				exprs.push(deserializeSimpleField(f));
			}
			else if(Macro.isArray(f)) {
				exprs.push(deserializeArrayField(f));
			}
			else if(Macro.isMap(f)) {
				exprs.push(deserializeMapField(f));
			}
			else if(Macro.isAbstract(f)) {
				exprs.push(deserializeSimpleField(f));
			}
			else {
			}
		}

		return {
			expr: ExprDef.EBlock(exprs),
			pos: Context.currentPos()
		}
	}

	static function deserializeField(f:Field, expr:Expr):Expr {
		var res:Expr = macro {
			try {
				if(Reflect.hasField(obj, $v{f.name})) {
					$expr;
					hxsge.core.debug.Debug.trace($v{f.name} + ": " + $i{f.name});
				}
			}
			catch(e:Dynamic) {
				hxsge.core.debug.Debug.trace("deserialize exception " + $v{f.name} + ": " + Std.string(e));
			}
		}

		return res;
	}

	static function getSerializerFieldTypeByIndex(f:Field, paramIndex:Int):SerializerMacroFieldType {
		var ct:ComplexType = null;
		var tp:TypePath = null;

		if(f != null) {
			ct = Macro.getComplexType(f);
			if(ct != null) {
				tp = TypePathMacro.fromComplexType(ct);
				if(tp != null && tp.params != null && tp.params.length > paramIndex) {
					return getSerializerFieldType(tp.params[paramIndex]);
				}
			}
		}

		return SerializerMacroFieldType.UNKNOWN;
	}

	static function getSerializerFieldType(tp:TypeParam):SerializerMacroFieldType {
		if(tp == null) {
			return SerializerMacroFieldType.UNKNOWN;
		}

		var act:ComplexType = switch(tp) {
			case TypeParam.TPType(t):
				t;
			default:
				null;
		}

		if(act != null) {
			var atp:TypePath = TypePathMacro.fromComplexType(act);
			if(TypePathMacro.isSimpleType(atp) || TypePathMacro.isAbstract(atp)) {
				return SerializerMacroFieldType.SIMPLE;
			}
			else {
				return switch(Context.getType(atp.name)) {
					case TInst(cct, _):
						isSerializableClass(cct.get()) ? SerializerMacroFieldType.SERIALIZABLE : SerializerMacroFieldType.UNKNOWN;
					default:
						SerializerMacroFieldType.UNKNOWN;
				}
			}
		}

		return SerializerMacroFieldType.UNKNOWN;
	}

	static function deserializeSimpleField(f:Field):Expr {
		return deserializeField(f, macro {
			$i{f.name} = cast Reflect.field(obj, $v{f.name});
		});
	}

	static function deserializeArrayField(f:Field):Expr {
		var tName:String = Macro.getParamNameByIndex(f, 0);
		return deserializeField(f, switch(getSerializerFieldTypeByIndex(f, 0)) {
			case SerializerMacroFieldType.SERIALIZABLE:
				macro {
					var d:Array<Dynamic> = Reflect.field(obj, $v{f.name});
					if(d != null) {
						$i{f.name} = [];
						for(v in d) {
							var val = Type.createInstance($i{tName}, []);
							Reflect.field(val, "deserialize")(v);
							$i{f.name}.push(val);
						}
					}
				}
			case SerializerMacroFieldType.SIMPLE:
				macro {
					var d:Array<Dynamic> = Reflect.field(obj, $v{f.name});
					if(d != null) {
						$i{f.name} = [];
						for(v in d) {
							$i{f.name}.push(cast v);
						}
					}
				}
			default:
				macro {
					var d:Array<Dynamic> = Reflect.field(obj, $v{f.name});
					if(d != null) {
						$i{f.name} = [];
						for(v in d) {
							$i{f.name}.push(Std.instance(v, $i{tName}));
						}
					}
				}
		});
	}

	static function deserializeMapField(f:Field):Expr {
		return deserializeField(f, switch(getSerializerFieldTypeByIndex(f, 0)) {
			case SerializerMacroFieldType.SIMPLE:
				var tName:String = Macro.getParamNameByIndex(f, 1);
				switch(getSerializerFieldTypeByIndex(f, 1)) {
					case SerializerMacroFieldType.SERIALIZABLE:
						macro {
							$i{f.name} = new Map();
							var d:Dynamic = Reflect.field(obj, $v{f.name});
							if(d != null) {
								try {
									var keys = Reflect.fields(d);
									for(k in keys) {
										var val = Type.createInstance($i{tName}, []);
										Reflect.field(val, "deserialize")(Reflect.field(d, k));
										$i{f.name}.set(cast k, val);
									}
								}
								catch(e:Dynamic) {}
							}
						}
					case SerializerMacroFieldType.SIMPLE:
						macro {
							$i{f.name} = new Map();
							var d:Dynamic = Reflect.field(obj, $v{f.name});
							if(d != null) {
								try {
									var keys = Reflect.fields(d);
									for(k in keys) {
										$i{f.name}.set(cast k, cast Reflect.field(d, k));
									}
								}
								catch(e:Dynamic) {}
							}
						}
					default:
						macro {
							$i{f.name} = new Map();
							var d:Dynamic = Reflect.field(obj, $v{f.name});
							if(d != null) {
								try {
									var keys = Reflect.fields(d);
									for(k in keys) {
										$i{f.name}.set(cast k, Std.instance(Reflect.field(d, k), $i{tName}));
									}
								}
								catch(e:Dynamic) {}
							}
						}
				}
			default:
				macro {
					$i{f.name} = new Map();
				}
		});
	}
}
#end