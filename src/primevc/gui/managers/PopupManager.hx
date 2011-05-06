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
 import primevc.gui.core.IUIElement;
 import primevc.gui.core.UIComponent;
 import primevc.gui.core.UIWindow;
 import primevc.utils.FastArray;
  using primevc.utils.FastArray;



/**
 * @author Ruben Weijers
 * @creation-date Jan 17, 2011
 */
class PopupManager implements IPopupManager 
{
	private var window	: UIWindow;
	private var modal	: UIComponent;	//can't be a UIGraphic since it needs to block mouse clicks
	
	/**
	 * List of all popups who also want a modal. If a new popup is opened above
	 * the current popup, the modal will move one level up.
	 */
	private var modalPopups	: FastArray<IUIElement>;
	
	
	
	public function new (window:UIWindow)
	{
		modalPopups	= FastArrayUtil.create();
		this.window = window;
	}
	
	
	public function dispose ()
	{
		modalPopups.removeAll();
		modalPopups = null;
		window = null;
	}
	
	
	
	/**
	 * Method will open the given popup on the forground of the window
	 * @return 	index of the popup in the displaylist
	 */
	public inline function add (popup:IUIElement, modal:Bool = false) : Int
	{
		if (modal)
			createModalFor(popup);
		
		Assert.null( popup.window );
		Assert.null( popup.layout.parent );
		window.popupLayout.children.add( popup.layout );
		popup.attachDisplayTo( window );
		return window.children.length - 1;
	}
	
	
	public inline function remove (popup:IUIElement)
	{
		removeModalFor( popup );
		Assert.notNull( popup.window );
		Assert.notNull( popup.layout.parent );
		popup.detach();
	}
	
	
	
	
	private function createModalFor (popup:IUIElement)
	{
		if (modal == null) {
			modal = new UIComponent("modal");
			modal.tabEnabled = false;
		}
		
		if (modal.window == null)
		{
			window.popupLayout.children.add( modal.layout );
			modal.attachDisplayTo( window );
		}
		else
			moveModalBackground( window.popupLayout.children.length - 1 );
		
		modalPopups.push( popup );
	}
	
	
	private function removeModalFor (popup:IUIElement)
	{
		var index = modalPopups.indexOf(popup);
		if (index > 0)
		{
			modalPopups.removeItem(popup);
			
			//keep the modalbackground if there are more modal-popups open
			if (modalPopups.length > 0)		moveModalBackground( window.children.indexOf( modalPopups[ modalPopups.length - 1 ] ) - 1 );
			else							modal.detach();
		}
	}
	
	
	private inline function moveModalBackground (newPos:Int)
	{
		window.popupLayout.children.move( modal.layout, newPos );
		window.children.move( modal, newPos );
	}
}