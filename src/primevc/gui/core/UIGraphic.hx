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
 import primevc.gui.behaviours.BehaviourList;
 import primevc.gui.behaviours.RenderGraphicsBehaviour;
 import primevc.gui.display.Shape;
 import primevc.gui.effects.UIElementEffects;
 import primevc.gui.graphics.GraphicProperties;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.states.UIElementStates;
#if flash9
 import primevc.gui.styling.UIElementStyle;
 import primevc.gui.traits.IDrawable;
#end
  using primevc.gui.utils.UIElementActions;
  using primevc.utils.Bind;


/**
 * @author Ruben Weijers
 * @creation-date Aug 02, 2010
 */
class UIGraphic extends Shape
			,	implements IUIElement
#if flash9	,	implements IDrawable	#end
{
	public var behaviours		(default, null)					: BehaviourList;
	public var id				(default, null)					: Bindable < String >;
	public var state			(default, null)					: UIElementStates;
	public var effects			(default, default)				: UIElementEffects;
	
	public var layout			(default, null)					: LayoutClient;
	public var graphicData		(default, null)					: Bindable < GraphicProperties >;
	
#if flash9
	public var style			(default, null)					: UIElementStyle;
	public var styleClasses		(default, null)					: Bindable< String >;
	public var stylingEnabled	(default, setStylingEnabled)	: Bool;
#end
	
	
	public function new (id:String = null)
	{
		super();
		this.id	= new Bindable<String>(id);
		visible = false;
		init.onceOn( displayEvents.addedToStage, this );
		
		state			= new UIElementStates();
		behaviours		= new BehaviourList();
#if flash9
		styleClasses	= new Bindable < String > ();
		stylingEnabled	= true;
#end
		graphicData		= new Bindable < GraphicProperties > ();
		
		//add default behaviours
		behaviours.add( new RenderGraphicsBehaviour(this) );
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
		
		state.dispose();
		id.dispose();
#if flash9
		if (style.target == this)
			style.dispose();
		
		styleClasses.dispose();
#end

		if (layout != null)
			layout.dispose();
		
		if (graphicData != null)
		{
			if (graphicData.value != null)
				graphicData.value.dispose();

			graphicData.dispose();
			graphicData = null;
		}
		
		id				= null;
#if flash9
		style			= null;
		styleClasses	= null;
#end
		state			= null;
		behaviours		= null;
		layout			= null;

		super.dispose();
	}
	
	
	
	//
	// METHODS
	//
	
	
	private function init ()
	{
		behaviours.init();
		
		//overwrite the graphics of the skin with custom graphics (or do nothing if the method isn't overwritten)
		createGraphics();
		
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
		layout = new LayoutClient();
	}
	
	
	//
	// GETTERS / SETTESR
	//
	
#if flash9
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
				style = new UIElementStyle(this);
		}
		return v;
	}
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
	
	
	
	//
	// ABSTRACT METHODS
	//
	
	private function createBehaviours ()	: Void; //	{ Assert.abstract(); }
	private function createGraphics ()		: Void; //	{ Assert.abstract(); }
	private function removeGraphics ()		: Void; //	{ Assert.abstract(); }
	
	
#if debug
	override public function toString() { return id.value; }
#end
}