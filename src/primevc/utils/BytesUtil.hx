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
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.utils;
 import haxe.io.BytesData;
  using primevc.utils.NumberUtil;
  using StringTools;


/**
 * @author Ruben Weijers
 * @creation-date Apr 12, 2011
 */
class BytesUtil
{
	/**
	 * Method will return the data of the byte-array in a hexadecimale 
	 * representation with 16 bytes on one row.
	 * 
	 * Note: Use this method only for debugging, it's quite inefficient
	 */
	public static function toHex (data:BytesData) : String
	{
		data.position = 0;
		
		var l = Std.int(data.length);
		var s = [];
		var rows = (l / 16).ceilFloat();
		
		for (i in 0...rows) {
			var r = [];
			
			try {
				for (j in 0...16)
					r.push( data.readByte().hex(2).substr(-2, 2) );
				
				throw 0;
			}
			catch(e:Dynamic) {
				s.push(r.join(" "));
			}
		}
		
		trace(s.length+" / "+rows+"; "+l);
		return "\n\t"+s.join("\n\t");
	}
}