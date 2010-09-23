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
 import primevc.core.traits.Invalidatable;
 import primevc.gui.core.ISkin;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.shapes.IGraphicShape;
 import primevc.gui.styling.StyleContainer;
 import primevc.utils.StringUtil;

#if neko
 import primevc.tools.generator.ICodeGenerator;
#end



/**
 * Class contains the style-data for a specific UIElement
 * 
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
class UIElementStyle extends Invalidatable, implements IStyleDeclaration
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
	
	
	public var uuid			(default,		null)			: String;
	public var type			(default,		null)			: StyleDeclarationType;
	
	public var skin			(getSkin,		setSkin)		: Class < ISkin >;
	public var background	(getBackground, setBackground)	: IFill;
	public var border		(getBorder,		setBorder)		: IBorder<IFill>;
	public var shape		(getShape,		setShape)		: IGraphicShape;
	
	public var layout		(getLayout,		setLayout)		: LayoutStyleDeclarations;
	public var font			(getFont,		setFont)		: FontStyleDeclarations;
	
	public var effects		(getEffects,	setEffects)		: EffectStyleDeclarations;
	public var filters		(getFilters,	setFilters)		: FilterStyleDeclarations;
	
#if neko
	public var children		(default,		null)			: StyleContainer;
#else
	public var children		(default,		default)		: StyleContainer;
#end
	
	
	
	public function new (
		type		: StyleDeclarationType,
		layout		: LayoutStyleDeclarations = null,
		font		: FontStyleDeclarations = null,
		shape		: IGraphicShape = null,
		background	: IFill = null,
		border		: IBorder < IFill > = null,
		skin		: Class< ISkin > = null,
		effects		: EffectStyleDeclarations = null,
		filters		: FilterStyleDeclarations = null
	)
	{
		super();
		this.uuid		= StringUtil.createUUID();
		this.children	= new StyleContainer();
		this.type		= type;
		
		this.layout		= layout;
		this.font		= font;
		this.shape		= shape;
		this.background	= background;
		this.border		= border;
		this.skin		= skin;
		this.effects	= effects;
		this.filters	= filters;
	}
	
	
	override public function dispose ()
	{	
		nestingInherited	= null;
		superStyle			= null;
		extendedStyle		= null;
		parentStyle			= null;
		
	//	if ((untyped this).skin != null)		skin.dispose();
		if ((untyped this).shape != null)		shape.dispose();
		if ((untyped this).background != null)	background.dispose();
		if ((untyped this).border != null)		border.dispose();
		if ((untyped this).layout != null)		layout.dispose();
		if ((untyped this).font != null)		font.dispose();
		if ((untyped this).effects != null)		effects.dispose();
		if ((untyped this).filters != null)		filters.dispose();
		
		children.dispose();
		
		children	= null;
		type		= null;
		skin		= null;
		shape		= null;
		background	= null;
		border		= null;
		layout		= null;
		font		= null;
		effects		= null;
		filters		= null;
		
		uuid		= null;
		
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
		
		if (list != null && list.exists(name)) {
			style = list.get(name);
			if (style == exclude)
				style = null;
		}
		
		if (style == null && parentStyle != null)
			style = parentStyle.findStyle( name, type, exclude );
		
		return style;
	}
	
	
	
	//
	// GETTERS
	//
	
	private function getSkin ()
	{
		var v = skin;
		if (v == null && extendedStyle != null)	v = extendedStyle.skin;
		if (v == null && superStyle != null)	v = superStyle.skin;
		return v;
	}
	
	
	private function getShape ()
	{
		var v = shape;
		if (v == null && extendedStyle != null)	v = extendedStyle.shape;
		if (v == null && superStyle != null)	v = superStyle.shape;
		return v;
	}
	
	
	private function getLayout ()
	{
		var v = layout;
		if (v == null && extendedStyle != null)	v = extendedStyle.layout;
		if (v == null && superStyle != null)	v = superStyle.layout;
		return v;
	}
	
	
	private function getFont ()
	{
		var v = font;
		if (v == null && extendedStyle != null)		v = extendedStyle.font;
		if (v == null && nestingInherited != null)	v = nestingInherited.font;
		if (v == null && superStyle != null)		v = superStyle.font;
		if (v == null && parentStyle != null)		v = parentStyle.font;
		
		return v;
	}


	private function getBackground ()
	{
		var v = background;
		if (v == null && extendedStyle != null)	v = extendedStyle.background;
		if (v == null && superStyle != null)	v = superStyle.background;
		return v;
	}


	private function getBorder ()
	{
		var v = border;
		if (v == null && extendedStyle != null)	v = extendedStyle.border;
		if (v == null && superStyle != null)	v = superStyle.border;
		return v;
	}
	
	
	private function getEffects ()
	{
		var v = effects;
		if (v == null && extendedStyle != null)	v = extendedStyle.effects;
		if (v == null && superStyle != null)	v = superStyle.effects;
		return v;
	}


	private function getFilters ()
	{
		var v = filters;
		if (v == null && extendedStyle != null)	v = extendedStyle.filters;
		if (v == null && superStyle != null)	v = superStyle.filters;
		return v;
	}
	
	
	
	//
	// SETTERS
	//
	
	private function setNestingInherited (v)
	{
		if (v != nestingInherited) {
			nestingInherited = v;
			invalidate( StyleFlags.NESTING_STYLE );
		}
		return v;
	}
	
	
	private function setSuperStyle (v)
	{
		if (v != superStyle) {
			superStyle = v;
			invalidate( StyleFlags.SUPER_STYLE );
		}
		return v;
	}


	private function setExtendedStyle (v)
	{
		if (v != extendedStyle) {
			extendedStyle = v;
			invalidate( StyleFlags.EXTENDED_STYLE );
		}
		return v;
	}


	private function setParentStyle (v)
	{
		if (v != parentStyle) {
			parentStyle = v;
			invalidate( StyleFlags.PARENT_STYLE );
		}
		return v;
	}
	
	
	
	
	
	private function setSkin (v)
	{
		if (v != skin) {
			skin = v;
			invalidate( StyleFlags.SKIN );
		}
		return v;
	}


	private function setShape (v)
	{
		if (v != shape) {
			shape = v;
			invalidate( StyleFlags.SHAPE );
		}
		return v;
	}
	
	
	private function setLayout (v)
	{
		if (v != layout) {
			layout = v;
			invalidate( StyleFlags.LAYOUT );
		}
		return v;
	}
	
	
	private function setFont (v)
	{
		if (v != font) {
			font = v;
			invalidate( StyleFlags.FONT );
		}
		return v;
	}
	
	
	private function setBackground (v)
	{
		if (v != background) {
			background = v;
			invalidate( StyleFlags.BACKGROUND );
		}
		return v;
	}


	private function setBorder (v)
	{
		if (v != border) {
			border = v;
			invalidate( StyleFlags.BORDER );
		}
		return v;
	}


	private function setEffects (v)
	{
		if (v != effects) {
			effects = v;
			invalidate( StyleFlags.EFFECTS );
		}
		return v;
	}


	private function setFilters (v)
	{
		if (v != filters) {
			filters = v;
			invalidate( StyleFlags.FILTERS );
		}
		return v;
	}


#if (debug || neko)
	public function toString () { return toCSS(); }
	
	
	public function toCSS (namePrefix:String = "")
	{
		var css = "";
		
		if (skin != null)		css += "\tskin: " + skin + ";";
		if (shape != null)		css += "\n\tshape: " + shape.toCSS() + ";";
		if (background != null)	css += "\n\tbackground: " + background.toCSS() + ";";
		if (border != null)		css += "\n\tborder: "+ border.toCSS() + ";";
		if (layout != null)		css += layout.toCSS();
		if (font != null)		css += font.toCSS();
		if (effects != null)	css += effects.toCSS();
		if (filters != null)	css += filters.toCSS();
		
		css = "{" + css + "\n}";
		
		if (hasChildren())
			css += "\n " + children.toCSS(namePrefix);
		
		return css;
	}
	
	
	public function isEmpty () : Bool
	{
		return allPropertiesEmpty() && !hasChildren();
	}
	
	
	public function allPropertiesEmpty () : Bool
	{
		return (untyped skin) == null 
			&& (untyped shape) == null 
			&& (untyped border) == null 
			&& ((untyped layout) == null || (untyped layout).isEmpty())
			&& ((untyped font) == null || (untyped font).isEmpty())
		 	&& ((untyped effects) == null || (untyped effects).isEmpty())
			&& ((untyped filters) == null || (untyped filters).isEmpty());
	}
	
	
	public function hasChildren () : Bool
	{
		return children != null && !children.isEmpty();
	}
#end


#if neko
	public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
		{
			if (!allPropertiesEmpty())
				code.construct(this, [ type, untyped layout, untyped font, untyped shape, untyped background, untyped border, untyped skin, untyped effects, untyped filters ]);
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
}