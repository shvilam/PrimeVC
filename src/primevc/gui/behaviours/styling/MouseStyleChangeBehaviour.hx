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
package primevc.gui.behaviours.styling;
 import primevc.core.dispatcher.Wire;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.IUIComponent;
 import primevc.gui.events.MouseButton;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.styling.StyleState;
 import primevc.gui.styling.StyleStateFlags;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;


/**
 * Behaviour will change the style-state of the component based on 
 * interactions with the mouse.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 15, 2010
 */
class MouseStyleChangeBehaviour extends BehaviourBase < IUIComponent >
{
	private var overBinding			: Wire < Dynamic >;
	private var outBinding			: Wire < Dynamic >;
	private var globalUpBinding		: Wire < Dynamic >;
	private var downBinding			: Wire < Dynamic >;
	private var upBinding			: Wire < Dynamic >;
	
	
	private var styleBinding		: Wire < Dynamic >;
	private var state				: StyleState;
	
	
	override private function init ()
	{
		styleBinding = updateBehaviour.on( getStates().change, this );
		updateBehaviour( getStates().filledProperties );
	}
	
	
	override private function reset ()
	{
		removeHoverBindings();
		removeDownBindings();
		
		if (styleBinding != null) {
			styleBinding.dispose();
			styleBinding = null;
		}
		
		removeState();
	}
	
	
	
	
	private function updateBehaviour (changes:UInt) : Void
	{
	//	trace(target + ".update; "+getStates().readProperties());
		var hoverChanged	= changes.has( StyleStateFlags.HOVER );
		var downChanged		= changes.has( StyleStateFlags.DOWN );
		
		if (!hoverChanged && !downChanged)
			return;
		
		var hasHoverState	= getStates().has( StyleStateFlags.HOVER );
		var hasDownState	= getStates().has( StyleStateFlags.DOWN );
		
		
		// MANAGE STATE OBJECT
		if (hasHoverState || hasDownState)
			createState();
		else
			removeState();
		
		
		// MANAGE HOVER
		if (hoverChanged && !hasHoverState)
		{
			if (state != null && state.current == StyleStateFlags.HOVER)
				state.current = StyleStateFlags.NONE;
			
			removeHoverBindings();
		}
		else
			createHoverBindings();
		
		
		// MANAGE DOWN
		if (downChanged && !hasDownState)
		{
			if (state != null && state.current == StyleStateFlags.DOWN)
				state.current = StyleStateFlags.NONE;
			
			removeDownBindings();
		}
		else
			createDownBindings();
	}
	
	
	
	
	//
	// HELPER METHODS
	//
	
	private inline function getEvents ()	{ return target.userEvents.mouse; }
	private inline function getStates ()	{ return target.style.states; }
	
	
	private inline function createHoverBindings ()
	{
		if (overBinding == null)	overBinding	= changeStateToHover.on( getEvents().rollOver,	this );
		if (outBinding == null)		outBinding	= clearState		.on( getEvents().rollOut,	this );
		outBinding.disable();
	}
	
	
	private inline function removeHoverBindings ()
	{
		if (overBinding != null)	overBinding.dispose();
		if (outBinding != null)		outBinding.dispose();
		overBinding = outBinding = null;
	}
	
	
	private inline function createDownBindings ()
	{
		if (downBinding == null)		downBinding		= changeStateToDown	.on( getEvents().down,				this );
		if (upBinding == null)			upBinding		= changeStateToHover.on( getEvents().up,				this );
		if (globalUpBinding == null)	globalUpBinding	= clearState		.on( target.window.mouse.events.up,	this );
		
		globalUpBinding.disable();
		upBinding.disable();
	}
	
	
	private inline function removeDownBindings ()
	{
		if (downBinding != null)		downBinding.dispose();
		if (upBinding != null)			upBinding.dispose();
		if (globalUpBinding != null)	globalUpBinding.dispose();
		downBinding = upBinding = globalUpBinding = null;
	}
	
	
	private inline function removeState ()
	{
		if (state != null)
		{
			target.style.removeState( state );
			state = null;
		}
	}
	
	
	private inline function createState ()
	{
		if (state == null)
			state = target.style.createState();
	}
	
	
	
	
	//
	// CHANGE HANDLERS
	//
	
	private function changeStateToDown ()
	{
		state.current = StyleStateFlags.DOWN;
		downBinding		.disable();
		upBinding		.enable();
		globalUpBinding	.enable();
	}
	
	
	private function clearState ()
	{
		state.current = StyleStateFlags.NONE;
		upBinding		.disable();
		globalUpBinding	.disable();
		outBinding		.disable();
		
		downBinding.enable();
		overBinding.enable();
	}
	
	
	private function changeStateToHover (mouseObj:MouseState)
	{
		if (mouseObj.mouseButton() != MouseButton.None)
			return;
		
		state.current = StyleStateFlags.HOVER;
		overBinding	.disable();
		outBinding	.enable();
	}
}