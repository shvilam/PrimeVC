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
 import primevc.core.dispatcher.Wire;
 import primevc.core.Bindable;
 import primevc.gui.core.UIDataContainer;
  using primevc.utils.Bind;


/**
 * EditableLabel will add a button to the label to change the textfield to
 * an inputfield and back.
 * 
 * The button will on default have the ButtonIconSkin.
 * When the label changes to an inputfield the button will get the id "editBtn"
 * and the label will get the id "editField".
 * 
 * The container itself will get an extra styleclass in editMode 'editable'
 * 
 * @author Ruben Weijers
 * @creation-date Jan 25, 2011
 */
class EditableLabel extends UIDataContainer <Bindable<String>>
{
	private static inline var EDIT_BTN_ID		= "editBtn";
	private static inline var EDIT_FIELD_ID		= "editField";
	
	private var editBtn			: Button;
	private var field			: Label;
	
	private var editable		: Bool;
	
	private var fieldBinding	: Wire<Dynamic>;
	private var btnEditBinding	: Wire<Dynamic>;
	private var btnApplyBinding	: Wire<Dynamic>;
	
	
	override private function createChildren ()
	{
		editable = false;
		
		children.add( field		= new Label( null, data ) );
		children.add( editBtn	= new Button() );
		
		layoutContainer.children.add( field.layout );
		layoutContainer.children.add( editBtn.layout );
		
		fieldBinding	= makeEditable	.on( field.userEvents.mouse.down, this );
		btnEditBinding	= makeEditable	.on( editBtn.userEvents.mouse.click, this );
		btnApplyBinding	= makeStatic	.on( editBtn.userEvents.mouse.click, this );
		
		btnApplyBinding.disable();
	}
	
	
	
	public function makeEditable ()
	{
		if (editable)
			return;
		
		styleClasses.add("editable");
		
		field.makeEditable();
		field.id.value		= EDIT_FIELD_ID;
		editBtn.id.value	= EDIT_BTN_ID;
		editable			= true;
		
		fieldBinding	.disable();
		btnEditBinding	.disable();
		btnApplyBinding	.enable();
	}
	
	
	public function makeStatic ()
	{
		if (!editable)
			return;
		
		styleClasses.remove("editable");
		
		field.makeStatic();
		field.id.value		= null;
		editBtn.id.value	= null;
		editable			= false;
		
		fieldBinding	.enable();
		btnEditBinding	.enable();
		btnApplyBinding	.disable();
	}
}