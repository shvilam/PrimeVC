/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.utils;
  using primevc.utils.ERegUtil;


/**
 * @author Ruben Weijers
 * @creation-date Sep 04, 2010
 */
class ERegUtil #if flash9 extends EReg #end
{
	public static inline function matchAll (expr:EReg, str:String, f:EReg -> Void) : Void
	{
		while (true) {
			if ( !expr.match(str) )
				break;
			
			f(expr);
			str = expr.matchedRight();
		}
	}
	
#if debug
	public static inline function test (expr:EReg, str:String, ?pos:haxe.PosInfos) : Bool
	{
	#if flash9
		var success		= expr.match(str);
		var hasResults	= expr.result != null && expr.result.length > 0 && expr.matched(0) == str;
	#else
		var hasResults	= false;
		var success		= expr.match(str);
		try {
			hasResults	= success && expr.matched(0) == str;
		}
		catch (e:Dynamic) {}
	#end
		if (!hasResults)
			success = false;
		
		if (!success) {
			trace(pos.fileName + ":" + pos.lineNumber+"; Assertion failed: '"+str+"'"+(hasResults ? " is not matched with '"+expr.matched(0)+"'" : " not matched"));
#if flash9	trace(expr.resultToString());	#end
			throw "Error";
		} else {
#if debug	trace(pos.fileName + ":" + pos.lineNumber+"; Assertion success: '"+expr.matched(0)+"' is correct");		#end
		}
		
		return success;
	}
	
	
	public static inline function testWrong (expr:EReg, str:String, ?pos:haxe.PosInfos) : Bool
	{
	#if flash9
		var success		= !expr.match(str) || expr.result == null || expr.result.length == 0 || expr.matched(0) != str;
		var hasResults	= expr.result != null && expr.result.length > 0;
	#else
		var hasResults	= false;
		var success		= !expr.match(str) || expr.matched(0) != str;
		try {
			hasResults	= success && expr.matched(0) == str;
		}
		catch (e:Dynamic) {}
	#end
	
		if (!success) {
			trace(pos.fileName + ":" + pos.lineNumber+"; Assertion failed: '"+str+"'"+ (hasResults ? " is matched with '"+expr.matched(0)+"'" : ""));
#if flash9	trace(expr.resultToString());	#end
			throw "Error";
		} else {
#if debug	trace(pos.fileName + ":" + pos.lineNumber+"; Assertion success: '"+str + "' is not matched");		#end
		}
		
		return success;
	}
	
	
	#if flash9
	public static inline function resultToString (expr:EReg) : String
	{
		var output = "";
		if (expr.result != null && expr.result.length > 0) {
			for (i in 0...expr.result.length)
				output += "\n[ "+i+" ] = "+expr.matched(i);
		}
		else
			output = "No result matched or expression not yet called.";
		return output;
	}
	
	public static inline function getExpression (expr:EReg) { return expr.r; }
	
	#end
#end
}