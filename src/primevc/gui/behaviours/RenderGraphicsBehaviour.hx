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
 import primevc.gui.core.IUIComponent;
 import primevc.gui.core.UIWindow;
 import primevc.gui.traits.IDrawable;
 import primevc.gui.traits.IGraphicsValidator;
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
class RenderGraphicsBehaviour extends ValidatingBehaviour < IDrawable >, implements IGraphicsValidator
{
	public function new (target:IDrawable) { super(target); }
	
	
	override private function init ()
	{
		Assert.that( target.layout != null );
		
		if (target.graphicData != null)
		{
			invalidateGraphics.on( target.graphicData.changeEvent, this );
			invalidateGraphics.on( target.displayEvents.addedToStage, this );
			invalidateGraphics();
		}
	}
	
	
	override private function reset ()
	{
		if (target.graphicData != null)
			target.graphicData.changeEvent.unbind( this );
		
		target.displayEvents.addedToStage.unbind( this );
		super.reset();
	}
	
	
	public inline function invalidateGraphics ()
	{
	//	trace(target+" => "+target.graphicData.isEmpty()+"; "+target.graphicData.shape+"; "+target.graphicData.layout);
		if (isOnStage() && !target.graphicData.isEmpty() && !isQueued())
			getValidationManager().add( this );
		
		else if (target.graphicData.isEmpty())
			target.graphics.clear();
	}
	
	
	public function validateGraphics ()
	{
		if (target == null || target.graphics == null) {
			trace(target+".validateGraphics ==> empty target or graphics... ");
			return;
		}
		
		target.graphics.clear();
		target.graphicData.draw( target, false );
		
		if (target.is(IUIComponent) && target.as(IUIComponent).skin != null)
			target.as(IUIComponent).skin.drawGraphics(); //.onceOn( target.displayEvents.enterFrame, this );
	}
	
	
	override private function getValidationManager ()
	{
		return (isOnStage()) ? cast target.window.as(UIWindow).rendering : null;
	}
}