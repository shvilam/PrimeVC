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
 import primevc.core.Bindable;
 import primevc.gui.behaviours.layout.ValidateLayoutBehaviour;
 import primevc.gui.behaviours.styling.InteractiveStyleChangeBehaviour;
 import primevc.gui.behaviours.BehaviourList;
 import primevc.gui.behaviours.RenderGraphicsBehaviour;
 import primevc.gui.display.Sprite;
 import primevc.gui.effects.UIElementEffects;
 import primevc.gui.events.UserEventTarget;
 import primevc.gui.graphics.GraphicProperties;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.managers.ISystem;
 import primevc.gui.states.UIElementStates;
#if flash9
 import primevc.core.collections.SimpleList;
 import primevc.gui.styling.UIElementStyle;
#end
 import primevc.gui.traits.IValidatable;
  using primevc.gui.utils.UIElementActions;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;


/**
 * UIComponent defines the basic behaviour of a UIComponent without data.
 *
 * These include the default states of a component, the way it
 * should change between states and a helper function to create a new skin.
 * 
 * To create a component, extend UIComponent and override the 
 * following methods:
 * 	- createStates
 * 	- createBehaviours
 *  - createChildren
 *  - createSkin
 *  - removeStates
 *  - removeSkin
 *  - removeChildren
 * 
 * Non of these methods need to call their super methods because they
 * are empty.
 *  
 * When any behaviours outside of "public var behaviours" are defined,
 * the removeBehaviours() method should be overridden.
 * 
 * @author Ruben Weijers
 * @creation-date Jun 07, 2010
 */
class UIComponent extends Sprite, implements IUIComponent
{
	public var prevValidatable	: IValidatable;
	public var nextValidatable	: IValidatable;
	private var changes			: Int;
	
	public var behaviours		(default, null)					: BehaviourList;
	public var state			(default, null)					: UIElementStates;
	public var effects			(default, default)				: UIElementEffects;
	public var id				(default, null)					: Bindable < String >;
	
	public var skin				(default, setSkin)				: ISkin;
	public var layout			(default, null)					: LayoutClient;
	public var system			(getSystem, never)				: ISystem;
	
#if flash9	
	public var graphicData		(default, null)					: GraphicProperties;
	public var style			(default, null)					: UIElementStyle;
	public var styleClasses		(default, null)					: SimpleList < String >;
	public var stylingEnabled	(default, setStylingEnabled)	: Bool;
#end
	
	public var enabled			(default, null)					: Bindable < Bool >;
	
	
	public function new (?id:String)
	{
		super();
		
#if debug
		if (id == null)
			id = this.getReadableId();
#end
		this.id			= new Bindable<String>(id);
		this.enabled	= new Bindable<Bool>(true);
		visible			= false;
		changes			= 0;
		
		state			= new UIElementStates();
		behaviours		= new BehaviourList();
		
		handleEnableChange.on( enabled.change, this );
		init.onceOn( displayEvents.addedToStage, this );
#if flash9		
		graphicData		= new GraphicProperties( rect );
		styleClasses	= new SimpleList<String>();
		stylingEnabled	= true;		// <- will create UIElementStyle instance
		
		//add default behaviours
		behaviours.add( new ValidateLayoutBehaviour(this) );
		behaviours.add( new RenderGraphicsBehaviour(this) );
		behaviours.add( new InteractiveStyleChangeBehaviour(this) );
#end
		
		createStates();
		createBehaviours();
		createLayout();
		
		state.current = state.constructed;
	}
	
	
	private function init ()
	{
		if (isInitialized())
			return;

#if flash9		
		Assert.notNull(parent);
#end
	//	Assert.notNull(container, "Container can't be null for "+this);
		behaviours.init();
		
		if (skin != null)
			skin.createChildren();
		
		//create the children of this component after the skin has created it's children
		createChildren();
		
		//notify the skin that the children of the UIComponent are created
		if (skin != null)
			skin.childrenCreated();
		
		validate();
		removeValidation.on( displayEvents.removedFromStage, this );
		
		//finish initializing
		state.current = state.initialized;
	}
	
	
	public inline function forceInitialization ()
	{
		init();
	}
	
	
	override public function dispose ()
	{
		if (isDisposed())
			return;
		
		removeValidation();
		removeChildren();
		removeStates();
		
		//Change the state to disposed before the behaviours are removed.
		//This way a behaviour is still able to respond to the disposed
		//state.
		state.current = state.disposed;
		Assert.that(isDisposed());
		
		behaviours	.dispose();
		state		.dispose();
		graphicData	.dispose();
		
		if (layout != null)
			layout.dispose();
		
		id.dispose();
		enabled.dispose();
		
#if flash9
		style.dispose();
		styleClasses.dispose();
		styleClasses	= null;
		style			= null;
#end
		state			= null;
		behaviours		= null;
		id				= null;
		enabled			= null;
		graphicData		= null;
		skin			= null;
		layout			= null;
		behaviours		= null;
		
		super.dispose();
	}
	
	
	public inline function isDisposed ()	{ return state == null || state.is(state.disposed); }
	public inline function isInitialized ()	{ return state != null && state.is(state.initialized); }
	public function isResizable ()			{ return true; }
	
	
	//
	// ATTACH METHODS
	//
	
