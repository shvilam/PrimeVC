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
package primevc.gui.graphics.fills;
 import primevc.core.geom.IRectangle;
 import primevc.gui.graphics.GraphicElement;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.gui.traits.IDrawable;
 import primevc.utils.FastArray;
  using primevc.utils.FastArray;



/**
 * A composed-fill is a fill that exists of multiple other fills so that a shape
 * can be filled multiple times in one render cycle.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class ComposedFill extends GraphicElement, implements IFill 
{
	public var fills	(default, null)		: FastArray <IFill>;
	
	
	public function new ()
	{
		super();
		fills = FastArrayUtil.create();
	}
	
	
	override public function dispose ()
	{
		for (fill in fills)
			fill.dispose();
		
		fills = null;
		super.dispose();
	}
	
	
	//
	// IFILL METHODS
	//
	
	public inline function begin (target:IDrawable, ?bounds:IRectangle)
	{
		changes = 0;
		for (fill in fills)
			fill.begin(target, bounds);
		
	}
	
	
	public inline function end (target:IDrawable)
	{
		for (fill in fills)
			fill.endFill(target);
	}
	
	
	
	//
	// LIST METHODS
	//

	public inline function add ( fill:IFill, depth:Int = -1 )
	{
		fills.insertAt( fill, depth );
		fill.parent = this;
		invalidate( GraphicFlags.FILL_CHANGED );
	}


	public inline function remove ( fill:IFill )
	{
		fills.remove(fill);
		fill.dispose();
		invalidate( GraphicFlags.FILL_CHANGED );
	}
}