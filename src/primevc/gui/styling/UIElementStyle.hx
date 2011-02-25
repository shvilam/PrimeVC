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
 import primevc.core.collections.FastDoubleCell;
 import primevc.core.collections.ListChange;
 import primevc.core.collections.PriorityList;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.dispatcher.Wire;
 import primevc.core.traits.IInvalidatable;
 import primevc.gui.traits.IStylable;
 import primevc.utils.FastArray;
#if debug
 import primevc.utils.ID;
#end
  using primevc.gui.styling.StyleFlags;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.FastArray;
  using primevc.utils.IfUtil;
  using primevc.utils.TypeUtil;
  using Std;
  using Type;


private typedef Flags = StyleFlags;


/**
 * UIElementStyle contains all style objects that are used by one IUIElement.
 * It's a unique collection of id-selectors, styleName-selectors and 
 * element-selectors.
 * 
 * The UIElementStyle of an element has to be rebuild everytime the element is 
 * changing of parent.
 * 
 * When the target is removed from the stage, it's styles won't be removed
 * directly. This will only happen when the UIElementStyle is disposed or
 * when the target is added to the stage again but with a different parent.
 * 
 * By not removing the style when the target is removed-from-stage, a lot of
 * overhead is removed, since most of the time the object will be added to the
 * same parent.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 22, 2010
 */
class UIElementStyle implements IUIElementStyle
{
#if debug
	public var _oid						(default, null)			: Int;
#end
	
	/**
	 * object on which the style applies
	 */
	public var target					(default, null)			: IStylable;
	/**
	 * cached classname (incl package) of target since target won't change.
	 */
	private var targetClassName			: String;
	
	private var addedBinding			: Wire <Dynamic>;
	private var removedBinding			: Wire <Dynamic>;
	private var styleNamesChangeBinding	: Wire <Dynamic>;
	private var idChangeBinding			: Wire <Dynamic>;
	
	public var styles					(default, null)			: PriorityList < StyleBlock >;
	/**
	 * Bitflag-collection with all properties that are set in the styles of 
	 * the target,
	 */
	public var filledProperties			(default, null)			: Int;
	/**
	 * Signal which is dispatched when one of the style objects is changed. 
	 * The first parameter of signal will be a bit-flag conttaining all the 
	 * properties that are changed.
	 */
//	public var change					(default, null)			: Signal1 < Int >;
	/**
	 * Current css-states of the object.
	 */
	public var currentStates			(default, null)			: FastArray < StyleState >;
	
	/**
	 * Flag indicating wether the styles of the target are searched or not (by 
	 * calling updateStyles method). If the clearStyles method is called, this
	 * flag is set to false again.
	 * 
	 * Property is used to check if some style-updating methods should send a 
	 * change event or not.
	 */
	private var stylesAreSearched		: Bool;
	
	public var graphics					(getGraphics, null)		: GraphicsCollection;
	public var effects					(getEffects, null)		: EffectsCollection;
	public var boxFilters				(getBoxFilters, null)	: FiltersCollection;
	public var font						(getFont, null)			: TextStyleCollection;
	public var layout					(getLayout, null)		: LayoutCollection;
	/**
	 * Proxy object to loop through all available states in this object.
	 */
	public var states					(getStates, null)		: StatesCollection;
	
	/**
	 * Reference to the style of whom the current-style got it's properteies
	 */
	public var parentStyle				(default, null)			: IUIElementStyle;
	
	/**
	 * Signal is fired when the children-property of the element-style is
	 * changed
	 */
	public var childrenChanged			(default, null)			: Signal0;
	
	
	
	
	
