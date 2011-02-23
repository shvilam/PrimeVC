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
package primevc.gui.components;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.Bindable;
 import primevc.gui.core.UIContainer;



/**
 * Panel component will display a floating window with support for a label and
 * a close-btn. 
 * 
 * Components for label and the closeBtn will be created in the skin. The skin
 * will also add the behaviour to drag the panel around.
 * 
 * @author Ruben Weijers
 * @creation-date Feb 14, 2011
 */
class Panel extends UIContainer
{
	public var label	(default, null) : Bindable<String>;
	
	/**
	 * Container in which the real content for the panel can be placed.
	 * The instance will be created in the constructor. This way, the children
	 * of a panel can always be added.
	 */
	public var content	(default, null)	: UIContainer;
	/**
	 * Signal to send a request to be closed to whoever is listening.
	 */
	public var close	(default, null) : Signal0;
	
	
	public function new (id:String = null, label:String = null)
	{
		super(id);
		this.label	= new Bindable<String>(label);
		content		= new UIContainer();
		close		= new Signal0();
	}
	
	
	override public function dispose ()
	{
		close.dispose();
		content.dispose();
		label.dispose();
		content	= null;
		label	= null;
		close	= null;
		
		super.dispose();
	}
	
	
	override private function createChildren ()
	{
		content.styleClasses.add("content");
		layoutContainer.children.add( content.layout );
		children.add( content );
	}
}