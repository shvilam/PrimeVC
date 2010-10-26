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
package primevc.gui.graphics.borders;
 import primevc.core.geom.IRectangle;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.GraphicElement;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.gui.traits.IDrawable;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end


/**
 * Base class for borders
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class BorderBase <FillType:IFill> extends GraphicElement, implements IBorder <FillType>
{
	public var weight		(default, setWeight)		: Float;
	public var fill			(default, setFill)			: FillType;
	/**
	 * The capsstyle that is used at the end of lines
	 */
	public var caps			(default, setCaps)			: CapsStyle;
	/**
	 * The jointstyle that is used at angles
	 */
	public var joint		(default, setJoint)			: JointStyle;
	public var pixelHinting	(default, setPixelHinting)	: Bool;
	/**
	 * Should this border be drawn on the inside of the parent shape (true) or
	 * on the outside of the parentshape.
	 */
	public var innerBorder	(default, setInnerBorder)	: Bool;
	
	
	
	public function new ( fill:FillType, weight:Float = 1, innerBorder:Bool = false, caps:CapsStyle = null, joint:JointStyle = null, pixelHinting:Bool = false )
	{
		super();
#if flash9
		Assert.notNull(fill);
#end
		this.fill			= fill;
		this.weight			= weight;
		this.caps			= caps != null ? caps : CapsStyle.NONE;
		this.joint			= joint != null ? joint : JointStyle.ROUND;
		this.innerBorder	= innerBorder;
		this.pixelHinting	= pixelHinting;
	}
	
	
	override public function dispose ()
	{
		fill = null;
		super.dispose();
	}
	
	
	public function begin (target:IDrawable, ?bounds:IRectangle) {
		Assert.abstract();
	}
	
	
	public function end (target:IDrawable)
	{
#if flash9
		target.graphics.lineStyle( 0, 0 , 0 );
#end
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setWeight (v:Float)
	{
		if (v != weight) {
			weight = v;
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}
	
	
	private inline function setFill (v:FillType)
	{
		if (v != fill) {
			if (fill != null)
				fill.listeners.remove(this);
			
			fill = v;
			if (fill != null)
				fill.listeners.add(this);
			
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}


	private inline function setCaps (v:CapsStyle)
	{
		if (v != caps) {
			caps = v;
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}


	private inline function setJoint (v:JointStyle)
	{
		if (v != joint) {
			joint = v;
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}


	private inline function setPixelHinting (v:Bool)
	{
		if (v != pixelHinting) {
			pixelHinting = v;
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}


	private inline function setInnerBorder (v:Bool)
	{
		if (v != innerBorder) {
			innerBorder = v;
			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}
	
	
#if (debug || neko)
	override public function toCSS (prefix:String = "")
	{
		return fill + " " + weight + "px";
	}
	
	
	override public function isEmpty () : Bool
	{
		return fill == null;
	}
#end
#if neko
	override public function toCode (code:ICodeGenerator)
	{
		code.construct( this, [ fill, weight, innerBorder, caps, joint, pixelHinting ] );
	}
#end
}