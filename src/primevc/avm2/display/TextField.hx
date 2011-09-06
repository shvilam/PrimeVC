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
package primevc.avm2.display;
 import flash.display.DisplayObject;
 import primevc.core.geom.IntRectangle;
 import primevc.core.Bindable;

 import primevc.gui.display.DisplayDataCursor;
 import primevc.gui.display.IDisplayContainer;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.display.IInteractiveObject;
 import primevc.gui.display.ITextField;
 import primevc.gui.display.ISprite;
 import primevc.gui.display.Window;

 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.FocusState;
 import primevc.gui.events.TextEvents;
 import primevc.gui.events.UserEventTarget;
 import primevc.gui.events.UserEvents;

 import primevc.gui.text.TextFormat;
 import primevc.gui.text.TextTransform;

  using primevc.utils.Bind;
  using primevc.utils.NumberUtil;
  using primevc.utils.StringUtil;
  using primevc.utils.TypeUtil;


/**
 * PrimeVC AVM2 TextField implementation
 * 
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class TextField extends flash.text.TextField, implements ITextField 
{	
	/**
	 * The padding to be added to textWidth to get the width
	 * of a TextField that can display the text without clipping.
	 */ 
	public static inline var TEXT_WIDTH_PADDING:Int = 5;

	/**
	 * The padding to be added to textHeight to get the height
	 * of a TextField that can display the text without clipping.
	 */ 
	public static inline var TEXT_HEIGHT_PADDING:Int = 4;
	
	
	public var container		(default, setContainer)		: IDisplayContainer;
	public var window			(default, setWindow)		: Window;
	
	public var displayEvents	(default, null)				: DisplayEvents;
	public var textEvents		(default, null)				: TextEvents;
	public var userEvents		(default, null)				: UserEvents;
	
	public var rect				(default, null)				: IntRectangle;
	
	/**
	 * Returns the textWidth + TEXT_WIDTH_PADDING
	 */
	public var realTextWidth	(getRealTextWidth, never)	: Float;
	/**
	 * Returns the textHeight + TEXT_HEIGHT_PADDING
	 */
	public var realTextHeight	(getRealTextHeight, never)	: Float;
	
	public var data				(default, setData)			: Bindable < String >;
	
	/**
	 * getter / setter to update the text/htmlText property of the textfield,
	 * depending on wether displayHTML is true or false.
	 */
	public var content			(getContent, setContent)	: String;
	public var value			(getValue, setValue)		: String;
	public var textStyle		(default, setTextStyle)		: TextFormat;
	
	
	/**
	 * Flag indicating wether the data of the textfield should be displayed as
	 * plain-text or as HTML.
	 * @default	false
	 */
	public var displayHTML		(default, setDisplayHTML)	: Bool;
	
	
	
	public function new (data:Bindable<String> = null)
	{
		super();
		displayEvents	= new DisplayEvents( this );
		textEvents		= new TextEvents( this );
		userEvents		= new UserEvents( this );
		rect			= new IntRectangle( x.roundFloat(), y.roundFloat(), width.roundFloat(), height.roundFloat() );
		this.data		= data == null ? new Bindable<String>(text) : data;
		textStyle		= new TextFormat();
		
		makeStatic();
	}
	
	
	private function setHandlers ()
	{
		applyValue.on( data.change, this );
		updateValue.on( textEvents.change, this );
		applyValue();
	}
	
	
	private inline function setData (v:Bindable<String>)
	{
		if (v != data)
		{
			if (data != null)
			{
				data.change.unbind(this);
				textEvents.change.unbind(this);
			}
		
			data = v;
			
			if (data != null && window != null)
				setHandlers();
			else if (data != null && displayEvents != null)
				setHandlers.onceOn( displayEvents.addedToStage, this );
		}
		return v;
	}
	
	
	public function dispose ()
	{
		if (displayEvents == null)
			return;		// already disposed
		
		if (container != null)
			container.children.remove(this);
		
		var d = data;
		data  = null;
		
		stopRespondingToOtherFocus();
		
		displayEvents.dispose();
		textEvents.dispose();
		userEvents.dispose();
		rect.dispose();
		
		displayEvents	= null;
		textEvents		= null;
		userEvents		= null;
		textStyle		= null;
		container		= null;
		window			= null;
		rect			= null;
		
	//	if (d != null)
	//		d.dispose();
	}


	public function isObjectOn (otherObj:IDisplayObject) : Bool
	{
		return otherObj == null ? false : otherObj.as(DisplayObject).hitTestObject( this.as(DisplayObject) );
	}
	
	
	public inline function isEditable () : Bool
	{
		return type == flash.text.TextFieldType.INPUT;
	}
	
	
	public function isFocusOwner (target:UserEventTarget) : Bool
	{
		return target == this;
	}
	
	
#if !neko
	public function getDisplayCursor			() : DisplayDataCursor											{ return new DisplayDataCursor(this); }
	public inline function attachDisplayTo		(target:IDisplayContainer, pos:Int = -1)	: IDisplayObject	{ target.children.add( this, pos ); return this; }
	public inline function detachDisplay		()											: IDisplayObject	{ container.children.remove( this ); return this; }
	public inline function changeDisplayDepth	(newPos:Int)								: IDisplayObject	{ container.children.move( this, newPos ); return this; }
