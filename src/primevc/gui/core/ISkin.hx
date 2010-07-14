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
 import haxe.FastList;
 import primevc.core.IDisposable;
 import primevc.gui.behaviours.IBehaviour;
 import primevc.gui.display.ISprite;
 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.UserEvents;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.states.SkinStates;


/**
 * Interface for a skin.
 * 
 * @author Ruben Weijers
 * @creation-date Jun 08, 2010
 */
interface ISkin implements ISprite, implements IDisposable //, implements ILayoutOwner
{
	public var skinState		(default, null)		: SkinStates;
	
//	public var owner			(default, setOwner) : OwnerClass;
	public var layout			(default, null)		: LayoutClient;
	
	public var behaviours		: FastList < IBehaviour <ISkin> >;
	
	
	public function init ()					: Void;
	private function createLayout ()		: Void;
	private function createStates ()		: Void;
	private function createBehaviours ()	: Void;
	private function createChildren ()		: Void;
	
	private function removeStates ()		: Void;
	private function removeBehaviours ()	: Void;
	private function removeChildren ()		: Void;
	
}