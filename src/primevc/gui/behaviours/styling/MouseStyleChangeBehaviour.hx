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
  using primevc.utils.Bind;


/**
 * Behaviour will change the style-state of the component based on 
 * interactions with the mouse.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 15, 2010
 */
class MouseStyleChangeBehaviour extends BehaviourBase < IUIComponent >
{
	private var overBinding	: Wire < Dynamic >;
	private var outBinding	: Wire < Dynamic >;
	private var downBinding	: Wire < Dynamic >;
	private var upBinding	: Wire < Dynamic >;
	
	
	override private function init ()
	{
		var events = target.userEvents.mouse;
		
		downBinding	= changeStateToDown	.on( events.down,		this );
		upBinding	= changeStateToHover.on( events.up,			this );
		overBinding	= changeStateToHover.on( events.rollOver,	this );
		outBinding	= clearState		.on( events.rollOut,	this );
		
		clearState();
	}
	
	
	override private function reset ()
	{
		downBinding.dispose();
		upBinding.dispose();
		overBinding.dispose();
		outBinding.dispose();
	}
	
	
	private function changeStateToDown ()
	{
		target.style.state = "down";
		downBinding.disable();
		upBinding.enable();
	}
	
	
	private function clearState ()
	{
		target.style.state = "";
		upBinding.disable();
		outBinding.disable();
		downBinding.enable();
		overBinding.enable();
	}
	
	
	private function changeStateToHover ()
	{
		target.style.state = "hover";
		overBinding.disable();
		outBinding.enable();
	}
}