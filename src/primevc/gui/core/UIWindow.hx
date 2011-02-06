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
#if (flash9 && stats)
 import net.hires.debug.Stats;
#end
 import primevc.core.geom.IntRectangle;
 import primevc.core.traits.IIdentifiable;
 import primevc.core.Bindable;
 import primevc.gui.behaviours.layout.AutoChangeLayoutChildlistBehaviour;
 import primevc.gui.behaviours.layout.WindowLayoutBehaviour;
 import primevc.gui.behaviours.BehaviourList;
 import primevc.gui.behaviours.RenderGraphicsBehaviour;
 import primevc.gui.display.Stage;
 import primevc.gui.display.Window;
 import primevc.gui.graphics.GraphicProperties;
 import primevc.gui.layout.algorithms.RelativeAlgorithm;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.VirtualLayoutContainer;
 import primevc.gui.managers.InvalidationManager;
 import primevc.gui.managers.IPopupManager;
 import primevc.gui.managers.ISystem;
 import primevc.gui.managers.PopupManager;
 import primevc.gui.managers.RenderManager;
 import primevc.gui.managers.ToolTipManager;
 import primevc.gui.styling.ApplicationStyle;
 import primevc.gui.styling.UIElementStyle;
 import primevc.gui.traits.IBehaving;
 import primevc.gui.traits.IDrawable;
 import primevc.gui.traits.ILayoutable;
 import primevc.gui.traits.IStylable;
  using primevc.utils.TypeUtil;

#if flash9
 import primevc.core.collections.SimpleList;
 import primevc.gui.display.VectorShape;
#end


/**
 * UIWindow acts as a container for display objects and 
 * determines their layout. 
 * 
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
class UIWindow extends Window		
	,	implements IBehaving
	,	implements IDrawable
	,	implements IIdentifiable
	,	implements ILayoutable
	,	implements IStylable
	,	implements ISystem
{
	public var layout				(default, null)					: LayoutClient;
	
	/**
	 * variable 'layout' casted as LayoutContainer. The 'layout' is meant for
	 * the children of window except for popups.
	 */
	public var layoutContainer		(getLayoutContainer, never)		: LayoutContainer;
	
	/**
	 * Top layout-container, only containing 'layout' and 'popupLayout'.
	 */
	public var topLayout			(default, null)					: LayoutContainer;
	/**
	 * Layoutcontainer for popups.
	 */
	public var popupLayout			(default, null)					: LayoutContainer;
	
	
	
	public var behaviours			(default, null)					: BehaviourList;
	public var id					(default, null)					: Bindable < String >;
	public var graphicData			(default, null)					: GraphicProperties;
	
#if flash9
	/**
	 * Shape to draw the background graphics in. Stage doesn't have a Graphics
	 * property.
	 */
	public var bgShape				: VectorShape;
	/**
	 * Reference to bgShape.graphics.. Needed for compatibility with IDrawable
	 */
	public var graphics				(default, null)					: flash.display.Graphics;
	public var rect					(default, null)					: IntRectangle;
	
	public var style				(default, null)					: UIElementStyle;
	public var styleClasses			(default, null)					: SimpleList<String>;
	public var stylingEnabled		(default, setStylingEnabled)	: Bool;
#end
	
	public var invalidation			(default, null)					: InvalidationManager;
	public var rendering			(default, null)					: RenderManager;
	public var popups				(getPopupManager, null)			: IPopupManager;
	public var toolTip				(default, null)					: ToolTipManager;
	
	
	public function new (target:Stage, id:String = null)
	{
		super(target);
		
#if debug
		if (id == null)
			id = this.getReadableId();
#end
		this.id			= new Bindable<String>( id );
		rendering		= new RenderManager(this);
		invalidation	= new InvalidationManager(this);
		toolTip			= new ToolTipManager(this);
		
		behaviours		= new BehaviourList();
		rect			= new IntRectangle();
		
#if flash9		
		graphicData		= new GraphicProperties(rect);
		styleClasses	= new SimpleList<String>();
#end
		
		behaviours.add( new WindowLayoutBehaviour(this) );
		behaviours.add( new RenderGraphicsBehaviour(this) );
		
		createBehaviours();
		createLayout();
		
#if flash9
		bgShape			= new VectorShape();
		graphics		= bgShape.graphics;
		children.add(bgShape);
		stylingEnabled	= true;
#end
		init();
	}
	
	
	private function init ()
	{
		behaviours.init();
		createChildren();

#if (flash9 && stats)
		children.add( new Stats() );
#end
	}


	override public function dispose ()
	{
		if (displayEvents == null)
			return;
		
		behaviours		.dispose();
		layout			.dispose();
		invalidation	.dispose();
		rendering		.dispose();
		toolTip			.dispose();
		rect			.dispose();
		
#if flash9
		bgShape			.dispose();
		style			.dispose();
		styleClasses	.dispose();
		styleClasses	= null;
		style			= null;
		bgShape			= null;
#end
		
		if (layout != null)					layout		.dispose();
		if (graphicData != null)			graphicData	.dispose();
		if ((untyped this).popups != null)	popups		.dispose();
		
		behaviours		= null;
		graphicData		= null;
		layout			= null;
		invalidation	= null;
		rendering		= null;
		rect			= null;
		
		super.dispose();
	}
	
	
	private inline function createLayout ()
	{
		topLayout	=	#if flash9	new primevc.avm2.layout.StageLayout( target );
						#else		new LayoutContainer();	#end
		
		topLayout.children.add( layout		= new VirtualLayoutContainer( #if debug "contentLayout" #end ) );
		topLayout.children.add( popupLayout	= new VirtualLayoutContainer( #if debug "popupLayout" #end ) );
		
		popupLayout.algorithm	= new RelativeAlgorithm();
		layout.percentWidth		= layout.percentHeight = popupLayout.percentWidth = popupLayout.percentHeight = 1.0;
	//	layoutContainer.algorithm = new RelativeAlgorithm();
	}
	
	
	//
	// ABSTRACT METHODS
	//
	
	private function createBehaviours ()	: Void
	{
		behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
	}
	
	
	private function createChildren ()		: Void;
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getLayoutContainer ()
	{
		return layout.as(LayoutContainer);
	}
	
	
	private inline function getPopupManager ()
	{
		if (popups == null)
			popups = new PopupManager(this);
		return popups;
	}
	
	
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
			if (v) {
				style = new ApplicationStyle(this);
				style.updateStyles();
			}
		}
		return v;
	}
#end


#if debug
	public function toString ()
	{
		return id.value;
	}
#end
}