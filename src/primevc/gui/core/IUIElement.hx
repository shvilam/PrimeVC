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
package primevc.gui.core;
 import primevc.core.traits.IIdentifiable;
 import primevc.core.IDisposable;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.effects.UIElementEffects;
 import primevc.gui.states.UIElementStates;
 import primevc.gui.traits.IBehaving;
 import primevc.gui.traits.ILayoutable;


/**
 * @author Ruben Weijers
 * @creation-date Aug 02, 2010
 */
interface IUIElement	
				implements IDisplayObject
			,	implements ILayoutable
			,	implements IBehaving
			,	implements IIdentifiable
			,	implements IDisposable
			,	implements IStylable
{
	public var state	(default, null)		: UIElementStates;
	
	/**
	 * Collection of effects that are defined for this UIElement. The 
	 * UIElementEffects object won't be created by an UIElement but has to be
	 * set the first time an effect is added to the UIElement.
	 */
	public var effects	(default, default)	: UIElementEffects;
	
	
	//
	// ACTIONS
	//
	
	public function move (newX:Float, newY:Float)	: Void;
	public function resize (newW:Float, newH:Float)	: Void;
	public function rotate (newV:Float)				: Void;
	public function scale (newX:Float, newY:Float)	: Void;
	public function show ()							: Void;
	public function hide ()							: Void;
}