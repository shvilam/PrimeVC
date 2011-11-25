/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *	 notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *	 notice, this list of conditions and the following disclaimer in the
 *	 documentation and/or other materials provided with the distribution.
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
#if neko
 import primevc.tools.generator.ICodeGenerator;
 import primevc.types.SimpleDictionary;
#end
 import primevc.core.traits.IInvalidatable;
 import primevc.core.traits.IPrioritizable;
 import primevc.gui.styling.StyleChildren;	//needed for SelectorMapType typedef
  using primevc.gui.styling.StyleFlags;
  using primevc.utils.BitUtil;
  using primevc.utils.HashUtil;
  using Type;

#if (neko || debug)
  using StringTools;
#end


private typedef Flags	= StyleFlags;
private typedef SType	= StyleBlockType;

typedef ChildrenList = #if neko SimpleDictionary<String, StyleBlock> #else Hash<StyleBlock> #end;


/**
 * Class contains the style-data for a specific UIElement
 * 
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
class StyleBlock extends StyleBlockBase
	,	implements IStyleBlock
	,	implements IPrioritizable
{
	/**
	 * Reference to style of which this style is inheriting when the requested
	 * property is not in this declaration.
	 * 
	 * The 'nestingInherited' property is a reference to the style of the 
	 * container in which the IStylable object is placed
	 * 
	 * @example
	 * class SomeStyle implements IStyleBlock {
	 * 		public var font (getFont, default)	: String;
	 * 
	 * 		...
	 * 
	 * 		private function getFont () {
	 * 			if 		(font != null)					return font;
	 * 			else if (nestingInherited != null)		return nestingInherited.font;
	 * 			else 									return null;
	 * 		}
	 * }
	 * 
	 * 
	 * var styleA = new SomeStyle( "Arial" );
	 * var styleB = new SomeStyle();
	 * 
	 * trace(a.font);		//output: "Arial"
	 * trace(b.font);		//output: ""
	 * 
	 * var objA = new Component( styleA );
	 * var objB = new Component( styleB );
	 * objA.children.add( objB );
	 * 
	 * trace(a.font);		//output: "Arial"
	 * trace(b.font);		//output: "Arial"
	 * 
	 */
	public var nestingInherited		(default, setNestingInherited)	: StyleBlock;
	
	/**
	 * Reference to other style-object of whom this style is inheriting when
	 * the requested property is not in this declaration.
	 * 
	 * The 'superStyle' property is used to get style-information of a 
	 * super-class of the described class.
	 * 
	 * @example
	 * var styleA = new StyleDeclaration( package.A, new SomeStyle( new SolidFill( 0xfff000 ) ) );
	 * var styleB = new StyleDeclaration( package.B, new SomeStyle() );
	 * 
	 * class A extends StyleInjector {}
	 * class B extends A {}
	 * 
	 * var objA = new A();
	 * var objB = new B();
	 * 
	 * trace( objA.style.fill );	//output:	SolidFill( 0xfff000 );
	 * trace( objB.style.fill );	//output:	SolidFill( 0xfff000 );
	 */
	public var superStyle			(default, setSuperStyle)		: StyleBlock;
	
	/**
	 * Style object which was declared for the same property, only before..
	 * object.
	 * 
	 * @example
	 * Button, Label {
	 * 		font-size: 10px;
	 * }
	 * Button {
	 * 		font-family: Verdana;
	 * }
	 * 
	 * buttonStyle.font.size = 10;
	 * buttonStyle.font.family -> buttonStyle.font.extendedStyle.family = "Verdana";
	 */
	public var extendedStyle		(default, setExtendedStyle)		: StyleBlock;
	
	/**
	 * Parent StyleBlock object. This property is only set if the style 
	 * only applies to the children of another style.
	 * 
	 * I.e. CSS:
	 * .headerBlock DataGrid Button { ... }
	 * 
	 * The parent of Button will be DataGrid style. The parent of DataGrid
	 * will be .headerBlock.
	 * This property is needed to find the correct inherited styles.
	 */
	public var parentStyle			(default, setParentStyle)		: StyleBlock;

	
	//
	// STYLE PROPERTIES
	//
	
	private var _graphics			: GraphicsStyle;
	private var _layout				: LayoutStyle;
	private var _font				: TextStyle;
	private var _effects			: EffectsStyle;
	private var _boxFilters			: FiltersStyle;
	private var _bgFilters			: FiltersStyle;
	
