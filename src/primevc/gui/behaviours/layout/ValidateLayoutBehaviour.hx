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
 import primevc.gui.core.UIWindow;
 import primevc.gui.states.ValidateStates;
 import primevc.gui.traits.IRenderable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;
 

/**
 * Instance will trigger layout.validate on a 'enterFrame event' when the 
 * layout is invalidated.
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class ValidateLayoutBehaviour extends BehaviourBase < IUIElement >, implements IRenderable
{
	private var isNotPositionedYet : Bool;
	
	private inline function getUIWindow () : UIWindow	{ return target.window.as(UIWindow); }
	
	
	override private function init ()
	{
		isNotPositionedYet = true;
		Assert.that(target.layout != null, "Layout of "+target+" can't be null for "+this);
		
#if debug
		target.layout.name = target.id.value+"Layout";
#end
		
		layoutStateChangeHandler.on( target.layout.state.change, this );
		requestRender.on( target.layout.events.posChanged, this );
	//	requestRender.on( target.layout.events.sizeChanged, this );
	}
	
	
	override private function reset ()
	{
		if (target.layout == null)
			return;
		
		var window = getUIWindow();
		
		if (window != null)
			window.invalidationManager.remove( target.layout );
		target.layout.state.change.unbind( this );
		target.layout.events.posChanged.unbind( this );
	}
	
	
	private function layoutStateChangeHandler (oldState:ValidateStates, newState:ValidateStates)
	{
		switch (newState)
		{
			case ValidateStates.invalidated:
				if (target.window != null)
					getUIWindow().invalidationManager.add( target.layout );
			
			case ValidateStates.parent_invalidated:
				if (oldState == ValidateStates.invalidated)
					getUIWindow().invalidationManager.remove( target.layout );
		}
	}
	
	
	public inline function requestRender ()
	{
		if (target.window != null)
			getUIWindow().renderManager.add(this);
	}
	
	
	public inline function render ()
	{
		var l = target.layout;
	//	trace(target+".applyPosition; " + l + " - pos: " + l.getHorPosition() + ", " + l.getVerPosition() + " - old pos "+target.x+", "+target.y);
		if (target.effects == null || isNotPositionedYet)
		{
			target.x	= target.rect.left	= l.getHorPosition();
			target.y	= target.rect.top	= l.getVerPosition();
			isNotPositionedYet = false;
		} else {
			target.effects.playMove();
		}
	}
}