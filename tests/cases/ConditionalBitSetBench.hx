package cases;
 import Benchmark;
  using primevc.utils.IfUtil;


/**
 * @author Danny Wilson
 * @creation-date nov 29, 2010
 */
class ConditionalBitSetBench
{
	static public function main()
	{
		trace("Bench?");
		
		var bench = new Benchmark();
		var group = new Comparison( "OR", 1);
		group.add(new Test(ifExpr_Plusplus,  "`if (expr) ++i; ...`"));
		group.add(new Test(varExpr_Plusplus, "`var i = (expr) + ...`"));
//		group.add(new Test(ifExpr_OR, "`untyped if (expr) i |= ...`"));
//		group.add(new Test(ifExpr_OR_noUntyped, "`if (expr) i |= ...`"));
//		group.add(new Test(OR_ShiftExpr, "`i |= (untyped expr) << ...`"));
//		group.add(new Test(OR_IfExpr, "`i |= expr? ... : 0`"));
//		group.add(new Test(OR_ShiftExpr_One, "`untyped i = expr0 | expr1 ...`"));
//		group.add(new Test(OR_ShiftExpr_One_noUntyped, "`i = expr0 | expr1 ...`"));
		bench.add( group );
		
		bench.start();
	}
	
	static var instance = new ConditionalBitSetBench();
	
	var var1 : Int;
	var var2 : String;
	var var3 : String;
	var var4 : String;
	var var5 : String;
	var var6 : String;
	var var7 : String;
	var var8 : String;
	
	function new() {
		var1 = 0;
		var2 = null; //"2";
		var3 = null; //"3";
		var4 = null; //"4";
		var5 = null; //"5";
		var6 = null; //"6";
		var7 = null; //"7";
		var8 = null; //"8";
	}
	
	static function ifExpr_Plusplus() {
		var i = 0, variable = instance;
		for (x in 0 ... 2000000) {
			if (variable.var1 == 0) i |= 0x01;
			if (untyped variable.var2 && untyped variable.var2.length) ++i;
			if (untyped variable.var3 && untyped variable.var3.length) ++i;
			if (untyped variable.var4 && untyped variable.var4.length) ++i;
			if (untyped variable.var5 && untyped variable.var5.length) ++i;
			if (untyped variable.var6 && untyped variable.var6.length) ++i;
			if (untyped variable.var7 && untyped variable.var7.length) ++i;
			if (untyped variable.var8 && untyped variable.var8.length) ++i;
			
			if (untyped i) itsTrue();
		}
	}
	
	static function varExpr_Plusplus() {
		var variable = instance;
		for (x in 0 ... 2000000) {
			var i = (variable.var1 == 0).boolCalc() + 
			 (untyped variable.var2 && untyped variable.var2.length? 1 : 0) +
			 (untyped variable.var3 && untyped variable.var3.length? 1 : 0) +
			 (untyped variable.var4 && untyped variable.var4.length? 1 : 0) +
			 (untyped variable.var5 && untyped variable.var5.length? 1 : 0) +
			 (untyped variable.var6 && untyped variable.var6.length? 1 : 0) +
			 (untyped variable.var7 && untyped variable.var7.length? 1 : 0) +
			 (untyped variable.var8 && untyped variable.var8.length? 1 : 0);
			
			if (untyped i) itsTrue();
		}
	}
	
	static function ifExpr_OR() {
		var i = 0, variable = instance;
		for (x in 0 ... 2000000) {
			if (variable.var1 == 0) i |= 0x01;
			if (untyped variable.var2 && untyped variable.var2.length) i |= 0x02;
			if (untyped variable.var3 && untyped variable.var3.length) i |= 0x04;
			if (untyped variable.var4 && untyped variable.var4.length) i |= 0x08;
			if (untyped variable.var5 && untyped variable.var5.length) i |= 0x10;
			if (untyped variable.var6 && untyped variable.var6.length) i |= 0x20;
			if (untyped variable.var7 && untyped variable.var7.length) i |= 0x40;
			if (untyped variable.var8 && untyped variable.var8.length) i |= 0x80;
			
			if (untyped i) itsTrue();
		}
	}
	