//	private var _children			: StyleChildren;
	private var _states				: StatesStyle;
	
	private var _elementChildren	: ChildrenList;
	private var _styleNameChildren	: ChildrenList;
	private var _idChildren			: ChildrenList;
	
	
	
	
	public var type					(default,				null)					: StyleBlockType;
	
	public var graphics				(getGraphics,			setGraphics)			: GraphicsStyle;
	public var layout				(getLayout,				setLayout)				: LayoutStyle;
	public var font					(getFont,				setFont)				: TextStyle;
	public var effects				(getEffects,			setEffects)				: EffectsStyle;
	public var boxFilters			(getBoxFilters,			setBoxFilters)			: FiltersStyle;
	public var bgFilters			(getBgFilters,			setBgFilters)			: FiltersStyle;
	
	public var states				(getStates,				setStates)				: StatesStyle;
//	public var children				(getChildren,			setChildren)			: StyleChildren;
	public var idChildren			(getIdChildren,			setIdChildren)			: ChildrenList;
	public var styleNameChildren	(getStyleNameChildren,	setStyleNameChildren)	: ChildrenList;
	public var elementChildren		(getElementChildren,	setElementChildren)		: ChildrenList;
	
	
	public function new (
		filledProps			: Int = 0,
		type				: StyleBlockType = null,	//FIXME: parameter should be required but in generated code there's sometimes a style-block without parameters..
		graphics			: GraphicsStyle = null,
		layout				: LayoutStyle = null,
		font				: TextStyle = null,
		effects				: EffectsStyle = null,
		boxFilters			: FiltersStyle = null,
		bgFilters			: FiltersStyle = null,
		states				: StatesStyle = null,
//		children			: StyleChildren = null,
		idChildren			: ChildrenList = null,
		styleNameChildren	: ChildrenList = null,
		elementChildren		: ChildrenList = null,
		parentStyle			: StyleBlock = null,
		superStyle			: StyleBlock = null,
		nestingStyle		: StyleBlock = null,
		extendedStyle		: StyleBlock = null
	)
	{
		super(filledProps);
		this.type = type;
		
		//NOTE: can't use this._graphics on each property below (like in the style-sub-blocks) since every style-sub-block requires an owner which is set in the setter
		this.graphics			= graphics;
		this.layout				= layout;
		this.font				= font;
		this.effects			= effects;
		this.boxFilters			= boxFilters;
		this.bgFilters			= bgFilters;
		this.states				= states;
		
	//	this.children			= children;
		this.elementChildren	= elementChildren;
		this.styleNameChildren	= styleNameChildren;
		this.idChildren			= idChildren;
		
		this.parentStyle		= parentStyle;
		this.superStyle			= superStyle;
		this.nestingInherited	= nestingStyle;
		this.extendedStyle		= extendedStyle;
	}
	
	
	override public function dispose ()
	{	
		nestingInherited = superStyle = extendedStyle = parentStyle = null;
		
		if (_graphics != null)		_graphics.dispose();
		if (_layout != null)		_layout.dispose();
		if (_font != null)			_font.dispose();
		if (_effects != null)		_effects.dispose();
		if (_boxFilters != null)	_boxFilters.dispose();
		if (_bgFilters != null)		_bgFilters.dispose();
		if (_states != null)		_states.dispose();
	//	if (_children != null)		_children.dispose();
		
		//disposing the has is possible by using hash-util
		if (_elementChildren != null)	_elementChildren.dispose();
		if (_styleNameChildren != null)	_styleNameChildren.dispose();
		if (_idChildren != null)		_idChildren.dispose();
		
		type		= null;
		_graphics	= null;
		_states		= null;
	//	_children	= null;
		_layout		= null;
		_font		= null;
		_effects	= null;
		_boxFilters	= null;
		_bgFilters	= null;
		
		_elementChildren	= null;
		_styleNameChildren	= null;
		_idChildren			= null;
		
		super.dispose();
	}
	
	
	//
	// METHODS
	//
	
	
	public inline function getPriority ()		: Int	{ return type.enumIndex(); }
	public inline function isState ()			: Bool	{ return type == SType.elementState || type == SType.styleNameState || type == SType.idState; }
	public inline function isElementState ()	: Bool	{ return type == SType.elementState; }
	public inline function isStyleNameState ()	: Bool	{ return type == SType.styleNameState; }
	public inline function isIdState ()			: Bool	{ return type == SType.idState; }
	public inline function isElement ()			: Bool	{ return type == SType.element; }
	public inline function isStyleName ()		: Bool	{ return type == SType.styleName; }
	public inline function isId ()				: Bool	{ return type == SType.id; }
	
	
