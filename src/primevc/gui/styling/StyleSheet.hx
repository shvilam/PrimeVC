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
 import primevc.core.dispatcher.Signal1;
 import primevc.core.dispatcher.Wire;
 import primevc.core.traits.IInvalidatable;
 import primevc.core.traits.IInvalidateListener;
 import primevc.core.IDisposable;
 import primevc.gui.styling.declarations.EffectStyleDeclarations;
 import primevc.gui.styling.declarations.EffectStyleProxy;
 import primevc.gui.styling.declarations.FilterCollectionType;
 import primevc.gui.styling.declarations.FilterStyleDeclarations;
 import primevc.gui.styling.declarations.FilterStyleProxy;
 import primevc.gui.styling.declarations.LayoutStyleDeclarations;
 import primevc.gui.styling.declarations.LayoutStyleProxy;
 import primevc.gui.styling.declarations.StyleDeclarationType;
 import primevc.gui.styling.declarations.StyleFlags;
 import primevc.gui.styling.declarations.UIElementStyle;
 import primevc.gui.traits.IStylable;
 import primevc.utils.FastArray;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
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
class StyleSheet implements IInvalidateListener, implements IDisposable
{
	/**
	 * object on which the style applies
	 */
	private var target					: IStylable;
	/**
	 * cached classname (incl package) of target since target won't change.
	 */
	private var targetClassName			: String;
	
	private var addedBinding			: Wire <Dynamic>;
	private var removedBinding			: Wire <Dynamic>;
	private var styleNamesChangeBinding	: Wire <Dynamic>;
	private var idChangeBinding			: Wire <Dynamic>;
	
	
	public var idStyle					(default, null)			: UIElementStyle;
	public var styleNameStyles			(default, null)			: FastArray < UIElementStyle >;
	public var elementStyle				(default, null)			: UIElementStyle;
	
	
	/**
	 * Bitflag-collection with all properties that are set in the styles of 
	 * the target,
	 */
	public var filledProperties			(default, null)	: UInt;
	/**
	 * Cached bitflag with the properties of the id-style (if there is any)
	 */
	public var idStyleProperties		(default, null)	: UInt;
	/**
	 * Cached bitflag with the properties of every style-name-style (if there 
	 * are any)
	 */
	public var styleNameStyleProperties	(default, null)	: UInt;
	/**
	 * Cached bitflag with the properties of the element-style (if there is any)
	 */
	public var elementStyleProperties	(default, null)	: UInt;
	
	
	/**
	 * Signal which is dispatched when one of the style objects is changed. 
	 * The parameter of signal will be a bit-flag conttaining all the properties
	 * that are changed.
	 */
	public var change					(default, null)			: Signal1 < UInt >;
	/**
	 * Current css-state of the object. When the property is set, the class 
	 * will look for style-information that only applies for the given state.
	 * 
	 * All the properties that are changed will be stored as bitflags in 
	 * 'stateChanges'. The style-information of the object before the state
	 * was changed will be temporarily stored in 'orignalStyle'.
	 */
	public var state					(default, setState)		: String;
	public var stateChanges				: UInt;
	
	/**
	 * Flag indicating wether the styles of the target are searched or not (by 
	 * calling updateStyles method). If the clearStyles method is called, this
	 * flag is set to false again.
	 * 
	 * Property is used to check if some style-updating methods should send a 
	 * change event or not.
	 */
	private var stylesAreSearched		: Bool;
	
