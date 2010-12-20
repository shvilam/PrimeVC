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
class InteractiveStyleChangeBehaviour extends BehaviourBase < IUIComponent >
{
	private var overBinding			: Wire < Dynamic >;
	private var outBinding			: Wire < Dynamic >;
	private var globalUpBinding		: Wire < Dynamic >;
	private var downBinding			: Wire < Dynamic >;
	private var upBinding			: Wire < Dynamic >;
	
	private var disabledBinding		: Wire < Dynamic >;
	
	
	private var styleBinding		: Wire < Dynamic >;
	private var mouseState			: StyleState;
	private var disabledState		: StyleState;
	
	
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
		
		if (mouseState != null) {
			mouseState.dispose();
			mouseState = null;
		}
		
		if (disabledState != null) {
			disabledState.dispose();
			disabledState = null;
		}
	}
	
	
	
	
	private function updateBehaviour (changes:UInt) : Void
	{
		//
		// DISABLED STATE
		//
		
		if (changes.has( StyleStateFlags.DISABLED ))
		{
			var hasDisabledState = getStates().has( StyleStateFlags.DISABLED );
			
			if (hasDisabledState)
			{
				if (disabledState == null)		{ disabledState		= target.style.createState(); }
				if (disabledBinding == null)	{ disabledBinding	= changeEnabledState.on( target.enabled.change, this ); changeEnabledState( target.enabled.value, false ); }
			}
			else
			{
				if (disabledState != null)		{ disabledState.dispose();		disabledState = null; }
				if (disabledBinding != null)	{ disabledBinding.dispose();	disabledBinding = null; }
			}
		}
		
		
		//
		// HOVER / DOWN STATE
		//
		
	//	trace(target + ".update; "+getStates().readProperties());
		var hoverChanged	= changes.has( StyleStateFlags.HOVER );
		var downChanged		= changes.has( StyleStateFlags.DOWN );
		
		if (hoverChanged || downChanged)
		{
			var hasHoverState	= getStates().has( StyleStateFlags.HOVER );
			var hasDownState	= getStates().has( StyleStateFlags.DOWN );
		
		
			// MANAGE STATE OBJECT
			if (hasHoverState || hasDownState)
				if (mouseState == null)
					mouseState = target.style.createState();
			else
				if (mouseState != null) {
					mouseState.dispose();
					mouseState = null;
				}
		
		
			// MANAGE HOVER
			if (hoverChanged && !hasHoverState)
			{
				if (mouseState != null && mouseState.current == StyleStateFlags.HOVER)
					mouseState.current = StyleStateFlags.NONE;
			
				removeHoverBindings();
			}
			else if (hasHoverState)
				createHoverBindings();
		
		
			// MANAGE DOWN
			if (downChanged && !hasDownState)
			{
				if (mouseState != null && mouseState.current == StyleStateFlags.DOWN)
					mouseState.current = StyleStateFlags.NONE;
			
				removeDownBindings();
			}
			else if (hasDownState)
				createDownBindings();
		}
	}
	
	
	
	
	//
	// HELPER METHODS
	//
	
	private inline function getEvents ()	{ return target.userEvents.mouse; }
	private inline function getStates ()	{ return target.style.states; }
	
	
	private inline function createHoverBindings ()
	{
		if (overBinding == null)	overBinding	= changeStateToHover.on( getEvents().rollOver,	this );
		if (outBinding == null)		outBinding	= clearMouseState	.on( getEvents().rollOut,	this );
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
		if (globalUpBinding == null)	globalUpBinding	= clearMouseState	.on( target.window.mouse.events.up,	this );
		
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
	
	
	
	
	//
	// CHANGE HANDLERS
	//
	
	private function changeStateToDown ()
	{
		mouseState.current = StyleStateFlags.DOWN;
		
		if (outBinding != null)			outBinding		.disable();
		if (overBinding != null)		overBinding		.disable();
		
		if (upBinding != null)			upBinding		.enable();
		if (globalUpBinding != null)	globalUpBinding	.enable();
		if (downBinding != null)		downBinding		.disable();
	}
	
	
	private function clearMouseState ()
	{
		if (mouseState != null)
		{
			mouseState.current = StyleStateFlags.NONE;
			
			if (outBinding != null)			outBinding		.disable();
			if (overBinding != null)		overBinding		.enable();
			
			if (upBinding != null)			upBinding		.disable();
			if (globalUpBinding != null)	globalUpBinding	.disable();
			if (downBinding != null)		downBinding		.enable();
		}
	}
	
	
	private function changeStateToHover (mouseObj:MouseState)
	{
		if (mouseObj.mouseButton() != MouseButton.None)
			return;
		
		//check if there's a hover state, otherwise change state to none
		mouseState.current = (overBinding != null) ? StyleStateFlags.HOVER : StyleStateFlags.NONE;
		
		if (outBinding != null)			outBinding		.enable();
		if (overBinding != null)		overBinding		.disable();
		
		if (upBinding != null)			upBinding		.disable();
		if (globalUpBinding != null)	globalUpBinding	.disable();
		if (downBinding != null)		downBinding		.enable();
	}
	
	
	private function changeEnabledState (newVal:Bool, oldVal:Bool)
	{
		if (newVal)		disabledState.current = StyleStateFlags.NONE;
		else			disabledState.current = StyleStateFlags.DISABLED;
		
		if (!newVal)
			clearMouseState();
	}
}