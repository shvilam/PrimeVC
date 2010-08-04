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
 import primevc.gui.styling.UIStyle;
 import primevc.gui.traits.IStylable;
 import primevc.utils.FastArray;
  using primevc.utils.FastArray;
  using Type;


/**
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
class LoadStyleBehaviour extends BehaviourBase < IStylable >
{
	private var inheritanceList	: FastArray < String >;
	
	
	override private function init ()
	{	
		var start = flash.Lib.getTimer();
		
		//create empty style object
		target.style = new UIStyle();
		
		//list all super-classes
		inheritanceList			= FastArrayUtil.create();
		var c:Class<Dynamic>	= target.getClass();
		
		while (c != null)
		{
			inheritanceList.push( c.getClassName() );
			c = c.getSuperClass();
		}
		
		//
		
		
		var dur = flash.Lib.getTimer() - start;
		trace(inheritanceList.asString());
		trace("duration: "+dur+" ms");
	}
	
	
	override private function reset ()
	{
		
	}
}