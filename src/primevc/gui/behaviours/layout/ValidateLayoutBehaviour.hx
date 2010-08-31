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
 import primevc.core.dispatcher.Wire;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.IUIElement;
 import primevc.gui.states.LayoutStates;
  using primevc.utils.Bind;
 

/**
 * Instance will trigger layout.validate on a 'enterFrame event' when the 
 * layout is invalidated.
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class ValidateLayoutBehaviour extends BehaviourBase < IUIElement >
{
	/**
	 * Reference to the last used enterFrame binding. If the state of a 
	 * layoutclient changes to parentInvalidated, this enterFrame binding
	 * should be removed.
	 */
	private var enterFrameBinding	: Wire <Dynamic>;
	private var renderBinding		: Wire <Dynamic>;
	
	
	override private function init ()
	{
		Assert.that(target.layout != null, "Layout of "+target+" can't be null for "+this);
		
		enterFrameBinding	= measure.on( target.displayEvents.enterFrame, this );
		renderBinding		= applyPosition.on( target.displayEvents.render, this );
		enterFrameBinding.disable();
		renderBinding.disable();
		
		layoutStateChangeHandler.on( target.layout.state.change, this );
#if flash9
		invalidateWindow		.on( target.layout.events.posChanged, this );
#else
		applyPosition			.on( target.layout.events.posChanged, this );
#end
	}
	
	
	override private function reset ()
	{
		enterFrameBinding.dispose();
		renderBinding.dispose();
		
		enterFrameBinding	= null;
		renderBinding		= null;
		
		if (target.layout == null)
			return;
		
		target.layout.state.change.unbind( this );
		target.layout.events.posChanged.unbind( this );
	}
	
	
	private function layoutStateChangeHandler (oldState:LayoutStates, newState:LayoutStates)
	{
	//	trace(target+".layoutStateChangeHandler "+oldState+" -> "+newState);
		switch (newState) {
			case LayoutStates.invalidated:
				enterFrameBinding.enable();
			
			case LayoutStates.measuring:
				enterFrameBinding.disable();
			
			/**
			 * When the state of the layout is changed from invalidated to parent_invalidated so the parent skin
			 * will add a enterFrame to validate this layout as well.
			 */
			case LayoutStates.parent_invalidated:
				enterFrameBinding.disable();
			
			case LayoutStates.validated:
				enterFrameBinding.disable();
		}
	}


	private function measure () {
	//	trace(target+".enterFrame measure");
		enterFrameBinding.disable();
		target.layout.measure();
	}
	
	
	private inline function invalidateWindow ()
	{
		if (target.container == null)
			return;
		
	//	trace(target+".invalidateWindow");
		renderBinding.enable();
		target.window.invalidate();
	}
	
	
	private function applyPosition ()
	{
		renderBinding.disable();
		var l = target.layout;
	//	trace("applyPosition " + target.id + " / " + l + " - pos: " + l.getHorPosition() + ", " + l.getVerPosition() + " - old pos "+target.x+", "+target.y);
		target.x		= l.getHorPosition();
		target.y		= l.getVerPosition();
	}
}