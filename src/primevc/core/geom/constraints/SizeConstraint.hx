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
package primevc.core.geom.constraints;
 import primevc.core.IDisposable;
 import primevc.types.Number;
 

/**
 * Description
 * 
 * @creation-date	Jun 19, 2010
 * @author			Ruben Weijers
 */
class SizeConstraint implements IDisposable //implements IConstraint <Dynamic>
{
	public var width (default, null)	: IntConstraint;
	public var height (default, null)	: IntConstraint;
	
	
	public function new(minW = Number.INT_MIN, maxW = Number.INT_MAX, minH = Number.INT_MIN, maxH = Number.INT_MAX) 
	{
		width	= new IntConstraint(minW, maxW);
		height	= new IntConstraint(minH, maxH);
	}
	
	
	public function reset ()
	{
		width.min = Number.INT_MIN;
		width.max = Number.INT_MAX;
		height.min = Number.INT_MIN;
		height.max = Number.INT_MAX;
	}
	
	
	public function dispose ()
	{
		if (width == null)
			return;
		
		width.dispose();
		height.dispose();
		width = null;
		height = null;
	}
}