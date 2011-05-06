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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.managers;
 import primevc.core.traits.IDisposable;
 import primevc.gui.core.IUIComponent;
 import primevc.gui.core.UIComponent;
 import primevc.gui.core.UIWindow;


/**
 * @author Ruben Weijers
 * @creation-date Jan 17, 2011
 */
interface IPopupManager implements IDisposable
{
	private var window	: UIWindow;
	
	/**
	 * shape that is put over the rest of the application to make sure the 
	 * active popup is first closed before anything else is done in the 
	 * application.
	 */
	private var modal	: UIComponent;
	
	
	/**
	 * Method will add the given IUIElement as popup to the displayList. Method
	 * will return the depth of the popup or -1 if the popup couldnt be added,
	 */
	public function add (popup:IUIComponent, modal:Bool = false)	: Int;
	
	/**
	 * Method will remove the IUIElement as popup.
	 */
	public function remove (popup:IUIComponent) : Void;
}