	public function new (target:IStylable)
	{
#if debug
		_oid = ID.getNext();
#end
		currentStates		= FastArrayUtil.create();
		styles				= new PriorityList < StyleBlock > ();
		
		this.target			= target;
		targetClassName		= target.getClass().getClassName();
		childrenChanged		= new Signal0();
		
		stylesAreSearched	= false;
		filledProperties	= 0;
		
		styleNamesChangeBinding = updateStyleNameStyles	.on( target.styleClasses.change, this );
		idChangeBinding			= updateIdStyle			.on( target.id.change, this );
		
		styleNamesChangeBinding.disable();
		idChangeBinding.disable();
		
		init();
	}
	
	
	private function init ()
	{
		addedBinding	= enableStyleListeners	.on( target.displayEvents.addedToStage, this );
		removedBinding	= disableStyleListeners	.on( target.displayEvents.removedFromStage, this );
		
		if (target.window != null) {
			updateStyles();
			addedBinding.disable();
		} else {
			removedBinding.disable();
		}
	}
	
	
	public function dispose ()
	{
		if (target == null)
			return;
		
		if (addedBinding != null)				addedBinding.dispose();
		if (removedBinding != null)				removedBinding.dispose();
		if (styleNamesChangeBinding != null)	styleNamesChangeBinding.dispose();
		if (idChangeBinding != null)			idChangeBinding.dispose();
		
		addedBinding = removedBinding = styleNamesChangeBinding = idChangeBinding = null;
		
		//remove styles and their listeners
		while (styles.length > 0)
			removeStyleCell( styles.last );
		
		if (boxFilters != null)		boxFilters.dispose();
		if (effects != null)		effects.dispose();
		if (font != null)			font.dispose();
		if (graphics != null)		graphics.dispose();
		if (layout != null)			layout.dispose();
		if (states != null)			states.dispose();
		
		if (parentStyle != null && parentStyle.childrenChanged != null)
			parentStyle.childrenChanged.unbind( this );
		
		childrenChanged.dispose();
		currentStates.removeAll();
		
		parentStyle		= null;
		currentStates	= null;
		styles			= null;
		targetClassName	= null;
		target			= null;
		childrenChanged	= null;
		
		boxFilters		= null;
		effects			= null;
		font			= null;
		graphics		= null;
		layout			= null;
		states			= null;
#if debug
		_oid			= -1;
#end
	}
	
	
	public function findStyle ( name:String, type:StyleBlockType, ?exclude:StyleBlock ) : StyleBlock
	{
		var style : StyleBlock = null;
		
	//	trace(target+".findStyle "+name+" of type "+type+"; styles length: "+styles.length+"; "+Flags.readProperties(filledProperties));
		if (filledProperties.has( Flags.CHILDREN ))
		{
			for (styleObj in styles)
			{
				style = styleObj.findChild( name, type, exclude );
				if (style != null)
					break;
			}
		}
		
		if (style == null)
		{
			//look in parent.. (prevent infinte loops with parentStyle != this)
			if (parentStyle != this)
				style = parentStyle.findStyle( name, type, exclude );
		}
		return style;
	}
	
	
	/**
	 * Method will enable the style-listeners (changes). Method is called when
	 * the target is added to the stage
	 */
	private function enableStyleListeners ()
	{
		Assert.notNull( target.container );
		Assert.that( target.container.is( IStylable ) );
		Assert.notNull( target.container.as( IStylable ).style );
		
		if (removedBinding != null)		removedBinding.enable();
		if (addedBinding != null)		addedBinding.disable();
		
		//remove styles if the new parent is not the same as the old parent
		if (target.container != null && target.container.as( IStylable ).style != parentStyle)
		{
			clearStyles();
			
			parentStyle = target.container.as( IStylable ).style;
			resetStyles.on( parentStyle.childrenChanged, this );
			updateStyles();
		}
	}
	
	
	/**
	 * Method will disable the style-listeners (changes). Method is called when
	 * the target is removed from the stage
	 */
	private function disableStyleListeners ()
	{
		if (removedBinding != null)		removedBinding.disable();
		if (addedBinding != null)		addedBinding.enable();
		
		styleNamesChangeBinding.disable();
		idChangeBinding.disable();
	}
	
	
	
