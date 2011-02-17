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
 import primevc.gui.behaviours.layout.ClippedLayoutBehaviour;
#if !neko
 import primevc.core.geom.space.Direction;
 import primevc.core.geom.Box;
 import primevc.gui.components.ScrollBar;
 import primevc.gui.layout.ILayoutContainer;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.traits.ILayoutable;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;
#end



/**
 * Behaviour will add scrollbars to the target if necessary.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 04, 2011
 */
class ShowScrollbarsBehaviour extends ClippedLayoutBehaviour
{
#if !neko
	private static inline var SIZE = 15;
	
	private var scrollbarHor	: ScrollBar;
	private var scrollbarVer	: ScrollBar;
	
//	private var parentLayout	: ILayoutContainer;
	
	
	override private function init ()
	{
		super.init();
		
		Assert.that( target.container.is(ILayoutable) );
		var parent = target.container.as(ILayoutable);
		Assert.that( parent.layout.is(ILayoutContainer) );
	//	parentLayout = target.layout.parent; //parent.layout.as(ILayoutContainer);
		
		checkIfScrollbarsNeeded.on( layoutContainer.changed, this );
	}
	
	
	override private function reset ()
	{
		layoutContainer.changed.unbind(this);
		
		if (scrollbarVer != null)	{ removeScrollBar( scrollbarHor ); scrollbarHor.dispose(); }
		if (scrollbarVer != null)	{ removeScrollBar( scrollbarVer ); scrollbarVer.dispose(); }
		
		scrollbarHor = scrollbarVer = null;
		super.reset();
	}
	
	
	private function addScrollBar (direction:Direction, scrollBar:ScrollBar = null)
	{
		var children	= target.container.children;
		var depth		= children.indexOf( target ) + 1;
	//	var layout		= parentLayout.children;
	//	var layoutDepth	= layout.indexOf( target.layout ) + 1;
		
		if (scrollBar == null)
			scrollBar = new ScrollBar( null, target, direction );
		else
			scrollBar.target = target;
		
		var l = target.layout;
		if (l.padding == null)
			l.padding = new Box();
		
		// use hardcoded width value, because the width of scrollbar is not yet available... FIXME
		if (direction == horizontal) {
			l.padding.bottom += SIZE;
			l.invalidateVerPaddingMargin();
		} else {
			l.padding.right += SIZE;
			l.invalidateHorPaddingMargin();
		}
		
		
		children.add( scrollBar, depth );
	//	layout.add( scrollBar.layout, layoutDepth );
		
		return scrollBar;
	}
	
	
	private function removeScrollBar (scrollBar:ScrollBar)
	{
	//	parentLayout.children.remove( scrollBar.layout );
		target.container.children.remove( scrollBar );
		scrollBar.target = null;
		
		var l = target.layout;
		// use hardcoded width value, because the width of scrollbar is not yet available... FIXME
		if (scrollBar.direction == horizontal) {
			l.padding.bottom -= SIZE;
			l.invalidateVerPaddingMargin();
		} else {
			l.padding.right -= SIZE;
			l.invalidateHorPaddingMargin();
		}
	}
	
	
	private function checkIfScrollbarsNeeded (changes:Int)
	{
	//	trace(target+": "+layoutContainer.measuredWidth+", "+layoutContainer.explicitWidth+"; "+layoutContainer.width+"; "+layoutContainer.measuredHeight+", "+layoutContainer.explicitHeight+"; "+layoutContainer.height);
		if (changes.hasNone( LayoutFlags.WIDTH_PROPERTIES | LayoutFlags.HEIGHT_PROPERTIES ))
			return;
		
		var hasHorScrollbar		= scrollbarHor != null && scrollbarHor.container == target.container;
		var needHorScrollbar	= layoutContainer.horScrollable();
		var hasVerScrollbar		= scrollbarVer != null && scrollbarVer.container == target.container;
		var needVerScrollbar	= layoutContainer.verScrollable();
		
		//check horizontal
		if		(hasHorScrollbar && !needHorScrollbar)		removeScrollBar( scrollbarHor );
		else if (!hasHorScrollbar && needHorScrollbar)		scrollbarHor = addScrollBar( Direction.horizontal, scrollbarHor );
		
		//check vertically
		if		(hasVerScrollbar && !needVerScrollbar)		removeScrollBar( scrollbarVer );
		else if (!hasVerScrollbar && needVerScrollbar)		scrollbarVer = addScrollBar( Direction.vertical, scrollbarVer );
		
		
		var l = target.layout;
		
		//update position and size of the scrollbars
		if (needHorScrollbar)
		{
			var scrollBar	= scrollbarHor.layout.outerBounds;
			var bounds		= l.innerBounds;
			
			scrollBar.invalidatable = false;
			scrollBar.width		= bounds.width - (needVerScrollbar ? scrollbarVer.layout.outerBounds.width : 0);
			scrollBar.top		= l.getVerPosition() + bounds.height - scrollBar.height;
			scrollBar.left		= l.getHorPosition();
			scrollBar.invalidatable = true;
		}	
		
		if (needVerScrollbar)
		{
			var scrollBar	= scrollbarVer.layout.outerBounds;
			var bounds		= l.innerBounds;
			
			//update padding to keep an empty space at the bottom of the bar with the height of the horizontal scrollbar
			scrollbarVer.layout.padding.bottom = needHorScrollbar ? scrollbarHor.layout.outerBounds.height : 0;
			
			scrollBar.invalidatable = false;
			scrollBar.height	= bounds.height;
			scrollBar.left		= l.getHorPosition() + bounds.width - scrollBar.width;
			scrollBar.top		= l.getVerPosition();
			scrollBar.invalidatable = true;
		}
	}
#end
}