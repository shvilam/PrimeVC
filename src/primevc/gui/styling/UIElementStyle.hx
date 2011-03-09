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
	
	
	
	private inline function styleTypeToFlag (type:StyleBlockType) : Int
	{
		return switch (type) {
			case id:		Flags.ID_CHILDREN;
			case styleName:	Flags.STYLE_NAME_CHILDREN;
			case element:	Flags.ELEMENT_CHILDREN;
			default:		0;
		}
	}
	
	
	
	/**
	 * Method is called by children of the target to find their style. Finding
	 * a child's style is done in 3 iterations per style-type.
	 * 
	 * First it looks in the parents 'idStyle', then in the 'styleNameStyle' and
	 * finally in the 'elementStyle'.
	 * 
	 * When a child has the following style-selectors, the amount of searches 
	 * will be:
	 * 		- idStyle			=> parent.findChildStyle (6 times)
	 * 		- 2 style-names		=> parent.findChildStyle (12 times)
	 * 		- elementName		=> parent.findChildStyle (6 times)
	 */
	public function addChildStyles ( child:IUIElementStyle, name:String, type:StyleBlockType, ?exclude:StyleBlock ) : Int
	{
		var foundStyles = 0;
		var changes		= 0;
		var childFlag	= styleTypeToFlag( type );
		
		
		if (filledProperties.has( childFlag ))
		{
			var curCell = styles.last;
			while (curCell != null)
			{
				var styleObj	= curCell.data;
				curCell			= curCell.prev;
				
				//try the next cell if the styleObj doesn't have children
				if (styleObj.doesntHave( childFlag ))
					continue;
				
				var style = styleObj.findChild( name, type, exclude );
				
				//if a style is found, add it to the child
				if (style != null) {
					changes = changes.set( child.addStyle( style ) );
					foundStyles++;
				}
			}
		}
		
		// if there's no styleBlock found for the child, try the next parent
		if (foundStyles == 0 && parentStyle != this)
			changes = parentStyle.addChildStyles( child, name, type, exclude );
		
		return changes;
	}
	
	
	public function removeChildStyles ( child:IUIElementStyle, name:String, type:StyleBlockType, ?exclude:StyleBlock ) : Int
	{
		var foundStyles = 0;
		var changes		= 0;
		var childFlag	= styleTypeToFlag( type );
		
	//	trace(target+".findStyle "+name+" of type "+type+"; styles length: "+styles.length+"; "+Flags.readProperties(filledProperties));
		if (filledProperties.has( childFlag ))
		{
			var curCell = styles.last;
			
			while (curCell != null)
			{
				var styleObj	= curCell.data;
				curCell			= curCell.prev;
				
				//try the next cell if the styleObj doesn't have children
				if (styleObj.doesntHave( childFlag ))
					continue;
				
				var style = styleObj.findChild( name, type, exclude );
				
				//if a style is found, add it to the child
				if (style != null) {
					changes = changes.set( child.removeStyle( style ) );
					foundStyles++;
				}
			}
		}
		
		// if there's no styleBlock found for the child, try the next parent
		if (foundStyles == 0 && parentStyle != this)
			changes = parentStyle.removeChildStyles( child, name, type, exclude );
		
		return changes;
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
		if (styles.length > 0)			// <-- check if there are any old styles
		{
			var oldStyles		= styles.clone();
			var changes			= updateStyles(false);
			var childrenChanged	= false;
			
			if (styles.length > 0)		// <-- check if there are any new styles
			{
				var realChanges = 0;
				var boxFiltersChanges	= 0;
				var effectsChanges		= 0;
				var fontChanges			= 0;
				var graphicsChanges		= 0;
				var layoutChanges		= 0;
				var statesChanges		= 0;
				var childrenChanged		= false;
				
				
				//
				// The goal of this loop is to prevent updates in the target that
				// aren't nescesary. This is done by comparing the new styles with
				// the old styles and unsetting changes that are caused by 
				// style-blocks that are in the old- and newlist.
				//
				var newStyleCell:FastDoubleCell<StyleBlock> = styles.last;
				do
				{
					var newStyle	= newStyleCell.data;
					//
					// Try to find the style-block in the old list.
					// If the style is in the old-styles list, it means the properties of
					// that style are already applied on the target-UIElement, and can be
					// ignored as changed properties.
					// 
					
					var extendedStyle	= newStyle.extendedStyle;
					var superStyle		= newStyle.superStyle;
					var hadStyle		= oldStyles.has( newStyle );
					var hadSuper		= oldStyles.has( superStyle );
					var hadExtended		= oldStyles.has( extendedStyle );
					
					if (hadStyle) {
						oldStyles.remove( newStyle );
						continue;
					}
					
					if (hadSuper)		oldStyles.remove( superStyle );
					if (hadExtended)	oldStyles.remove( extendedStyle );
					
					var props = newStyle.getPropertiesWithout( hadExtended, hadSuper ).unset( Flags.INHERETING_STYLES );
					if (props > 0)
					{
						realChanges |= props;
						if (props.has( Flags.BOX_FILTERS ))	boxFiltersChanges	|= newStyle.boxFilters	.getPropertiesWithout( hadExtended, hadSuper );
						if (props.has( Flags.EFFECTS ))		effectsChanges		|= newStyle.effects		.getPropertiesWithout( hadExtended, hadSuper );
						if (props.has( Flags.FONT ))		fontChanges			|= newStyle.font		.getPropertiesWithout( hadExtended, hadSuper );
						if (props.has( Flags.GRAPHICS ))	graphicsChanges		|= newStyle.graphics	.getPropertiesWithout( hadExtended, hadSuper );
						if (props.has( Flags.LAYOUT ))		layoutChanges		|= newStyle.layout		.getPropertiesWithout( hadExtended, hadSuper );
						if (props.has( Flags.STATES ))		statesChanges		|= newStyle.states		.getPropertiesWithout( hadExtended, hadSuper );
						if (props.has(Flags.CHILDREN))		childrenChanged	 = true;
					}
					
					if (hadExtended)	styles.addAfter( extendedStyle, newStyleCell );
					if (hadSuper)		styles.addAfter( superStyle, newStyleCell );
					
				} while (null != (newStyleCell = newStyleCell.prev));
				
				
				
				//
				// check old styles for the changes that were maybe overseen
				//
				
				if (oldStyles.length > 0)
				{
					var oldStyleCell = oldStyles.last;
					do
					{
						var oldStyle	 = oldStyleCell.data;
						var superStyle	 = oldStyle.superStyle;
						var extended	 = oldStyle.extendedStyle;
						
						var hasSuper	 = styles.has( superStyle );
						var hasExtended	 = styles.has( extended );
						var props		 = oldStyle.getPropertiesWithout( hasExtended, hasSuper ).unset( Flags.INHERETING_STYLES );
						
						if (props > 0)
						{
							realChanges |= props;
							if ( props.has( Flags.BOX_FILTERS ) )	boxFiltersChanges	|= oldStyle.boxFilters	.getPropertiesWithout( hasExtended, hasSuper );
							if ( props.has( Flags.EFFECTS ) )		effectsChanges		|= oldStyle.effects		.getPropertiesWithout( hasExtended, hasSuper );
							if ( props.has( Flags.FONT ) )			fontChanges			|= oldStyle.font		.getPropertiesWithout( hasExtended, hasSuper );
							if ( props.has( Flags.GRAPHICS ) )		graphicsChanges		|= oldStyle.graphics	.getPropertiesWithout( hasExtended, hasSuper );
							if ( props.has( Flags.LAYOUT ) )		layoutChanges		|= oldStyle.layout		.getPropertiesWithout( hasExtended, hasSuper );
							if ( props.has( Flags.STATES ) )		statesChanges		|= oldStyle.states		.getPropertiesWithout( hasExtended, hasSuper );
							if (props.has(Flags.CHILDREN))			childrenChanged	 = true;
						}
						
					}
					while (null != (oldStyleCell = oldStyleCell.prev));
				}
				
				
				changes = realChanges;
				if (changes.has( Flags.BOX_FILTERS ))	boxFilters.changes	= boxFiltersChanges;
				if (changes.has( Flags.EFFECTS ))		effects.changes		= effectsChanges;
				if (changes.has( Flags.FONT ))			font.changes		= fontChanges;
				if (changes.has( Flags.GRAPHICS ))		graphics.changes	= graphicsChanges;
				if (changes.has( Flags.LAYOUT ))		layout.changes		= layoutChanges;
				if (changes.has( Flags.STATES ))		states.changes		= statesChanges;
			}
			
			oldStyles.dispose();
			stylesAreSearched = true;
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
		
		Assert.notNull(childrenChanged);
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
		if (styles.has(style))
			return 0;
		
		var changes		= 0;
	//	if (style.extendedStyle != null)	changes = changes.set( addStyle( style.extendedStyle ) );
	//	if (style.superStyle != null)		changes = changes.set( addStyle( style.superStyle ) );
		var styleCell	= styles.add( style );
		
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
		
		if (style.has( Flags.BOX_FILTERS ))		boxFilters	.remove( style.boxFilters	, isStyleStillInList );
		if (style.has( Flags.EFFECTS ))			effects		.remove( style.effects		, isStyleStillInList );
		if (style.has( Flags.FONT ))			font		.remove( style.font			, isStyleStillInList );
		if (style.has( Flags.GRAPHICS ))		graphics	.remove( style.graphics		, isStyleStillInList );
		if (style.has( Flags.LAYOUT ))			layout		.remove( style.layout		, isStyleStillInList );
		if (style.has( Flags.STATES ))			states		.remove( style.states		, isStyleStillInList );
		
		if (isStyleStillInList)
			styles.removeCell( styleCell );
		
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
	
	
	public function removeStyle (style:StyleBlock) : Int
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
		var idStyle:StyleBlock = null;
		
		var changes = removeStylesWithPriority( StyleBlockType.id.enumIndex() );
		
		if (target.id.value != null && target.id.value != "")
			changes = changes.set( parentStyle.addChildStyles( this, target.id.value, StyleBlockType.id ) );
		
		return broadcastChanges( changes );
	}
	
	
	private function updateStyleNameStyles (change:ListChange<String>) : Int
	{
		if (change == null)
			change = ListChange.reset;
		
		var changes = 0;
		
		switch (change)
		{
			case added( styleName, newPos ):	changes = changes.set( parentStyle.addChildStyles( this, styleName, StyleBlockType.styleName ) );
			case moved( item, newPos, oldPos ):	//do nothing
			
			
		//	case ListChange.removed(item, oldPos), ListChange.reset:
			default:
				changes = changes.set( removeStylesWithPriority( StyleBlockType.styleName.enumIndex() ) );
				
				if (target.styleClasses.length > 0)
					for ( styleName in target.styleClasses )
						changes = changes.set( parentStyle.addChildStyles( this, styleName, StyleBlockType.styleName ) );
		}
		
		return broadcastChanges( changes );
	}
	
	
	private function updateElementStyle () : Int
	{
		var removeChanges	= removeStylesWithPriority( StyleBlockType.element.enumIndex() );
		var addChanges		= 0;
		var parentClass		= target.getClass();
		
		//search for the first element style that is defined for this object or one of it's super classes
		while (parentClass != null && addChanges == 0)
		{
			addChanges	= addChanges.set( parentStyle.addChildStyles( this, parentClass.getClassName(), StyleBlockType.element ) );
			parentClass	= cast parentClass.getSuperClass();
		}
		
		//use the IDisplayObject style if there isn't a style defined for this element
		if (addChanges == 0)
			addChanges = parentStyle.addChildStyles( this, "primevc.gui.display.IDisplayObject", StyleBlockType.element );
		
		return broadcastChanges( addChanges | removeChanges );
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
			if (commonProps.has( Flags.STATES )		 && !hasUniqueProperies( givenData.states,		curData.states ))		commonProps = commonProps.unset( Flags.STATES );		 // trace("\t\t\tstateChanges: "+states.readProperties(states.changes)); }
			if (commonProps.has( Flags.GRAPHICS )	 && !hasUniqueProperies( givenData.graphics,	curData.graphics ))		commonProps = commonProps.unset( Flags.GRAPHICS );	 // trace("\t\t\tGraphicChanges: "+graphics.readProperties(graphics.changes)); }
			if (commonProps.has( Flags.LAYOUT )		 && !hasUniqueProperies( givenData.layout,		curData.layout ))		commonProps = commonProps.unset( Flags.LAYOUT );		 // trace("\t\t\tLayoutChanges: "+layout.readProperties(layout.changes)); }
			if (commonProps.has( Flags.FONT )		 && !hasUniqueProperies( givenData.font,		curData.font ))			commonProps = commonProps.unset( Flags.FONT );		 // trace("\t\t\tFontChanges: "+font.readProperties(font.changes)); }
			if (commonProps.has( Flags.EFFECTS )	 && !hasUniqueProperies( givenData.effects,		curData.effects ))		commonProps = commonProps.unset( Flags.EFFECTS );		 // trace("\t\t\teffectChanges: "+effects.readProperties(effects.changes)); }
			if (commonProps.has( Flags.BOX_FILTERS ) && !hasUniqueProperies( givenData.boxFilters,	curData.boxFilters ))	commonProps = commonProps.unset( Flags.BOX_FILTERS );	 // trace("\t\t\tboxFilterChanges: "+boxFilters.readProperties(boxFilters.changes)); }
			
			// unset all the style properties of the higher-style in the usable properties flag,
			// except for those they share and are not the same
			properties = properties.unset( curData.allFilledProperties ).set( commonProps );
		}
		
		return properties;
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
		return new StyleState( this );
	}
	
	
	
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
				if (changes.hasAll( Flags.CHILDREN ))				resetStyles();
				else
				{
					if (changes.has( Flags.ID_CHILDREN ))			updateIdStyle();
					if (changes.has( Flags.STYLE_NAME_CHILDREN ))	updateStyleNameStyles(null);
					if (changes.has( Flags.ELEMENT_CHILDREN ))		updateElementStyle();
				}
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