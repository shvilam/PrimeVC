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
typedef BevelFilter = flash.filters.BevelFilter;

#elseif	js
throw "error";

#else

 import primevc.tools.generator.ICodeGenerator;
 import primevc.utils.Color;
  using primevc.utils.Color;
  using Std;


/**
 * Simple BevelFilter implementation. Class currently just contains the 
 * same properties as the flash.filters.BevelFilter, but doesn't do 
 * anything else.
 *
 * @author Ruben Weijers
 * @creation-date Sep 30, 2010
 */
class BevelFilter extends BitmapFilter
{
	public var highlightAlpha	: Float;
	public var highlightColor	: UInt;
	public var shadowAlpha		: Float;
	public var shadowColor		: UInt;
	
	public var angle		: Float;
	public var blurX		: Float;
	public var blurY		: Float;
	public var distance		: Float;
	public var knockout		: Bool;
	public var quality		: Int;
	public var strength		: Float;
	public var type			: BitmapFilterType;
	
	
	public function new (
				distance:Float = 4.0, angle:Float = 45, 
				highlightColor:UInt = 0xffffff, highlightAlpha:Float = 1.0, 
				shadowColor:UInt = 0x000000, shadowAlpha:Float = 1.0,
				blurX:Float = 4.0, blurY:Float = 4.0, strength:Float = 1.0, quality:Int = 1, 
				type = null, knockout:Bool = false
				)
	{
		super();
		
		this.distance		= distance;
		this.angle			= angle;
		this.highlightColor	= highlightColor;
		this.highlightAlpha	= highlightAlpha;
		this.shadowColor	= shadowColor;
		this.shadowAlpha	= shadowAlpha;
		this.blurX			= blurX;
		this.blurY			= blurY;
		this.strength		= strength;
		this.quality		= quality;
		this.type			= type == null ? BitmapFilterType.INNER : type;
		this.knockout		= knockout;
	}


	override public function toCSS (prefix:String = "") : String
	{
		var css = [];
		css.push( distance+"px");
		css.push( blurX+"px" );
		css.push( blurY+"px" );
		css.push( strength.string() );
		css.push( angle+"deg");
		css.push( Color.create().setRgb( highlightColor ).setAlpha( highlightAlpha.uint() ).string() );
		css.push( Color.create().setRgb( shadowColor ).setAlpha( shadowAlpha.uint() ).string() );
		
		if (knockout)	css.push("knockout");
		
		css.push ( switch (type) {
			case INNER:	"inner";
			case OUTER:	"outer";
			case FULL:	"full";
		} );
		
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
		code.construct( this, [ 
			distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, 
			blurX, blurY, strength, quality, type, knockout
		] );
	}


	override public function isEmpty () : Bool
	{
		return false;
	}
#end
}

#end
