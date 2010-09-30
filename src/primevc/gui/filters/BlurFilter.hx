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
package primevc.gui.filters;


#if (flash9 || flash8)
typedef BlurFilter = flash.filters.BlurFilter;

#elseif	js
throw "error";

#else

 import primevc.tools.generator.ICodeGenerator;


/**
 * Simple BlurFilter implementation. Class currently just contains the 
 * same properties as the flash.filters.BlurFilter, but doesn't do 
 * anything else.
 *
 * @author Ruben Weijers
 * @creation-date Sep 30, 2010
 */
class BlurFilter extends BitmapFilter
{
	public var blurX	: Float;
	public var blurY	: Float;
	public var quality	: Int;
	
	
	public function new (blurX = 4.0, blurY = 4.0, quality = 1)
	{
		super();
		this.blurX		= blurX;
		this.blurY		= blurY;
		this.quality	= quality;
	}


	override public function toCSS (prefix:String = "") : String
	{
		var css = [];
		css.push( blurX+"px" );
		css.push( blurY+"px" );

		css.push ( switch (quality) {
			case 1:		"low";
			case 2:		"medium";
			case 3:		"high";
		} );

		return css.join(" ");
	}


	#if (neko || debug)
	override public function toCode (code:ICodeGenerator) : Void
	{
		code.construct( this, [ blurX, blurY, quality ] );
	}


	override public function isEmpty () : Bool
	{
		return blurX == 0 && blurY == 0;
	}
	#end
}

#end