	static function ifExpr_OR_noUntyped() {
		var i = 0, variable = instance;
		for (x in 0 ... 2000000) {
			if (variable.var1 == 0) i |= 0x01;
			if (variable.var2 != null && variable.var2.length > 0) i |= 0x02;
			if (variable.var3 != null && variable.var3.length > 0) i |= 0x04;
			if (variable.var4 != null && variable.var4.length > 0) i |= 0x08;
			if (variable.var5 != null && variable.var5.length > 0) i |= 0x10;
			if (variable.var6 != null && variable.var6.length > 0) i |= 0x20;
			if (variable.var7 != null && variable.var7.length > 0) i |= 0x40;
			if (variable.var8 != null && variable.var8.length > 0) i |= 0x80;
			
			if (untyped i) itsTrue();
		}
	}
/*	
	static function OR_ShiftExpr() {
		var i = 0, variable = instance;
		for (x in 0 ... 2500000) {
			i |= (untyped (variable.var1 == 0));
			i |= (untyped (untyped variable.var2 && untyped variable.var2.length)) << 1;
			i |= (untyped (untyped variable.var3 && untyped variable.var3.length)) << 2;
			i |= (untyped (untyped variable.var4 && untyped variable.var4.length)) << 3;
			i |= (untyped (untyped variable.var5 && untyped variable.var5.length)) << 4;
			i |= (untyped (untyped variable.var6 && untyped variable.var6.length)) << 5;
			i |= (untyped (untyped variable.var7 && untyped variable.var7.length)) << 6;
			i |= (untyped (untyped variable.var8 && untyped variable.var8.length)) << 7;
		}
		if (i == 0) throw 0;
	}
*/	
	static function OR_ShiftExpr_One_noUntyped() {
		var i = 0, variable = instance;
		for (x in 0 ... 2000000) {
			if( ( ((variable.var1 == 0)? 1 : 0)
		 	  | (variable.var2 != null && variable.var2.length > 0? 0x02 : 0)
			  | (variable.var3 != null && variable.var3.length > 0? 0x04 : 0)
			  | (variable.var4 != null && variable.var4.length > 0? 0x08 : 0)
			  | (variable.var5 != null && variable.var5.length > 0? 0x10 : 0)
			  | (variable.var6 != null && variable.var6.length > 0? 0x20 : 0)
			  | (variable.var7 != null && variable.var7.length > 0? 0x40 : 0)
			  | (variable.var8 != null && variable.var8.length > 0? 0x80 : 0)
			) != 0)
				itsTrue();
		}
	}
	
	static function OR_ShiftExpr_One() {
		var i = 0, variable = instance;
		for (x in 0 ... 2000000) {
			if( untyped (untyped (variable.var1 == 0))
		 	  | (       (untyped variable.var2 && untyped variable.var2.length)) << 1
			  | (       (untyped variable.var3 && untyped variable.var3.length)) << 2
			  | (       (untyped variable.var4 && untyped variable.var4.length)) << 3
			  | (       (untyped variable.var5 && untyped variable.var5.length)) << 4
			  | (       (untyped variable.var6 && untyped variable.var6.length)) << 5
			  | (       (untyped variable.var7 && untyped variable.var7.length)) << 6
			  | (       (untyped variable.var8 && untyped variable.var8.length)) << 7
			)
				itsTrue();
			
		}
	}
	
	static function itsTrue() {}
/*	
	static function OR_IfExpr() {
		var i = 0, variable = instance;
		
		for (x in 0 ... 2500000) {
			i |= (variable.var1 == 0)? 0x01 : 0;
			i |= (untyped variable.var2 && untyped variable.var2.length)? 0x02 : 0;
			i |= (untyped variable.var3 && untyped variable.var3.length)? 0x04 : 0;
			i |= (untyped variable.var4 && untyped variable.var4.length)? 0x08 : 0;
			i |= (untyped variable.var5 && untyped variable.var5.length)? 0x10 : 0;
			i |= (untyped variable.var6 && untyped variable.var6.length)? 0x20 : 0;
			i |= (untyped variable.var7 && untyped variable.var7.length)? 0x40 : 0;
			i |= (untyped variable.var8 && untyped variable.var8.length)? 0x80 : 0;
		}
		if (i == 0) throw 0;
	}*/
}