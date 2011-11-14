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
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.traits.IScrollable;
#if !neko
 import primevc.core.geom.space.Direction;
 import primevc.core.geom.Box;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.components.ScrollBar;
// import primevc.gui.core.IUIContainer;
 import primevc.gui.layout.IScrollableLayout;
 import primevc.gui.layout.LayoutFlags;
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
class ShowScrollbarsBehaviour extends BehaviourBase<IScrollable>, implements IScrollBehaviour
{
#if !neko
	private static inline var SIZE = 15;
	
	private var scrollbarHor	: ScrollBar;
	private var scrollbarVer	: ScrollBar;
	
	private var layout : IScrollableLayout;
	
	
	override private function init ()
	{
		layout = target.scrollableLayout;
		target.enableClipping();
		checkIfScrollbarsNeeded.on( layout.changed, this );
	}
	
	
	override private function reset ()
	{
		layout.changed.unbind(this);
		
		if (scrollbarVer != null)	{ removeScrollBar( scrollbarHor ); scrollbarHor.dispose(); }
		if (scrollbarVer != null)	{ removeScrollBar( scrollbarVer ); scrollbarVer.dispose(); }
		
		scrollbarHor = scrollbarVer = null;
		target.disableClipping();
	}
	
	
	private function addScrollBar (direction:Direction, scrollBar:ScrollBar = null)
	{
		var depth = target.is(IDisplayObject) ? target.container.children.indexOf( target.as(IDisplayObject) ) + 1 : target.container.children.length;
		
		if (scrollBar == null)
			scrollBar = new ScrollBar( null, target, direction );
		else
			scrollBar.target = target;
		
		var l = layout;
		l.invalidatable = false;
		l.padding 		= l.padding.clone().as(Box);	// make sure the layout has a new padding box.. it could be shared with other components
		
		// use hardcoded width value, because the width of scrollbar is not yet available... FIXME
		if (direction == horizontal) {
			l.padding.bottom += SIZE;
			l.invalidateVerPaddingMargin();
		} else {
			l.padding.right += SIZE;
			l.invalidateHorPaddingMargin();
		}
		l.invalidatable = true;
		
		scrollBar.attachToDisplayList( target.container, depth );
	//	layout.add( scrollBar.layout, layoutDepth );
		
		return scrollBar;
	}
	
	
	private function removeScrollBar (scrollBar:ScrollBar)
	{
	//	parentLayout.children.remove( scrollBar.layout );
		scrollBar.detachDisplay();
	//	target.container.children.remove( scrollBar );
		scrollBar.target = null;
		
		var l = layout;
		l.invalidatable = false;
		// use hardcoded width value, because the width of scrollbar is not yet available... FIXME
		if (scrollBar.direction == horizontal) {
			l.padding.bottom -= SIZE;
			l.invalidateVerPaddingMargin();
		} else {
			l.padding.right -= SIZE;
			l.invalidateHorPaddingMargin();
		}
		l.invalidatable = true;
	}
	
	
	private function checkIfScrollbarsNeeded (changes:Int)
	{
		if (changes.hasNone( LayoutFlags.WIDTH_PROPERTIES | LayoutFlags.HEIGHT_PROPERTIES | LayoutFlags.POSITION ))
			return;

	//	trace(target+": mw: "+layout.measuredWidth+", ew "+layout.explicitWidth+"; w "+layout.width+"; mh "+layout.measuredHeight+", eh "+layout.explicitHeight+"; h "+layout.height);
		var hasHorScrollbar		= scrollbarHor != null && scrollbarHor.container == target.container;
		var needHorScrollbar	= layout.horScrollable();
		var hasVerScrollbar		= scrollbarVer != null && scrollbarVer.container == target.container;
		var needVerScrollbar	= layout.verScrollable();
		
		//check horizontal
		if		(hasHorScrollbar && !needHorScrollbar)		removeScrollBar( scrollbarHor );
		else if (!hasHorScrollbar && needHorScrollbar)		scrollbarHor = addScrollBar( Direction.horizontal, scrollbarHor );
		
		//check vertically
		if		(hasVerScrollbar && !needVerScrollbar)		removeScrollBar( scrollbarVer );
		else if (!hasVerScrollbar && needVerScrollbar)		scrollbarVer = addScrollBar( Direction.vertical, scrollbarVer );
		
		
		if (needHorScrollbar || needVerScrollbar)
		{
			Assert.that(!layout.hasEmptyPadding());
			var l = layout;
			var bounds		= l.innerBounds;
		//	var maxBounds	= l.parent.innerBounds;
			
			var width		= bounds.width; //IntMath.min(bounds.width, maxBounds.width);
			var height		= bounds.height; //IntMath.min(bounds.height, maxBounds.height);
			
		
			//update position and size of the scrollbars
			if (needHorScrollbar)
			{
				var scrollBar		= scrollbarHor.layout.outerBounds;
				scrollBar.invalidatable = false;
				scrollBar.width		= width - (needVerScrollbar ? scrollbarVer.layout.outerBounds.width : 0);
				scrollBar.bottom	= l.getVerPosition() + height; // - scrollBar.height;
				scrollBar.left		= l.getHorPosition();
				scrollBar.invalidatable = true;
			}	
		
			if (needVerScrollbar)
			{
				var scrollBar	= scrollbarVer.layout.outerBounds;
				//update padding to keep an empty space at the bottom of the bar with the height of the horizontal scrollbar
				scrollbarVer.layout.padding.bottom = needHorScrollbar ? scrollbarHor.layout.outerBounds.height : 0;
			
				scrollBar.invalidatable = false;
				scrollBar.height	= height;
				scrollBar.right		= l.getHorPosition() + width; // - scrollBar.width;
				scrollBar.top		= l.getVerPosition();
				scrollBar.invalidatable = true;
			
			//	trace(scrollBar.left+", "+scrollBar.top+"; "+width+', '+height);
			}
		}
	}
#end
}