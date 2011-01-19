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
 import primevc.core.traits.IDisposable;
 import primevc.gui.states.SkinStates;
 import primevc.gui.traits.IBehaving;


/**
 * Interface for a skin.
 * 
 * Order of execution of methods of a skin:
 * 	- IUIComponent creates skin
 * 	- ISkin->constructor
 * 		- createStates()
 * 		- createChildren()
 * 	- IUIComponent.createChildren()
 * 	- IUIComponent -> ISkin.setupSkin()
 * 
 * @author Ruben Weijers
 * @creation-date Aug 03, 2010
 */
interface ISkin 
		implements IBehaving
	,	implements IDisposable
{
	public var skinState		(default, null)		: SkinStates;	
//	public var owner			(default, setOwner) : OwnerClass;
	public function changeOwner	(o:IUIComponent)	: Void;
	
	
	/**
	 * Method for adding extra state objects to the skin
	 */
	private function createStates ()		: Void;
	
	/**
	 * Creates the default graphical data of a UIComponent
	 */
	private function createGraphics ()		: Void;
	
	/**
	 * A skin can have children, despite the fact that it isn't a IDisplayable 
	 * object. It will add it's children to the child-list of it's owner.
	 * After this method, the owner will creates it's children.
	 */
	public function createChildren ()		: Void;
	
	/**
	 * This method is called after the owner has created it's children. It can 
	 * be used e.g. to place them in a different container or change their 
	 * depts or values.
	 */
	public function childrenCreated ()		: Void;
	
	
	/**
	 * Dispose method for all the extra states that where created for this skin.
	 */
	private function removeStates ()		: Void;
	
	/**
	 * Dispose all the children of this skin. This can happen when the owner 
	 * is disposed or when the owner changes it's skin.
	 */
	private function removeChildren ()		: Void;
	
	
	/**
	 * Method is called when the owner is validated and allows the skin to
	 * update itself after some properties have changed.
	 */
	public function validate (changes:Int)	: Void;
}