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
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */

#if flash9
 import flash.errors.Error;
#end
#if debug
  using Type;
#end

class Assert
{
#if debug
	public static var tracesEnabled = true;
#end
	
	
	static inline public function isType(var1:Dynamic, type:Class<Dynamic>, ?pos:haxe.PosInfos)
	{
#if debug
		Assert.notNull( var1, "To check the type of a variable it can't be null." );
		Assert.notNull( type, "The type of a variable can't be null." );
		Assert.that( Std.is(var1, type), "var of type '" + Type.getClass(var1).getClassName() + "' should be of type '" + type.getClassName() + "'" );
#end
	}
	
	
	static inline public function abstract	(msg:String = "", ?pos:haxe.PosInfos)								{ #if debug	sendError("Abstract method", msg, pos); #end }
	static inline public function that		(expr:Bool, msg:String = "", ?pos:haxe.PosInfos)					{ #if debug if (!expr)			sendError(expr+" == false", msg, pos); #end }
	static inline public function notThat	(expr:Bool, msg:String = "", ?pos:haxe.PosInfos)					{ #if debug if (expr)			sendError(expr+" == true", msg, pos); #end }
	static inline public function equal		(var1:Dynamic, var2:Dynamic, msg:String = "", ?pos:haxe.PosInfos)	{ #if debug if (var1 != var2)	sendError(var1+" != "+var2, msg, pos); #end }
	static inline public function notEqual	(var1:Dynamic, var2:Dynamic, msg:String = "", ?pos:haxe.PosInfos) 	{ #if debug	if (var1 == var2)	sendError(var1+" == "+var2, msg, pos); #end }
	static inline public function null		(var1:Dynamic, msg:String = "", ?pos:haxe.PosInfos)					{ #if debug if (var1 != null)	sendError(var1+" != null", msg, pos); #end }
	static inline public function notNull	(var1:Dynamic, msg:String = "", ?pos:haxe.PosInfos)					{ #if debug	if (var1 == null)	sendError(var1+" == null", msg, pos); #end }
	
	
	static inline private function sendError (error:String, msg:String, pos:haxe.PosInfos)
	{
#if debug
		var className = pos.className.split(".").pop();
		msg = className + "." + pos.methodName + "()::" + pos.lineNumber + ": "+error + "; msg: " + msg;
		trace(msg);
	#if flash9
		throw new Error( msg );
	#else
		throw msg;
	#end
#end
	}
}