	public inline function attachLayoutTo	(target:IUIContainer, pos:Int = -1) : IUIElement	{ target.layoutContainer.children.add( layout, pos ); return this; }
	public inline function attachTo			(target:IUIContainer, pos:Int = -1) : IUIElement	{ attachLayoutTo(target, pos); attachDisplayTo(target, pos); return this; }
	
	
	
	//
	// ACTIONS (actual methods performed by UIElementActions util)
	//
	
	public inline function show ()						{ this.doShow(); }
	public inline function hide ()						{ this.doHide(); }
	public inline function move (x:Int, y:Int)			{ this.doMove(x, y); }
	public inline function resize (w:Int, h:Int)		{ this.doResize(w, h); }
	public inline function rotate (v:Float)				{ this.doRotate(v); }
	public function scale (sx:Float, sy:Float)			{ this.doScale(sx, sy); }
	
	public inline function enable ()					{ enabled.value = true; }
	public inline function disable ()					{ enabled.value = false; }
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	private inline function getSystem () : ISystem		{ return window.as(ISystem); }
	public inline function isOnStage () : Bool			{ return window != null; }
	public inline function isQueued () : Bool			{ return nextValidatable != null || prevValidatable != null; }
	

	private function setSkin (newSkin)
	{
		if (skin != null)
			skin.dispose();
		
		skin = newSkin;
		
		if (skin != null)
			skin.changeOwner(this);
		
		return skin;
	}
	
	
#if flash9
	private inline function setStyle (v)
	{
		return style = v;
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
			if (v)
				style = new UIElementStyle(this, this);
		}
		return v;
	}
#end
	
	
	override public function isFocusOwner (target:UserEventTarget) : Bool
	{
		return super.isFocusOwner(target) || (skin != null && skin.isFocusOwner(target));
	}
	
	
	private function createLayout () : Void
	{
		layout = new LayoutClient();
#if debug
		layout.name = id+"Layout";
#end
	}
	
	
	private function removeChildren () : Void
	{
		children.removeAll();
	}
	
	
	//
	// IPROPERTY-VALIDATOR METHODS
	//
	
	public function invalidate (change:Int)
	{
		if (change != 0)
		{
			changes = changes.set( change );
			
			if (changes == change && isInitialized()) {
				if (system != null)		system.invalidation.add(this);
				else					validate.onceOn( displayEvents.addedToStage, this );
			}
		}
	}
	
	
	public function validate ()
	{
		if (changes > 0)
		{
			if (skin != null)
				skin.validate(changes);
			
			changes = 0;
		}
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
	// ABSTRACT METHODS
	//
	
	private function createStates ()		: Void; //	{ Assert.abstract(); }
	private function createBehaviours ()	: Void; //	{ Assert.abstract(); }
	private function createChildren ()		: Void; //	{ Assert.abstract(); }
	private function removeStates ()		: Void; //	{ Assert.abstract(); }
	
	
	//
	// EVENT HANDLERS
	//
	
	private function handleEnableChange (newVal:Bool, oldVal:Bool)
	{
		mouseEnabled = tabEnabled = children.mouseEnabled = children.tabEnabled = newVal;
	}
	
	
#if debug
	override public function toString ()	{ return id.value; }
	public function readChanges ()			{ return UIElementFlags.readProperties(changes); }
#end
}