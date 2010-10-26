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
package primevc.gui.behaviours;
 import primevc.core.dispatcher.Wire;
 import primevc.gui.core.IUIElement;
 import primevc.gui.core.UIWindow;
 import primevc.gui.traits.IDrawable;
 import primevc.gui.traits.IRenderable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * Behaviour that will respond changes in the graphicData and layout of the
 * given target. When one of these who object's changes, it will request a new
 * rendering.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 16, 2010
 */
class RenderGraphicsBehaviour extends BehaviourBase < IDrawable >, implements IRenderable
{
	private var graphicsBinding	: Wire <Dynamic>;
	
	override private function init ()
	{
		Assert.that( target.layout != null );
		sizeChangeHandler.on( target.layout.events.sizeChanged, this );
		updateGraphicBinding.on( target.graphicData.change, this );
		updateGraphicBinding();
		requestRender();
	}
	
	
	override private function reset ()
	{
		if (target.layout == null)
			return;
		
		target.layout.events.sizeChanged.unbind(this);
		
		if (graphicsBinding != null) {
			graphicsBinding.dispose();
			graphicsBinding = null;
		}
	}
	
	
	/**
	 * Event handler which is called when the graphicData property of the target
	 * changes.
	 */
	private inline function updateGraphicBinding ()
	{
		if (graphicsBinding != null) {
			graphicsBinding.dispose();
			graphicsBinding = null;
		}
		
		if (target.graphicData.value != null)
			graphicsBinding = requestRender.on( target.graphicData.value.changeEvent, this );
	}
	
	
	public function requestRender ()
	{
		if (target.window == null || target.graphicData.value == null || target.graphicData.value.isEmpty())
			return;
		
		target.window.as(UIWindow).renderManager.add( this );
	}
	
	
	public function render ()
	{
		target.graphics.clear();
		target.graphicData.value.draw( target, false );
	}
	
	
	private function sizeChangeHandler ()
	{
		var t:IUIElement = target.is(IUIElement) ? target.as(IUIElement) : null;
	//	trace(target+".sizeChanged; "+target.layout.bounds.width+", "+target.layout.bounds.height);
		if (t == null || t.effects == null)
		{
			target.rect.width	= target.layout.bounds.width;
			target.rect.height	= target.layout.bounds.height;
		} else {
			t.effects.playResize();
		}
	}
}