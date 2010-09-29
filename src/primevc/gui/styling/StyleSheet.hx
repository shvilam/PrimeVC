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
package primevc.gui.styling;

#if flash9
import primevc.core.dispatcher.Wire;
 import primevc.core.IDisposable;
 import primevc.gui.styling.declarations.FilterCollectionType;
 import primevc.gui.styling.declarations.FilterStyleDeclarations;
 import primevc.gui.styling.declarations.FilterStyleProxy;
 import primevc.gui.styling.declarations.LayoutStyleDeclarations;
 import primevc.gui.styling.declarations.LayoutStyleProxy;
 import primevc.gui.styling.declarations.StyleDeclarationType;
 import primevc.gui.styling.declarations.UIElementStyle;
 import primevc.gui.traits.IStylable;
 import primevc.utils.FastArray;
  using primevc.utils.Bind;
  using primevc.utils.FastArray;
  using primevc.utils.TypeUtil;
  using Type;



/**
 * StyleSheet contains all style objects that are used by one IUIElement.
 * It's a unique collection of id-selectors, styleName-selectors and 
 * element-selectors.
 * 
 * The StyleSheet of an element has to be rebuild everytime the element is 
 * changing of parent.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 22, 2010
 */
class StyleSheet implements IDisposable
{
	public var idStyle			: UIElementStyle;
	public var styleNameStyles	: FastArray < UIElementStyle >;
	public var elementStyle		: UIElementStyle;
	
	/**
	 * object on which the style applies
	 */
	private var target			: IStylable;
	
	/**
	 * cached classname (incl package) of target since target won't change.
	 */
	public var targetClassName	: String;
	
	
	private var addedBinding	: Wire <Dynamic>;
	private var removedBinding	: Wire <Dynamic>;
	
	
	
	public function new (target:IStylable)
	{
		styleNameStyles = FastArrayUtil.create();
		this.target		= target;
		targetClassName	= target.getClass().getClassName();
		
		updateStyleClasses	.on( target.styleClasses.change, this );
		updateIdStyle		.on( target.id.change, this );
		init();
	}
	
	
	private function init ()
	{
		addedBinding	= updateStyles	.on( target.displayEvents.addedToStage, this );
		removedBinding	= clearStyles	.on( target.displayEvents.removedFromStage, this );
		removedBinding.disable();
	}
	
	
	public function dispose ()
	{
		if (target == null)
			return;
		
		if (addedBinding != null) {
			addedBinding.dispose();
			addedBinding = null;
		}
		if (removedBinding != null) {
			removedBinding.dispose();
			removedBinding = null;
		}
		
		target.styleClasses.change.unbind( this );
		target.id.change.unbind( this );
	//	target.displayEvents.addedToStage.unbind( this );
	//	target.displayEvents.removedFromStage.unbind( this );
		
		clearStyles();
		styleNameStyles = null;
		targetClassName	= null;
		target			= null;
	}
	
	
	public function findStyle ( name:String, type:StyleDeclarationType, ?exclude:UIElementStyle ) : UIElementStyle
	{
		var style : UIElementStyle = null;
		
		//search in the id-style
		if (style == null && idStyle != null)
			style = idStyle.findStyle(name, type, exclude);
		
		//search in stylenames list
		if (style == null && styleNameStyles.length > 0)
		{
			for (styleNameStyle in styleNameStyles)
			{
				style = styleNameStyle.findStyle(name, type, exclude);
				if (style != null)
					break;
			}
		}
		
		//search in the element style
		if (style == null && elementStyle != null)
			style = elementStyle.findStyle(name, type, exclude);
		
		//look in parent.. (prevent infinte loops with parentStyle != this)
		var parentStyle = getParentStyle();
		if (style == null && parentStyle != null && parentStyle != this)
			style = parentStyle.findStyle( name, type, exclude );
		
		return style;
	}
	
	
	private function clearStyles () : Void
	{
		removedBinding.disable();
		addedBinding.enable();
		styleNameStyles.removeAll();
		idStyle			= null;
		elementStyle	= null;
	}
	
	
	private function updateStyleClasses () : Void
	{	
		//remove all styles
		styleNameStyles.removeAll();
		
		if (target.styleClasses.value == null || target.styleClasses.value == "")
			return;
		
		var parentStyle = getParentStyle();
		Assert.notNull( parentStyle );
		
		
		//search the style-object of each stylename
		var styleNames = target.styleClasses.value.split(",");
		for ( styleName in styleNames )
		{
			var tmp = parentStyle.findStyle( styleName, StyleDeclarationType.styleName );
			if (tmp != null)
				styleNameStyles.push( tmp );
		}
	}
	
	
	private function updateIdStyle () : Void
	{
		//remove old id style
		idStyle = null;
		
		if (target.id.value == null || target.id.value == "")
			return;
		
		var parentStyle = getParentStyle();
		Assert.notNull( parentStyle );
		idStyle = parentStyle.findStyle( target.id.value, StyleDeclarationType.id );
	}
	
	
	private function updateElementStyle () : Void
	{
		var parentStyle = getParentStyle();
		Assert.notNull( parentStyle );
		
		elementStyle = null;
		var parentClass = target.getClass();
		
		//search for the first element style that is defined for this object or one of it's super classes
		while (parentClass != null && elementStyle == null)
		{
			elementStyle	= parentStyle.findStyle( parentClass.getClassName(), StyleDeclarationType.element );
			parentClass		= cast parentClass.getSuperClass();
		}
		
	}
	
	
	public function updateStyles () : Void
	{
		removedBinding.enable();
		addedBinding.disable();
		
		if (getParentStyle() == null)
			return;
		
		updateIdStyle();
		updateStyleClasses();
		updateElementStyle();
		
		target.applyStyling();
	}
	
	
	private inline function getParentStyle () : StyleSheet
	{
		Assert.notNull( target.container );
		Assert.that( target.container.is( IStylable ) );
		Assert.notNull( target.container.as( IStylable ).style );
		return target.container.as( IStylable ).style;
	}
	
	
	public function getLayout () : LayoutStyleDeclarations
	{
		return new LayoutStyleProxy(this);
	}


