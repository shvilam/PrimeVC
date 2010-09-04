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
package primevc.gui.managers;
 import primevc.gui.display.Window;
 import primevc.gui.traits.IRenderable;
  using primevc.utils.Bind;


/**
 * Manager obj to queue the rendering of all IRenderable's until a render event
 * is fired.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
class RenderManager extends QueueManager < IRenderable, Window >
{
	public function new (owner)
	{
		super(owner);
		updateQueueBinding = renderQueue.on( owner.displayEvents.render, this );
		updateQueueBinding.disable();
	}
	
	
	override private function enableBinding ()
	{
		if (!updateQueueBinding.isEnabled())
			owner.invalidate();
		
		super.enableBinding();
	}
	
	
	private function renderQueue ()
	{
		var item:IRenderable;
		while (queue.length > 0) {
			item = queue.pop();
			item.render();
		}
		
		updateQueueBinding.disable();
	}
}