#if debug
	public inline function getPriorityName () : String
	{
		return type.enumConstructor();
	}
#end
	
	
	/*
	public inline function hasChildren () : Bool
	{
		return filledProperties.has( Flags.CHILDREN ); // _children != null && !_children.isEmpty();
	}
	
	
	public inline function hasStates () : Bool
	{
		return filledProperties.has( Flags.STATES ); // _states != null && !_states.isEmpty();
	}
	*/
	/*
	public function hasState (stateName:Int) : Bool
	{
		return states != null ? states.has(stateName) : false;
	}*/
	
	
	/**
	 * Method will search for the requested child + type in it's children or
	 * the children of his extended / superStyle.
	 */
	/*public function getChild (name:String, childType:StyleBlockType, ?exclude:StyleBlock ) : StyleBlock
	{
		var child:StyleBlock = null;
		
		if (filledProperties.has( Flags.CHILDREN ))
		{
			child = children.get( name, childType );
			
			if (child == exclude)
				child = null;
		}
		
		if (child == null && allFilledProperties.has( Flags.CHILDREN ))
		{
			//look in extended / super child-list
			if (extendedStyle != null)					child = extendedStyle.getChild( name, childType, exclude );
			if (child == null && superStyle != null)	child = superStyle.getChild( name, childType, exclude );
		}
		
		return child;
	}*/
	
	
#if neko
	/**
	 * Method will search for the requested state + type in it's children or
	 * the children of his extended / superStyle.
	 */
	public function getState ( stateName:Int, styleName:String, styleType:StyleBlockType, ?exclude:StyleBlock ) : StyleBlock
	{
		var stateStyle:StyleBlock = null;
		var child = findChild( styleName, styleType, exclude );
		
		if (child != null && child.states != null && child.states.has( stateName ))
			stateStyle = child.states.get( stateName );
		
		if (stateStyle == exclude)
			stateStyle = null;
		
		return stateStyle;
	}
	
	
	/**
	 * Method searches for the requested statename in it's children. When the
	 * state is not found there, it will ask it's parent to look for the 
	 * requested state.
	 */
	public function findState ( stateName:Int, styleName:String, styleType:StyleBlockType, ?exclude:StyleBlock, depth:Int = 0 ) : StyleBlock
	{
		var stateStyle = getState( stateName, styleName, styleType, exclude);
		
		if (stateStyle == null && parentStyle != null)
			stateStyle = parentStyle.findState( stateName, styleName, styleType, exclude, ++depth );
		
		return stateStyle;
	}
