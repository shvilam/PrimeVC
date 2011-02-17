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
 import primevc.gui.events.FocusState;
 import primevc.gui.events.MouseButton;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.styling.StyleState;
 import primevc.gui.styling.StyleStateFlags;
 import primevc.gui.traits.IDropTarget;
 import primevc.gui.traits.ISelectable;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = StyleStateFlags;


/**
 * Behaviour will change the style-state of the component based on 
 * interactions with the mouse/keyboard or any other way of input.
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
	private var selectedBinding		: Wire < Dynamic >;
	private var dragOverBinding		: Wire < Dynamic >;
	private var dragOutBinding		: Wire < Dynamic >;
	private var dragDropBinding		: Wire < Dynamic >;
	
	private var focusInBinding		: Wire < Dynamic >;
	private var focusOutBinding		: Wire < Dynamic >;
	
	private var mouseState			: StyleState;
	private var disabledState		: StyleState;
	private var selectedState		: StyleState;
	private var dragState			: StyleState;
	private var focusState			: StyleState;
	
	
	
	
	override private function init ()
	{
		//FIXME - maybe it's more efficient to disable all the bindings when the target is removed from the stage instead of disposing them..
		removeBindings.onceOn( target.displayEvents.removedFromStage, this );
		
		var states = getStates();
		updateInteractiveStates.on( states.change, this );
		updateInteractiveStates( states.filledProperties );
		
		if (target.is(IDropTarget)) {
			updateDropTargetStates.on( states.change, this );
			updateDropTargetStates( states.filledProperties );
		}
		
		
		if (target.is(ISelectable)) {
			updateSelectionStates.on( states.change, this );
			updateSelectionStates( states.filledProperties );
		}
	}
	
	
	override private function reset ()
	{
		removeBindings();
		target.displayEvents.addedToStage.unbind(this);
		target.displayEvents.removedFromStage.unbind(this);
	}
	
	
	private function removeBindings ()
	{
		removeHoverBindings();
		removeDownBindings();
		removeDragOverBindings();
		removeDisableBinding();
		removeSelectBinding();
		removeFocusBindings();
		
		getStates().change.unbind( this );
		
		if (mouseState != null)		mouseState.dispose();
		if (disabledState != null)	disabledState.dispose();
		if (selectedState != null)	selectedState.dispose();
		if (dragState != null)		dragState.dispose();
		if (focusState != null)		focusState.dispose();
		
		mouseState = disabledState = selectedState = dragState = focusState = null;
		init.onceOn( target.displayEvents.addedToStage, this );
	}
	
	
	
	
	
	/**
	 * Method is called when the available style-states for the target are 
	 * changed and will check if the behaviour should start listening to the
	 * possible interactive events. The states that every interactive object 
	 * can have are:
	 * 		- focus
	 * 		- disabled
	 * 		- hover
	 * 		- down
	 */
	private function updateInteractiveStates (changes:Int) : Void
	{
		var states = getStates();
		
		//
		// DISABLED STATE
		//
		
		if (changes.has( Flags.DISABLED ))
		{
			var hasDisabledState = states.has( Flags.DISABLED );
			
			if (hasDisabledState)
			{
				if (disabledState == null)		{ disabledState		= target.style.createState(); }
				if (disabledBinding == null)	{ disabledBinding	= changeEnabledState.on( target.enabled.change, this ); }
				
				changeEnabledState( target.enabled.value, false );
			}
			else
			{
				if (disabledState != null)		{ disabledState.dispose();		disabledState = null; }
				removeDisableBinding();
			}
		}
		
		
		
		//
		// FOCUS STATE
		//
		
		if (changes.has( Flags.FOCUS ))
		{
			var hasState = states.has( Flags.FOCUS );
			
			if (hasState)
			{
				if (focusState == null)			{ focusState		= target.style.createState(); }
				else							{ clearFocusState( null); /* important to clear the state, otherwise it can stay in focus state after it's added to the stage again */ }
				if (focusInBinding == null)		{ focusInBinding	= enableFocusState.on( target.userEvents.focus, this ); }
				if (focusOutBinding == null)	{ focusOutBinding	= clearFocusState.on( target.userEvents.blur, this ); focusOutBinding.disable(); }
			}
			else
			{
				if (focusState != null)			{ focusState.dispose(); focusState = null; }
				removeFocusBindings();
			}
		}
		
		
		
		//
		// HOVER / DOWN STATE
		//
		
		if (changes.has( Flags.MOUSE_STATES ))
		{
			var hoverChanged	= changes.has( Flags.HOVER );
			var downChanged		= changes.has( Flags.DOWN );
			var hasHoverState	= states.has( Flags.HOVER );
			var hasDownState	= states.has( Flags.DOWN );
		
	
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
				unsetState( mouseState, Flags.HOVER );
				removeHoverBindings();
			}
			else if (hasHoverState)
				createHoverBindings();
	
	
			// MANAGE DOWN
			if (downChanged && !hasDownState)
			{
				unsetState( mouseState, Flags.DOWN );
				removeDownBindings();
			}
			else if (hasDownState)
				createDownBindings();
		}
	}
	
	
	/**
	 * Method is called when the style-states are changed and will check if the
	 * behaviour should start listening for selection changes. This is only
	 * needed when there is an selected style-state defined for the target
	 */
	private function updateSelectionStates (changes:Int)	: Void
	{
		if (changes.has( Flags.SELECTED ))
		{
			var selectable = target.as(ISelectable);
			
			if (getStates().has( Flags.SELECTED ))
			{
				if (selectedState == null)		{ selectedState		= target.style.createState(); }
				if (selectedBinding == null)	{ selectedBinding	= changeSelectedState.on( selectable.selected.change, this ); }
				
				changeSelectedState( selectable.selected.value, false );
			}
			else
			{
				if (selectedState != null)		{ selectedState.dispose();		selectedState = null; }
				removeSelectBinding();
			}
		}
	}
	
	
	/**
	 * Method is called when the style-states are changed and will check if the
	 * behaviour should start listening for drag-drop-events. This is only
	 * needed when there are drag-style-states defined for the target.
	 * 		- drag-over
	 * 		- drag-out	(not used yet)
	 * 		- drag-drop	(not used yet)
	 */
	private function updateDropTargetStates (changes:Int)	: Void
	{
		if (changes.hasNone( Flags.DRAG_STATES ))
			return;
		
		var states	= getStates();
		var target	= target.as(IDropTarget);
		
		if (changes.has( Flags.DRAG_OVER ))
			if (!states.has( Flags.DRAG_OVER ))
			{
				unsetState( dragState, Flags.DRAG_OVER );
				removeDragOverBindings();
			}
			else
			{
				if (dragState == null)			dragState		= target.style.createState();
				if (dragOverBinding == null)	dragOverBinding = changeStateToDragOver	.on( target.dragEvents.over,	this );
				if (dragOutBinding == null)		dragOutBinding	= clearDragState		.on( target.dragEvents.out,		this );
				if (dragDropBinding == null)	dragDropBinding	= clearDragState		.on( target.dragEvents.drop,	this );
			}
	}
	
	
	
	
	//
	// HELPER METHODS
	//
	
	private inline function getEvents ()	{ return target.userEvents.mouse; }
	private inline function getStates ()	{ return target.style.states; }
	
	
	private inline function unsetState (stateObj:StyleState, stateFlag:Int) : Void
	{
		if (stateObj != null && stateObj.current == stateFlag)
			stateObj.current = Flags.NONE;
	}
	
	
	
	
	
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
	
	
	
	
	
	
	private inline function removeDragOverBindings ()
	{
		if (dragOverBinding != null)	dragOverBinding.dispose();
		if (dragOutBinding != null)		dragOutBinding.dispose();
		if (dragDropBinding != null)	dragDropBinding.dispose();
		dragOverBinding = dragOutBinding = dragDropBinding = null;
	}
	
	
	
	
	private inline function removeDisableBinding ()
	{
		if (disabledBinding != null)
		{
			disabledBinding.dispose();
			disabledBinding = null;
		}
	}
	
	
	
	private inline function removeSelectBinding ()
	{
		if (selectedBinding != null)
		{
			selectedBinding.dispose();
			selectedBinding = null;
		}
	}
	
	
	
	private inline function removeFocusBindings ()
	{
		if (focusInBinding != null)		focusInBinding.dispose();
		if (focusOutBinding != null)	focusOutBinding.dispose();
		
		focusOutBinding = focusInBinding = null;
	}
	
	
	
	
	
	//
	// CHANGE HANDLERS
	//
	
	private function changeStateToDown ()
	{
		mouseState.current = Flags.DOWN;
		
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
			mouseState.current = Flags.NONE;
			
			if (outBinding != null)			outBinding		.disable();
			if (overBinding != null)		overBinding		.enable();
			
			if (upBinding != null)			upBinding		.disable();
			if (globalUpBinding != null)	globalUpBinding	.disable();
			if (downBinding != null)		downBinding		.enable();
		}
	}
	
	
	private function changeStateToHover (mouseObj:MouseState)
	{
		if (mouseObj.mouseButton() != MouseButton.None && downBinding != null)
			return;
		
		//check if there's a hover state, otherwise change state to none
		mouseState.current = (overBinding != null) ? Flags.HOVER : Flags.NONE;
		
		if (outBinding != null)			outBinding		.enable();
		if (overBinding != null)		overBinding		.disable();
		
		if (upBinding != null)			upBinding		.enable();
		if (globalUpBinding != null)	globalUpBinding	.enable();
		if (downBinding != null)		downBinding		.enable();
	}
	
	
	private function changeEnabledState (newVal:Bool, oldVal:Bool)
	{
		if (newVal)		disabledState.current = Flags.NONE;
		else			disabledState.current = Flags.DISABLED;
		
		if (!newVal)
			clearMouseState();
	}
	
	
	private function changeSelectedState (newVal:Bool, oldVal:Bool)
	{
		if (newVal)		selectedState.current = Flags.SELECTED;
		else			selectedState.current = Flags.NONE;
	}
	
	
	private function changeStateToDragOver ()	{ dragState.current = Flags.DRAG_OVER; }
	private function clearDragState ()			{ dragState.current = Flags.NONE; }
	
	
	private function enableFocusState (event:FocusState)
	{
		if (!target.isFocusOwner(event.target))
			return;
		
		trace(target);
		focusState.current = Flags.FOCUS;
		focusInBinding.disable();
		focusOutBinding.enable();
	}
	
	
	private function clearFocusState (event:FocusState)
	{
	//	trace(target+" -> "+target.isFocusOwner(event.related));
		if (event != null && target.isFocusOwner(event.related))
			return;
		
		focusState.current = Flags.NONE;
		focusInBinding.enable();
		focusOutBinding.disable();
	}
}