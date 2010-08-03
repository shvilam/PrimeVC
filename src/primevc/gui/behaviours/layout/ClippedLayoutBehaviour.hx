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
package primevc.gui.behaviours.layout;
 import primevc.core.geom.Rectangle;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.IUIContainer;
 import primevc.gui.layout.LayoutContainer;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;
 

/**
 * Clipped layout behaviour will clip a skin that contains a LayoutContainer to the
 * given width and height properties. All children that will fall outside of
 * the layout are not visible (unless the scrollX and scrollY properties of the
 * LayoutContainer is changed.
 * 
 * @creation-date	Jun 25, 2010
 * @author			Ruben Weijers
 */
class ClippedLayoutBehaviour extends BehaviourBase < IUIContainer >
{
	private var layoutContainer : LayoutContainer;
	
	
	/**
	 * Method will add signal-listeners to the layout object of the target to 
	 * listen for changes in the size of the layout. If the size changes, it 
	 * will adjust the scrollRect of the target.
	 */
	override private function init ()
	{
		Assert.that(target.layoutContainer != null, "Layout of "+target+" can't be null for "+this);
		layoutContainer		= target.layoutContainer;
		target.scrollRect	= new Rectangle();
		
		updateScrollRect.on( target.layout.events.sizeChanged, this );
		updateScrollX.on( layoutContainer.scrollPos.xProp.change, this );
		updateScrollY.on( layoutContainer.scrollPos.yProp.change, this );
	}
	
	
	override private function reset ()
	{
		if (target.layout != null)
			target.layout.events.sizeChanged.unbind(this);
		
		layoutContainer.scrollPos.xProp.change.unbind( this );
		layoutContainer.scrollPos.yProp.change.unbind( this );
		target.scrollRect	= null;
		layoutContainer		= null;
	}
	
	
	private function updateScrollRect ()
	{
		var r		= target.scrollRect;
	//	r.x			= layoutContainer.scrollX;
	//	r.y			= layoutContainer.scrollY;
		r.width		= layoutContainer.bounds.width;
		r.height	= layoutContainer.bounds.height;
		
	//	trace("updated scrollRect " + r);
		target.scrollRect = r;
	}


	private function updateScrollX ()
	{
		var r	= target.scrollRect;
		r.x		= layoutContainer.scrollPos.x;
		target.scrollRect = r;
	}
	
	
	private function updateScrollY ()
	{
		var r	= target.scrollRect;
		r.y		= layoutContainer.scrollPos.y;
		target.scrollRect = r;
	}
}