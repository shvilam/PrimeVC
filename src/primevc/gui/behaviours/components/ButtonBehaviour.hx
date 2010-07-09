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
package primevc.gui.behaviours.components;
 import primevc.gui.behaviours.Behaviour;
 import primevc.gui.core.UIComponent;
 import primevc.gui.states.ButtonStates;


typedef ButtonObject = { >UIComponent,
	var buttonStates : ButtonStates;
}


/**
 * Behaviour that will bind the states of a button to the default 
 * Mouse-events.
 * 
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
class ButtonBehaviour extends Behaviour < ButtonObject >
{
	override private function init ()
	{
		var states = target.buttonStates;
		var events = target.skin.userEvents.mouse;
		
		states.changeOn( events.down,		states.down );
		states.changeOn( events.up,			states.hover );
		states.changeOn( events.rollOver,	states.hover );
		states.changeOn( events.rollOut,	states.normal );
	}
	
	
	override private function reset ()
	{
		var states = target.buttonStates;
		var events = target.skin.userEvents.mouse;
		
		//FIXME: Dit ruimt alle handlers op van "states". Als er 2 behaviours gekoppeld zijn aan hetzelfde states object gaat de boel kaput.
		events.down.unbind( states );
		events.up.unbind( states );
		events.rollOver.unbind( states );
		events.rollOut.unbind( states );
	}
}