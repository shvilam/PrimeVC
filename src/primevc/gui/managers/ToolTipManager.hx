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
package primevc.gui.managers;
 import primevc.core.dispatcher.Wire;
 import primevc.core.traits.IDisposable;
 import primevc.core.Bindable;
 import primevc.gui.components.Label;
 import primevc.gui.core.UIComponent;
 import primevc.gui.core.UIWindow;
  using primevc.utils.Bind;


/**
 * Class for centralizing the use of tooltips.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 24, 2011
 */
class ToolTipManager implements IDisposable
{
	private var toolTip 	: Label;
	private var window		: UIWindow;
	
	private var lastLabel	: Bindable<String>;
	private var lastObj		: UIComponent;
	
	private var mouseMove	: Wire<Dynamic>;
	
	
	public function new (window:UIWindow)
	{
		toolTip		= new Label("toolTip");
		this.window	= window;
		
		mouseMove	= updatePosition.on( window.mouse.events.move, this );
		mouseMove.disable();
		
		toolTip.enabled.value = false;
	}
	
	
	public function dispose ()
	{
		hide();
		removeListeners();
		mouseMove.dispose();
		toolTip.dispose();
		
		mouseMove	= null;
		toolTip		= null;
		window		= null;
	}
	
	
	/**
	 * Method will enable the tooltip for the given obj with the given label.
	 * When the tooltip is enabled, it will also start following the mouse.
	 */
	@:keep public function show (obj:UIComponent, label:Bindable<String>)
	{
		removeListeners();

#if debug
		Assert.notNull(obj, "Target object can't be null with label "+label);
		Assert.notNull(label, "Tooltip-label can't be null for object "+obj);
#end
		
		if (isLabelEmpty(label.value))
		{
			hide();
			showAfterChange.onceOn( label.change, this );
		}
		else
		{
			//enable mouse-follower
			mouseMove.enable();
		
			//give label the correct text
		//	toolTip.data.bind( label );		//don't bind.. if the change event is dispatched manually (without calling Bindable.setValue), the tooltip won't update	
			toolTip.data.value = label.value;
			updateToolTip.on( label.change, this );
			
			//move tooltip to right position
			updatePosition();
			
			if (!isVisible())
				window.children.add( toolTip );
		}
		
		lastObj		= obj;
		lastLabel	= label;
		targetRemovedHandler.on( obj.displayEvents.removedFromStage, this );
	}
	
	
	
	/**
	 * method will hide the tooltip. If 'obj' is given, the method will only
	 * hide the tooltip if 'obj' is the current hovered object.
	 */
	public function hide (?obj:UIComponent)
	{
		if (obj != null && obj != lastObj)
			return;
		
		removeListeners();
		mouseMove.disable();
		
		lastObj		= null;
		lastLabel	= null;
		
		if (isVisible())
			window.children.remove( toolTip );
	}
	
	
	private inline function isLabelEmpty (label:String)
	{
		return label == "" || label == null;
	}
	
	
	/**
	 * Method is called when the tooltip of the lastObj is changed and the 
	 * previous value of the tooltip was empty
	 */
	private function showAfterChange ()
	{
		show(lastObj, lastLabel);
	}
	
	
	private inline function removeListeners ()
	{
		if (lastObj != null)
			lastObj.displayEvents.removedFromStage.unbind( this );
		
		if (lastLabel != null) {
		//	toolTip.data.unbind( lastLabel );
			lastLabel.change.unbind(this);
		}
	}
	
	
	
	public inline function isVisible ()
	{
		return toolTip.window != null;
	}
	
	
	//
	// EVENTHANDLERS
	//
	
	private function updatePosition ()
	{
		var newX	= window.mouse.x + 5;
		var newY	= window.mouse.y - 5 + toolTip.height;
		var bounds	= window.layout.innerBounds;
		
		if		(newX < bounds.left)						newX = 0;
		else if ((newX + toolTip.width) > bounds.right)		newX = bounds.right - toolTip.width;
		if		(newY < bounds.top)							newY = 0;
		else if ((newY + toolTip.height) > bounds.bottom)	newY = bounds.bottom - toolTip.height;
		
		toolTip.x = newX;
		toolTip.y = newY; // - toolTip.height - 5;
	//	trace(newX+", "+newY);
	}
	
	
	private function targetRemovedHandler ()
	{
		hide(lastObj);
		toolTip.x = toolTip.y = -400;
	}
	
	
	private function updateToolTip (newVal:String, oldVal:String)
	{
		toolTip.data.value = newVal;
	}
}