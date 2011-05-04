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
 import primevc.gui.graphics.IGraphicProperty;
 import primevc.gui.traits.IDrawable;


/**
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
interface IBorder implements IGraphicProperty 
{
	public var weight		(default, setWeight)		: Float;
//	public var fill			(default, setFill)			: FillType;
	/**
	 * The capsstyle that is used at the end of lines
	 */
//	public var caps			(default, setCaps)			: CapsStyle;
	/**
	 * The jointstyle that is used at angles
	 */
//	public var joint		(default, setJoint)			: JointStyle;
//	public var pixelHinting	(default, setPixelHinting)	: Bool;
	
	/**
	 * Should this border be drawn on the inside of the parent shape (true) or
	 * on the outside of the parentshape.
	 */
	public var innerBorder	(default, setInnerBorder)	: Bool;
	
	
//	public function begin (target:IDrawable, ?bounds:IRectangle) : Void;
//	public function end (target:IDrawable) : Void;
}