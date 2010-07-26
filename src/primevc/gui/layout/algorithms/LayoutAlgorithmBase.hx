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
 import primevc.core.dispatcher.Signal0;
 import primevc.core.IDisposable;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.ILayoutContainer;
 import primevc.gui.layout.LayoutClient;
  using primevc.utils.TypeUtil;
 

/**
 * Base class for algorithms
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class LayoutAlgorithmBase implements IDisposable
{
	public var algorithmChanged 		(default, null)				: Signal0;
	public var group					(default, setGroup)			: ILayoutContainer<LayoutClient>;
	
	
	public function new()
	{
		algorithmChanged	= new Signal0();
	}
	
	
	public function dispose ()
	{
		algorithmChanged.dispose();
		algorithmChanged	= null;
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setGroup (v)
	{
		return group = v;
	}
	
	
	private inline function setGroupHeight (h:Int)
	{
		if (group.is(AdvancedLayoutClient))
			group.as(AdvancedLayoutClient).measuredHeight = h;
		else
			group.height = h;
	}
	
	
	private inline function setGroupWidth (w:Int)
	{
		if (group.is(AdvancedLayoutClient))
			group.as(AdvancedLayoutClient).measuredWidth = w;
		else
			group.width = w;
	}
	
	
	private var measurePrepared : Bool;
	public function prepareMeasure () {
		measurePrepared = true;
	}
}