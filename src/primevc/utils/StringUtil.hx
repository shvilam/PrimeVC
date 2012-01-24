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
  using primevc.utils.StringUtil;
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
	public static function createUUID () : String
	{
		return randomHexStr(0xffff) + randomHexStr(0xffff) 					//first 8 chars	(xxxxxxxx)
				+ "-" + randomHexStr(0xffff) 								//next 4 chars (xxxx)
				+ "-4" + randomHexStr(0xfff) 								//next 4 chars (4xxx)
				+ "-" + randomChar('89AB', 4) + randomHexStr(0xfff) 		//next 4 chars (yxxx)
				+ "-" + randomHexStr(0xffffff)	+ randomHexStr(0xffffff);	//next 12 chars (xxxxxxxxxxxx)
	}
	
	
	private static inline function randomHexStr (val:Int) : String		{ return val.random().hex(); }
	private static inline function randomChar(s:String, l:Int) : String	{ return s.charAt( Std.random( l ) ); }
	
	/**
	 * Method creates a random string with the given length
	 */
	public static function randomString(l:Int) : String
	{
		Assert.that(l > 0);
		var s = "";
		for (i in 0...l)
			s += (25.random() + 65).fromCharCode();
		return s;
	}
	
	
	/**
	 * Method will change the first character of every word in the given string
	 * to uppercase
	 */
	public static function capitalize (v:String) : String
	{
		var words	= v.split(" ");
		var len		= words.length;
		for ( i in 0...len )
			words[ i ] = words[ i ].capitalizeFirstLetter();
		
		return words.join(" ");
	}
	
	
	/**
	 * Method will change the first character of the given string to uppercase
	 */
	public static inline function capitalizeFirstLetter (v:String) : String
	{
		return v.substr(0, 1).toUpperCase() + v.substr(1);
	}


	public static inline function breakAfter (v:String, breakPoint:Int) : String
	{
		var loop = (v.length / breakPoint).int();
		var newV = "";
		for (i in 0...loop)
			newV += v.substr(i * breakPoint, breakPoint) + "\n";
		
		var last = v.length % breakPoint;
		newV += v.substr( -last, last );

		trace(v.length % breakPoint);
		return newV + "\n";
	}
}