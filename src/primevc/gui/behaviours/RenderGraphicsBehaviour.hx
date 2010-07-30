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
 import primevc.gui.core.ISkin;
  using primevc.utils.Bind;


/**
 * Class description
 * 
 * @author Ruben Weijers
 * @creation-date Jul 16, 2010
 */
class RenderGraphicsBehaviour extends BehaviourBase < ISkin >
{
	private var renderBinding : Wire <Dynamic>;
	
	
	override private function init ()
	{
			if (target.layout == null)
				return;
			
#if flash9	invalidateWindow.on( target.layout.events.sizeChanged, this );
#else		renderTarget.on( target.layout.events.sizeChanged, this );
#end
	}
	
	
	override private function reset ()
	{
		if (target.layout == null)
			return;
		
		target.layout.events.sizeChanged.unbind(this);
		if (renderBinding != null) {
			renderBinding.dispose();
			renderBinding = null;
		}
	}
		
	
	private function invalidateWindow ()
	{
		if (target.container == null)
			return;
		
	//	trace("invalidateWindow "+target);
		target.window.invalidate();
		renderBinding = renderTarget.on( target.displayEvents.render, this );
	//	target.render.on( target.displayEvents.enterFrame, this );
	}
	
	
	private function renderTarget ()
	{
		if (renderBinding == null)
			return;
		
		renderBinding.dispose();
		renderBinding = null;
	//	trace("render "+target+" size: "+target.layout.bounds.width+", "+target.layout.bounds.height);
		target.displayEvents.render.unbind( this );
		target.render();
	}
}