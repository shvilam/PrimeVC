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
 import primevc.core.collections.SimpleList;
 import primevc.gui.styling.UIElementStyle;
#end
 import primevc.core.Bindable;
 import primevc.gui.behaviours.layout.ValidateLayoutBehaviour;
 import primevc.gui.behaviours.BehaviourList;
 import primevc.gui.display.TextField;
 import primevc.gui.effects.UIElementEffects;
 import primevc.gui.layout.ILayoutContainer;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.managers.ISystem;
 import primevc.gui.states.ValidateStates;
 import primevc.gui.states.UIElementStates;
 import primevc.gui.traits.IValidatable;
 import primevc.types.Number;
  using primevc.gui.utils.UIElementActions;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


/**
 * TextField with IUIElement implementation.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class UITextField extends TextField, implements IUIElement
{
	public var prevValidatable	: IValidatable;
	public var nextValidatable	: IValidatable;
	private var changes			: Int;
	
	public var id				(default, null)					: Bindable < String >;
	public var behaviours		(default, null)					: BehaviourList;
	public var effects			(default, default)				: UIElementEffects;
	public var layout			(default, null)					: LayoutClient;
	public var system			(getSystem, never)				: ISystem;
	public var state			(default, null)					: UIElementStates;
	
#if flash9
	public var style			(default, null)					: UIElementStyle;
	public var styleClasses		(default, null)					: SimpleList<String>;
	public var stylingEnabled	(default, setStylingEnabled)	: Bool;
#end
	
	
	public function new (id:String = null, stylingEnabled:Bool = true, data:Bindable<String> = null)
	{
#if debug
	if (id == null)
		id = this.getReadableId();
#end
		this.id				= new Bindable<String>(id);
		super(data);
#if flash9
		styleClasses		= new SimpleList<String>();
		this.stylingEnabled	= stylingEnabled;
#end
		visible				= false;
		changes				= 0;
		state				= new UIElementStates();
		behaviours			= new BehaviourList();
		
		//add default behaviour
		init.onceOn( displayEvents.addedToStage, this );
		behaviours.add( new ValidateLayoutBehaviour(this) );
		
		createBehaviours();
		createLayout();
		
		state.current = state.constructed;
	}


	override public function dispose ()
	{
		if (isDisposed())
			return;
		
		if (container != null)			detachDisplay();
		if (layout.parent != null)		detachLayout();
		
		//Change the state to disposed before the behaviours are removed.
		//This way a behaviour is still able to respond to the disposed
		//state.
		state.current = state.disposed;
		
		removeValidation();
		behaviours.dispose();
		id.dispose();
		state.dispose();
		
		if (layout != null)
			layout.dispose();
		
#if flash9
		if (style != null && style.target == this)
			style.dispose();
		
		styleClasses.dispose();
		styleClasses	= null;
		style			= null;
#end
		
		id				= null;
		state			= null;
		behaviours		= null;
		super.dispose();
	}
	
	
	public inline function isDisposed ()	{ return state == null || state.is(state.disposed); }
	public inline function isInitialized ()	{ return state != null && state.is(state.initialized); }
	public function isResizable ()			{ return true; }
	
	
	//
	// ATTACH METHODS
	//
	
	public inline function attachLayoutTo	(t:ILayoutContainer, pos:Int = -1)	: IUIElement	{ t.children.add( layout, pos );										return this; }
	public inline function detachLayout		()									: IUIElement	{ layout.parent.children.remove( layout );								return this; }
	public inline function attachTo			(t:IUIContainer, pos:Int = -1)		: IUIElement	{ attachLayoutTo(t.layoutContainer, pos);	attachDisplayTo(t, pos);	return this; }
	public inline function detach			()									: IUIElement	{ detachDisplay();							detachLayout();				return this; }
	

	//
	// METHODS
	//

	private function init ()
	{
		visible = true;
		behaviours.init();
		validate();
		removeValidation.on( displayEvents.removedFromStage, this );
	//	applyTextFormat	.on( displayEvents.addedToStage, this );
		
		state.current = state.initialized;
	}


	private function createLayout () : Void
	{
		layout = new LayoutClient();
	}
	
	
	public inline function setHtmlText (v:String) : Void
	{
		if (v == null)
			v = "";
		
		htmlText = v;
		invalidate( UIElementFlags.TEXT );
	//	layout.invalidate( LayoutFlags.WIDTH | LayoutFlags.HEIGHT );
	//	updateSize.onceOn( layout.state.change, this );
	}
	
	
#if flash9
	override private function setTextStyle (v)
	{
	//	Assert.notNull(v);
		
		invalidate( UIElementFlags.TEXTSTYLE );
		textStyle = v;
		
		if (v != null)
			defaultTextFormat = v;
		
		if (window == null)
			return v;
		
		//Invalidate layout and apply the textformat when the layout starts validating
		//This will prevend screen flickering.
	//	layout.invalidate( LayoutFlags.WIDTH | LayoutFlags.HEIGHT );
		
		return v; 
	}
	
	
	override private function applyTextFormat ()
	{
		super.applyTextFormat();
		updateSize.onceOn( displayEvents.enterFrame, this );
	}
	
	
	private function setStylingEnabled (v:Bool)
	{
		if (v != stylingEnabled)
		{
			if (stylingEnabled) {
				style.dispose();
				style = null;
			}
			
			stylingEnabled = v;
			if (stylingEnabled)
				style = new UIElementStyle(this, this);
		}
		return v;
	}
#end
	
	
	
	
	//
	// IPROPERTY-VALIDATOR METHODS
	//
	
	private inline function getSystem () : ISystem		{ return window.as(ISystem); }
	public inline function isOnStage () : Bool			{ return window != null; }
	public inline function isQueued () : Bool			{ return nextValidatable != null || prevValidatable != null; }
	
	
	public function invalidate (change:Int)
	{
		if (change != 0)
		{
			changes = changes.set( change );
			
			if (changes == change && isInitialized())
				if (system != null)		system.invalidation.add(this);
				else					validate.onceOn( displayEvents.addedToStage, this );
		}
	}
	
	
	public function validate ()
	{
		if (changes.has( UIElementFlags.TEXTSTYLE ))
			applyTextFormat();
		
		else if (changes.has( UIElementFlags.TEXT ))
			updateSize();
		
		changes = 0;
	}
	
	
	/**
	 * method is called when the object is removed from the stage or disposed
	 * and will remove the object from the validation queue.
	 */
	private function removeValidation () : Void
	{
		if (isQueued() &&isOnStage())
			system.invalidation.remove(this);
			
		if (!isDisposed() && changes > 0)
			validate.onceOn( displayEvents.addedToStage, this );
	}
	
	
	
	
	//
	// ACTIONS (actual methods performed by UIElementActions util)
	//

	public inline function show ()						{ this.doShow(); }
	public inline function hide ()						{ this.doHide(); }
	public inline function move (x:Int, y:Int)			{ this.doMove(x, y); }
	public inline function resize (w:Int, h:Int)		{ this.doResize(w, h); }
	public inline function rotate (v:Float)				{ this.doRotate(v); }
	public inline function scale (sx:Float, sy:Float)	{ this.doScale(sx, sy); }
	
	
	private function createBehaviours ()	: Void		{}
	
	
	
	//
	// EVENTHANDLERS
	//
	
	private function updateSize ()
	{
#if flash9
		if (autoSize == flash.text.TextFieldAutoSize.NONE)
			scrollH = 0;
#end
		layout.invalidatable = false;
		if (layout.percentWidth.notSet())	layout.width	= realTextWidth.roundFloat();
		if (layout.percentHeight.notSet())	layout.height	= realTextHeight.roundFloat();
		layout.invalidatable = true;
		
		// Disabled since sometimes the validation will happen too soon (E.g. try tooltip).
		// Although enabling this code can also solve some textfield 
		// problems like setting the correct size for the titlefield of the mediapopup.
	//	if (layout.parent == null && layout.changes > 0)
	//		layout.validate();
	}
	
	
#if debug
	override public function toString()		{ return id.value; }
	public function readChanges()			{ return UIElementFlags.readProperties(changes); }
#end
}