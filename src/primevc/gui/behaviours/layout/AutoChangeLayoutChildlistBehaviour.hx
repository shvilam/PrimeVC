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
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.IUIContainer;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.traits.IDisplayable;
 import primevc.gui.traits.ILayoutable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * Behaviour to automaticly update the layoutGroup of a Skin when the display-
 * list of this skin changes.
 * 
 * LayoutObjects of the children of the skin will be added, moved and removed
 * at the same depths as they are placed in the displayList.
 * 
 * For example: 
 * 		skinObj.children.add( someSkin, 3 );
 * 
 * Will cause the layout of someSkin to be added in the layoutGroup of skinObj
 * on depth 3 (skinObj.layoutGroup.children.add(someSkin.layout, 3);).
 * 
 * @author Ruben Weijers
 * @creation-date Jul 28, 2010
 */
class AutoChangeLayoutChildlistBehaviour extends BehaviourBase < IUIContainer >
{
	private var layoutGroup	: LayoutContainer;
	
	
	override private function init ()
	{
		Assert.that(target.layoutContainer != null, "Layout of "+target+" can't be null for "+this);
		layoutGroup = target.layoutContainer;
		
		addedHandler	.on( target.children.events.added, this );
		removedHandler	.on( target.children.events.removed, this );
		movedHandler	.on( target.children.events.moved, this );
	}
	
	
	override private function reset ()
	{
		layoutGroup = null;
		target.children.events.added.unbind(this);
		target.children.events.removed.unbind(this);
		target.children.events.moved.unbind(this);
	}
	
	
	private function addedHandler (child:IDisplayable, pos:Int) {
		if (child.is(ILayoutable))	addChildToLayout( child.as(ILayoutable), pos );
	}
	private function movedHandler (child:IDisplayable, newPos:Int, oldPos:Int) {
		if (child.is(ILayoutable))	moveChildInLayout( child.as(ILayoutable), newPos, oldPos );
	}
	private function removedHandler (child:IDisplayable, pos:Int) {
		if (child.is(ILayoutable))	removeChildFromLayout( child.as(ILayoutable) );
	}
	
	
	private inline function addChildToLayout (child:ILayoutable, pos:Int)
	{
		var curPos = layoutGroup.children.indexOf(child.layout);
		if (curPos != -1)
			layoutGroup.children.move(child.layout, pos, curPos);
		else
			layoutGroup.children.add( child.layout, pos );
	}
	
	
	private inline function removeChildFromLayout (child:ILayoutable) {
		layoutGroup.children.remove( child.layout );
	}
	
	
	private inline function moveChildInLayout (child:ILayoutable, newPos:Int, oldPos:Int) {
		layoutGroup.children.move( child.layout, newPos, oldPos );
	}
}