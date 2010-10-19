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
package primevc.gui.styling.declarations;
#if neko
 import primevc.gui.behaviours.layout.ClippedLayoutBehaviour;
 import primevc.gui.behaviours.layout.UnclippedLayoutBehaviour;
 import primevc.gui.behaviours.scroll.CornerScrollBehaviour;
 import primevc.gui.behaviours.scroll.DragScrollBehaviour;
 import primevc.gui.behaviours.scroll.MouseMoveScrollBehaviour;
#end
 import primevc.core.traits.IInvalidatable;
 import primevc.gui.core.ISkin;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.shapes.IGraphicShape;
 import primevc.gui.styling.declarations.StyleContainer;
 import primevc.types.Bitmap;
 import primevc.types.Number;
 import primevc.types.SimpleDictionary;
 import primevc.utils.StringUtil;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;

#if neko
 import primevc.tools.generator.ICodeGenerator;
#end


typedef StatesListType = SimpleDictionary < String, UIElementStyle >;
private typedef Flags = StyleFlags;


/**
 * Class contains the style-data for a specific UIElement
 * 
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
class UIElementStyle extends StyleDeclarationBase, implements IStyleDeclaration
{
	/**
	 * Reference to style of which this style is inheriting when the requested
	 * property is not in this declaration.
	 * 
	 * The 'nestingInherited' property is a reference to the style of the 
	 * container in which the IStylable object is placed
	 * 
	 * @example
	 * class SomeStyle implements IStyleDeclaration {
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
	public var nestingInherited		(default, setNestingInherited)	: UIElementStyle;
	
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
	public var superStyle			(default, setSuperStyle)		: UIElementStyle;
	
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
	public var extendedStyle		(default, setExtendedStyle)		: UIElementStyle;
	
	/**
	 * Parent UIElementStyle object. This property is only set if the style 
	 * only applies to the children of another style.
	 * 
	 * I.e. CSS:
	 * .headerBlock DataGrid Button { ... }
	 * 
	 * The parent of Button will be DataGrid style. The parent of DataGrid
	 * will be .headerBlock.
	 * This property is needed to find the correct inherited styles.
	 */
	public var parentStyle			(default, setParentStyle)		: UIElementStyle;
	
	
	//
	// STYLE PROPERTIES
	//
	
	private var _skin		: Class < ISkin >;
	private var _opacity	: Float;
	private var _visible	: Null < Bool >;
	private var _icon		: Bitmap;
	private var _overflow	: Class < Dynamic >;
	
	private var _background	: IFill;
	private var _border		: IBorder<IFill>;
	private var _shape		: IGraphicShape;
	
	private var _layout		: LayoutStyleDeclarations;
	private var _font		: FontStyleDeclarations;
	
	private var _effects	: EffectStyleDeclarations;
	private var _boxFilters	: FilterStyleDeclarations;
	private var _bgFilters	: FilterStyleDeclarations;
	
	private var _states		: StatesListType;
	
	
	
	
	public var type			(default,		null)			: StyleDeclarationType;
	
	public var skin			(getSkin,		setSkin)		: Class < ISkin >;
	public var opacity		(getOpacity,	setOpacity)		: Float;
	public var visible		(getVisible,	setVisible)		: Null< Bool >;
	public var icon			(getIcon,		setIcon)		: Bitmap;
	public var overflow		(getOverflow,	setOverflow)	: Class < Dynamic >;
	
	public var background	(getBackground, setBackground)	: IFill;
	public var border		(getBorder,		setBorder)		: IBorder<IFill>;
	public var shape		(getShape,		setShape)		: IGraphicShape;
	
	public var layout		(getLayout,		setLayout)		: LayoutStyleDeclarations;
	public var font			(getFont,		setFont)		: FontStyleDeclarations;
	
	public var effects		(getEffects,	setEffects)		: EffectStyleDeclarations;
	public var boxFilters	(getBoxFilters,	setBoxFilters)	: FilterStyleDeclarations;
	public var bgFilters	(getBgFilters,	setBgFilters)	: FilterStyleDeclarations;
	
#if neko
	public var children		(default,		null)			: StyleContainer;
#else
	public var children		(default,		default)		: StyleContainer;