	/**
	 * Method will remove all the styles defined for the target and disable
	 * the style-change-listeners.
	 */
	private inline function clearStyles () : Void
	{
		stylesAreSearched	= false;
		var changed			= filledProperties;
		
		//remove styles and their listeners
		while (styles.length > 0)
			removeStyleCell( styles.last );
		
		if (parentStyle != null)
		{
		//	if (target.container != null && target.container.as( IStylable ).style == parentStyle)
		//		return;
			if (parentStyle.childrenChanged != null)
				parentStyle.childrenChanged.unbind( this );
			parentStyle = null;
		}
		
		Assert.equal( styles.length, 0, styles.string() );
		
		filledProperties = 0;
		broadcastChanges( changed );
	}
	
	
	/**
	 * Method is called when the child-styles of the parentstyle are changed.
	 * To make sure that the style of the target is still correct, this method
	 * will update all style-values.
	 */
	private function resetStyles ()
	{
		if (styles.length > 0)
		{
			var oldStyles		= styles.clone();
			var changes			= updateStyles(false);
			var childrenChanged	= false;
			
			var o = changes;
			trace(this+".beginReset "+changes.read()+"; styles: "+styles.length);
			
			if (changes.has( Flags.STATES ))		trace("\t\tstateChanges1: "+states.readChanges());
			if (changes.has( Flags.GRAPHICS ))		trace("\t\tGraphicChanges1: "+graphics.readChanges());
			if (changes.has( Flags.LAYOUT ))		trace("\t\tLayoutChanges1: "+layout.readChanges());
			if (changes.has( Flags.FONT ))			trace("\t\tFontChanges1: "+font.readChanges());
			if (changes.has( Flags.EFFECTS ))		trace("\t\teffectChanges1: "+effects.readChanges());
			if (changes.has( Flags.BOX_FILTERS ))	trace("\t\tboxFilterChanges1: "+boxFilters.readChanges());
			
			if (styles.length > 0)
			{
				//
				// The goal of this loop is to prevent updates in the target that
				// aren't nescesary. This is done by comparing the new styles with
				// the old styles and unsetting changes that are caused by 
				// style-blocks that are in the old- and newlist.
				//
				var newStyleCell = styles.first;
				while (newStyleCell != null)
				{
					var newStyle = newStyleCell.data;
					//
					// Try to find the style-block in the old list.
					// If the style is in the old-styles list, it means the properties of
					// that style are already applied on the target-UIElement, and can be
					// ignored as changed properties.
					// 
					// To make sure that the properties can be ignored, the 
					// "unsetChangesBy" method does a thorough inspection of the content 
					// of the style-block.
					//
					// FIXME: Ruben @ 25Feb
					// Often when a newStyle is added, the extendedStyle or super style already
					// used to be in the styles list. So we try to filter out there changes.
					// For some reason this doesn't work very well yet.
					//
					// For example:
					// SuperStyle props: graphics( border, visible )
					// newStyle props: graphics( background )
					//
					// If the superStyle was already in the stylelist and the newstyle isn't,
					// the graphic-changes for border and visible should be unset 
					// (since the target already has the correct properties).
					// The problem is, these flags aren't removed yet from the sub-style collections.
					//
					
					var properties = 0;
					
					var hasStyle			= oldStyles.has( newStyle );
					var hasSuperStyle		= !hasStyle && oldStyles.has( newStyle.superStyle );
					var hasExtendedStyle	= !hasStyle && oldStyles.has( newStyle.extendedStyle );
					
					if (hasStyle)
						properties = newStyle.allFilledProperties;
					
					else if (hasSuperStyle || hasExtendedStyle)
					{
					//	properties = newStyle.filledProperties;
						if (hasSuperStyle) {
							var cell	= styles.addBefore( newStyle.superStyle, newStyleCell );
							changes		= changes.unset( unsetChangesBy( cell, cell.data, cell.data.allFilledProperties, changes ) );
						}
						else if (newStyle.superStyle != null)
							properties = properties.set( newStyle.superStyle.allFilledProperties );
						
						if (hasExtendedStyle) {
							var cell	= styles.addBefore( newStyle.extendedStyle, newStyleCell );
							changes		= changes.unset( unsetChangesBy( cell, cell.data, cell.data.allFilledProperties, changes ) );
						}
						else if (newStyle.extendedStyle != null)
							properties = properties.set( newStyle.extendedStyle.allFilledProperties );
					}
					
					trace("\t\t"+this+".was already in oldStyle? "+properties+"; "+oldStyles.has( newStyle )+"; ext: "+oldStyles.has( newStyle.extendedStyle )+"("+newStyle.extendedStyle+"); super: "+oldStyles.has( newStyle.superStyle )+"("+newStyle.superStyle+")");
					if (properties > 0)
						changes	= changes.unset( unsetChangesBy( newStyleCell, newStyle, properties, changes ) );
					
				/*	if (oldStyles.has( newStyle.superStyle )) {
					//	addStyle( newStyle.superStyle );
						var cell	= styles.addBefore( newStyle.superStyle, newStyleCell );
						changes		= changes.unset( unsetChangesBy( cell, newStyle.superStyle, changes ) );
					}
					if (oldStyles.has( newStyle.extendedStyle )) {
					//	addStyle( newStyle.extendedStyle );
						var cell	= styles.addBefore( newStyle.extendedStyle, newStyleCell );
						changes		= changes.unset( unsetChangesBy( cell, newStyle.extendedStyle, changes ) );
					}
					
					if (oldStyles.has( newStyle )) {
						changes	= changes.unset( unsetChangesBy( newStyleCell, newStyle, changes ) );
					}*/
					if (!childrenChanged)
						childrenChanged	= newStyle.filledProperties.has( Flags.CHILDREN );
					
					newStyleCell = newStyleCell.next;
				}
			}
			
			if (!childrenChanged)
				changes = changes.unset( Flags.CHILDREN );
			
			if (changes.has( Flags.STATES ))		trace("\t\tstateChanges2: "+states.readChanges());
			if (changes.has( Flags.GRAPHICS ))		trace("\t\tGraphicChanges2: "+graphics.readChanges());
			if (changes.has( Flags.LAYOUT ))		trace("\t\tLayoutChanges2: "+layout.readChanges());
			if (changes.has( Flags.FONT ))			trace("\t\tFontChanges2: "+font.readChanges());
			if (changes.has( Flags.EFFECTS ))		trace("\t\teffectChanges2: "+effects.readChanges());
			if (changes.has( Flags.BOX_FILTERS ))	trace("\t\tboxFilterChanges2: "+boxFilters.readChanges());
			
			oldStyles.dispose();
			stylesAreSearched = true;
			trace(this+".end reset; realChanges: "+changes.read()+"; childrenChanged? "+childrenChanged+"; styles: "+styles.length);
			broadcastChanges( changes );
		}
		else
			updateStyles();
	}
	
	
	/**
	 * Method will fill the styles-list for this object and enable the 
	 * style-change listeners.
	 */
	public function updateStyles (allowBroadcast:Bool = true) : Int
	{
		styleNamesChangeBinding	.enable();
		idChangeBinding			.enable();
		if (removedBinding != null)	removedBinding.enable();
		if (addedBinding != null)	addedBinding.disable();
		
		stylesAreSearched	= false;
	//	filledProperties	= 0;
		
		//update styles.. start with the lowest priorities
		var changes	= updateElementStyle();
		changes		= changes.set( updateStyleNameStyles(null) );
		changes		= changes.set( updateIdStyle() );
		changes		= changes.set( updateStatesStyle() );		//set de styles for any states that are already set
	//	changes		= changes.unset( Flags.INHERETING_STYLES );
		
		//update filled-properties flag
		stylesAreSearched = true;
		
		if (allowBroadcast)
			return broadcastChanges(changes);
		else
			return changes;
	}
	
	
	private inline function getBoxFilters ()	{ return (boxFilters == null)	? boxFilters	= new FiltersCollection( this, FilterCollectionType.box ) : boxFilters; }
	private inline function getEffects ()		{ return (effects == null)		? effects		= new EffectsCollection( this ) : effects; }
	private inline function getFont ()			{ return (font == null)			? font			= new TextStyleCollection( this ) : font; }
	private inline function getGraphics ()		{ return (graphics == null)		? graphics		= new GraphicsCollection( this ) : graphics; }
	private inline function getLayout ()		{ return (layout == null)		? layout		= new LayoutCollection( this ) : layout; }
	private inline function getStates ()		{ return (states == null)		? states		= new StatesCollection( this ) : states; }
	
	
	/**
	 * Method to loop through all available style objects to find all the 
	 * properties that are set for the target.
	 */
	public function broadcastChanges (changedProperties:Int = -1) : Int
	{
		if (!stylesAreSearched)
			return changedProperties;
		
		updateFilledPropertiesFlag();
		
		if (changedProperties == -1)
			changedProperties = filledProperties;
		
		//update state properties
		if (changedProperties.has( Flags.STATES ))
		{
			var tmp				= stylesAreSearched;
			stylesAreSearched	= false;
			changedProperties	= changedProperties.set( updateStatesStyle() );
			stylesAreSearched	= tmp;
		//	states.change.send( statesChangedProps );
		}
		
		if (changedProperties.has( Flags.STATES ))			states		.apply();
		if (changedProperties.has( Flags.GRAPHICS ))		graphics	.apply();
		if (changedProperties.has( Flags.LAYOUT ))			layout		.apply();
		if (changedProperties.has( Flags.FONT ))			font		.apply();
		if (changedProperties.has( Flags.EFFECTS ))			effects		.apply();
		if (changedProperties.has( Flags.BOX_FILTERS ))		boxFilters	.apply();
		
		if (changedProperties.has( Flags.CHILDREN ))
			childrenChanged.send();
		
	//	trace(target+".broadcastChanges "+Flags.readProperties(changedProperties));
		
		return changedProperties;
	}
	
	
	public function addStyle (style:StyleBlock) : Int
	{
#if debug
		Assert.notNull( styles );
		Assert.notNull( style );
	//	Assert.that( !styles.has(style), "style "+style+" already exists for "+target );
#end
		var styleCell	= styles.add( style );
		var changes		= 0;
		
		if (styleCell != null)
		{
			//
			// ADD LISTENERS
			//
			style.listeners.add( this );
			
			if (style.has( Flags.BOX_FILTERS ))		boxFilters	.add( style.boxFilters );
			if (style.has( Flags.EFFECTS ))			effects		.add( style.effects );
			if (style.has( Flags.FONT ))			font		.add( style.font );
			if (style.has( Flags.GRAPHICS ))		graphics	.add( style.graphics );
			if (style.has( Flags.LAYOUT ))			layout		.add( style.layout );
			if (style.has( Flags.STATES ))			states		.add( style.states );
			
		//	if (style.parentStyle != null)
		//		style.parentStyle.listeners.add( this );
			
			// FIND CHANGES
			changes				= getUsablePropertiesOf( styleCell );
			filledProperties	= filledProperties.set( changes );
			
	//		trace(target+".addedStyle " + style.type+"; "+readProperties( changes ));
		}
		return changes;
	}
	
	
	
