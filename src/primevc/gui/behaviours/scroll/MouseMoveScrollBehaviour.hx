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
 import primevc.core.geom.IntPoint;
 import primevc.gui.events.MouseEvents;
  using Math;
  using Std;


/**
 * Behaviour to scroll in the target by moving the mouse.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 28, 2010
 */
class MouseMoveScrollBehaviour extends MouseScrollBehaviourBase
{
	override private function calculateScroll (mouseObj:MouseState)
	{
		var scrollHor = scrollLayout.horScrollable();
		var scrollVer = scrollLayout.verScrollable();
		
		if (!scrollHor && !scrollVer)
			return;
		
		var mousePos	= ScrollHelper.getLocalMouse(target, mouseObj);
		var scrollPos	= new IntPoint();
		
		//horScroll
		if (scrollHor) {
			var percentX	 = ( mousePos.x / scrollLayout.explicitWidth ).max(0).min(1);
			scrollPos.x		 = ( scrollLayout.scrollableWidth * percentX ).round().int();
		//	trace("scrollX: "+layoutGroup.scrollX+"; sW: "+scrollableW+"; eW: "+layoutGroup.explicitWidth+"; mW: "+layoutGroup.measuredWidth+"; mX: "+mousePos.x+"; pX "+percentX+"; horP: "+layoutGroup.getHorPosition()+"; x: "+target.x);
		}
		
		//verScroll
		if (scrollVer) {
			var percentY	 = ( mousePos.y / scrollLayout.explicitHeight ).min(1).max(0);
			scrollPos.y		 = ( scrollLayout.scrollableHeight * percentY ).round().int();
		//	trace("scrollY: "+layoutGroup.scrollY+"; sH: "+scrollableH+"; eW: "+layoutGroup.explicitHeight+"; mW: "+layoutGroup.measuredHeight+"; mY: "+mousePos.y+"; stageMY: "+mouseObject.stage.y+"; pY "+percentY);
		}
		
		scrollPos = scrollLayout.validateScrollPosition( scrollPos );
		
		if (!scrollPos.isEqualTo( scrollLayout.scrollPos ))
			scrollLayout.scrollPos.setTo( scrollPos );
	}
}