#end

	public var states		(getStates,		setStates)		: StatesListType;
	
	
	
	public function new (
		type		: StyleDeclarationType,
		layout		: LayoutStyleDeclarations = null,
		font		: FontStyleDeclarations = null,
		shape		: IGraphicShape = null,
		background	: IFill = null,
		border		: IBorder < IFill > = null,
		skin		: Class< ISkin > = null,
		visible		: Null < Bool > = null,
		opacity		: Float = Number.INT_NOT_SET,
		effects		: EffectStyleDeclarations = null,
		boxFilters	: FilterStyleDeclarations = null,
		bgFilters	: FilterStyleDeclarations = null,
		icon		: Bitmap = null,
		overflow	: Class < Dynamic > = null,
		states		: StatesListType = null
	)
	{
		super();
		this.type = type;
		
		if (children == null)
			children = new StyleContainer();
		
		this.layout		= layout;
		this.font		= font;
		this.shape		= shape;
		this.background	= background;
		this.border		= border;
		this.skin		= skin;
		this.visible	= visible;
		this.opacity	= opacity != Number.INT_NOT_SET ? opacity : Number.FLOAT_NOT_SET;
		this.effects	= effects;
		this.boxFilters	= boxFilters;
		this.bgFilters	= bgFilters;
		this.icon		= icon;
		this.overflow	= overflow;
		this.states		= states;
	}
	
	
	override public function dispose ()
	{	
		nestingInherited	= null;
		superStyle			= null;
		extendedStyle		= null;
		parentStyle			= null;
		
	//	if (_skin != null)			_skin.dispose();
		if (_shape != null)			_shape.dispose();
		if (_background != null)	_background.dispose();
		if (_border != null)		_border.dispose();
		if (_layout != null)		_layout.dispose();
		if (_font != null)			_font.dispose();
		if (_effects != null)		_effects.dispose();
		if (_boxFilters != null)	_boxFilters.dispose();
		if (_bgFilters != null)		_bgFilters.dispose();
		if (_icon != null)			_icon.dispose();
		
		_states.dispose();
		children.dispose();
		
		_states		= null;
		children	= null;
		type		= null;
		_skin		= null;
		_shape		= null;
		_background	= null;
		_border		= null;
		_layout		= null;
		_font		= null;
		_effects	= null;
		_boxFilters	= null;
		_bgFilters	= null;
		_icon		= null;
		_overflow	= null;
		
		super.dispose();
	}
	
	
	//
	// METHODS
	//
	
	
	/**
	 * Searches recursivly in all parents until a style with the requested name
	 * of the requested type is found.
	 * With the 'exclude' parameter it's possible to exclude a style-element,
	 * for example the original style that is searching for another style with
	 * the same name.
	 */
	public function findStyle ( name:String, type:StyleDeclarationType, ?exclude:UIElementStyle ) : UIElementStyle
	{
		var style : UIElementStyle = null;
		
		var list = switch (type) {
			case element:	children.elementSelectors;
			case styleName:	children.styleNameSelectors;
			case id:		children.idSelectors;
			default:		null;
		}
		
	//	trace("searching "+name+" of type "+type+"; list: "+(list != null) + "; parent? "+(parentStyle != null));
			
	/*	if (list != null) {
			var keys = list.keys();
			for (key in keys)
				trace("[ "+key+"] = "+list.get(key));
		}*/
		if (list != null && list.exists(name)) {
			style = list.get(name);
			if (style == exclude)
				style = null;
		}
		
		if (style == null && parentStyle != null)
			style = parentStyle.findStyle( name, type, exclude );
		
		return style;
	}
	
	
	override public function updateAllFilledPropertiesFlag ()
	{
		super.updateAllFilledPropertiesFlag();
		
		if (allFilledProperties < Flags.ALL_PROPERTIES && extendedStyle != null)
			allFilledProperties |= extendedStyle.allFilledProperties;
		
		if (allFilledProperties < Flags.ALL_PROPERTIES && superStyle != null)
			allFilledProperties |= superStyle.allFilledProperties;
	}
	
	
	
	/**
	 * Method is called when a property in the parent-, super-, extended- or 
	 * nested-style is changed. If the property is not set in this style-object,
	 * it means that the allFilledPropertiesFlag needs to be changed..
	 */
	override public function invalidateCall ( changeFromOther:UInt, sender:IInvalidatable ) : Void
	{
		Assert.that(sender != null);
		
		if (filledProperties.has( changeFromOther ))
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
		else if ((extendedStyle == null || !extendedStyle.allFilledProperties.has( changeFromOther )) && sender == superStyle)
		{
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
	
	
	private function getSkin ()
	{
		var v = _skin;
		if (v == null && extendedStyle != null)	v = extendedStyle.skin;
		if (v == null && superStyle != null)	v = superStyle.skin;
		return v;
	}
	
	
	private function getShape ()
	{
		var v = _shape;
		if (v == null && extendedStyle != null)	v = extendedStyle.shape;
		if (v == null && superStyle != null)	v = superStyle.shape;
		return v;
	}
	
	
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
		if (v == null && nestingInherited != null)	v = nestingInherited.font;
		if (v == null && superStyle != null)		v = superStyle.font;
		if (v == null && parentStyle != null)		v = parentStyle.font;
		
		return v;
	}


	private function getBackground ()
	{
		var v = _background;
		if (v == null && extendedStyle != null)	v = extendedStyle.background;
		if (v == null && superStyle != null)	v = superStyle.background;
		return v;
	}


	private function getBorder ()
	{
		var v = _border;
		if (v == null && extendedStyle != null)	v = extendedStyle.border;
		if (v == null && superStyle != null)	v = superStyle.border;
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
	
	
	private function getVisible ()
	{
		var v = _visible;
		if (v == null && extendedStyle != null)	v = extendedStyle.visible;
		if (v == null && superStyle != null)	v = superStyle.visible;
		return v;
	}


	private function getOpacity ()
	{
		var v = _opacity;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.opacity;
		if (v.notSet() && superStyle != null)		v = superStyle.opacity;
		return v;
	}
	

	private function getIcon ()
	{
		var v = _icon;
		if (v == null && extendedStyle != null)		v = extendedStyle.icon;
		if (v == null && superStyle != null)		v = superStyle.icon;
		return v;
	}
	

	private function getOverflow ()
	{
		var v = _overflow;
		if (v == null && extendedStyle != null)		v = extendedStyle.overflow;
		if (v == null && superStyle != null)		v = superStyle.overflow;
		return v;
	}
	

	private function getStates ()
	{
		var v = _states;
		if (v == null && extendedStyle != null)		v = extendedStyle.states;
		if (v == null && superStyle != null)		v = superStyle.states;
		return v;
	}
	
	
	
	
	//
	// SETTERS
	//
	
	private function setNestingInherited (v)
	{
		if (v != nestingInherited) {
			nestingInherited = v;
			invalidate( Flags.NESTING_STYLE );
		}
		return v;
	}
	
	
	private function setSuperStyle (v)
	{
		if (v != superStyle)
		{
			if (superStyle != null)
				superStyle.listeners.remove( this );
			
			superStyle = v;
			
			if (superStyle != null)
				superStyle.listeners.add( this );
			
			updateAllFilledPropertiesFlag();
			invalidate( Flags.SUPER_STYLE );
		}
		return v;
	}


	private function setExtendedStyle (v)
	{
		if (v != extendedStyle)
		{
			if (extendedStyle != null)
				extendedStyle.listeners.remove( this );
			
			extendedStyle = v;
			
			if (extendedStyle != null)
				extendedStyle.listeners.add( this );
			
			updateAllFilledPropertiesFlag();
			invalidate( Flags.EXTENDED_STYLE );
		}
		return v;
	}


	private function setParentStyle (v)
	{
		if (v != parentStyle) {
			parentStyle = v;
			invalidate( Flags.PARENT_STYLE );
		}
		return v;
	}
	
	
	
	
	
	private function setSkin (v)
	{
		if (v != _skin) {
			_skin = v;
			markProperty( Flags.SKIN, v != null );
		}
		return v;
	}


	private function setShape (v)
	{
		if (v != _shape) {
			_shape = v;
			markProperty( Flags.SHAPE, v != null );
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
	
	
	private function setBackground (v)
	{
		if (v != _background) {
			_background = v;
			markProperty( Flags.BACKGROUND, v != null );
		}
		return v;
	}


	private function setBorder (v)
	{
		if (v != _border) {
			_border = v;
			markProperty( Flags.BORDER, v != null );
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


	private function setVisible (v)
	{
		if (v != _visible) {
			_visible = v;
			markProperty( Flags.VISIBLE, v != null );
		}
		return v;
	}
	
	
	private function setOpacity (v)
	{
		if (v != _opacity) {
			_opacity = v;
			markProperty( Flags.OPACITY, v.isSet() );
		}
		return v;
	}
	
	
	private function setIcon (v)
	{
		if (v != _icon) {
			_icon = v;
			markProperty( Flags.ICON, v != null );
		}
		return v;
	}
	
	
	private function setOverflow (v)
	{
		if (v != _overflow) {
			_overflow = v;
			markProperty( Flags.OVERFLOW, v != null );
		}
		return v;
	}
	
	
	private function setStates (v)
	{
		if (v != _states) {
			_states = v;
			markProperty( Flags.STATES, v != null );
		}
		return v;
	}
	
	
	


#if (debug || neko)
	override public function toCSS (namePrefix:String = "")
	{
		var css = "";
		
		if (_skin != null)			css += "\tskin: " + _skin + ";";
		if (_shape != null)			css += "\n\tshape: " + _shape.toCSS() + ";";
		if (_background != null)	css += "\n\tbackground: " + _background.toCSS() + ";";
		if (_border != null)		css += "\n\tborder: "+ _border.toCSS() + ";";
		if (_visible != null)		css += "\n\tvisability: "+ _visible + ";";
		if (_opacity.isSet())		css += "\n\topacity: "+ _opacity + ";";
		if (_icon != null)			css += "\n\ticon: "+ _icon + ";";
		if (_overflow != null)		css += "\n\toverflow: "+ overflowToCSS() + ";";
		if (_layout != null)		css += _layout.toCSS();
		if (_font != null)			css += _font.toCSS();
		if (_effects != null)		css += _effects.toCSS();
		if (_boxFilters != null)	css += _boxFilters.toCSS();
		if (_bgFilters != null)		css += _bgFilters.toCSS();
		
		css = "{" + css + "\n}";
		
		if (_states != null)		css += "\n " + statesToCSS ( namePrefix );
		if (hasChildren())			css += "\n " + children.toCSS ( namePrefix );
		
		return css;
	}
	
	
	override public function isEmpty () : Bool
	{
		return allPropertiesEmpty() && !hasChildren();
	}
	
	
	public function allPropertiesEmpty () : Bool
	{
		return _skin == null 
			&& _shape == null 
			&& _background == null
			&& _border == null 
			&& _visible == null
			&& _opacity.notSet()
			&& (_layout == null || _layout.isEmpty())
			&& (_font == null || _font.isEmpty())
		 	&& (_effects == null || _effects.isEmpty())
			&& (_boxFilters == null || _boxFilters.isEmpty())
			&& (_bgFilters == null || _bgFilters.isEmpty())
			&& _icon == null
			&& _overflow == null
			&& (_states == null || _states.isEmpty());
	}
	
	
	public function hasChildren () : Bool
	{
		return children != null && !children.isEmpty();
	}
	
	
	private function overflowToCSS () : String
	{
	#if neko
		return switch (_overflow) {
				case UnclippedLayoutBehaviour:	"visible";
				case ClippedLayoutBehaviour:	"hidden";
				case DragScrollBehaviour:		"drag-scroll";
				case CornerScrollBehaviour:		"corner-scroll";
				case MouseMoveScrollBehaviour:	"scroll-mouse-move";
			}
	#else
		return null;
	#end
	/*	return switch (_overflow) {
			case OverflowType.visible:			"visible";
			case OverflowType.hidden:			"hidden";
			case OverflowType.dragScroll:		"drag-scroll";
			case OverflowType.scrollbars:		"scrollbars";
			case OverflowType.cornerScroll:		"corner-scroll";
			case OverflowType.scrollMouseMove:	"scroll-mouse-move";
		}*/
	}
	
	
	private function statesToCSS (styleName:String) : String
	{
	#if neko
		var css = "";
		
		var stateNames = _states.keys();
		for (stateName in stateNames)
			css += _states.get( stateName ).toCSS( styleName + ":" + stateName );
		
		return css;
	#else
		return null;
	#end
	}
#end


#if neko
	override public function toCode (code:ICodeGenerator)
	{
		//first make sure all containers are null when they are empty:
		if (_layout != null && _layout.isEmpty())			_layout		= null;
		if (_font != null && _font.isEmpty())				_font		= null;
		if (_effects != null && _effects.isEmpty())			_effects	= null;
		if (_boxFilters != null && _boxFilters.isEmpty())	_boxFilters	= null;
		if (_bgFilters != null && _bgFilters.isEmpty())		_bgFilters	= null;
		if (_states != null && _states.isEmpty())			_states		= null;
		
		if (!isEmpty())
		{
			if (!allPropertiesEmpty())
				code.construct(this, [ type, _layout, _font, _shape, _background, _border, _skin, _visible, _opacity, _effects, _boxFilters, _bgFilters, _icon, _overflow, _states ]);
			else
				code.construct(this, [ type ]);
			
			if (nestingInherited != null)	code.setProp( this, "nestingInherited", nestingInherited );
			if (superStyle != null)			code.setProp( this, "superStyle", superStyle );
			if (extendedStyle != null)		code.setProp( this, "extendedStyle", extendedStyle );
			if (parentStyle != null)		code.setProp( this, "parentStyle", parentStyle );
			
			if (hasChildren())
				code.setProp(this, "children", children);
		}
	}
#end
	
#if debug
	override public function readProperties (flags:Int = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;
		
		return Flags.readProperties( flags );
	}
#end
}