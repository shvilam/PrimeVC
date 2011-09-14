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
 import primevc.gui.traits.IDisplayable;
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
	 * displayobject to which the target belongs (can be the target itself when
	 * it's also IDisplayable)
	 */
	public var owner					(default, null)			: IDisplayable;
	
	
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
	
	
	
	
	
	public function new (target:IStylable, owner:IDisplayable)
	{
#if debug
		_oid = ID.getNext();
#end
		currentStates		= FastArrayUtil.create();
		styles				= new PriorityList < StyleBlock > ();
		
		this.target			= target;
		this.owner			= owner;
		
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
	
	
	private function init ()	//can't merge with constructor, is needed for ApplicationStyle
	{
		addedBinding	= enableStyleListeners	.on( owner.displayEvents.addedToStage, this );
		removedBinding	= disableStyleListeners	.on( owner.displayEvents.removedFromStage, this );
		
		if (owner.window != null) {
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
	public function getChildStyles ( child:IUIElementStyle, name:String, type:StyleBlockType, foundStyles:FastArray<StyleBlock> = null, exclude:StyleBlock = null ) : FastArray<StyleBlock>
	{
		if (foundStyles == null)
			foundStyles = FastArrayUtil.create();
		
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
				if (style != null && !foundStyles.has(style))
					foundStyles.push(style);
			}
		}
		
		// if there's no styleBlock found for the child, try the next parent
		if (foundStyles.length == 0 && parentStyle != this && parentStyle != null)
			parentStyle.getChildStyles( child, name, type, foundStyles, exclude );
		
		return foundStyles;
	}
	
	
	
	/**
	 * Method will enable the style-listeners (changes). Method is called when
	 * the target is added to the stage
	 */
	private function enableStyleListeners ()
	{
		Assert.notNull( owner.container );
		Assert.that( owner.container.is( IStylable ) );
		Assert.notNull( owner.container.as( IStylable ).style );
		
		if (removedBinding != null)		removedBinding.enable();
		if (addedBinding != null)		addedBinding.disable();
		
		var parent = owner.container != null ? owner.container.as( IStylable ) : null;
		//remove styles if the new parent is not the same as the old parent
		if (parent != null && parent.style != parentStyle)
		{
			clearStyles();
			parentStyle = parent.style;
			updateStyles.on( parentStyle.childrenChanged, this );
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
	 * Method will fill the styles-list for this object and enable the 
	 * style-change listeners.
	 */
	public function updateStyles () : Int
	{
		styleNamesChangeBinding	.enable();
		idChangeBinding			.enable();

		if (removedBinding 	!= null)	removedBinding.enable();
		if (addedBinding 	!= null)	addedBinding.disable();

		//update styles.. start with the lowest priorities
		stylesAreSearched	= false;
		var changes			= updateElementStyle() | updateStyleNameStyles(null) | updateIdStyle() | updateStatesStyle();
		stylesAreSearched 	= true;
		
		return broadcastChanges(changes);
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
		if (target.isDisposed())
			return 0;
		
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
#if debug 	Assert.that(!styles.has(style), styles+"; adding style "+style); #end
		
		var changes		= 0;
		var styleCell	= styles.add( style );
		
		if (styleCell != null)
		{
			// ADD LISTENERS
			style.listeners.add( this );
			// FIND CHANGES
			changes =   (style.has( Flags.BOX_FILTERS ) && boxFilters.add( style.boxFilters ) 	> 0 ? Flags.BOX_FILTERS : 0)
					  | (style.has( Flags.EFFECTS )		&& effects	 .add( style.effects ) 		> 0 ? Flags.EFFECTS 	: 0)
					  | (style.has( Flags.FONT )		&& font		 .add( style.font ) 		> 0 ? Flags.FONT 		: 0)
					  | (style.has( Flags.GRAPHICS )	&& graphics	 .add( style.graphics ) 	> 0 ? Flags.GRAPHICS 	: 0)
					  | (style.has( Flags.LAYOUT )		&& layout	 .add( style.layout ) 		> 0 ? Flags.LAYOUT 		: 0)
					  | (style.has( Flags.STATES )		&& states	 .add( style.states ) 		> 0 ? Flags.STATES 		: 0)
					  .set( style.allFilledProperties.filter( Flags.CHILDREN ) );
			
			filledProperties = filledProperties.set(changes);
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
		Assert.notNull( styleCell );
		var style = styleCell.data;
		
		//
		// REMOVE LISTENERS
		//
		style.listeners.remove( this );
		
		var c =   (style.has( Flags.BOX_FILTERS )	&& boxFilters.remove( style.boxFilters	, isStyleStillInList ) > 0 ? Flags.BOX_FILTERS 	: 0)
				| (style.has( Flags.EFFECTS )		&& effects	 .remove( style.effects		, isStyleStillInList ) > 0 ? Flags.EFFECTS 		: 0)
				| (style.has( Flags.FONT )		 	&& font		 .remove( style.font		, isStyleStillInList ) > 0 ? Flags.FONT 		: 0)
				| (style.has( Flags.GRAPHICS )	 	&& graphics	 .remove( style.graphics	, isStyleStillInList ) > 0 ? Flags.GRAPHICS 	: 0)
				| (style.has( Flags.LAYOUT )		&& layout	 .remove( style.layout		, isStyleStillInList ) > 0 ? Flags.LAYOUT 		: 0)
				| (style.has( Flags.STATES )		&& states	 .remove( style.states		, isStyleStillInList ) > 0 ? Flags.STATES 		: 0)
				.set( style.allFilledProperties.filter( Flags.CHILDREN ) );
		
		if (isStyleStillInList)
			styles.removeCell( styleCell );
		
		return c;
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
		return broadcastChanges( replaceStylesOfType( StyleBlockType.id, parentStyle.getChildStyles( this, target.id.value, StyleBlockType.id ) ) );
	}
	
	
	private function updateStyleNameStyles (change:ListChange<String>) : Int
	{
		if (change == null)
			change = ListChange.reset;
		
		var changes = 0;
		
		switch (change)
		{
			case added( styleName, newPos ):					changes = addStyles( 	parentStyle.getChildStyles(this, styleName, StyleBlockType.styleName) );
			case ListChange.removed(styleName, curPos):			changes = removeStyles( parentStyle.getChildStyles(this, styleName, StyleBlockType.styleName) );
			case moved( item, newPos, curPos ):					//do nothing
			
			
			case ListChange.reset:
				if (target.styleClasses.length > 0)
				{
					var newStyles:FastArray<StyleBlock> = FastArrayUtil.create();
					for (styleName in target.styleClasses)
						parentStyle.getChildStyles(this, styleName, StyleBlockType.styleName, newStyles);
					
					changes = replaceStylesOfType( StyleBlockType.styleName, newStyles );
				}
				else
					changes = removeStylesWithPriority( StyleBlockType.styleName.enumIndex() );
		}
		
		return broadcastChanges( changes );
	}
	
	
	private function updateElementStyle () : Int
	{
		var parentClass	= target.getClass();
		var newStyles:FastArray<StyleBlock> = FastArrayUtil.create();

		//search for the first element style that is defined for this object or one of it's super classes
		while (parentClass != null) {
			parentStyle.getChildStyles( this, parentClass.getClassName(), StyleBlockType.element, newStyles );
			parentClass	= newStyles.length > 0 ? null : cast parentClass.getSuperClass();
		}

		//use the IDisplayObject style if there isn't a style defined for this element
		if (newStyles.length == 0)
			parentStyle.getChildStyles( this, "primevc.gui.display.IDisplayObject", StyleBlockType.element, newStyles );

		return broadcastChanges( replaceStylesOfType(StyleBlockType.element, newStyles) );
	}


	/**
	 * Method will add the styles in the given FastArray if they don't exist already in the currentStyles.
	 * All other styles with the given priority will be removed.
	 */
	private function replaceStylesOfType (type:StyleBlockType, newStyles:FastArray<StyleBlock>) : Int
	{
		var priority = type.enumIndex();
		var changes  = 0;

		if (newStyles.length > 0)
		{
			//
			// remove old styles from styleslist
			//

			var styleCell:FastDoubleCell<StyleBlock> = styles.getCellWithPriority( priority );
			while (null != styleCell && newStyles.length > 0)
			{
				var style = styleCell.data;
				var next  = styleCell.next;
				if (style.getPriority() != priority)
					break;
				
				if (newStyles.has(style))	newStyles.removeItem(style);						// current-style and new-styles both have this style.. do noting
				else 						changes = changes.set(removeStyleCell(styleCell));	// old-style doesn't exist anymore in newstyles.. remove it

				styleCell = next;
			}

			//
			// add new styles to styleslist
			//
			changes = changes.set( addStyles(newStyles) );
		}
		else
			changes = removeStylesWithPriority(priority);
		

		return changes;
	}


	private inline function removeStyles (removableStyles:FastArray<StyleBlock>) : Int
	{
		var changes = 0;
		for (style in removableStyles)
			changes = changes.set(removeStyle(style));
		
		return changes;
	}


	private inline function addStyles (newStyles:FastArray<StyleBlock>) : Int
	{
		var changes = 0;
		for (newStyle in newStyles)
			changes = changes.set(addStyle(newStyle));
		return changes;
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
	 * Method sets filledProperties with flags of every property that is set.
	 */
	private inline function updateFilledPropertiesFlag () : Void
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
	
	
	public function createState (state:Int = 0)
	{
		return new StyleState( this, state );
	}
	
	
	
	//
	// IINVALIDATELIST METHODS
	//
	
	public function invalidateCall (changes:Int, sender:IInvalidatable)
	{
		if (sender.is(UIElementStyle))
		{
			var senderCell = styles.getCellForItem( cast sender );
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
			//	if (changes.has( Flags.CHILDREN ))
			//		resetStyles();
				if (changes.hasAll( Flags.CHILDREN ))				updateStyles();
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