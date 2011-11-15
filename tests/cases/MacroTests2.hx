package cases;
 import haxe.macro.Context;
 import haxe.macro.Expr;
 import haxe.macro.Type;
#if macro
  using MacroTests2;
#end


class MacroTests2
{
	public static function main ()
	{
		trace("===== new test1 =====");
		var a = new Test1();
		trace("===== new test2 =====");
		var b = new Test2();
		trace("===== new test3 =====");
		var a = new Test3();
		trace("===== new test4 =====");
		var b = new Test4();
	}
}


@:autoBuild(MacroUtils.addConstructor())
@:build(MacroUtils.addConstructor())
class Test1 {}





class MacroUtils
{
	@:macro public static function addConstructor () : Array<Field>
	{
		var userFields		= Context.getBuildFields();
		var local			= Context.getLocalClass().get();
		var pos				= Context.currentPos();
		var methodName		= "new";
		var returnType		= "Void";
		
		var hasSuper		= false;
		var curDef			= null;
		
		// check if the method is already declared in the current class
		for (field in userFields) {
			if (field.name != methodName)	continue;
			curDef = field;
			break;
		}
		
		// check if the method is already declared in one of the super classes
		if (curDef == null)
			hasSuper = local.hasSuper( methodName );
		
		trace(local.name+".addMethod "+methodName+"(); curDef: "+(curDef != null)+"; hasSuper: "+hasSuper);
		
		// dirty way to create constructor content
		var methodContent = Context.parse("trace('==> new "+local.name+"')", pos);
		
		// if it's already declared in the current class, add method implementation to the existing method
		if (curDef != null)
		{
			var current	= curDef.getContent();
			pos			= current.pos;
			var block	= current.getBlock();
			
			if (block == null)
			{
				block = new Array<Expr>();
				block.push( current );
				curDef.setContent(block.toExpr(pos));
			}
			block.push( methodContent );
		}
		
		
		// if the method is declared in a super class, override that implementation and call super
		else
		{
			var access = [APublic];
			if (hasSuper)
			{
				var superExpr = methodName == "new" ? "super()" : "super."+methodName+"()";
				trace(" - "+superExpr);
				
				if (methodName != "new")
					access.push(Access.AOverride);
				
				var block = new Array<Expr>();
				block.push( Context.parse(superExpr, pos) );
				block.push( methodContent );
				methodContent = block.toExpr();
			}
			
			// add the method to the class-definition
			userFields.push( {
				name:		methodName,
				doc:		null,
				meta:		[],
				access:		access,
				kind:		FFun({
					expr:	methodContent,
					args:	[], 
					params:	[],
					ret:	TPath({ pack : [], name : returnType, params : [], sub : null })
				}),
				pos:		pos
			} );
		}
		trace("done");
		return userFields;
	}
	
	
#if macro
	private static function hasSuper (classDef:ClassType, fieldName:String) : Bool
	{
		var s = classDef.superClass;
		if (s == null)					return false;
		else if (fieldName == "new")	return true;

		var def = s.t.get();
		for (field in def.fields.get())
			if (field.name == fieldName)
				return true;

		return hasSuper( def, fieldName );
	}
	
	
	private static inline function getContent (field:Field) : Expr
	{
		return switch (field.kind) {
			case FFun(f):	return f.expr;
			default:		throw "wrong field.kind.. Should be FieldType.FFun instead of "+field.kind;
		}
	}
	
	
	private static inline function setContent (field:Field, content:Expr) : Expr
	{
		return switch (field.kind) {
			case FFun(f):	return f.expr = content;
			default:		throw "wrong field.kind.. Should be FieldType.FFun instead of "+field.kind;
		}
	}
	
	
	private static inline function getBlock (expr:Expr) : Array<Expr>
	{
		return switch (expr.expr) {
			case EBlock(exprs):	exprs;
			default:			null;
		}
	}
	
	
	private static inline function toExpr (blocks:Array<Expr>, pos:Position = null) : Expr
	{
		if (pos == null)
			pos = Context.currentPos();
		return {expr: EBlock(blocks), pos: pos };
	}
#end
}