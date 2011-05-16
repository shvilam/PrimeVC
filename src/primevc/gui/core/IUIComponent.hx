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
 import primevc.gui.display.IDisplayContainer;
 import primevc.gui.traits.ISkinnable;
#if flash9
 import primevc.gui.traits.IDrawable;
#end
 

/**
 * Interface for UIComponent
 *
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
interface IUIComponent
				implements IDisplayContainer
			,	implements IUIElement
			,	implements ISkinnable
#if flash9	,	implements IDrawable	#end
{
	public var enabled	(default, null)				: Bindable < Bool >;
	
	/**
	 * This is the first method that will be runned by the constructor.
	 * Overwrite this method to instantiate the states of the component.
	 */
	private function createStates ()				: Void;
	/**
	 * After creating the behaviours, the component can also create child 
	 * UIComponents.
	 */
	private function createChildren ()				: Void;
	
	
	/**
	 * Implement this method to clean-up the states of the component
	 */
	private function removeStates ()				: Void;
	/**
	 * Implement this method to clean-up the children of the component
	 */
	private function removeChildren ()				: Void;
}