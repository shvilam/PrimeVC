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
 import primevc.gui.states.UIComponentStates;
 

/**
 * Interface for UIComponentBase.
 *
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
interface IUIComponent implements ISprite, implements IDisposable
{
	public var behaviours		: FastList < IBehaviour < IUIComponentBase > >;
	public var componentState	: UIComponentStates;
	public var skin				(default, setSkin)	: ISkin;
	
	
	/**
	 * Factory method for creating the default skin of this UIComponent. Setting
	 * the skin property in the constructor will cause the createSkin method
	 * not being called.
	 * 
	 * Use the setupSkin() method for giving the skin different properties or 
	 * adding skins to skin from child components.
	 */
	private function createSkin ()					: Void;
	
	
	
	/**
	 * This is the first method that will be runned by the constructor.
	 * Overwrite this method to instantiate the states of the component.
	 */
	private function setupStates ()					: Void;
	/**
	 * After constructing the states, the behaviours will be created.
	 * Overwrite this method to define all the behaviours of the component.
	 */
	private function setupBehaviours ()				: Void;
	/**
	 * After creating the behaviours, the component can also create child UIComponents.
	 * These components can be added by callig the addChild method. This will
	 * on default also add the skin of the child as child to the parent skin.
	 */
	private function setupChildren ()				: Void;
	/**
	 * After creating the child componentns, the skin will be created.
	 * Overwrite this method to give the current skin the right properties
	 * and subskins.
	 */
	private function setupSkin ()					: Void;
	
	
	/**
	 * Implement this method to clean-up the states of the component
	 */
	private function removeStates ()				: Void;
	/**
	 * Implement this method to clean-up the behaviours of the component
	 */
	private function removeBehaviours ()			: Void;
	/**
	 * Implement this method to clean-up the skin of the component
	 */
	private function removeSkin ()					: Void;
	/**
	 * Implement this method to clean-up the children of the component
	 */
	private function removeChildren ()				: Void;
	
	
	
//	public function add ( child:IUIComponent )		: IUIComponent;
//	public function remove ( child:IUIComponent )	: IUIComponent;
//	private var childeren							: FastList;
}