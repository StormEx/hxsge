package hxsge.core.serialize;

#if macro
import haxe.macro.Type.ClassType;
import haxe.macro.Context;
import hxsge.core.debug.Debug;
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
			else {
			}
		}

		return {
			expr: ExprDef.EBlock(exprs),
			pos: Context.currentPos()
		}
	}

	static function deserializeSimpleField(f:Field):Expr {
		return macro
			if(Reflect.hasField(obj, $v{f.name})) {
				$i{f.name} = cast Reflect.field(obj, $v{f.name});
				hxsge.core.debug.Debug.trace($v{f.name} + ": " + $i{f.name});
			}
	}

	static function deserializeArrayField(f:Field):Expr {
		var ct:ComplexType = Macro.getComplexType(f);
		var tp:TypePath = TypePathMacro.fromComplexType(ct);
		var simple:Bool = true;
		var isSerializable = false;

		if(tp != null && tp.params != null && tp.params.length > 0) {
			var act:ComplexType = switch(tp.params[0]) {
				case TypeParam.TPType(t):
					t;
				default:
					null;
			}
			if(act != null) {
				var atp:TypePath = TypePathMacro.fromComplexType(act);
				simple = TypePathMacro.isSimpleType(atp);

				if(simple) {
					return macro {
						if(Reflect.hasField(obj, $v{f.name})) {
							var d:Array<Dynamic> = Reflect.field(obj, $v{f.name});
							if(d != null) {
								$i{f.name} = [];
								for(v in d) {
								$i{f.name}.push(cast v);
								}
							}
							hxsge.core.debug.Debug.trace($v{f.name} + ": " + $i{f.name});
						}
					}
				}
				else {
					switch(Context.getType(atp.name)) {
						case TInst(cct, _):
							isSerializable = isSerializableClass(cct.get());
						default:
							isSerializable = false;
					}
					if(isSerializable) {
						return macro {
							if(Reflect.hasField(obj, $v{f.name})) {
								var d:Array<Dynamic> = Reflect.field(obj, $v{f.name});
								if(d != null) {
									$i{f.name} = [];
									for(v in d) {
										var val = Type.createInstance($i{atp.name}, []);
										Reflect.field(val, "deserialize")(v);
										$i{f.name}.push(val);
									}
								}
								hxsge.core.debug.Debug.trace($v{f.name} + ": " + $i{f.name});}
						}
					}
					else {
						return macro {
							if(Reflect.hasField(obj, $v{f.name})) {
								var d:Array<Dynamic> = Reflect.field(obj, $v{f.name});
								if(d != null) {
									$i{f.name} = [];
									for(v in d) {
										$i{f.name}.push(Std.instance(v, $i{atp.name}));
									}
								}
								hxsge.core.debug.Debug.trace($v{f.name} + ": " + $i{f.name});}
							}
					}
				}
			}
		}

		return macro {};
	}

	static function deserializeMapField(f:Field):Expr {
		var ct:ComplexType = Macro.getComplexType(f);
		var tp:TypePath = TypePathMacro.fromComplexType(ct);
		var simple:Bool = true;
		var isSerializable = false;

		if(tp != null && tp.params != null && tp.params.length > 0) {
			var act:ComplexType = switch(tp.params[0]) {
				case TypeParam.TPType(t):
					t;
				default:
					null;
			}
			if(act != null) {
				var atp:TypePath = TypePathMacro.fromComplexType(act);
				simple = TypePathMacro.isSimpleType(atp);

				return macro {
					var dd:Dynamic = Reflect.field(obj, $v{f.name});
					trace("------------------------> " + dd);
				}

//				TODO: need to finish parsing of map type

//				if(simple) {
//					return macro {
//						if(Reflect.hasField(obj, $v{f.name})) {
//							var d:Array<Dynamic> = Reflect.field(obj, $v{f.name});
//							if(d != null) {
//								$i{f.name} = [];
//								for(v in d) {
//								$i{f.name}.push(cast v);
//								}
//							}
//							hxsge.core.debug.Debug.trace($v{f.name} + ": " + $i{f.name});
//						}
//					}
//				}
//				else {
//					switch(Context.getType(atp.name)) {
//						case TInst(cct, _):
//							isSerializable = isSerializableClass(cct.get());
//						default:
//							isSerializable = false;
//					}
//					if(isSerializable) {
//						return macro {
//							if(Reflect.hasField(obj, $v{f.name})) {
//								var d:Array<Dynamic> = Reflect.field(obj, $v{f.name});
//								if(d != null) {
//									$i{f.name} = [];
//									for(v in d) {
//									var val = Type.createInstance($i{atp.name}, []);
//									Reflect.field(val, "deserialize")(v);
//									$i{f.name}.push(val);
//									}
//								}
//								hxsge.core.debug.Debug.trace($v{f.name} + ": " + $i{f.name});}
//						}
//					}
//					else {
//						return macro {
//							if(Reflect.hasField(obj, $v{f.name})) {
//								var d:Array<Dynamic> = Reflect.field(obj, $v{f.name});
//								if(d != null) {
//									$i{f.name} = [];
//									for(v in d) {
//									$i{f.name}.push(Std.instance(v, $i{atp.name}));
//									}
//								}
//								hxsge.core.debug.Debug.trace($v{f.name} + ": " + $i{f.name});}
//						}
//					}
//				}
			}
		}

		return macro {};
	}
}
#end