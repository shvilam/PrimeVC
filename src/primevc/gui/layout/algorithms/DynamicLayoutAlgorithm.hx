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
package primevc.gui.layout.algorithms;
 import primevc.core.geom.space.Direction;
 import primevc.core.geom.space.Horizontal;
 import primevc.core.geom.space.Vertical;
 import primevc.core.geom.IRectangle;
 import primevc.utils.IntMath;
  using primevc.utils.Bind;
 

/**
 * Dynamic layout algorithm allows to specify different sub-algorithms for
 * horizontal and vertical layouts.
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class DynamicLayoutAlgorithm extends LayoutAlgorithmBase, implements ILayoutAlgorithm
{
	
	/**
	 * Defines the start position on the horizontal axis.
	 * @default		Horizontal.left
	 */
	public var horizontalDirection		(default, setHorizontalDirection)	: Horizontal;
	/**
	 * Defines the start position on the vertical axis.
	 * @default		Vertical.top
	 */
	public var verticalDirection		(default, setVerticalDirection)		: Vertical;
	
	
	public var horAlgorithm				(default, setHorAlgorithm)			: IHorizontalAlgorithm;
	public var verAlgorithm				(default, setVerAlgorithm)			: IVerticalAlgorithm;
	
	
	public function new (horAlgorithm:IHorizontalAlgorithm, verAlgorithm:IVerticalAlgorithm) 
	{
		super();
		this.horAlgorithm	= horAlgorithm;
		this.verAlgorithm	= verAlgorithm;
	}
	
	
	override public function dispose ()
	{
		horAlgorithm.dispose();
		verAlgorithm.dispose();
		horAlgorithm	= null;
		verAlgorithm	= null;
		super.dispose();
	}
	
	
	
	//
	// ALGORITHM METHODS
	//
	
	
	override public function prepareValidate ()
	{
		if (!validatePrepared)
		{
			horAlgorithm.prepareValidate();
			verAlgorithm.prepareValidate();
		}
		super.prepareValidate();
	}
	
	
	public function validate ()
	{
		if (group.children.length == 0)
			return;
		
		validateHorizontal();
		validateVertical();
	}
	
	
	public function validateHorizontal ()	{ horAlgorithm.validateHorizontal(); }
	public function validateVertical ()		{ verAlgorithm.validateVertical(); }
	
	
 	public function apply ()
	{
		horAlgorithm.apply();
		verAlgorithm.apply();
		validatePrepared = false;
	}
	
	
	public function isInvalid (changes:Int) : Bool
	{
		return horAlgorithm.isInvalid(changes) || verAlgorithm.isInvalid(changes);
	}
	
	
	private function invalidate (shouldbeResetted:Bool = true) : Void
	{
		algorithmChanged.send();
	}
	
	
	public function getDepthForBounds (bounds:IRectangle)
	{
		var depthHor = horAlgorithm.getDepthForBounds(bounds);
		var depthVer = verAlgorithm.getDepthForBounds(bounds);
		var depth = IntMath.max( depthHor, depthVer );
		
		if (depthHor < 0)	depth = group.children.length - (depthVer);
		if (depthVer < 0)	depth = group.children.length - (depthHor);
		return depth;
	}
	
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	override private function setGroup (v)
	{
		if (group != v)
		{
			if (group != null) {
				horAlgorithm.group = null;
				verAlgorithm.group = null;
			}
			
			v = super.setGroup(v);
			invalidate(true);
			
			if (v != null) {
				horAlgorithm.group	= v;
				verAlgorithm.group	= v;
			}
		}
		return v;
	}
	
	
	private inline function setHorAlgorithm (v)
	{
		if (horAlgorithm != null) {
			horAlgorithm.group = null;
			horAlgorithm.algorithmChanged.unbind(this);
		}
		
		horAlgorithm = v;
		invalidate(false);
		
		if (horAlgorithm != null) {
			horAlgorithm.group = group;
			algorithmChanged.send.on( horAlgorithm.algorithmChanged, this );
		}
		return v;
	}
	
	
	private inline function setVerAlgorithm (v)
	{
		if (verAlgorithm != null) {
			verAlgorithm.group = null;
			verAlgorithm.algorithmChanged.unbind(this);
		}
		
		verAlgorithm = v;
		invalidate(false);
		
		if (verAlgorithm != null) {
			verAlgorithm.group = group;
			algorithmChanged.send.on( verAlgorithm.algorithmChanged, this );
		}
		return v;
	}
	
	
	private function setHorizontalDirection (v:Horizontal)
	{
		if (v != horizontalDirection) {
			horizontalDirection		= v;
			horAlgorithm.direction	= v;
			invalidate(false);
		}
		return v;
	}
	
	
	private function setVerticalDirection (v:Vertical)
	{
		if (v != verticalDirection) {
			verticalDirection		= v;
			verAlgorithm.direction	= v;
			invalidate(false);
		}
		return v;
	}
	
	
#if debug
	public function toString ()
	{
		return "dynamic ( " + horAlgorithm + ", " + verAlgorithm + " )";
	}
#end
}