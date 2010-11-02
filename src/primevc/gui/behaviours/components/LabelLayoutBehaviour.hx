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
 import primevc.core.dispatcher.Wire;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.components.Label;
 import primevc.gui.core.UIWindow;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.states.ValidateStates;
 import primevc.gui.traits.IRenderable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * @author Ruben Weijers
 * @creation-date Nov 01, 2010
 */
class LabelLayoutBehaviour extends BehaviourBase < Label > , implements IRenderable 
{
	private inline function getUIWindow () : UIWindow	{ return target.window.as(UIWindow); }
	
	
	override private function init ()
	{
		if ( target.state.current != target.state.initialized )
			setEventHandlers.onceOn( target.state.initialized.entering, this );
		else
			setEventHandlers();
	}
	
	
	private function setEventHandlers ()
	{
		requestRender	.on( target.layout.events.sizeChanged, this );
		updateLabelSize	.on( target.field.layout.events.sizeChanged, this );
		requestRender();
	}
	
	
	override private function reset ()
	{
		if (target.layout != null)
		{
			target.layout.events.sizeChanged.unbind(this);
			
			var window = getUIWindow();
			if (window != null)
				window.invalidationManager.remove( target.layout );
		}
		
		if (target.field != null && target.field.layout != null)
			target.field.layout.events.sizeChanged.unbind( this );
	}
	
	
	public function requestRender ()
	{
		if (target.window != null)
			getUIWindow().renderManager.add(this);
	}
	
	
	public function render ()
	{
		var targetLayout	= target.layout;
		var fieldLayout		= target.field.layout;
		fieldLayout.width	= targetLayout.width;
		fieldLayout.height	= targetLayout.height;
		
		if (targetLayout.padding != null)
		{
			fieldLayout.x	= targetLayout.padding.left;
			fieldLayout.y	= targetLayout.padding.top;
		}
		else
		{
			fieldLayout.x = fieldLayout.y = 0;
		}
	}
	
	
	private function updateLabelSize ()
	{
		var l = target.layout.as(AdvancedLayoutClient);
	//	trace(target+".updateSize "+target.field.layout.bounds);
		l.measuredWidth		= target.field.layout.width;
		l.measuredHeight	= target.field.layout.height;
	}
}