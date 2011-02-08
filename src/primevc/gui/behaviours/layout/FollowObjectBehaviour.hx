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
package primevc.gui.behaviours.layout;
 import primevc.core.dispatcher.Wire;
 import primevc.core.geom.Point;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.IUIElement;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.traits.ILayoutable;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberMath;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;



/**
 * Behaviour allows the target to follow the position of another UIElement, 
 * even when it's in a different display-container.
 * 
 * This behaviour is usefull for popup's like the selectionmenu of the combobox.
 * The selectionmenu is placed on top of all other UIElements but should still
 * be above the combobox button (also when it changes it's position).
 * 
 * On default, the behaviour will place the target-element on the left-top 
 * corner of the followed object, but by using the relative layout-properties
 * 
 * @author Ruben Weijers
 * @creation-date Jan 18, 2011
 */
class FollowObjectBehaviour extends BehaviourBase<IUIElement>
{
	private var followedElement : IUIElement;
	
	private var followedLayoutBinding	: Wire<Dynamic>;
	private var containerLayoutBinding	: Wire<Dynamic>;
	private var targetLayoutBinding		: Wire<Dynamic>;
	
	
	public function new (target:IUIElement, followedElement:IUIElement)
	{
		super(target);
		this.followedElement = followedElement;
	}
	
	
	override private function init ()
	{
		Assert.notNull(followedElement, "followed-element can't be null for "+target);
		followedLayoutBinding	= checkChanges			.on( followedElement.layout.changed,					this );
		containerLayoutBinding	= checkChanges			.on( target.container.as(ILayoutable).layout.changed,	this );
		targetLayoutBinding		= checkTargetChanges	.on( target.layout.changed,								this );
		
		updateTarget	.on( target.displayEvents.addedToStage, this );
		disableWires	.on( target.displayEvents.removedFromStage, this );
		
		if (target.window == null)	disableWires();
		else						updateTarget();
	}
	
	
	override private function reset ()
	{
		followedLayoutBinding	.dispose();
		containerLayoutBinding	.dispose();
		targetLayoutBinding		.dispose();
		
		var e = target.displayEvents;
		e.addedToStage.unbind( this );
		e.removedFromStage.unbind( this );
		followedElement = null;
	}
	
	
	private function disableWires ()
	{
		followedLayoutBinding	.disable();
		containerLayoutBinding	.disable();
		targetLayoutBinding		.disable();
	}
	
	
	private function updateTarget ()
	{
		followedLayoutBinding	.enable();
		containerLayoutBinding	.enable();
		targetLayoutBinding		.enable();
		updatePosition();
	}
	
	
	/**
	 * Method will check the given layoutflags for position-changes. If the
	 * position is changed, it will update the position of the target
	 */
	private function checkChanges (changes:Int)
	{
		if (changes.has( LayoutFlags.POSITION | LayoutFlags.SIZE ))
			updatePosition();
	}
	
	
	/**
	 * Method is called when the target's layout is changed and will update
	 * it's position if the relative properties or size is changed.
	 */
	private function checkTargetChanges (changes:Int)
	{
		if (changes.has( LayoutFlags.SIZE | LayoutFlags.RELATIVE ))
			updatePosition();
	}
	
	
	private function updatePosition ()
	{
		Assert.notNull(target.window, target+"");
		
		var layout		= target.layout;
		var bounds		= layout.outerBounds;
		var follow		= followedElement.layout.innerBounds;
		var relative	= layout.relative;
		var newPos		= new Point( followedElement.x, followedElement.y );
		
		if (relative != null)
		{
			if		(relative.left.isSet())		newPos.x += relative.left;
			else if (relative.right.isSet())	newPos.x += follow.width - relative.right;
			else if (relative.hCenter.isSet())	newPos.x += ((follow.width - bounds.width) >> 1) + relative.hCenter;
			
			if		(relative.top.isSet())		newPos.y += relative.top;
			else if (relative.bottom.isSet())	newPos.y += follow.height - relative.bottom;
			else if (relative.vCenter.isSet())	newPos.y += ((follow.height - bounds.height) >> 1) + relative.vCenter;
		}
		
#if flash9
		newPos		= followedElement.container.localToGlobal( newPos );
		var right	= newPos.x + bounds.width;
		var bottom	= newPos.y + bounds.height;
		var stageW	= target.window.target.stageWidth;
		var stageH	= target.window.target.stageHeight;
		
		if		(newPos.x < 0)			newPos.x = 0;
		else if (newPos.x > stageW)		newPos.x = stageW - bounds.width;
		if		(newPos.y < 0)			newPos.y = 0;
		else if (newPos.y > stageH)		newPos.y = stageH - bounds.height;
		newPos = target.container.globalToLocal( newPos );
#end
		
		target.y = bounds.top	= newPos.y.roundFloat();
		target.x = bounds.left	= newPos.x.roundFloat();
	//	trace(bounds+"; r: "+relative);
	}
}