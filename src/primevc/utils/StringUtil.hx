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
  using Std;
  using StringTools;
  using String;



/**
 * @author Ruben Weijers
 * @creation-date Sep 14, 2010
 */
class StringUtil
{
	/**
	 * Method generates a UUID string
	 * 
	 * UUID format
	 * xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
	 * 
	 * x = any hexadecimal character
	 * y = 8,9,a,b
	 */
	public static inline function createUUID () : String
	{
		return randomHexStr(0xffff) + randomHexStr(0xffff) 					//first 8 chars	(xxxxxxxx)
				+ "-" + randomHexStr(0xffff) 								//next 4 chars (xxxx)
				+ "-4" + randomHexStr(0xfff) 								//next 4 chars (4xxx)
				+ "-" + randomChar('89AB', 4) + randomHexStr(0xfff) 		//next 4 chars (yxxx)
				+ "-" + randomHexStr(0xffffff)	+ randomHexStr(0xffffff);	//next 12 chars (xxxxxxxxxxxx)
	}
	
	
	private static inline function randomHexStr (val:Int)		{ return val.random().hex(); }
	private static inline function randomChar(s:String, l:Int)	{ return s.charAt( Std.random( l ) ); }
}