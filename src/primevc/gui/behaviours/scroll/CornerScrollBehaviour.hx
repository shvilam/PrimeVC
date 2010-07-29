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
package primevc.gui.behaviours.scroll;
 import primevc.core.dispatcher.Wire;
 import primevc.core.geom.IntPoint;
 import primevc.gui.events.MouseEvents;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;
  using Math;
  using Std;



/**
 * Behaviour to enable scrolling when the mouse moves out of the center of
 * the object. The further to mouse will go to a corner, the faster the 
 * scrolling will go.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
class CornerScrollBehaviour extends MouseScrollBehaviourBase
{
	private var scrollSpeed		: IntPoint;
	private var scrollBinding	: Wire < Dynamic >;
	
	
	override private function reset () {
		super.reset();
		scrollBinding.dispose();
		scrollBinding	= null;
		scrollSpeed		= null;
	}
	
	override private function createBindings ()
	{
		super.createBindings();
		scrollBinding = scroll.on( target.displayEvents.enterFrame, this );
		scrollBinding.disable();
	}
	
	
	override private function deactivateScrolling ()
	{
		scrollBinding.disable();
		super.deactivateScrolling();
	}
	
	
	private function scroll ()
	{
		var scrollPos	= scrollLayout.scrollPos.add( scrollSpeed );
		scrollPos		= scrollLayout.validateScrollPosition( scrollPos );
		
		if (scrollPos.isEqualTo( scrollLayout.scrollPos )) {
			scrollBinding.disable();
			return;
		}
		
		scrollLayout.scrollPos.setTo( scrollPos );
	}
	
	
	override private function calculateScroll (mouseObj:MouseState)
	{
		var scrollHor = scrollLayout.horScrollable();
		var scrollVer = scrollLayout.verScrollable();
		
		if (!scrollHor && !scrollVer)
			return;
		
		var mousePos = getLocalMousePosition(mouseObj);
		
		if (scrollSpeed == null)
			scrollSpeed	= new IntPoint();
		
		//horScroll
		if (scrollHor)
		{
			var quarterW	= scrollLayout.explicitWidth * .25;
			var maxSpeedX	= quarterW * 0.05;
			var speedX		= 0.0;
			
			if		(mousePos.x < quarterW)			speedX = ((quarterW - mousePos.x) / quarterW) * -maxSpeedX;				//scroll to left
			else if	(mousePos.x > (quarterW * 3))	speedX = ((mousePos.x - (quarterW * 3)) / quarterW) *  maxSpeedX;		//scroll to right
			
			scrollSpeed.x = speedX.round().int();
		//	trace(target+".calculateScrollSpeedX: "+scrollSpeed.x+"; mousePos: "+mousePos.x+"; w: "+scrollLayout.explicitWidth);
		}
		
		//verScroll
		if (scrollVer)
		{
			var quarterH	= scrollLayout.explicitHeight * .25;
			var maxSpeedY	= quarterH * 0.05;
			var speedY		= 0.0;
			
			if		(mousePos.y < quarterH)			speedY = ((quarterH - mousePos.y) / quarterH) * -maxSpeedY;				//scroll to top
			else if	(mousePos.y > (quarterH * 3))	speedY = ((mousePos.y - (quarterH * 3)) / quarterH) *  maxSpeedY;		//scroll to bottom
			
			scrollSpeed.y = speedY.round().int();
		//	trace(target+".calculateScrollSpeedY: "+scrollSpeed.y+"; mousePos: "+mousePos.y+"; h: "+scrollLayout.explicitHeight);
		}
		
		if (scrollSpeed.x != 0 || scrollSpeed.y != 0)
			scrollBinding.enable();
	}
}