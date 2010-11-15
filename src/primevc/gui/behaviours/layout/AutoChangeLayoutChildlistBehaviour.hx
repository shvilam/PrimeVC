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
 import primevc.core.collections.IList;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.display.IDisplayContainer;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.traits.IDisplayable;
 import primevc.gui.traits.IDraggable;
 import primevc.gui.traits.ILayoutable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * Behaviour to automaticly update the layoutGroup of a component when the 
 * displaylist of the component changes.
 * 
 * LayoutObjects of the children of the component will be added, moved and removed
 * at the same depths as they are placed in the displayList.
 * 
 * For example: 
 * 		uiObj.children.add( someSkin, 3 );
 * 
 * Will cause the layout of someSkin to be added in the layoutGroup of uiObj
 * on depth 3 (uiObj.layoutGroup.children.add(someSkin.layout, 3);).
 * 
 * @author Ruben Weijers
 * @creation-date Jul 28, 2010
 */
class AutoChangeLayoutChildlistBehaviour extends BehaviourBase < IDisplayContainer >
{
	private var layoutGroup		: LayoutContainer;
	
	/**
	 * Number indicating the difference between the number of children the
	 * target and the childList of the layout on the moment that this behaviour
	 * is initialized.
	 * 
	 * This number makes sure that if a child is added on depth 3 and the 
	 * countDifference is 2 that the layout of the child will be added on depth
	 * 2.
	 */
	private var countDifference	: Int;
	
	
	override private function init ()
	{
		Assert.that(target.is(ILayoutable), "Target must be "+target+" must be ILayoutable");
		Assert.that(target.as(ILayoutable).layout.is(LayoutContainer), "Layout of "+target+" must be ILayoutContainer");
		
		layoutGroup		= target.as(ILayoutable).layout.as(LayoutContainer);
		countDifference	= target.children.length - layoutGroup.children.length;
		
		handleChildChange.on( target.children.change, this );
	}
	
	
	override private function reset ()
	{
		layoutGroup = null;
		target.children.change.unbind(this);
	}
	
	
	private function handleChildChange ( change:ListChange < IDisplayObject > )
	{
	//	trace(target+".handleChildChange for layout "+change);
		switch (change)
		{
			case added( child, newPos ):
				if (child.is(IDraggable) && child.as(IDraggable).isDragging)
					return;
				
				if (child.is(ILayoutable))
					addChildToLayout( child.as(ILayoutable), newPos );
				
			
				
			case removed( child, oldPos ):
				if (child.is(ILayoutable))
					removeChildFromLayout( child.as(ILayoutable) );
			
			
			
			case moved( child, newPos, oldPos ):
				if (child.is(ILayoutable))
					moveChildInLayout( child.as(ILayoutable), newPos, oldPos );
			
			
			default:
		}
	//	trace("\t children: "+layoutGroup.children);
	}
	
	
	private inline function addChildToLayout (child:ILayoutable, pos:Int)
	{
		var curPos = layoutGroup.children.indexOf(child.layout);
		pos -= countDifference;
		
		if (pos != curPos)
		{
			if (curPos != -1)	layoutGroup.children.move(child.layout, pos, curPos);
			else				layoutGroup.children.add( child.layout, pos );
		}
	}
	
	
	private inline function removeChildFromLayout (child:ILayoutable) {
		layoutGroup.children.remove( child.layout );
	}
	
	
	private inline function moveChildInLayout (child:ILayoutable, newPos:Int, oldPos:Int) {
		oldPos -= countDifference;	
		newPos -= countDifference;
		layoutGroup.children.move( child.layout, newPos, oldPos );
	}
}