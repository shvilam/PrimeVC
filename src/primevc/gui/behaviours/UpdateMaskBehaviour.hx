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
 import primevc.gui.core.IUIElement;
 import primevc.gui.core.UIWindow;
 import primevc.gui.display.Shape;
 import primevc.gui.traits.IDrawable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * Behavior will draw and update the given shape to fit the given mirror object.
 * It will redraw the shape when the mirror object changes of size or when it's
 * graphicProperties change.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 09, 2010
 */
class UpdateMaskBehaviour extends ValidatingBehaviour < Shape >
{
	private var mirror : IDrawable;
	
	
	public function new (target:Shape, mirror:IDrawable)
	{
		super(target);
		this.mirror = mirror;
	}
	
	
	override private function init ()
	{
		if (mirror.graphicData != null)
		{
			requestRender.on( mirror.graphicData.changeEvent, this );
			requestRender();
		}
	}
	
	
	override private function reset ()
	{
		if (mirror.graphicData != null)
			mirror.graphicData.changeEvent.unbind( this );
		
		mirror = null;
		super.reset();
	}
	
	
	public function requestRender ()
	{
		if (target.window == null || mirror.graphicData.isEmpty())
			return;
		
		getValidationManager().add( this );
	}
	
	
	override public function validate ()
	{
		target.graphics.clear();
		mirror.graphicData.draw( target, false );
	}
	
	
	override private function getValidationManager ()
	{
		return (target.window != null) ? cast target.window.as(UIWindow).renderManager : null;
	}
}