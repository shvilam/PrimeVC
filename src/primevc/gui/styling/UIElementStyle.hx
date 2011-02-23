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
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.FastArray;
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
		//FIXME : by Ruben @ 23 feb 2011
		//		getUsablePropertiesOf is to greedy and will cause some style properties to be unset while they need to be updated
		//		For example when the target has a styleclass with graphic-property "shape" and the new updated styles have a
		//			graphic-property "border", getUsablePropertiesOf will tell us that there are no changes in the graphics of the
		//			new style since they both have a "graphics" object. This is obviously incorrect and should be fixed!
	/*	if (styles.length > 0)
		{
			var oldStyles	= styles.clone();
			var changes		= updateStyles(false);
		
			if (styles.length > 0)
			{
				//find removed or added style-blocks
				var styleCell:FastDoubleCell < StyleBlock > = oldStyles.first;
				while (styleCell != null)
				{
					var newCell = styles.getCellForItem( styleCell.data );
					if (newCell != null)
						changes = changes.unset( getUsablePropertiesOf( newCell ) );
					
					styleCell = styleCell.next;
				}
			}
			
			oldStyles.dispose();
			stylesAreSearched = true;
			broadcastChanges( changes );
		}
		else*/
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
		
		if (changedProperties.has( Flags.CHILDREN )) {
			if (target.is(nl.onlinetouch.view.components.spread.FramesView))
			trace(this+"; childrenchanged");
			childrenChanged.send();
		}
		
	//	trace(target+".broadcastChanges "+Flags.readProperties(changedProperties));
		
		return changedProperties;
	}
	
	
	public function addStyle (style:StyleBlock) : Int
	{
#if debug
		Assert.notNull( styles );
		Assert.notNull( style );
		Assert.that( !styles.has(style), "style "+style+" already exists for "+target );
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
	public function getUsablePropertiesOf ( styleCell:FastDoubleCell < StyleBlock >, properties:Int = -1 ) : Int
	{
		Assert.notNull( styleCell );
		if (properties == -1)
			properties = styleCell.data.allFilledProperties;
		
		properties = properties.unset( Flags.INHERETING_STYLES );
		
		//loop through all cell's with higher priority
		while (null != (styleCell = styleCell.prev) && properties > 0) {
			Assert.notNull( styleCell.data, "found cell without data in "+target );
			properties = properties.unset( styleCell.data.allFilledProperties );
		}
		
		return properties;
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
		
		return StyleFlags.readProperties(flags);
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