	public function getBoxFilters () : FilterStyleDeclarations
	{
		return new FilterStyleProxy(this, FilterCollectionType.box);
	}
	
	
	
	//
	// ITERATABLE METHODS
	//
	
	public function iterator () : Iterator < UIElementStyle >
	{
		return cast new StyleSheetIterator(this);
	}
}





class StyleSheetIterator
{
	private var target				: StyleSheet;
	private var currentStyleObj		: UIElementStyle;
	
	/**
	 * The StyleDeclarationType of the last used UIElementStyle
	 */
	private var currentType			: StyleDeclarationType;
	
	/**
	 * Keeps track of the last position of the currentStyleObj in the 
	 * target.styleNameStyles list.
	 */
	private var styleNamesListPos	: Int;
	
	
	
	
	public function new (target:StyleSheet)
	{
		this.target			= target;
		currentType			= isTargetEmpty() ? null : specific;
		styleNamesListPos	= -1;
	}
	
	
	public function next () : UIElementStyle
	{
		switch (currentType)
		{
			//there is no next object
			case element:
				currentStyleObj = null;
				currentType		= null;
			
			
			//element will be next if this is the last styleName style
			case styleName:
				if (styleNamesListPos >= target.styleNameStyles.length) {
					currentStyleObj = target.elementStyle;
					currentType		= element;
				}
				else
					currentStyleObj	= target.styleNameStyles[ styleNamesListPos++ ];
			
			
			case id:	
				styleNamesListPos++;
				currentType = styleName;
			
			
			//currentStyleObj is still 'specific'
			default:
				currentType		= id;
				currentStyleObj	= target.idStyle;
		}
		
		
		if (currentStyleObj == null && hasNext())
			next();
		
		return currentStyleObj;
	}
	
	
	public function hasNext () : Bool {
		return currentType != null && currentType != element;
	}
	
	
	private function isTargetEmpty () : Bool {
		return target.idStyle == null && target.elementStyle == null && target.styleNameStyles.length == 0;
	}
}

#else

class StyleSheet {}

#end