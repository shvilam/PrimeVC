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
 import primevc.gui.behaviours.layout.SkinLayoutBehaviour;
 import primevc.gui.behaviours.RenderGraphicsBehaviour;
 import primevc.gui.behaviours.IBehaviour;
 import primevc.gui.display.Sprite;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.states.SkinStates;
  using primevc.utils.Bind;


/**
 * Base Skin class.
 * 
 * TODO Ruben: explain the difference between UIComponent en Skin
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class Skin <OwnerClass> extends Sprite, implements ISkin //<OwnerClass>
{
	public var layout			(default, null)		: LayoutClient;
	public var owner			(default, setOwner) : OwnerClass;
	public var skinState		(default, null)		: SkinStates;
	
	public var behaviours		(default, null)		: FastList < IBehaviour <Dynamic> >;
	
	
	public function new()
	{
		super();
		init.onceOn( displayEvents.addedToStage, this );
		
		visible			= false;
		skinState		= new SkinStates();
		
		behaviours		= new FastList< IBehaviour<Dynamic> > ();
		behaviours.add( new RenderGraphicsBehaviour (this) );
		behaviours.add( new SkinLayoutBehaviour (this) );
		
		createStates();
		createBehaviours();
		createLayout();
		
		skinState.current = skinState.constructed;
	}
	
	
	public function init ()
	{
		initBehaviours();
		createChildren();
		visible = true;
		skinState.current = skinState.initialized; 
	}
	
	
	override public function dispose ()
	{
		if (behaviours == null)
			return;
		
		removeChildren();
		removeBehaviours();
		removeStates();
		
		if (layout != null)
			layout.dispose();
		
		behaviours	= null;
		layout		= null;
		owner		= null;
		
		super.dispose();
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setOwner (newOwner) {
		return this.owner = newOwner;
	}
	
	
	
	
	//
	// METHODS
	//
	
	//TODO RUBEN - enable Assert.abstract
	private function createLayout ()			: Void; //	{ Assert.abstract(); }
	private function createStates ()			: Void; //	{ Assert.abstract(); }
	private function createBehaviours ()		: Void; //	{ Assert.abstract(); }
	private function createChildren ()			: Void; //	{ Assert.abstract(); }
	
	private function removeStates ()			: Void; //	{ Assert.abstract(); }
	private function removeChildren ()			: Void; //	{ Assert.abstract(); }
	private inline function removeBehaviours ()	: Void
	{
		while (!behaviours.isEmpty())
			behaviours.pop().dispose();
	}
	
	private inline function initBehaviours ()	: Void
	{
		for (behaviour in behaviours)
			behaviour.initialize();
	}
	
	
#if debug
	public var id (default, setId) : String;
	
	
	private inline function setId (v)
	{
		id = name = v;
		if (layout != null)
			layout.name = name + "Layout";
		return v;
	}
	
	
	override public function toString() { return id; }
#end
}