#end
	
	
	public inline function findChild (name:String, childType:StyleBlockType, ?exclude:StyleBlock ) : StyleBlock
	{
		return switch (childType) {
			case id:		findIdStyle(name, exclude);
			case styleName:	findStyleNameStyle(name, exclude);
			case element:	findElementStyle(name, exclude);
			default: throw "not implemented";
		}
	}
	
	
	/**
	 * Method searches for the requested child in it's children. When the
	 * child is not found there, it will ask it's parent to look for the 
	 * requested child.
	 */
	public function findIdStyle ( name:String, ?exclude:StyleBlock ) : StyleBlock
	{
		var style:StyleBlock = null;
		
		//first try to find it in the own children
		if (filledProperties.has( Flags.ID_CHILDREN ))
		{
			style = _idChildren.get( name );
			if (style == exclude)
				style = null;
		}
		
		//look in extended / super child-list
		if (style == null && allFilledProperties.has( Flags.ID_CHILDREN ))
		{
			if (extendedStyle != null)					style = extendedStyle.findIdStyle( name, exclude );
			if (style == null && superStyle != null)	style = superStyle	 .findIdStyle( name, exclude );
		}
		
		if (style == null && parentStyle != null)
			style = parentStyle.findIdStyle( name, exclude );
		
		return style;
	}
	
	
	public function findStyleNameStyle ( name:String, ?exclude:StyleBlock ) : StyleBlock
	{
		var style:StyleBlock = null;
		
		//first try to find it in the own children
		if (filledProperties.has( Flags.STYLE_NAME_CHILDREN ))
		{
			style = _styleNameChildren.get( name );
			if (style == exclude)
				style = null;
		}
		
		//look in extended / super child-list
		if (style == null && allFilledProperties.has( Flags.STYLE_NAME_CHILDREN ))
		{
			if (extendedStyle != null)					style = extendedStyle.findStyleNameStyle( name, exclude );
			if (style == null && superStyle != null)	style = superStyle	 .findStyleNameStyle( name, exclude );
		}
		
		if (style == null && parentStyle != null)
			style = parentStyle.findStyleNameStyle( name, exclude );
		
		return style;
	}
	
	
	public function findElementStyle ( name:String, ?exclude:StyleBlock ) : StyleBlock
	{
		var style:StyleBlock = null;
		
		//first try to find it in the own children
		if (filledProperties.has( Flags.ELEMENT_CHILDREN ))
		{
			style = _elementChildren.get( name );
			if (style == exclude)
				style = null;
		}
		
		//look in extended / super child-list
		if (style == null && allFilledProperties.has( Flags.ELEMENT_CHILDREN ))
		{
			if (extendedStyle != null)					style = extendedStyle.findElementStyle( name, exclude );
			if (style == null && superStyle != null)	style = superStyle	 .findElementStyle( name, exclude );
		}
		
		if (style == null && parentStyle != null)
			style = parentStyle.findElementStyle( name, exclude );
		
		return style;
	}
	
	
	override public function updateAllFilledPropertiesFlag ()
	{
	//	super.updateAllFilledPropertiesFlag();
		inheritedProperties = 0;
		if (extendedStyle != null)	inheritedProperties  = extendedStyle.allFilledProperties;
		if (superStyle != null)		inheritedProperties |= superStyle.allFilledProperties;
		
		allFilledProperties = filledProperties | inheritedProperties;
		inheritedProperties	= inheritedProperties.unset( filledProperties | Flags.INHERETING_STYLES );
	}
	
	
	override public function getPropertiesWithout (noExtendedStyle:Bool, noSuperStyle:Bool)
	{
		var props = filledProperties;
		if (!noExtendedStyle && extendedStyle != null)	props |= extendedStyle.allFilledProperties;
		if (!noSuperStyle && superStyle != null)		props |= superStyle.allFilledProperties;
		return props;
	}
	
	
	
	/**
	 * Method is called when a property in the parent-, super-, extended- or 
	 * nested-style is changed. If the property is not set in this style-object,
	 * it means that the allFilledPropertiesFlag needs to be changed..
	 */
	override public function invalidateCall ( changeFromOther:Int, sender:IInvalidatable ) : Void
	{
		Assert.that(sender != null);
		
		changeFromOther = changeFromOther.filter( filledProperties | Flags.INHERETING_STYLES );
		if (changeFromOther == 0)
			return;
		
		//The changed property is not in this style-object.
		//Check if the change should be broadcasted..
		if (sender == extendedStyle)
		{
			if (extendedStyle.allFilledProperties.has( changeFromOther ))
				allFilledProperties = allFilledProperties.set( changeFromOther );
			else
				allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the super style and the extendedStyle doesn't have the property that is changed, broadcast the change as well
		else if (sender == superStyle)
		{
			if (extendedStyle != null)		changeFromOther = changeFromOther.filter( extendedStyle.allFilledProperties );
			if (changeFromOther == 0)		return;
			
			if (superStyle.allFilledProperties.has( changeFromOther ))
				allFilledProperties = allFilledProperties.set( changeFromOther );
			else
				allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
	}
	
	
	
	//
	// GETTERS
	//
	
	private function getLayout ()
	{
		var v = _layout;
		if (v == null && extendedStyle != null)	v = extendedStyle.layout;
		if (v == null && superStyle != null)	v = superStyle.layout;
		return v;
	}
	
	
	private function getFont ()
	{
		var v = _font;
			if (v == null && extendedStyle != null)		v = extendedStyle.font;
#if flash9	if (v == null && nestingInherited != null)	v = nestingInherited.font; #end
			if (v == null && superStyle != null)		v = superStyle.font;
#if flash9	if (v == null && parentStyle != null)		v = parentStyle.font; #end
		
		return v;
	}
	
	
	private function getEffects ()
	{
		var v = _effects;
		if (v == null && extendedStyle != null)	v = extendedStyle.effects;
		if (v == null && superStyle != null)	v = superStyle.effects;
		return v;
	}


	private function getBoxFilters ()
	{
		var v = _boxFilters;
		if (v == null && extendedStyle != null)	v = extendedStyle.boxFilters;
		if (v == null && superStyle != null)	v = superStyle.boxFilters;
		return v;
	}
	

	private function getBgFilters ()
	{
		var v = _bgFilters;
		if (v == null && extendedStyle != null)	v = extendedStyle.bgFilters;
		if (v == null && superStyle != null)	v = superStyle.bgFilters;
		return v;
	}
	
	
	private function getStates ()
	{
		var v = _states;
		if (v == null && extendedStyle != null)		v = extendedStyle.states;
		if (v == null && superStyle != null)		v = superStyle.states;
		return v;
	}
	
	
	private function getGraphics ()
	{
		var v = _graphics;
		if (v == null && extendedStyle != null)		v = extendedStyle.graphics;
		if (v == null && superStyle != null)		v = superStyle.graphics;
		return v;
	}
	
	
	private function getIdChildren ()
	{
		var v = _idChildren;
		if (v == null && extendedStyle != null)		v = extendedStyle.idChildren;
		if (v == null && superStyle != null)		v = superStyle.idChildren;
		return v;
	}
	
	
	private function getElementChildren ()
	{
		var v = _elementChildren;
		if (v == null && extendedStyle != null)		v = extendedStyle.elementChildren;
		if (v == null && superStyle != null)		v = superStyle.elementChildren;
		return v;
	}
	
	
	private function getStyleNameChildren ()
	{
		var v = _styleNameChildren;
		if (v == null && extendedStyle != null)		v = extendedStyle.styleNameChildren;
		if (v == null && superStyle != null)		v = superStyle.styleNameChildren;
		return v;
	}
	
	
	
	
	//
	// SETTERS
	//
	
	private function setNestingInherited (v)
	{
		Assert.notEqual(v, this);
		if (v != nestingInherited)
		{
#if (debug && !neko)
			if (v != null && nestingInherited != null)
				throw "Changing the nestingInherited style after it's set is not yet supported!";
#end
			
			nestingInherited = v;
			markProperty( Flags.NESTING_STYLE, v != null );
		}
		return v;
	}
	
	
	private function setSuperStyle (v)
	{
		Assert.notEqual(v, this);
		if (v != superStyle)
		{			
#if (debug && !neko)
			if (v != null && superStyle != null)
				throw "Changing the superStyle style after it's set is not yet supported!";
#end

			if (superStyle != null)
				superStyle.listeners.remove( this );
			
			superStyle = v;
			
			if (superStyle != null)
				superStyle.listeners.add( this );
			
			updateAllFilledPropertiesFlag();
			markProperty( Flags.SUPER_STYLE, v != null );
		}
		return v;
	}


	private function setExtendedStyle (v)
	{
		Assert.notEqual(v, this);
		if (v != extendedStyle)
		{
#if (debug && !neko)
			if (v != null && extendedStyle != null)
				throw "Changing the extendedStyle style after it's set is not yet supported!";
#end
			if (extendedStyle != null)
				extendedStyle.listeners.remove( this );
			
			extendedStyle = v;
			
			if (extendedStyle != null)
				extendedStyle.listeners.add( this );
			
			updateAllFilledPropertiesFlag();
			markProperty( Flags.EXTENDED_STYLE, v != null );
		}
		return v;
	}


	private function setParentStyle (v)
	{
		Assert.notEqual(v, this);
		if (v != parentStyle)
		{
#if (debug && !neko)
			if (v != null && parentStyle != null)
				throw "Changing the parentStyle style after it's set is not yet supported!";
#end
			parentStyle = v;
			markProperty( Flags.PARENT_STYLE, v != null );
		}
		return v;
	}
	
	
	
	
	
	
	private function setLayout (v)
	{
		if (v != _layout)
		{
			if (_layout != null)
				_layout.owner = null;
			
			_layout = v;
			
			if (_layout != null)
				_layout.owner = this;
			
			markProperty( Flags.LAYOUT, v != null );
		}
		return v;
	}
	
	
	private function setFont (v)
	{
		if (v != _font)
		{
			if (_font != null)
				_font.owner = null;
			
			_font = v;
			
			if (_font != null)
				_font.owner = this;
			
			markProperty( Flags.FONT, v != null );
		}
		return v;
	}
	

	private function setEffects (v)
	{
		if (v != _effects)
		{
			if (_effects != null)
				_effects.owner = null;
			
			_effects = v;
			
			if (_effects != null)
				_effects.owner = this;
			
			markProperty( Flags.EFFECTS, v != null );
		}
		return v;
	}


	private function setBoxFilters (v)
	{
		if (v != _boxFilters)
		{
			if (_boxFilters != null)
				_boxFilters.owner = null;
			
			_boxFilters = v;
			
			if (_boxFilters != null)
				_boxFilters.owner = this;
			
			markProperty( Flags.BOX_FILTERS, v != null );
		}
		return v;
	}
	

	private function setBgFilters (v)
	{
		if (v != _bgFilters)
		{
			if (_bgFilters != null)
				_bgFilters.owner = null;
			
			_bgFilters = v;
			
			if (_bgFilters != null)
				_bgFilters.owner = this;
			
			markProperty( Flags.BACKGROUND_FILTERS, v != null );
		}
		return v;
	}
	
	
	private function setStates (v)
	{
		if (v != _states)
		{
			if (_states != null)
				_states.owner = null;
			
			_states = v;
			
			if (_states != null)
				_states.owner = this;
			
			markProperty( Flags.STATES, v != null );
		}
		return v;
	}
	
	
	private function setIdChildren (v)
	{
		if (v != _idChildren)
		{
			_idChildren = v;
			markProperty( Flags.ID_CHILDREN, v != null );
		}
		return v;
	}
	
	
	private function setElementChildren (v)
	{
		if (v != _elementChildren)
		{
			_elementChildren = v;
			markProperty( Flags.ELEMENT_CHILDREN, v != null );
		}
		return v;
	}
	
	
	private function setStyleNameChildren (v)
	{
		if (v != _styleNameChildren)
		{
			_styleNameChildren = v;
			markProperty( Flags.STYLE_NAME_CHILDREN, v != null );
		}
		return v;
	}
	
	
	private function setGraphics (v)
	{
		if (v != _graphics)
		{
			if (_graphics != null)
				_graphics.owner = null;
			
			_graphics = v;
			
			if (_graphics != null)
				_graphics.owner = this;
			
			markProperty( Flags.GRAPHICS, v != null );
		}
		return v;
	}
	
	
	public inline function setInheritedStyles( nestedStyle:StyleBlock = null, superStyle:StyleBlock = null, extendedStyle:StyleBlock = null, parentStyle:StyleBlock = null )
	{
		if (nestingInherited != null)	this.nestingInherited	= nestedStyle;
		if (superStyle != null)			this.superStyle			= superStyle;
		if (extendedStyle != null)		this.extendedStyle		= extendedStyle;
		if (parentStyle != null)		this.parentStyle		= parentStyle;
	}
	
	
	public inline function setChildren (idChildren:ChildrenList = null, styleNameChildren:ChildrenList = null, elementChildren:ChildrenList = null)
	{
		if (idChildren != null)			this.idChildren			= idChildren;
		if (styleNameChildren != null)	this.styleNameChildren	= styleNameChildren;
		if (elementChildren != null)	this.elementChildren	= elementChildren;
	}
	
	
#if neko
	override public function toCSS (namePrefix:String = "")
	{
		var css = "";
		
		if (_graphics != null)		css += _graphics.toCSS();
		if (_layout != null)		css += _layout.toCSS();
		if (_font != null)			css += _font.toCSS();
		if (_effects != null)		css += _effects.toCSS();
		if (_boxFilters != null)	css += _boxFilters.toCSS();
		if (_bgFilters != null)		css += _bgFilters.toCSS();
		
		if (css.trim() != "")
			css = namePrefix + " {" + css + "\n}";
		
		if (_states != null)			css += "\n" + _states.toCSS ( namePrefix );
	//	if (_children != null)			css += "\n" + _children.toCSS ( namePrefix );
		if (_idChildren != null)		css += "\n" + hashToCSSString( namePrefix, _idChildren, "#" );
		if (_styleNameChildren != null)	css += "\n" + hashToCSSString( namePrefix, _styleNameChildren, "." );
		if (_elementChildren != null)	css += "\n" + hashToCSSString( namePrefix, _elementChildren, "" );
		
		return css;
	}
	
	
	private  function hashToCSSString (namePrefix:String, hash:ChildrenList, keyPrefix:String = "") : String
	{
		var css = "";
		var keys = hash.keys();
		while (keys.hasNext())
		{
			var key = keys.next();
			var val = hash.get(key);
			var name = (namePrefix + " " + keyPrefix + key).trim();
			
			if (!val.isEmpty())
				css += "\n" + val.toCSS( name );
		}
		return css;
	}
	
	
	override public function cleanUp ()
	{
		if (_boxFilters != null)
		{
			_boxFilters.cleanUp();
			if (_boxFilters.isEmpty()) {
				_boxFilters.dispose();
				boxFilters = null;
				Assert.that( doesntOwn( Flags.BOX_FILTERS ) );
			}
		}
		
		if (_bgFilters != null)
		{
			_bgFilters.cleanUp();
			if (_bgFilters.isEmpty()) {
				_bgFilters.dispose();
				bgFilters = null;
				Assert.that( doesntOwn( Flags.BACKGROUND_FILTERS ) );
			}
		}
		
		if (_effects != null)
		{
			_effects.cleanUp();
			if (_effects.isEmpty()) {
				_effects.dispose();
				effects = null;
				Assert.that( doesntOwn( Flags.EFFECTS ) );
			}
		}
		
		if (_font != null)
		{
			_font.cleanUp();
			if (_font.isEmpty()) {
				_font.dispose();
				font = null;
				Assert.that( doesntOwn( Flags.FONT ) );
			}
		}
		
		if (_graphics != null)
		{
			_graphics.cleanUp();
			if (_graphics.isEmpty()) {
				_graphics.dispose();
				graphics = null;
				Assert.that( doesntOwn( Flags.GRAPHICS ) );
			}
		}
		
		if (_layout != null)
		{
			_layout.cleanUp();
			if (_layout.isEmpty()) {
				_layout.dispose();
				layout = null;
				Assert.that( doesntOwn( Flags.LAYOUT ) );
			}
		}
		
		if (_idChildren != null)
		{
			_idChildren.cleanUp();
			if (_idChildren.isEmpty()) {
				_idChildren.dispose();
				idChildren = null;
				Assert.that( doesntOwn( Flags.ID_CHILDREN ) );
			}
		}
		
		if (_styleNameChildren != null)
		{
			_styleNameChildren.cleanUp();
			if (_styleNameChildren.isEmpty()) {
				_styleNameChildren.dispose();
				styleNameChildren = null;
				Assert.that( doesntOwn( Flags.STYLE_NAME_CHILDREN ) );
			}
		}
		
		if (_elementChildren != null)
		{
			_elementChildren.cleanUp();
			if (_elementChildren.isEmpty()) {
				_elementChildren.dispose();
				elementChildren = null;
				Assert.that( doesntOwn( Flags.ELEMENT_CHILDREN ) );
			}
		}
		
	/*	if (_children != null)
		{
			_children.cleanUp();
			if (_children.isEmpty()) {
				_children.dispose();
				children = null;
			}
		}*/
		
		if (_states != null)
		{
			_states.cleanUp();
			if (_states.isEmpty()) {
				_states.dispose();
				states = null;
				Assert.that( doesntOwn( Flags.STATES ) );
			}
		}
	}
	
	
	override public function isEmpty ()
	{
		return type == null || filledProperties.unset( Flags.PARENT_STYLE ) == 0;
	}
	
	
	public function getChildrenOfType (type:StyleBlockType) : ChildrenList
	{
		Assert.notNull(type);
		return switch (type) {
				case id:		_idChildren			== null ? idChildren		= new ChildrenList() : _idChildren;
				case styleName:	_styleNameChildren	== null ? styleNameChildren	= new ChildrenList() : _styleNameChildren;
				case element:	_elementChildren	== null ? elementChildren	= new ChildrenList() : _elementChildren;
				default:		null;
			}
	}
	

	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
		{
			if (filledProperties.has( Flags.ALL_PROPERTIES ))
				code.construct(this, [ filledProperties, type, _graphics, _layout, _font, _effects, _boxFilters, _bgFilters ]); //, parentStyle, superStyle, nestingInherited, extendedStyle ]);
			else
				code.construct(this, [ filledProperties, type ]);
			
			if (filledProperties.has( Flags.INHERETING_STYLES ))
				code.setAction( this, "setInheritedStyles", [ nestingInherited, superStyle, extendedStyle, parentStyle ], true );
		/*	{
				if (nestingInherited != null)			code.setProp( this, "nestingInherited",	nestingInherited,	true );
				if (superStyle != null)					code.setProp( this, "superStyle",		superStyle,			true );
				if (extendedStyle != null)				code.setProp( this, "extendedStyle",	extendedStyle,		true );
				if (parentStyle != null)				code.setProp( this, "parentStyle",		parentStyle,		true );
			}*/
			
			//important to do after the styleblock is constructed. otherwise references to the parentstyle might nog yet exist
			if (filledProperties.has( Flags.CHILDREN ))
				code.setAction( this, "setChildren", [ idChildren, styleNameChildren, elementChildren ], true );
	//		if (filledProperties.has( Flags.ID_CHILDREN ))				code.setProp(this, "idChildren",		_idChildren,		true);
	//		if (filledProperties.has( Flags.STYLE_NAME_CHILDREN ))		code.setProp(this, "styleNameChildren",	_styleNameChildren,	true);
	//		if (filledProperties.has( Flags.ELEMENT_CHILDREN ))			code.setProp(this, "elementChildren",	_elementChildren,	true);
			
			if (filledProperties.has( Flags.STATES ))					code.setProp(this, "states",			_states,			true);
		}
	}
#end
	
#if (debug && !neko)
	override public function toString ()
	{
		return type + "("+getPriority()+")" + " - " + super.toString()
			+ (parentStyle 		!= null ? " - parent: "+	parentStyle._oid 		: "")
			+ (superStyle 		!= null ? " - super: "+		superStyle._oid 		: "")
			+ (extendedStyle 	!= null ? " - extended: "+	extendedStyle._oid 		: "")
			+ (nestingInherited != null ? " - nested: "+	nestingInherited._oid 	: "");
	}
#elseif (debug && neko)
	override public function toString ()
	{
		return parentStyle != null ? parentStyle + " " + cssName : cssName;
	//	return _oid+"; "+readProperties();
	}
#end
#if debug
	override public function readProperties (flags:Int = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;
		
		return flags.read();
	}
#end
}