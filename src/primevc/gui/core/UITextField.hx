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
#if flash9
 import flash.text.TextFieldAutoSize;
 import primevc.gui.styling.UIElementStyle;
 import primevc.gui.text.TextFormat;
#end
 import primevc.core.Bindable;
 import primevc.gui.behaviours.layout.ValidateLayoutBehaviour;
 import primevc.gui.behaviours.BehaviourList;
 import primevc.gui.display.TextField;
 import primevc.gui.effects.UIElementEffects;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.states.UIElementStates;
 import primevc.gui.traits.ITextStylable;
  using primevc.gui.utils.UIElementActions;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;
  using Std;


/**
 * TextField with IUIElement implementation.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class UITextField extends TextField, implements IUIElement, implements ITextStylable 
{
	public var id			(default, null)					: Bindable < String >;
	public var behaviours	(default, null)					: BehaviourList;
	public var effects		(default, default)				: UIElementEffects;
	public var layout		(default, null)					: LayoutClient;
	public var state		(default, null)					: UIElementStates;
	
#if flash9
	public var style		(default, null)					: UIElementStyle;
	public var styleClasses	(default, null)					: Bindable < String >;
	public var textStyle	(getTextStyle, setTextStyle)	: TextFormat;
#end
	
	
	public function new (?id:String)
	{
		super();
		this.id			= new Bindable<String>(id);
		styleClasses	= new Bindable<String>();
		style			= new UIElementStyle(this);
		
		visible			= false;
		init.onceOn( displayEvents.addedToStage, this );
		
		state			= new UIElementStates();
		behaviours		= new BehaviourList();
		
		//add default behaviour
		behaviours.add( new ValidateLayoutBehaviour(this) );
		
		createBehaviours();
		createLayout();
		
		state.current = state.constructed;
	}


	override public function dispose ()
	{
		if (state == null)
			return;
		
		//Change the state to disposed before the behaviours are removed.
		//This way a behaviour is still able to respond to the disposed
		//state.
		state.current = state.disposed;
		removeBehaviours();
		
		id.dispose();
		state.dispose();
#if flash9
		styleClasses.dispose();
#end
		if (layout != null)
			layout.dispose();
		
		id				= null;
		state			= null;
		behaviours		= null;
#if flash9
		styleClasses	= null;
		style			= null;
#end
		super.dispose();
	}



	//
	// METHODS
	//

	private function init ()
	{
		textStyle = new TextFormat();
		
		behaviours.init();
		
		//finish initializing
		visible = true;
		state.current = state.initialized;
	}


	private inline function removeBehaviours ()
	{
		behaviours.dispose();
		behaviours = null;
	}


	private function createLayout () : Void
	{
		layout = new AdvancedLayoutClient();
		updateSize();
		updateSize.on( textEvents.change, this );
	}
	
	
	public inline function setText (v:String) : Void
	{
		if (v == null)
			v = "";
		
		text = v;
		updateSize();
	}
	
	
	public inline function setHtmlText (v:String) : Void
	{
		if (v == null)
			v = "";
		
		htmlText = v;
		updateSize();
	}
	
	/*
#if flash9
	public inline function setAutoSize (v:TextFieldAutoSize)
	{
		if (v != autoSize)
		{
			autoSize = v;
			switch (v)
			{
				case TextFieldAutoSize.NONE:
			}
		}
		return v;
	}
#end
	*/
	
#if flash9
	private inline function getTextStyle ()				{ return (defaultTextFormat != null && defaultTextFormat.is(TextFormat)) ? defaultTextFormat.as(TextFormat) : null; }
	private inline function setTextStyle (v:TextFormat)	{ return cast defaultTextFormat = v; }
#end
	
	
	//
	// ACTIONS (actual methods performed by UIElementActions util)
	//

	public inline function show ()						{ this.doShow(); }
	public inline function hide ()						{ this.doHide(); }
	public inline function move (x:Float, y:Float)		{ this.doMove(x, y); }
	public inline function resize (w:Float, h:Float)	{ this.doResize(w, h); }
	public inline function rotate (v:Float)				{ this.doRotate(v); }
	public inline function scale (sx:Float, sy:Float)	{ this.doScale(sx, sy); }
	
	
	private function createBehaviours ()	: Void;
	
	
	//
	// EVENTHANDLERS
	//
	
	private function updateSize ()
	{
		var l = layout.as(AdvancedLayoutClient);
		l.measuredWidth		= realTextWidth.int();
		l.measuredHeight	= realTextHeight.int();
	}
	
	
#if debug
	override public function toString() { return id.value; }
#end
}