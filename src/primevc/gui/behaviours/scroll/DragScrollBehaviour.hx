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
package primevc.gui.behaviours.scroll;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.traits.IScrollable;
#if !neko
 import primevc.core.dispatcher.Wire;
 import primevc.core.geom.Point;
 import primevc.gui.behaviours.drag.DragHelper;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.input.Mouse;
 import primevc.gui.layout.IScrollableLayout;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
#end


/**
 * Behaviour to scroll by dragging the object.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
class DragScrollBehaviour extends BehaviourBase<IScrollable>, implements IScrollBehaviour
{
#if !neko
	private var layout			: IScrollableLayout;
	private var lastMousePos	: Point;
	private var dragHelper		: DragHelper;
	private var moveBinding		: Wire < Dynamic >;
	
	
	override private function init ()
	{
		Assert.notNull( target.scrollableLayout, "target.layout of "+target+" must be a IScrollableLayout" );
		target.enableClipping();
		
	//	trace(target+".init DragScrollBehaviour "+target.scrollRect);
		layout = target.scrollableLayout;
		checkScrollable.on( layout.changed, this );
		
		dragHelper		= new DragHelper( target, startScrolling, stopScrolling, dragAndScroll );
		moveBinding		= dragAndScroll.on( target.window.mouse.events.move, this );
		moveBinding.disable();
	}
	
	
	override private function reset ()
	{
		dragHelper.dispose();
		moveBinding.dispose();
		
		scrollLayout	= null;
		lastMousePos	= null;
		dragHelper		= null;
		moveBinding		= null;
		target.disableClipping();
	}
	
	
	private function checkScrollable (changes:Int)
	{
		if (changes.hasNone( LayoutFlags.WIDTH_PROPERTIES | LayoutFlags.HEIGHT_PROPERTIES ))
			return;
		
		if (!target.isScrollable || (!scrollLayout.horScrollable() && !scrollLayout.verScrollable()))
			target.userEvents.mouse.down.unbind( this );
		else
			dragHelper.start.on( target.userEvents.mouse.down, this );
	}
	
	
	private function startScrolling (mouseObj:MouseState)
	{
		moveBinding.enable();
		dragAndScroll(mouseObj);
	}


	private function stopScrolling (mouseObj:MouseState)
	{
		moveBinding.disable();
		lastMousePos = null;
	}
	
	
	private function dragAndScroll (mouseObj:MouseState)
	{
		if (mouseObj == null)
			return;
		
		var scrollHor = layout.horScrollable();
		var scrollVer = layout.verScrollable();
		
		if (!scrollHor && !scrollVer)
			return;
		
		if (lastMousePos == null) {
			lastMousePos = ScrollHelper.getLocalMouse(target, mouseObj);
			return;
		}
		
		var mousePos		= ScrollHelper.getLocalMouse(target, mouseObj);
		var mouseDiff		= lastMousePos.subtract(mousePos);
		var newScrollPos	= layout.scrollPos.clone();
		
		if (scrollHor)	newScrollPos.x += mouseDiff.x.roundFloat();
		if (scrollVer)	newScrollPos.y += mouseDiff.y.roundFloat();
		
		lastMousePos = mousePos;
		newScrollPos = layout.validateScrollPosition( newScrollPos );
		scrollLayout.scrollPos.setTo( newScrollPos );
	}
#end
}