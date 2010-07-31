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
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.GraphicElement;
 import primevc.gui.graphics.GraphicFlags;


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
	public var caps			(default, setCaps)			: CapsStyles;
	/**
	 * The jointstyle that is used at angles
	 */
	public var joint		(default, setJoint)			: JointStyles;
	public var pixelHinting	(default, setPixelHinting)	: Bool;
	
	
	
	public function new ( fill:FillType, weight:Float , caps:CapsStyles = null, joint:JointStyles = null )
	{
		super();
		this.fill	= fill;
		this.weight	= weight;
		this.caps	= caps != null ? caps : NoCaps;
		this.joint	= joint != null ? joint : RoundJoint;
	}
	
	
	override public function dispose ()
	{
		fill = null;
		super.dispose();
	}
	
	
	public function begin (target, ?bounds)	{}
	
	
	public function end (target)
	{
#if flash9
		target.graphics.lineStyle( 0, 0 , 0 );
#end
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getFlashCaps () : String
	{
		return switch (caps) {
			case NoCaps:		"none"; // CapsStyle.NONE;
			case RoundCaps:		"round"; // CapsStyle.ROUND;
			case SquareCaps:	"square"; // CapsStyle.SQUARE;
			default:			null;
		}
	}
	
	
	private inline function getFlashJoints () : String
	{
		return switch (joint) {
			case MiterJoint:	"mitter"; // JointStyle.MITER;
			case RoundJoint:	"round"; // JointStyle.ROUND;
			case BevelJoint:	"bevel"; // JointStyle.BEVEL;
			default:			null;
		}
	}
	
	
	private inline function setWeight (v:Float)
	{
		if (v != weight) {
			weight = v;
			invalidate( GraphicFlags.BORDER_CHANGED );
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
			
			invalidate( GraphicFlags.BORDER_CHANGED );
		}
		return v;
	}


	private inline function setCaps (v:CapsStyles)
	{
		if (v != caps) {
			caps = v;
			invalidate( GraphicFlags.BORDER_CHANGED );
		}
		return v;
	}


	private inline function setJoint (v:JointStyles)
	{
		if (v != joint) {
			joint = v;
			invalidate( GraphicFlags.BORDER_CHANGED );
		}
		return v;
	}
}