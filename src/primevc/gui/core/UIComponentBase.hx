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
 import primevc.gui.behaviours.IBehaviour;
 import primevc.gui.states.UIComponentStates;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * UIComponentBase defines the basic behaviour of a UIComponent without data.
 *
 * These include the default states of a component, the way it
 * should change between states and a helper function to setup a new skin.
 * 
 * You should never have to extend UIComponentBase class directly.
 * Instead, define new components as subclasses of UIComponent.
 *
 * To create a component, extend UIComponent and override the 
 * following methods:
 * 	- setupStates
 * 	- setupBehaviours
 *  - setupChildren
 *  - setupSkin
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
class UIComponentBase implements IUIComponentBase
{
	public var behaviours		: FastList < IBehaviour < IUIComponentBase > >;
	public var componentState	: UIComponentStates;
	public var skin				(default, setSkin)	: ISkin;
	
	
	private function new (?skin : ISkin)
	{
		componentState	= new UIComponentStates();
		behaviours		= new FastList <IBehaviour <IUIComponentBase> > ();
	//	behaviours.add( cast new ComponentBehaviour( this ) );
		
		if (skin != null)
			this.skin = skin;
		else
			createSkin();
		
		setupStates();
		setupBehaviours();
		setupChildren();
		setupSkin();
		
	//	componentState.current = componentState.constructed;
	}
	
	
	public function dispose ()
	{
		if (componentState == null)
			return;
		
		removeSkin();
		removeChildren();
		
		//Change the state to disposed before the behaviours are removed.
		//This way a behaviour is still able to respond to the disposed
		//state.
		componentState.current = componentState.disposed;
		
		removeBehaviours();
		removeStates();
		
		componentState.dispose();
		
		componentState	= null;
		behaviours		= null;
		skin			= null;
	}
	
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	private function setSkin (newSkin)
	{
		if (skin != null)
			removeSkin();
		
		skin = newSkin;
		
		if (skin != null && skin.is(Skin)) {
			cast(skin, Skin<Dynamic>).owner = this;
		}
		
		return skin;
	}
	
	
	
	
	//
	// METHODS
	//
	
	
	private function removeBehaviours ()	: Void
	{
		while (!behaviours.isEmpty())
			behaviours.pop().dispose();
	}
	
	
	//
	// ABSTRACT METHODS
	//
	
	private function createSkin ()			: Void	{ Assert.abstract(); }
	private function setupStates ()			: Void	{ Assert.abstract(); }
	private function setupBehaviours ()		: Void	{ Assert.abstract(); }
	private function setupChildren ()		: Void	{ Assert.abstract(); }
	private function setupSkin ()			: Void	{ Assert.abstract(); }
	
	
	private function removeStates ()		: Void	{ Assert.abstract(); }
	private function removeSkin ()			: Void	{ Assert.abstract(); }
	private function removeChildren ()		: Void	{ Assert.abstract(); }
}