	public var layout					(default, null)	: LayoutStyleProxy;
	public var boxFilters				(default, null)	: FilterStyleProxy;
	public var effects					(default, null)	: EffectStyleProxy;
	
	
	
	
	public function new (target:IStylable)
	{
		styleNameStyles		= FastArrayUtil.create();
		this.target			= target;
		targetClassName		= target.getClass().getClassName();
		change				= new Signal1();
		
		stylesAreSearched	= false;
		idStyleProperties	= styleNameStyleProperties = elementStyleProperties = 0;
		
		styleNamesChangeBinding = updateStyleNameStyles	.on( target.styleClasses.change, this );
		idChangeBinding			= updateIdStyle			.on( target.id.change, this );
		
		styleNamesChangeBinding.disable();
		idChangeBinding.disable();
		
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
		
		change.dispose();
		target.styleClasses.change.unbind( this );
		target.id.change.unbind( this );
	//	target.displayEvents.addedToStage.unbind( this );
	//	target.displayEvents.removedFromStage.unbind( this );
		
		clearStyles();
		styleNameStyles = null;
		targetClassName	= null;
		target			= null;
		change			= null;
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
		styleNamesChangeBinding.disable();
		idChangeBinding.disable();
		removedBinding.disable();
		addedBinding.enable();
		
		removeStyleNameStyles();
		
		stylesAreSearched	= false;
		idStyle				= null;
		elementStyle		= null;
		filledProperties	= idStyleProperties	= styleNameStyleProperties = elementStyleProperties = 0;
		
		change.send( StyleFlags.ALL_PROPERTIES );
	}
	
	
	public function updateStyles () : Void
	{	
		styleNamesChangeBinding.enable();
		idChangeBinding.enable();
		removedBinding.enable();
		addedBinding.disable();
		
		if (getParentStyle() == null)
			return;
		
		
		if (layout == null)			layout		= new LayoutStyleProxy(this);
		if (boxFilters == null)		boxFilters	= new FilterStyleProxy(this, FilterCollectionType.box);
		if (effects == null)		effects		= new EffectStyleProxy(this);
		
		filledProperties = 0;
		updateIdStyle();
		updateStyleNameStyles();
		updateElementStyle();
		
		//update filled-properties flag
		updateFilledPropertiesFlag();
		stylesAreSearched = true;
		
		change.send( filledProperties );
	}
	
	
	/**
	 * Method to loop through all available style objects to find all the 
	 * properties that are set for the target.
	 */
	private function updateFilledPropertiesFlag ()
	{
		filledProperties = idStyleProperties | styleNameStyleProperties | elementStyleProperties;
		
		layout.updateAllFilledPropertiesFlag();
		effects.updateAllFilledPropertiesFlag();
		boxFilters.updateAllFilledPropertiesFlag();
	}
	
	
	private function updateIdStyle () : Void
	{
		//remove old id style
		if (idStyle != null) {
			idStyle.listeners.remove( this );
			idStyle			= null;
		}
		var styleChanges	= idStyleProperties;
		idStyleProperties	= 0;
		
		if (target.id.value != null && target.id.value != "")
		{
			var parentStyle	= getParentStyle();
			Assert.notNull( parentStyle );
			idStyle			= parentStyle.findStyle( target.id.value, StyleDeclarationType.id );
			
			if (idStyle != null) {
				idStyleProperties = idStyle.allFilledProperties;
				idStyle.listeners.add( this );
			}
		}
		
		if (stylesAreSearched)
		{
			styleChanges = styleChanges.set( idStyleProperties );
			updateFilledPropertiesFlag();
			change.send( styleChanges );
		}
	}
	
	
	/**
	 * Method to remove all style-name-style classes, including the listeners.
	 */
	private function removeStyleNameStyles () : Void
	{
		while (styleNameStyles.length > 0)
		{
			var style = styleNameStyles.pop();
			style.listeners.remove( this );
		}
	}
	
	
	private function updateStyleNameStyles () : Void
	{	
		//remove all styles
		removeStyleNameStyles();
		
		var styleChanges:UInt		= styleNameStyleProperties;
		styleNameStyleProperties	= 0;
		
		if (target.styleClasses.value != null && target.styleClasses.value != "")
		{
			var parentStyle = getParentStyle();
			Assert.notNull( parentStyle );
			
			//search the style-object of each stylename
			var styleNames = target.styleClasses.value.split(",");
			for ( styleName in styleNames )
			{
				var tmp = parentStyle.findStyle( styleName, StyleDeclarationType.styleName );
				if (tmp != null) {
					styleNameStyles.push( tmp );
					styleNameStyleProperties = styleNameStyleProperties.set( tmp.allFilledProperties );
					tmp.listeners.add( this );
				}
			}
		}
		
		if (stylesAreSearched)
		{
			styleChanges = styleChanges.set( styleNameStyleProperties );	//add properties that are set in the new style-objects
			styleChanges = styleChanges.unset( idStyleProperties );			//remove properties that are set in the id-style
			
			updateFilledPropertiesFlag();
			change.send( styleChanges );
		}
	}
	
	
	private function updateElementStyle () : Void
	{
		var parentStyle = getParentStyle();
		Assert.notNull( parentStyle );
		
		if (elementStyle != null) {
			elementStyle.listeners.remove( this );
			elementStyle = null;
		}
		
		var styleChanges:UInt	= elementStyleProperties;
		elementStyleProperties	= 0;
		var parentClass			= target.getClass();
		
		//search for the first element style that is defined for this object or one of it's super classes
		while (parentClass != null && elementStyle == null)
		{
			elementStyle	= parentStyle.findStyle( parentClass.getClassName(), StyleDeclarationType.element );
			parentClass		= cast parentClass.getSuperClass();
			
			if (elementStyle != null) {
				elementStyleProperties = elementStyle.allFilledProperties;
				elementStyle.listeners.add( this );
			}
		}
		
		if (stylesAreSearched)
		{
			styleChanges = styleChanges.set( elementStyleProperties );		//add properties that are set in the new style-object
			styleChanges = styleChanges.unset( idStyleProperties );			//remove properties that are set in the id-style
			styleChanges = styleChanges.unset( styleNameStyleProperties );	//remove properties that are set in the stylenamestyles
			
			updateFilledPropertiesFlag();
			change.send( styleChanges );
		}
	}
	
	
	private inline function getParentStyle () : StyleSheet
	{
		Assert.notNull( target.container );
		Assert.that( target.container.is( IStylable ) );
		Assert.notNull( target.container.as( IStylable ).style );
		return target.container.as( IStylable ).style;
	}
	
	
	
	//
	// SETTERS
	//
	
	private inline function setState (v:String) : String
	{
	//	trace(target + ".setStyleState "+state+" => "+v);
		return state = v;
	}
	
	
	//
	// IINVALIDATELIST METHODS
	//
	
	public function invalidateCall (changes:UInt, sender:IInvalidatable)
	{
		//if sender is the idStyle, the changes will always be used
		if (sender != idStyle)
		{
			if (sender == elementStyle && styleNameStyles.length > 0)
			{
				//remove changes that are overwritten in style-name-styles
				for (style in styleNameStyles)
					changes = changes.unset( style.allFilledProperties );
			}
			//remove changes that are overwritten in the idStyle
			if (idStyle != null)
				changes = changes.unset( idStyle.allFilledProperties );
		}
		
		trace("\tchanged properties "+StyleFlags.readProperties(changes));
		
		if (changes > 0)
			change.send( changes );
	}
	
	
	//
	// ITERATABLE METHODS
	//
	
	public function iterator () : Iterator < UIElementStyle >
	{
		return cast new StyleSheetIterator(this);
	}
	
	
#if debug
	public function readProperties (flags:UInt = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;
		
		return StyleFlags.readProperties(flags);
	}
#end
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