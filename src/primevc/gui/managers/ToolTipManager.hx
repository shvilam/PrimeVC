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
	public function show (obj:UIComponent, label:Bindable<String>)
	{
		removeListeners();

#if debug
		Assert.notNull(obj, "Target object can't be null with label "+label);
		Assert.notNull(label, "Tooltip-label can't be null for object "+obj);
#end
		
		lastObj		= obj;
		lastLabel	= label;
		
		//move tooltip to right position
		updatePosition();
		
		//enable mouse-follower
		mouseMove.enable();
		
		//give label the correct text
		toolTip.data.bind( label );
		targetRemovedHandler.on( obj.displayEvents.removedFromStage, this );
		
		if (!isVisible())
			window.children.add( toolTip );
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
	
	
	private inline function removeListeners ()
	{
		if (lastObj != null)	lastObj.displayEvents.removedFromStage.unbind( this );
		if (lastLabel != null)	toolTip.data.unbind( lastLabel );
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
		toolTip.x = window.mouse.x + 5;
		toolTip.y = window.mouse.y - toolTip.height - 5;
	}
	
	
	private function targetRemovedHandler ()
	{
		hide(lastObj);
	}
}