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
 import primevc.gui.behaviours.ValidatingBehaviour;
 import primevc.gui.core.UIWindow;
 import primevc.gui.states.ValidateStates;
  using primevc.utils.Bind;


/**
 * @author Ruben Weijers
 * @creation-date Jul 26, 2010
 */
class WindowLayoutBehaviour extends ValidatingBehaviour < UIWindow >
{
	override private function init ()
	{
		Assert.that(target.layout != null, "Layout of "+target+" can't be null for "+this);
		
#if debug
		target.layout.name = target.id.value+"Layout";
#end
		
		layoutStateChangeHandler.on( target.layout.state.change, this );
		//trigger the event handler for the current state as well
		layoutStateChangeHandler( target.layout.state.current, null );
		
#if flash9
		updateBgSize.on( target.layout.events.sizeChanged, this );
	//	updateBgSize();
#end
	}


	override private function reset ()
	{
		if (target.layout == null)
			return;
		
		target.layout.state.change.unbind( this );
		super.reset();
	}

	
	private function layoutStateChangeHandler (newState:ValidateStates, oldState:ValidateStates)
	{
		switch (newState) {
			case ValidateStates.invalidated:
				target.invalidationManager.add(this);
		}
	}
	
	
	override private function getValidationManager ()	{ return cast target.invalidationManager; }
	override public function validate ()				{ target.layout.validate(); }
	
	
#if flash9
	private function updateBgSize ()
	{
		if (target.graphicData.value != null)
		{
			var l = target.layout;
		//	trace(target+".updateBgSize "+l.bounds);
		//	target.bgShape.width	= l.width;
		//	target.bgShape.height	= l.height;
			target.rect.width		= l.width.value;
			target.rect.height		= l.height.value;
		}
	}	
#end
}