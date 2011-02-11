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
 import primevc.gui.core.UIGraphic;
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
	private var modal	: UIGraphic;
	
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
	
	
	public inline function add (popup:IUIElement, modal:Bool = false) : Int
	{
	//	if (modal)
	//		createModalFor(popup);
		
		window.children.add( popup );
		window.popupLayout.children.add( popup.layout );
		return window.children.length - 1;
	}
	
	
	public inline function remove (popup:IUIElement)
	{
	//	removeModalFor( popup );
		Assert.notNull( popup.window );
		window.children.remove(popup);
		window.popupLayout.children.remove( popup.layout );
	}
	
	
	
	
	private function createModalFor (popup:IUIElement)
	{
		if (modal == null)
			modal = new UIGraphic("modal");
		
		if (modal.window == null)
		{
			window.children.add( modal );
			window.layoutContainer.children.add( modal.layout );
		}
		else
			window.children.move( modal, window.children.length - 1 );
		
		modalPopups.push( popup );
	}
	
	
	private function removeModalFor (popup:IUIElement)
	{
		var index = modalPopups.indexOf(popup);
		if (index > 0 && modalPopups.length > 1)		//if true, the popup has a modal that should not be removed yet
		{
			//move modal window one level down
			window.children.move( modal, window.children.indexOf( modalPopups[ index - 1 ] ) - 1 );
		}
		modalPopups.removeItem(popup);
	}
}