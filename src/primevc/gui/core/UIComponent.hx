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
 import primevc.core.Bindable;
 import primevc.gui.behaviours.layout.ValidateLayoutBehaviour;
 import primevc.gui.behaviours.BehaviourList;
 import primevc.gui.behaviours.RenderGraphicsBehaviour;
 import primevc.gui.display.Sprite;
 import primevc.gui.graphics.shapes.IGraphicShape;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.states.UIElementStates;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * UIComponent defines the basic behaviour of a UIComponent without data.
 *
 * These include the default states of a component, the way it
 * should change between states and a helper function to create a new skin.
 * 
 * To create a component, extend UIComponent and override the 
 * following methods:
 * 	- createStates
 * 	- createBehaviours
 *  - createChildren
 *  - createSkin
 *  - removeStates
 *  - removeSkin
 *  - removeChildren
 * 
 * Non of these methods need to call their super methods because they
 * are empty.
 *  
 * When any behaviours outside of "public var behaviours" are defined,
 * the removeBehaviours() method should be overridden.
 * 
 * @author Ruben Weijers
 * @creation-date Jun 07, 2010
 */
class UIComponent extends Sprite, implements IUIComponent
{
	public var behaviours		(default, null)			: BehaviourList;
	public var state			(default, null)			: UIElementStates;
	public var skin				(default, setSkin)		: ISkin;
	public var layout			(default, null)			: LayoutClient;
	public var graphicData		(default, null)			: Bindable < IGraphicShape >;
	
	
	private function new ()
	{
		super();
		visible = false;
		init.onceOn( displayEvents.addedToStage, this );
		
		state			= new UIElementStates();
		behaviours		= new BehaviourList();
		graphicData		= new Bindable < IGraphicShape > ();
		
		//add default behaviours
		behaviours.add( new RenderGraphicsBehaviour(this) );
		behaviours.add( new ValidateLayoutBehaviour(this) );
		
		createStates();
		createBehaviours();
		createLayout();
		
		state.current = state.constructed;
	}


	private function init ()
	{
		behaviours.init();
		
		//create a skin (if there is one defined for this component) and it's children
		createSkin();
		//overwrite the graphics of the skin with custom graphics (or do nothing if the method isn't overwritten)
		createGraphics();
		//create the children of this component after the skin has created it's children
		createChildren();
		
		//notify the skin that the children of the UIComponent are created
		if (skin != null)
			skin.childrenCreated();
		
		//finish initializing
		visible = true;
		state.current = state.initialized; 
	}
	
	
	override public function dispose ()
	{
		if (state == null)
			return;
		
		removeChildren();
		
		//Change the state to disposed before the behaviours are removed.
		//This way a behaviour is still able to respond to the disposed
		//state.
		state.current = state.disposed;
		removeBehaviours();
		removeStates();
		
		state.dispose();
		
		if (layout != null)
			layout.dispose();
		
		if (graphicData != null)
		{
			if (graphicData.value != null)
				graphicData.value.dispose();
			
			graphicData.dispose();
			graphicData = null;
		}
		
		state			= null;
		behaviours		= null;
		skin			= null;
		layout			= null;
		
		super.dispose();
	}
	
	
	
	//
	// METHODS
	//
	
	
	private inline function removeBehaviours ()
	{
		behaviours.dispose();
		behaviours = null;
	}
	
	
	private inline function removeSkin ()
	{
		skin = null;
	}


	public inline function render () : Void
	{
		if (graphicData.value != null)
		{
			graphics.clear();
			graphicData.value.draw(this, false);
		}
	}



	//
	// SETTERS / GETTERS
	//


	private function setSkin (newSkin)
	{
		skin = newSkin;

		if (skin != null && skin.is(Skin)) {
			cast(skin, Skin<Dynamic>).owner = this;
		}

		return skin;
	}
	
	
	
	//
	// ABSTRACT METHODS
	//
	
	private function createStates ()		: Void; //	{ Assert.abstract(); }
	private function createBehaviours ()	: Void; //	{ Assert.abstract(); }
	private function createLayout ()		: Void		{ Assert.abstract(); }
	private function createGraphics ()		: Void; //	{ Assert.abstract(); }
	private function createSkin ()			: Void; //	{ Assert.abstract(); }
	private function createChildren ()		: Void		{ Assert.abstract(); }
	
	private function removeStates ()		: Void; //	{ Assert.abstract(); }
	private function removeGraphics ()		: Void; //	{ Assert.abstract(); }
	private function removeChildren ()		: Void		{ Assert.abstract(); }
	
	
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