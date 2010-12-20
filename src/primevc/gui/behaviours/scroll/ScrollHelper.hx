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
#if !neko
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.events.KeyModState;		// <= needed for typedef TargetType
 import primevc.gui.events.MouseEvents;
 import primevc.gui.layout.IScrollableLayout;
 import primevc.gui.traits.IScrollable;
  using primevc.utils.TypeUtil;
#end



/**
 * Defines some methods that are used by most scroll classes.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
class ScrollHelper
{
#if !neko
	public static function getLocalMouse (target:IScrollable, mouseObj:MouseState)
	{
		Assert.notNull( target );
		Assert.notNull( target.container, "target's container can't be null for "+target);
		Assert.notNull( mouseObj, "MouseObj for "+target+" can't be null" );
		
		var mousePos = (mouseObj.target != target.container.as(TargetType))
							? target.container.as(IDisplayObject).globalToLocal(mouseObj.stage)
							: mouseObj.local;
		
		var scrollLayout = target.scrollableLayout;
		mousePos.x -= scrollLayout.getHorPosition() + scrollLayout.padding.left;
		mousePos.y -= scrollLayout.getVerPosition() + scrollLayout.padding.top;
		return mousePos;
	}	
#end
}