	/**
	 * Method will remove the given stylecell from the the list with styles.
	 * This includes removing the change-listeners. It will return a flag with
	 * style-properties that are changed after removing the style.
	 * 
	 * @param isStyleStillInList	flag indicating if the style is still in the styles list.
	 * 								This is not the case when the styles are resetted since
	 * 								the whole list is thrown away.
	 */
	public function removeStyleCell (styleCell:FastDoubleCell < StyleBlock >, isStyleStillInList:Bool = true) : Int
	{
#if debug
		Assert.notNull( styleCell );
#else
		if (styleCell == null)
			return 0;
#end
		
		var style	= styleCell.data;
		var changes	= isStyleStillInList ? getUsablePropertiesOf( styleCell ) : style.allFilledProperties;
		
		//
		// REMOVE LISTENERS
		//
		style.listeners.remove( this );
		
	//	if (style.parentStyle != null)
	//		style.parentStyle.listeners.remove( this );
		
		if (style.has( Flags.BOX_FILTERS ))		boxFilters	.remove( style.boxFilters	, isStyleStillInList );
		if (style.has( Flags.EFFECTS ))			effects		.remove( style.effects		, isStyleStillInList );
		if (style.has( Flags.FONT ))			font		.remove( style.font			, isStyleStillInList );
		if (style.has( Flags.GRAPHICS ))		graphics	.remove( style.graphics		, isStyleStillInList );
		if (style.has( Flags.LAYOUT ))			layout		.remove( style.layout		, isStyleStillInList );
		if (style.has( Flags.STATES ))			states		.remove( style.states		, isStyleStillInList );
		
		if (isStyleStillInList)
			styles.removeCell( styleCell );
		
	//	trace(target+".removedStyle "+readProperties( changes ));
		return changes;
	}
	
	
	/**
	 * Method will remove all the styles with the given priority and will return
	 * an Int flag with all the properties that where set in the removed styles.
	 */
	private function removeStylesWithPriority (priority:Int) : Int
	{
		if (styles.length == 0)
			return 0;
		
		var changes = 0;
		var styleCell:FastDoubleCell < StyleBlock > = null;
		
		while (null != (styleCell = styles.getCellWithPriority( priority )))
			changes = changes.set( removeStyleCell( styleCell ) );
		
		return changes;
	}
	
	
	private function removeStyle (style:StyleBlock) : Int
	{
		var cell	= styles.getCellForItem( style );
		var changes	= 0;
		if (cell != null)
			changes = removeStyleCell( cell );
		
		return changes;
	}
	
	
	
	
	//
	// STYLE UPDATE METHODS
	//
	
	
	/**
	 * Method will find the styles for every defined state
	 */
	private function updateStatesStyle () : Int
	{
		var changes = removeStylesWithPriority( StyleBlockType.idState.enumIndex() );
		var changes = removeStylesWithPriority( StyleBlockType.styleNameState.enumIndex() );
		var changes = removeStylesWithPriority( StyleBlockType.elementState.enumIndex() );
		
		if (currentStates.length > 0)
		{	
			//search the style-objects of each state
			for ( state in currentStates )
				changes = changes.set( state.setStyles() );
		}
		
		return broadcastChanges( changes );
	}
	
	
	private function updateIdStyle () : Int
	{
		var changes = removeStylesWithPriority( StyleBlockType.id.enumIndex() );
		
		if (target.id.value != null && target.id.value != "")
		{
			var idStyle = parentStyle.findStyle( target.id.value, StyleBlockType.id );
			if (idStyle != null)
				changes = changes.set( addStyle( idStyle ) );
		}
		
		return broadcastChanges( changes );
	}
	
	
	private function updateStyleNameStyles (change:ListChange<String>) : Int
	{
		if (change == null)
			change = ListChange.reset;
		
		var changes = 0;
		
		switch (change)
		{
			case added( styleName, newPos ):
				var style = parentStyle.findStyle( styleName, StyleBlockType.styleName );
				if (style != null)
					changes = changes.set( addStyle( style ) );
			
			
			case removed( styleName, oldPos ):
				var style = parentStyle.findStyle( styleName, StyleBlockType.styleName );
				if (style != null)
					changes = changes.set( removeStyle( style ) );
			
			
			case reset:
				changes = changes.set( removeStylesWithPriority( StyleBlockType.styleName.enumIndex() ) );
				
				for ( styleName in target.styleClasses )
				{
					var style = parentStyle.findStyle( styleName, StyleBlockType.styleName );
					if (style != null)
						changes = changes.set( addStyle( style ) );
				}
			
			
			default:
		}
		
		return broadcastChanges( changes );
	}
	
	
	private function updateElementStyle () : Int
	{
		var changes = removeStylesWithPriority( StyleBlockType.element.enumIndex() );
		
		var style:StyleBlock	= null;
		var parentClass			= target.getClass();
		
		//search for the first element style that is defined for this object or one of it's super classes
		while (parentClass != null && style == null)
		{
			style		= parentStyle.findStyle( parentClass.getClassName(), StyleBlockType.element );
			parentClass	= cast parentClass.getSuperClass();
		}
		
		//use the IDisplayObject style if there isn't a style defined for this element
		if (style == null)
			style = parentStyle.findStyle( "primevc.gui.display.IDisplayObject", StyleBlockType.element );
		
		if (style != null)
			changes = changes.set( addStyle( style ));
		
		return broadcastChanges( changes );
	}
	
	
	//
	// END UPDATE STYLE METHODS
	//
	
	
	
	
	/**
	 * Method returns all the properties that are defined in the given cell-style
	 * and which are not defined in the styles with higher priority.
	 * 
	 * @example
	 * 		idStyle props:			background, border
	 * 		elementStyle props:		font, background, border
	 * 
	 * Usabable props of elementStyle: font
	 */ 
	private function getUsablePropertiesOf ( styleCell:FastDoubleCell < StyleBlock >, properties:Int = -1 ) : Int
	{
		Assert.notNull( styleCell );
		if (properties == -1)
			properties = styleCell.data.allFilledProperties;
		
		var givenData	= styleCell.data;
		properties		= properties.unset( Flags.INHERETING_STYLES );
		
		//loop through all cell's with higher priority
		while (null != (styleCell = styleCell.prev) && properties > 0)
		{
			Assert.notNull( styleCell.data, "found cell without data in "+target );
			var curData		= styleCell.data;
			var curProps	= curData.allFilledProperties;
			
			//get the properties that the given-style has in common with the higher-style
			var commonProps = properties.filter( curProps );
			if (commonProps == 0)
				continue;
			
			//
			// Compare the content of each styleblock of the higher-style with the given-style.
			// If the content of the higher-style has all the properties of the given-style,
			// the content of the given cell will be ignored. 
			//
			// E.g. if both styles have a graphics-block with a background, the graphics property
			// of the given-style won't be usable.
			// If both styles have a style-block with a background, but the given-style also
			// has a border, the graphics property of the given-style is also usable.
			//
			if (commonProps.has( Flags.STATES )		 && !hasUniqueProperies( givenData.states,		curData.states ))		commonProps.unset( Flags.STATES );		 // trace("\t\t\tstateChanges: "+states.readProperties(states.changes)); }
			if (commonProps.has( Flags.GRAPHICS )	 && !hasUniqueProperies( givenData.graphics,	curData.graphics ))		commonProps.unset( Flags.GRAPHICS );	 // trace("\t\t\tGraphicChanges: "+graphics.readProperties(graphics.changes)); }
			if (commonProps.has( Flags.LAYOUT )		 && !hasUniqueProperies( givenData.layout,		curData.layout ))		commonProps.unset( Flags.LAYOUT );		 // trace("\t\t\tLayoutChanges: "+layout.readProperties(layout.changes)); }
			if (commonProps.has( Flags.FONT )		 && !hasUniqueProperies( givenData.font,		curData.font ))			commonProps.unset( Flags.FONT );		 // trace("\t\t\tFontChanges: "+font.readProperties(font.changes)); }
			if (commonProps.has( Flags.EFFECTS )	 && !hasUniqueProperies( givenData.effects,		curData.effects ))		commonProps.unset( Flags.EFFECTS );		 // trace("\t\t\teffectChanges: "+effects.readProperties(effects.changes)); }
			if (commonProps.has( Flags.BOX_FILTERS ) && !hasUniqueProperies( givenData.boxFilters,	curData.boxFilters ))	commonProps.unset( Flags.BOX_FILTERS );	 // trace("\t\t\tboxFilterChanges: "+boxFilters.readProperties(boxFilters.changes)); }
			
			// unset all the style properties of the higher-style in the usable properties flag,
			// except for those they share and are not the same
			properties = properties.unset( curData.allFilledProperties ).set( commonProps );
		}
		
		return properties;
	}
	
	
	/**
	 * Method returns the properties of the given style-cell that will be overwritten
	 * by style-cells with higher priority,
	 */
/*	private inline function getUnusablePropertiesOf (styleCell:FastDoubleCell<StyleBlock>, properties:Int = -1)
	{
		if (properties == -1)
			properties = styleCell.data.allFilledProperties;
		
		return properties.unset( Flags.INHERETING_STYLES | getUsablePropertiesOf( styleCell, properties ) );
	}*/
	
	
	/**
	 * Method will unset the changes-flags that are caused by the given style-cell.
	 * This also applies on the style-sub-blocks of this style.
	 */
	private function unsetChangesBy (givenCell:FastDoubleCell<StyleBlock>, givenData:StyleBlock, givenProps:Int, changes:Int) : Int
	{
	//	var givenProps		= givenData.allFilledProperties.unset( Flags.CHILDREN );	//<-- children will be checked sepperatly
		//	givenData.isElementState()
		//		? givenData.filledProperties		//ignore properties by superstyle if the givenStyle is a element-state. The style of the element will already be in the style-list
		//		: givenData.allFilledProperties;
		
	//	if (givenCell.data != givenData)
	//		givenProps			= givenProps.unset( givenCell.data.filledProperties );
		var possibleChanges		= changes.filter( givenProps.unset( Flags.CHILDREN ) );
		
	//	trace("\t\t\tchecking for changes on "+givenData+" for "+possibleChanges.read());
		
		if (possibleChanges == 0)
			return 0;
		
		var higherCell			= givenCell; //.prev; //givenCell.data != givenData ? givenCell : givenCell.prev;
		
		var boxFiltersChanges	= possibleChanges.has( Flags.BOX_FILTERS )	? boxFilters.changes.filter( givenData.boxFilters.allFilledProperties ) : 0;
		var effectsChanges		= possibleChanges.has( Flags.EFFECTS )		? effects	.changes.filter( givenData.effects	 .allFilledProperties ) : 0;
		var fontChanges			= possibleChanges.has( Flags.FONT )			? font		.changes.filter( givenData.font		 .allFilledProperties ) : 0;
		var graphicsChanges		= possibleChanges.has( Flags.GRAPHICS )		? graphics	.changes.filter( givenData.graphics	 .allFilledProperties ) : 0;
		var layoutChanges		= possibleChanges.has( Flags.LAYOUT )		? layout	.changes.filter( givenData.layout	 .allFilledProperties ) : 0;
		var statesChanges		= possibleChanges.has( Flags.STATES )		? states	.changes.filter( givenData.states	 .allFilledProperties ) : 0;
	//	var childrenChanged		= possibleChanges.has( Flags.CHILDREN );
		
	//	trace("\t\t\t\tboxFilter: "+boxFiltersChanges+"; effects: "+effectsChanges+"; font: "+fontChanges+"; graphics: "+graphicsChanges+"; layout: "+layoutChanges+"; states: "+statesChanges);
	/*	if (possibleChanges.has( Flags.STATES ))		trace("\t\t\t\tstateChanges1: "		+givenData.states	.readProperties( statesChanges ));
		if (possibleChanges.has( Flags.GRAPHICS ))		trace("\t\t\t\tGraphicChanges1: "	+givenData.graphics	.readProperties( graphicsChanges ));
		if (possibleChanges.has( Flags.LAYOUT ))		trace("\t\t\t\tLayoutChanges1: "	+givenData.layout	.readProperties( layoutChanges ));
		if (possibleChanges.has( Flags.FONT ))			trace("\t\t\t\tFontChanges1: "		+givenData.font		.readProperties( fontChanges ));
		if (possibleChanges.has( Flags.EFFECTS ))		trace("\t\t\t\teffectChanges1: "	+givenData.effects	.readProperties( effectsChanges ));
		if (possibleChanges.has( Flags.BOX_FILTERS ))	trace("\t\t\t\tboxFilterChanges1: "	+givenData.boxFilters.readProperties( boxFiltersChanges ));*/
		
		
		//loop through all cell's with higher priority
		while (null != (higherCell = higherCell.prev))
		{
		//	if (higherCell.data == givenData)
		//		continue;
			
			Assert.notNull( higherCell.data, "found cell without data in "+target );
			Assert.notEqual( higherCell.data, givenData );
			var higherData	= higherCell.data;
			var higherProps	= higherData.allFilledProperties;

			//get the properties that the given-style has in common with the higher-style
			var commonProps = possibleChanges.filter( higherProps );
			
			if (commonProps == 0)
				continue;
			
			//
			// Compare the content of each styleblock of the higher-style with the given-style.
			// If the content of the higher-style has all the properties of the given-style,
			// the content of the given cell will be ignored. 
			//
			// E.g. if both styles have a graphics-block with a background, the graphics property
			// of the given-style won't be usable.
			// If both styles have a style-block with a background, but the given-style also
			// has a border, the graphics property of the given-style is also usable.
			//
			
		//	if (commonProps.has( Flags.GRAPHICS ))
		//		trace("\t\t\t\t\t\t"+higherData+"; "+higherData.graphics.readProperties());
			
			if (commonProps.has( Flags.BOX_FILTERS ))	boxFiltersChanges	= boxFiltersChanges.unset( higherData.boxFilters.allFilledProperties );
			if (commonProps.has( Flags.EFFECTS ))		effectsChanges		= effectsChanges.unset( higherData.effects.allFilledProperties );
			if (commonProps.has( Flags.FONT ))			fontChanges			= fontChanges.unset( higherData.font.allFilledProperties );
			if (commonProps.has( Flags.GRAPHICS ))		graphicsChanges		= graphicsChanges.unset( higherData.graphics.allFilledProperties );
			if (commonProps.has( Flags.LAYOUT ))		layoutChanges		= layoutChanges.unset( higherData.layout.allFilledProperties );
			if (commonProps.has( Flags.STATES ))		statesChanges		= statesChanges.unset( higherData.states.allFilledProperties );
			
		//	higherCell = higherCell.prev;
		}
		
	//	if (possibleChanges.has( Flags.GRAPHICS ))		trace("\t\t\t\tGraphicChanges2: "	+givenData.graphics	.readProperties( graphicsChanges ));
	//	if (possibleChanges.has( Flags.STATES ))		trace("\t\t\t\tStatesChanges2: "	+givenData.states	.readProperties( statesChanges ));
		
		// possible changes are now the changes that are definitly caused by the givenCell..
		var realChanges = possibleChanges.unset(
			  Flags.BOX_FILTERS	* (boxFiltersChanges > 0).boolCalc()
			| Flags.EFFECTS		* (effectsChanges > 0).boolCalc()
			| Flags.FONT		* (fontChanges > 0).boolCalc()
			| Flags.GRAPHICS	* (graphicsChanges > 0).boolCalc()
			| Flags.LAYOUT		* (layoutChanges > 0).boolCalc()
			| Flags.STATES		* (statesChanges > 0).boolCalc()
		);
		
	//	changes = changes.unset( realChanges );
	//	if (realChanges > 0) {
			// unset the changes the styleCell caused in the sub blocks
			if (boxFiltersChanges > 0)	boxFilters.changes	= boxFilters.changes.unset( boxFiltersChanges );
			if (effectsChanges > 0)  	effects.changes		= effects	.changes.unset( effectsChanges );
			if (fontChanges > 0) 		font.changes		= font		.changes.unset( fontChanges );
			if (graphicsChanges > 0)	graphics.changes	= graphics	.changes.unset( graphicsChanges );
			if (layoutChanges > 0) 		layout.changes		= layout	.changes.unset( layoutChanges );
			if (statesChanges > 0)  	states.changes		= states	.changes.unset( statesChanges );
	//	}
		trace("\t\t\t\t\t"+givenData+".unsetting changes: box: "+boxFiltersChanges+", effects: "+effectsChanges+"; font: "+fontChanges+", graphics: "+graphicsChanges+", layout: "+layoutChanges+", state: "+statesChanges);
		trace("\t\t\t\t\t"+givenData+".unsetting changes: "+realChanges.read());
		
		return realChanges;
	}
	
	
	
