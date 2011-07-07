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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package primevc.mvc;
#if debug
  using primevc.utils.BitUtil;
#end


/**
 * @author Ruben Weijers
 * @creation-date Dec 14, 2010
 */
extern class MVCFlags
{
	public static inline var LISTENING	= 1 << 0;
	public static inline var DISPOSED	= 1 << 1;
	
	public static inline var ENABLED	= 1 << 2;
	public static inline var EDITING	= 1 << 3;
	public static inline var HAS_DATA	= 1 << 4;
	
	
#if debug
	public static inline function readState (state:Int) : String
	{
		var str = [];
		if (state.has(LISTENING))	str.push( "listening" );
		if (state.has(DISPOSED))	str.push( "disposed" );
		if (state.has(EDITING))		str.push( "editing" );
		if (state.has(ENABLED))		str.push( "enabled" );
		if (state.has(HAS_DATA))	str.push( "hasData" );
		
		return str.join(", ");
	}
#end
}