#end
	
	
	@:keep public inline function makeEditable ()
	{
		selectable		= true;
		mouseEnabled	= true;
		type			= flash.text.TextFieldType.INPUT;
	}
	
	
	public inline function makeStatic ()
	{
		type			= flash.text.TextFieldType.DYNAMIC;
		selectable		= false;
		mouseEnabled	= false;
	}
	
	
	/**
	 * Method will apply a text-transform on the value of the text-field.
	 * TODO: implementation for htmlText
	 */
	private function applyValue ()
	{
	//	trace(this+".applyValue "+text+" => "+value+"; transform: "+textStyle.transform);
		if (value != content && value != null)
			applyTextFormat();
		else if (value == null)
			text = htmlText = "";
	}
	
	
	private function updateValue ()
	{
		if (value != content)
		{
			value = content;
			applyTextFormat();
		}
	}
	
	
	private function applyTextFormat ()
	{
		var newText = value;
		if (newText == null)
			newText = "";
		
		if (value != null && textStyle != null && textStyle.transform != null)
			newText = switch (textStyle.transform) {
				case capitalize:	newText.capitalize();
				case uppercase:		newText.toUpperCase();
				case lowercase:		newText.toLowerCase();
				default:			newText;
			}
		
		if (newText != content)
			content = newText;
		
	//	trace(this+".applyTextFormat "+textStyle+"; "+width+"; "+height+"; autosize: "+autoSize);
		setTextFormat( textStyle );
	}
	
	
	
/*	override public function setTextFormat (format:flash.text.TextFormat, beginIndex:Int = -1, endIndex:Int = -1)
	{	
		super.setTextFormat(format, beginIndex, endIndex);
		if (beginIndex == -1 && endIndex == -1 && format.align != null)
		{
			var F		= flash.text.TextFormatAlign;
			var A		= flash.text.TextFieldAutoSize;
			
			if		(format.align == F.LEFT)	autoSize = A.LEFT;
			else if (format.align == F.CENTER)	autoSize = A.CENTER;
			else if (format.align == F.RIGHT)	autoSize = A.RIGHT;
			else 								autoSize = A.NONE;
		}
	}*/
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setContainer (v)
	{
		container	= v;
		if (v != null)	window = container.window;
		else			window = null;
		return v;
	}
	
	
	private inline function setWindow (v)
	{
		return window = v;
	}
	
	
	private function setTextStyle (v:TextFormat)
	{
		textStyle = v;
		
		if (v != null) {
			defaultTextFormat = v;
			if (window != null)
				applyTextFormat();
		}
		
		return v; 
	}
	
	
	private inline function setValue (v:String)		{ return data.value = v; }
	private inline function getValue () : String	{ return data.value; }
	
	private inline function getRealTextWidth ()		{ return textWidth + TEXT_WIDTH_PADDING; }
	private inline function getRealTextHeight ()	{ return getNonZeroTextHeight() + TEXT_HEIGHT_PADDING; }
	
	
	/**
	 * Copied from Flex mx.core.UITextField.
	 * Method returns the textheight even if there's no text in the field.
	 */
	private inline function getNonZeroTextHeight() : Float
    {
		var h = textHeight;
        if (content == "")
        {
            text	= "Wj";
            h		= textHeight;
            text	= "";
        }
        
        return h;
    }


	private inline function setDisplayHTML (v:Bool)
	{
		if (v != displayHTML)
		{
			displayHTML = v;
			htmlText = text = "";
			applyTextFormat();
		}
		return v;
	}

	
	private inline function getContent ()			{ return displayHTML ? htmlText : text; }
	private inline function setContent (v:String)	{ return displayHTML ? htmlText = v : text = v; }
	
	
	
	//
	// FOCUS METHODS
	//
	
	
	public inline function setFocus ()		{ if (window != null)							{ window.focus = this; } }
	public inline function removeFocus ()	{ if (window != null && window.focus == this)	{ window.focus = null; } }
	
	
	/**
	 * Reference to a target with focusevents to which the textfield should
	 * respond.
	 */
	private var focusTarget : IInteractiveObject;
	
	
	/**
	 * Method will make the textfield respond to focus events of the given
	 * target.
	 * 		- When the target receives an focus event, the textfield will set the
	 * 			focus to itself.
	 */
	public function respondToFocusOf (target:IInteractiveObject)
	{
		//bind the focus-events of the textfield and the target together
		redispatchFocusEvent.on( userEvents.focus, this );
		handleBlur			.on( userEvents.blur,  this );
		giveFocusToMe		.on( target.userEvents.focus, this );
		
		focusTarget = target;
	}
	
	
	public function stopRespondingToOtherFocus ()
	{
		if (focusTarget == null)
			return;
		
		userEvents.focus.unbind(this);
		userEvents.blur.unbind(this);
		focusTarget.userEvents.focus.unbind(this);
		
		focusTarget = null;
	}
	
	
	
	/**
	 * Method is called on a focus event. If the target isn't the textfield, 
	 * change the focus to the textfield.
	 */
	private function giveFocusToMe (event:FocusState)
	{
		if (event.target != this)
			setFocus();
	}
	
	
	/**
	 * If the textfield receives an focus-event, it will broadcast this event
	 * also to it's target
	 */
	private function redispatchFocusEvent (event:FocusState)
	{
		//send an focus event if the field get's focus from something else then the label
		if (event.target == this && event.related != cast focusTarget)
			focusTarget.userEvents.focus.send( event );
	}
	
	
	private function handleBlur (event:FocusState)
	{
		//if the field lost it's focus to the focusTarget, give the focus back to the txtfield
		if (event.target == this && event.related == cast focusTarget)
			setFocus();
		
		//the field lost it's focus to someone else.. Send an blur event
		else
			focusTarget.userEvents.blur.send( event );
	}
}