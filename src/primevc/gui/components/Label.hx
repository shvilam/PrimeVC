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
package primevc.gui.components;
 import primevc.core.Bindable;
 import primevc.gui.behaviours.components.LabelLayoutBehaviour;
 import primevc.gui.core.UIDataComponent;
 import primevc.gui.core.UITextField;
 import primevc.gui.events.FocusState;
 import primevc.gui.events.UserEventTarget;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.text.TextFormat;
 import primevc.gui.traits.ITextStylable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


private typedef DataType = Bindable<String>;


/**
 * Label Component
 * 
 * @author Ruben Weijers
 * @creation-date Oct 29, 2010
 */
class Label extends UIDataComponent <DataType>, implements ITextStylable
{
	public var field				(default, null)			: UITextField;
	
#if flash9
	public var textStyle			(default, setTextStyle)	: TextFormat;
	public var wordWrap				: Bool;
#end

	
	public function new (id:String = null, data:DataType = null)
	{
		if (data == null)
			data = new DataType();
		
		super(id, data);
	}
	
	
	override private function createLayout ()		{ layout = new AdvancedLayoutClient(); }
	override private function createBehaviours ()	{ behaviours.add( new LabelLayoutBehaviour(this) ); }
	
	
	override private function createChildren ()
	{
		field = new UITextField( null, false, data );
#if debug
		field.id.value = id.value + "TextField";
#end
#if flash9
		field.autoSize			= flash.text.TextFieldAutoSize.NONE;
		field.selectable		= false;
		field.mouseWheelEnabled	= false;
		field.respondToFocusOf( this );
#end
		
		if (textStyle != null)
			field.textStyle = textStyle;
		
		children.add( field );
	}
	
	
	override private function removeChildren ()
	{
		super.removeChildren();
		field.dispose();
		field = null;
	}
	
	
	override private function initData ()		{ field.data = data; }
	override private function removeData ()		{ field.data = null; }
	
	
#if flash9
	override public function isFocusOwner (target:UserEventTarget)
	{
		return super.isFocusOwner(target) || field.isFocusOwner(target);
	}
#end
	
	
	//
	// GETERS / SETTERS
	//
	
#if flash9
	private inline function setTextStyle (v:TextFormat)
	{
		if (field != null)
			field.textStyle = v;
		
		return textStyle = v;
	}
#end
}