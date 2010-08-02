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
 *  Danny Wilson	<danny @ onlinetouch.nl>
 */

#if flash9
import flash.Error;
#end

class Assert
{
	static inline public function abstract(?pos:haxe.PosInfos)
	{
		#if debug
		throw #if flash9 new Error( #end
			"Abstract method: "+ pos.className + "::" + pos.methodName +"() not overridden"
			#if flash9 ) #end ;
		#end
	}
	
	
	static inline public function that(expr:Bool, msg:String = "", ?pos:haxe.PosInfos)
	{
		#if debug
		if (!expr) throw #if flash9 new Error( #end
			"Assertion failed: " + msg + " in " + pos.className + "::" + pos.methodName + " @ " + pos.fileName + ":" + pos.lineNumber
			#if flash9 ) #end ;
		#end
	}
	
	
	static inline public function notThat(expr:Bool, msg:String = "", ?pos:haxe.PosInfos)
	{
		#if debug
		if (expr) throw #if flash9 new Error( #end
			"Assertion failed: " + msg + " in " + pos.className + "::" + pos.methodName + " @ " + pos.fileName + ":" + pos.lineNumber
			#if flash9 ) #end ;
		#end
	}
	
	
	static inline public function equal( var1:Dynamic, var2:Dynamic, msg:String = "", ?pos:haxe.PosInfos)
	{
		#if debug
		if (var1 != var2) {
			trace(pos.className + "::" + pos.lineNumber+": "+var1+" should be "+var2+"; "+msg);
			throw #if flash9 new Error( #end
			"Assertion failed: " + var1 + " != " + var2+"; msg: " + msg + " in " + pos.className + "::" + pos.methodName + " @ " + pos.fileName + ":" + pos.lineNumber
			#if flash9 ) #end;
		}
	//	else
	//		trace(pos.className + "::" + pos.lineNumber+": "+var1+" == "+var2);
		#end
	}
	
	
	static inline public function notEqual( var1:Dynamic, var2:Dynamic, msg:String = "", ?pos:haxe.PosInfos)
	{
		#if debug
		if (var1 == var2) {
			trace(pos.className + "::" + pos.lineNumber+": "+var1+" should not be "+var2+"; "+msg);
			throw #if flash9 new Error( #end
			"Assertion failed: " + var1 + " == " + var2+"; msg: " + msg + " in " + pos.className + "::" + pos.methodName + " @ " + pos.fileName + ":" + pos.lineNumber
			#if flash9 ) #end;
		}
	//	else
	//		trace(pos.className + "::" + pos.lineNumber+": "+var1+" != "+var2);
		#end
	}


	static inline public function notNull( var1:Dynamic, msg:String = "", ?pos:haxe.PosInfos)
	{
		#if debug
		if (var1 == null) {
			trace(pos.className + "::" + pos.lineNumber+": "+var1+" should not be null");
			throw #if flash9 new Error( #end
			"Assertion failed: " + var1 + " == null; msg: " + msg + " in " + pos.className + "::" + pos.methodName + " @ " + pos.fileName + ":" + pos.lineNumber
			#if flash9 ) #end;
		}
	//	else
	//		trace(pos.className + "::" + pos.lineNumber+": "+var1+" != "+var2);
		#end
	}
}