	/**
	 * Method will return true if the uniqueStyleBlock (i.e. graphics, fonts, layout etc) has
	 * unique properties compared with a higher prioritised style-sub-block.
	 */
	private inline function hasUniqueProperies (uniqueStyle:StyleSubBlock, higherStyle:StyleSubBlock) : Bool
	{
		Assert.notNull(uniqueStyle);
		Assert.notNull(higherStyle);
		return uniqueStyle.allFilledProperties.unset( higherStyle.allFilledProperties ) > 0;
	}
	
	
	/**
	 * Method returns a Int with flags of every property that is set. 
	 * Important: The method won't set the Int as value for filledProperties.
	 */
	private function updateFilledPropertiesFlag () : Void
	{
		filledProperties = 0;
		for (style in styles)
		{
			filledProperties = filledProperties.set( style.allFilledProperties );
			if (filledProperties == Flags.ALL_PROPERTIES)
				break;
		}
		filledProperties = filledProperties.unset( Flags.INHERETING_STYLES );
	}
	
	
	
	//
	// STATE SUPPORT
	//
	
	
	public function createState ()
	{
		/*var state = new StyleState( this );
		currentStates.push( state );*/
		return new StyleState( this );
	}
	
	/*
	public function removeState (state:StyleState)
	{
		currentStates.removeItem( state );
		state.dispose();
	}*/
	
	
/*	private inline function setState (v:String) : String
	{
	//	trace(target + ".setStyleState "+state+" => "+v);
		return state = v;
	}*/
	
	
	//
	// IINVALIDATELIST METHODS
	//
	
	public function invalidateCall (changes:Int, sender:IInvalidatable)
	{
		if (sender.is(UIElementStyle))
		{
			var senderCell = styles.getCellForItem( cast sender );
		//	Assert.notNull(senderCell);
			
			if (senderCell != null)
			{
				//sender is a styleblock of this style 
				changes = getUsablePropertiesOf( senderCell, changes );
				broadcastChanges( changes );
			}
			else
			{
				//Sender must be the parent-style of one of our styles.
				//Check if the changes include child-changes. If so, reset our styles
				if (changes.has( Flags.CHILDREN ))
					resetStyles();
			}
		}
	}
	
	
	//
	// ITERATABLE METHODS
	//
	
	public function iterator () : Iterator < StyleBlock >
	{
		return styles.iterator();
	}
	
	
#if debug
	public function readProperties (flags:Int = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;
		
		return flags.read();
	}
	
	
	public function readStates () : String
	{
		var r = [];
		
		for (state in currentStates)
			r.push( state );
		
		return r.join(", ");
	}
	
	
	public function toString ()
	{
		return target + ".UIElementStyle[ "+_oid+" ]";
	}
#end
}
#else

class UIElementStyle {}

#end