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
package primevc.gui.behaviours.scroll;
 import primevc.core.geom.space.Direction;
 import primevc.gui.behaviours.layout.ClippedLayoutBehaviour;
 import primevc.gui.components.ScrollBar;
 import primevc.gui.core.UIContainer;
  using primevc.utils.TypeUtil;



/**
 * Behaviour will add scrollbars to the target if necessary.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 04, 2011
 */
class ShowScrollbarsBehaviour extends ClippedLayoutBehaviour
{
	private var scrollbarHor	: ScrollBar;
	private var scrollbarVer	: ScrollBar;
	
	
	override private function init ()
	{
		super.init();
		
		scrollbarHor = addScrollBar( Direction.horizontal, scrollbarHor );
		scrollbarVer = addScrollBar( Direction.vertical, scrollbarVer );
	}
	
	
	override private function reset ()
	{
		if (scrollbarVer != null)	{ removeScrollBar( scrollbarHor ); scrollbarHor.dispose(); }
		if (scrollbarVer != null)	{ removeScrollBar( scrollbarVer ); scrollbarVer.dispose(); }
		
		scrollbarHor = scrollbarVer = null;
		super.reset();
	}
	
	
	private function addScrollBar (direction:Direction, scrollBar:ScrollBar = null)
	{
		var children	= target.container.children;
		var layout		= target.container.as(UIContainer).layoutContainer.children;
		var depth		= children.indexOf( target ) + 1;
		var layoutDepth	= layout.indexOf( target.layout ) + 1;
		
		if (scrollBar == null)
			scrollBar = new ScrollBar( null, target, direction );
		
		children.add( scrollBar, depth );
		layout.add( scrollBar.layout, layoutDepth );
		
		return scrollBar;
	}
	
	
	private function removeScrollBar (scrollBar:ScrollBar)
	{
		var layout		= target.container.as(UIContainer).layoutContainer.children.remove( scrollBar.layout );
		var children	= target.container.children.remove( scrollBar );
	}
}