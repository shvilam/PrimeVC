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
package primevc.gui.behaviours.components;
 import primevc.core.dispatcher.Wire;
 import primevc.core.Bindable;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.UIComponent;
  using primevc.utils.Bind;


/**
 * Behaviour to show a tooltip directly when the user hovers the mouse over
 * the target.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 24, 2011
 */
class DirectToolTipBehaviour extends BehaviourBase<UIComponent>
{
	private var mouseOver	: Wire<Dynamic>;
	private var mouseOut	: Wire<Dynamic>;
	/**
	 * Label to display on roll-over
	 */
	private var label		: Bindable<String>;
	
	
	public function new (target:UIComponent, label:Bindable<String>)
	{
		super(target);
		Assert.notNull(label, "Label can't be null for tooltip of "+target);
		this.label = label;
	}
	
	
	override private function init ()
	{
		Assert.notNull( target.window, "Target "+target+" must be on the stage for this behaviour to work." );
		mouseOver	= showToolTip.on( target.userEvents.mouse.rollOver, this );
		mouseOut	= hideToolTip.on( target.userEvents.mouse.rollOut, this );
	}
	
	
	override private function reset ()
	{
		if (target.window != null)
			hideToolTip();
		
		if (mouseOver != null)	mouseOver.dispose();
		if (mouseOut != null)	mouseOut .dispose();
		mouseOver	= mouseOut = null;
		label		= null;
	}
	
	
	private function showToolTip ()		{ target.system.toolTip.show( target, label ); }
	private function hideToolTip ()		{ target.system.toolTip.hide( target ); }
}