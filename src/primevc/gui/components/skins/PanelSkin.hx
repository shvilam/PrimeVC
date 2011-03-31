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
package primevc.gui.components.skins;
 import primevc.gui.behaviours.drag.DragMoveBehaviour;
 import primevc.gui.components.Button;
 import primevc.gui.core.Skin;
 import primevc.gui.core.UIContainer;
 import primevc.gui.core.UITextField;
  using primevc.utils.Bind;


/**
 * Default panel skin.
 * 
 * Will add a titlefield (.title) and a closebtn (.closeBtn). They both will
 * be placed in a subcontainer (.chrome).
 * 
 * @author Ruben Weijers
 * @creation-date Feb 14, 2011
 */
class PanelSkin extends Skin<Panel>
{
	private var chrome		: UIContainer;
	private var closeBtn	: Button;
	private var title		: Label;
	
	
	override public function createChildren ()
	{
		chrome		= new UIContainer("chrome");
		closeBtn	= new Button("closeBtn");
		title		= new Label("title");
		title.mouseEnabled = false;
		
		chrome	.layoutContainer.children.add( title.layout );
		chrome	.layoutContainer.children.add( closeBtn.layout );
		owner	.layoutContainer.children.add( chrome.layout, 0 );
		
		chrome	.children.add( title );
		chrome	.children.add( closeBtn );
		owner	.children.add( chrome, 0 );
		
		chrome	.styleClasses.add("chrome");
		title	.styleClasses.add("title");
		closeBtn.styleClasses.add("closeBtn");
		
		behaviours.add( new DragMoveBehaviour(owner, null, chrome) );
		
		owner.close.send.on( closeBtn.userEvents.mouse.click, this );
		title.data.bind( owner.label );
	}
	
	
	override private function removeChildren ()
	{
		chrome.children.remove( title );
		chrome.children.remove( closeBtn );
		owner.children.remove( chrome );
		
		chrome.layoutContainer.children.remove( title.layout );
		chrome.layoutContainer.children.remove( closeBtn.layout );
		owner.layoutContainer.children.remove( chrome.layout );
		
		chrome.dispose();
		closeBtn.dispose();
		title.dispose();
		
		chrome = null;
		closeBtn = null;
		title = null;
	}
}