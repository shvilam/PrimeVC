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
 import primevc.core.geom.Corners;
 import primevc.gui.graphics.borders.BitmapBorder;
 import primevc.gui.graphics.borders.GradientBorder;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.borders.SolidBorder;
 import primevc.gui.graphics.fills.BitmapFill;
 import primevc.gui.graphics.fills.ComposedFill;
 import primevc.gui.graphics.fills.GradientFill;
 import primevc.gui.graphics.fills.GradientStop;
 import primevc.gui.graphics.fills.GradientType;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.fills.SolidFill;
 import primevc.gui.graphics.fills.SpreadMethod;
 import primevc.gui.graphics.shapes.Circle;
 import primevc.gui.graphics.shapes.Ellipse;
 import primevc.gui.graphics.shapes.Line;
 import primevc.gui.graphics.shapes.RegularRectangle;
 import primevc.gui.graphics.shapes.Triangle;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.RelativeLayout;
 import primevc.gui.styling.declarations.EffectStyleDeclarations;
 import primevc.gui.styling.declarations.FilterStyleDeclarations;
 import primevc.gui.styling.declarations.FontStyleDeclarations;
 import primevc.gui.styling.declarations.LayoutStyleDeclarations;
 import primevc.gui.styling.declarations.UIElementStyle;
 import primevc.gui.styling.StyleContainer;
 import primevc.gui.text.FontStyle;
 import primevc.gui.text.FontWeight;
 import primevc.gui.text.TextAlign;
 import primevc.gui.text.TextDecoration;
 import primevc.gui.text.TextTransform;
 import primevc.types.Bitmap;
 import primevc.types.Number;
 import primevc.types.RGBA;
 import primevc.utils.Color;
  using primevc.utils.Bind;
  using primevc.utils.Color;
  using primevc.utils.ERegUtil;
  using primevc.utils.IntMath;
  using primevc.utils.TypeUtil;
  using Std;
  using StringTools;
  using Type;


/**
 * 
 * @author Ruben Weijers
 * @creation-date Sep 04, 2010
 */
class CSSParser
{
	public static inline var R_WHITESPACE			: String = "\\s"; //"\n\r\t ";
	public static inline var R_WS					: String = "[" + R_WHITESPACE + "]*";	//can have any kind of whitespace
	public static inline var R_WS_MUST				: String = "[" + R_WHITESPACE + "]+";	//must have at least one whitespace charater
	public static inline var R_SPACE				: String = "[ \\t]*";					//can have none, one or more tab/space charater
	public static inline var R_SPACE_MUST			: String = "[ \\t]+";					//must have at least one tab/space charater
	public static inline var R_PROPERTY_NAME		: String = "a-z0-9-";
	public static inline var R_PROPERTY_VALUE		: String = R_WHITESPACE + "a-z0-9%#.,:)(/\"'-";
	public static inline var R_BLOCK_VALUE			: String = R_PROPERTY_VALUE + ":;";
	
	public static inline var R_HEX_VALUE			: String = "0-9a-f";
	public static inline var R_HEX_EXPR				: String = "(0x|#)(["+R_HEX_VALUE+"]{8}|["+R_HEX_VALUE+"]{6}|["+R_HEX_VALUE+"]{3})";
	public static inline var R_RGBA_EXPR			: String = "(rgba)" + R_WS + "[(]((" + R_WS + R_DEC_OCTET + R_WS + "," + R_WS + "){3})((0[.][0-9]+)|0|1)" + R_WS + "[)]";
	public static inline var R_COLOR_EXPR			: String = "("+R_HEX_EXPR+")|("+R_RGBA_EXPR+")";
	
	public static inline var R_RELATIVE_UNITS		: String = "px|ex|em";
	public static inline var R_ABSOLUTE_UNITS		: String = "in|cm|mm|pt|pc";
	public static inline var R_UNITS				: String = "(" + R_RELATIVE_UNITS + "|" + R_ABSOLUTE_UNITS + ")"; // + "|%";
	
	public static inline var R_SIMPLE_UNIT_VALUE	: String = R_FLOAT_VALUE + "[%a-z]+";			//matches floating points with a posible unit (flash player will crash if we make the search complexer...)
	
	public static inline var R_INT_VALUE			: String = "([-]?[0-9]+)";
	public static inline var R_FLOAT_VALUE			: String = "([-]?(([0-9]*[.][0-9]{1,3})|[0-9]+))";
	public static inline var R_INT_UNIT_VALUE		: String = "(0|(" + R_INT_VALUE + R_UNITS + "))";
	public static inline var R_FLOAT_UNIT_VALUE		: String = "(0|(" + R_FLOAT_VALUE + R_UNITS + "))";
	public static inline var R_PERC_VALUE			: String = "(" + R_FLOAT_VALUE + "%)";
	public static inline var R_FLOAT_GROUP_VALUE	: String = R_FLOAT_UNIT_VALUE + "(" + R_SPACE + R_FLOAT_UNIT_VALUE + ")?(" + R_SPACE + R_FLOAT_UNIT_VALUE + ")?(" + R_SPACE + R_FLOAT_UNIT_VALUE + ")?";
	
	public static inline var R_SIMPLE_GRADIENT_COLOR: String = "(" + R_COLOR_EXPR + ")(" + R_SPACE_MUST + R_SIMPLE_UNIT_VALUE + ")?";
	public static inline var R_GRADIENT_COLOR		: String = "(" + R_COLOR_EXPR + ")(" + R_SPACE_MUST + "(0|" + R_FLOAT_UNIT_VALUE + "|" + R_PERC_VALUE + "))?";
	public static inline var R_GRADIENT_SPREAD		: String = "pad|reflect|repeat";
	
	public static inline var R_DOMAIN_LABEL			: String = "[a-z]([a-z0-9-]*[a-z0-9])?";
	public static inline var R_CLASS_EXPR			: String = "(" + R_DOMAIN_LABEL + ")([.]" + R_DOMAIN_LABEL + ")*";
	
	public static inline var R_ROTATION				: String = "([-]?[0-9]+)deg";
	public static inline var R_WORDWRAP				: String = "off|normal|break-word";
	
	
	//
	//URI Regexp
	//@see http://labs.apache.org/webarch/uri/rfc/rfc3986.html
	//
	public static inline var R_URI_SCHEME			: String = "[a-z][a-z0-9+.-]+";										//"file|http|https|ftp|ldap|news|telnet"
	public static inline var R_URI_USERINFO			: String = "[a-z0-9_-]+(:.+)?";										//match username and optional the password
	public static inline var R_URI_DNS				: String = "(" + R_DOMAIN_LABEL + ")([.]" + R_DOMAIN_LABEL + ")+";
	public static inline var R_DEC_OCTET			: String = "([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])";			//matches a number from 0 - 255
	public static inline var R_URI_IPV4				: String = "(" + R_DEC_OCTET + "[.]){3}" + R_DEC_OCTET;
	public static inline var R_URI_IPV6				: String = "((" + R_HEX_VALUE + "){4}){5}";							//TODO: not sure how to implement the full IPv6 range.. this just covers 60 bits
	public static inline var R_URI_HOST				: String = "(" + R_URI_DNS + "|" + R_URI_IPV4 + "|" + R_URI_IPV6 + "|localhost)";
	public static inline var R_URI_PORT				: String = "[0-9]{1,4}|[0-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9{2}|655[0-2][0-9]|6553[0-5]]";	//port range from 0 - 65535
	public static inline var R_URI_AUTHORITY		: String = "(" + R_URI_USERINFO + "@)?(" + R_URI_HOST + ")(:(" + R_URI_PORT + "))?";
	public static inline var R_URI_NAME				: String = "[a-z][a-z0-9+%_,-]*";
	public static inline var R_URI_FOLDERNAME		: String = "(" + R_URI_NAME + ")|([.]{1,2})";
	public static inline var R_URI_FILENAME			: String = R_URI_NAME + "[.][a-z0-9]+";
	public static inline var R_URI_PATH				: String = "((" + R_URI_FOLDERNAME + ")/)*((" + R_URI_FILENAME + ")|(" + R_URI_FOLDERNAME + ")/?)";		//match path with optional filename at the end
	public static inline var R_URI_QUERY_VALUE		: String = "[a-z][a-z0-9+.?/_%-]*";
	public static inline var R_URI_QUERY_VAR		: String = "((" + R_URI_QUERY_VALUE + "=" + R_URI_QUERY_VALUE + ")|(" + R_URI_QUERY_VALUE + "))";
	public static inline var R_URI_QUERY			: String = "[?]" + R_URI_QUERY_VAR + "(&" + R_URI_QUERY_VAR + ")*";
	public static inline var R_URI_FRAGMENT			: String = "#(" + R_URI_QUERY_VALUE + ")+";
	public static inline var R_URI_EXPR				: String = "((" + R_URI_SCHEME + ")://)?(" + R_URI_AUTHORITY + ")(/" + R_URI_PATH + ")?(" + R_URI_QUERY + ")?(" + R_URI_FRAGMENT + ")?";
	
	
	/**
	 * Greedy stupid URI/file matcher
	 * R_URI_EXPR took to much time
	 */
	public static inline var R_URI_PRETENDER		: String = "['\"]?([a-z0-9/&%.#+=\\;:$@?_-]+)['\"]?";
	public static inline var R_FILE_EXPR			: String = R_URI_PATH;
	
	
	public static inline var R_BG_REPEAT_EXPR		: String = "repeat-all|no-repeat";
	
	
	
	/**
	 * container with all the style blocks
	 */
	private var styles					: StyleContainer;
	/**
	 * block that is currently handled by the parser
	 */
	private var currentBlock			: UIElementStyle;
	
	
	public var blockExpr				(default, null) : EReg;
	public var propExpr					(default, null) : EReg;
	
	public var percValExpr				(default, null) : EReg;		//should match [float]%
	public var intValExpr				(default, null) : EReg;		//should match [int]
	public var intUnitValExpr			(default, null) : EReg;		//should match [int]unit
	public var floatValExpr				(default, null) : EReg;		//should match [float]
	public var floatUnitValExpr			(default, null) : EReg;		//should match [float]unit
	public var floatUnitGroupValExpr	(default, null) : EReg;		//should match [float]unit <[float]unit>? <[float]unit>? <[float]unit>?
	
	public var colorValExpr				(default, null) : EReg;
	public var linGradientExpr			(default, null) : EReg;
	public var radGradientExpr			(default, null) : EReg;
	public var gradientColorExpr		(default, null) : EReg;
//	public var gradientStopExpr			(default, null) : EReg;
	public var imageURIExpr				(default, null) : EReg;
	public var imageClassExpr			(default, null) : EReg;
	
	
	
	public function new (styles:StyleContainer)
	{
		this.styles = styles;
		init();
	}
	
	
	private inline function init ()
	{
		blockExpr = new EReg(
			  "(^([.#]?)([a-z]+))"			//match style selectors containing .name, #name or name
			+ "[" + R_WHITESPACE + "]*{"	//match opening of a block
			+ "([" + R_BLOCK_VALUE + "]*)"	//match content of a block
			+ "[" + R_WHITESPACE + "]*}"	//match closing of a block
			, "im");
		
		propExpr = new EReg(
			  "[" + R_WHITESPACE + "]*([" + R_PROPERTY_NAME + "]+)[" + R_WHITESPACE + "]*:"		//match property name
			+ "[" + R_WHITESPACE + "]*([" + R_PROPERTY_VALUE + "]+)[" + R_WHITESPACE + "]*;"	//match property value
			, "im");
		
		intValExpr				= new EReg(R_INT_VALUE, "i");
		intUnitValExpr			= new EReg(R_INT_UNIT_VALUE, "i");
		percValExpr				= new EReg(R_PERC_VALUE, "i");
		floatValExpr			= new EReg(R_FLOAT_VALUE, "i");
		floatUnitValExpr		= new EReg(R_FLOAT_UNIT_VALUE, "i");
		floatUnitGroupValExpr	= new EReg(R_FLOAT_GROUP_VALUE, "i");
		
		colorValExpr			= new EReg("^"+R_COLOR_EXPR+"$", "i");
		
		
		linGradientExpr = new EReg(
				  "(linear-gradient)"+R_WS+"[(]"					//match linear gradient		(1 = type)
				+ R_WS+"("+R_ROTATION+")"							//match rotation			(3 = degrees)
				+ "(("+R_WS+","+R_WS+R_SIMPLE_GRADIENT_COLOR+"){2,})"		//match colors				(4 = colors)
				+ "("+R_WS+","+R_WS+"("+R_GRADIENT_SPREAD+"))?"		//match spread method		(21 = method)
			    + R_WS+"[)]", "im");
		
		radGradientExpr = new EReg(
				  "(radial-gradient)"+R_WS+"[(]"					//match radial gradient		(1 = type)
				+ R_WS+"([-]?(0?[.][0-9]+|0|1))"					//match focal point			(2 = radial-point)
				+ "(("+R_WS+","+R_WS+R_SIMPLE_GRADIENT_COLOR+"){2,})"		//match colors				(4 = colors)
				+ "("+R_WS+","+R_WS+"("+R_GRADIENT_SPREAD+"))?"		//match spread method		(21 = method)
			    + R_WS+"[)]", "im");
		
		gradientColorExpr = new EReg(R_GRADIENT_COLOR, "i");
		
		imageURIExpr = new EReg(
				  "(url)"										//match url opener				1
				+ R_WS+"[(]"									//match opening '('
				+ R_WS+"['\"]?"									//match possible opening ' or "
		//		+ R_WS+"(("+R_FILE_EXPR+")|("+R_URI_EXPR+"))"	//match the url content			4 = local file. 19 = URI
				+ R_WS+"("+R_URI_PRETENDER+")"					//match the url content			2 
				+ R_WS+"['\"]?"									//match possible closing ' or "
				+ R_WS+"[)]"									//match closing ')'
				+ "("+R_WS_MUST+"("+R_BG_REPEAT_EXPR+"))?"		//match possible repeat value	5
			, "im");
		imageClassExpr = new EReg(
			  	"(Class)"										//match Class opener			1
				+ R_WS+"[(]"									//match opening '('
				+ R_WS+"("+R_CLASS_EXPR+")"						//match the class content		2
				+ R_WS+"[)]"									//match closing ')'
				+ "("+R_WS_MUST+"("+R_BG_REPEAT_EXPR+"))?"		//match possible repeat value	8
			, "im");
	}
	
	
	/**
	 * Find style blocks
	 */
	public inline function parse (styleString:String) : Void
	{
		trace("parse");
		styleString = removeComments(styleString);
		trace(styleString);
		blockExpr.matchAll(styleString, handleMatchedBlock);
	}
	
	
	/**
	 * Method will replace all comments with empty strings with support for
	 * literal strings.
	 * @see http://ostermiller.org/findcomment.html
	 */
	private inline function removeComments (style:String):String
	{
		var commentExpr = new EReg(
			  "(['\"]([^'\"]|[\r\n])*['\"]([/]*([^/][^*])|[\r\n])*)?"	//matches any opening and closing of a literal string, followed by any text accept for a comment
			+ "(/[*]([^*]|[\r\n]|([*]+([^*/]|[\r\n])))*[*]+/)"			//matches comments opening and closing /* */
		, "im");
		return commentExpr.customReplace(style, removeComment);
	}
	
	private function removeComment (expr:EReg) : String {
		return expr.matched(1) != null ? expr.matched(1) : "";
	}
	
	
	/**
	 * Method to handle each matched style block and put it in the right
	 * style-container.
	 */
	private function handleMatchedBlock (expr:EReg) : Void
	{
		var name = expr.matched(3);
		trace("handleMatchedBlock for "+name);
		
		//find the correct list to add the entry in
		var list = 
			if		(expr.matched(2) == "#")	styles.idSelectors;
			else if (expr.matched(2) == ".")	styles.styleNameSelectors;
			else								styles.typeSelectors;
		
		//create a styleobject for this name if it doens't exist
		if (list.exists(name))		currentBlock = list.get(name);
		else						list.set( name, currentBlock = new UIElementStyle() );
		
		var content = expr.matched(4).trim();
		if (content != "")
			parseBlock(content.trim());
	}
	
	
	/**
	 * Method to find all the style properties in one style block
	 */
	private inline function parseBlock (content:String) : Void
	{
		trace("parseBlock "+content);
		propExpr.matchAll(content, handleMatchedProperty);
	}
	
	
	/**
	 * Method to handle each matched property
	 */
	private function handleMatchedProperty (expr:EReg)
	{
		var name	= expr.matched(1).trim();
		var val		= expr.matched(2).trim();
		trace("handleMatchedProperty "+name+" = "+val);
		switch (name)
		{
			//
			// font properties
			//
			
		//	case "font":						createFontBlock();			parseAndSetFont(val);
			case "font-size":					createFontBlock();			currentBlock.font.size			= parseUnitInt( val );			//inherit, font-size
			case "font-family":					createFontBlock();			currentBlock.font.family		= val;							//inherit, font-name
			case "color":						createFontBlock();			currentBlock.font.color			= parseColor( val );			//inherit, color-values
			case "font-weight":					createFontBlock();			currentBlock.font.weight		= parseFontWeight( val );		//normal, bold, bolder, lighter
			case "font-style":					createFontBlock();			currentBlock.font.style			= parseFontStyle( val );		//inherit, normal, italic, oblique
			case "letter-spacing":				createFontBlock();			currentBlock.font.letterSpacing	= parseUnitFloat( val );		//inherit, normal, [length]
			case "text-align":					createFontBlock();			currentBlock.font.align			= parseTextAlign( val );		//inherit, left, center, right, justify
			case "text-decoration":				createFontBlock();			currentBlock.font.decoration	= parseTextDecoration( val );	//inherit, none, underline
			case "text-indent":					createFontBlock();			currentBlock.font.indent		= parseUnitFloat( val );
			case "text-transform":				createFontBlock();			currentBlock.font.transform		= parseTextTransform( val );	//inherit, none, capitalize, uppercase, lowercase
			
			
			//
			// fill properties
			//
			
		//	case "background":					parseAndSetBackground( val );
			case "background-color":			setBackground( parseColorFill( val ) );				// #fff, 0xfff, #fffddd, 0xfff000, #ffddeeaa, 0xffddeeaa, rgba(255,255,255,0.9)
			case "background-image":			setBackground( parseImage( val ) );					// url( www.rubenw.nl/img.jpg ), class( package.of.Asset ) <background-repeat>
			
			
			//
			// border properties
			//
			
		//	case "border":						parseAndSetBorder( val );
			case "border-color":				setBorderFill( parseColorFill( val ) );
			case "border-image":
			case "border-image-source":			setBorderFill( parseImage( val ) );
			
		//	case "border-style":				parseAndSetBorderStyle( val );						//none, solid, dashed, dotted
			case "border-width":				setBorderWidth( parseUnitFloat( val ) );
			
		//	case "border-radius":				parseAndSetBorderRadius( val );						//[t]px <[r]px> <[b]px> <[l]px>
			case "border-top-left-radius":		setBorderTopLeftRadius( parseUnitFloat( val ) );
			case "border-top-right-radius":		setBorderTopRightRadius( parseUnitFloat( val ) );
			case "border-bottom-left-radius":	setBorderBottomLeftRadius( parseUnitFloat( val ) );
			case "border-bottom-right-radius":	setBorderBottomRightRadius( parseUnitFloat( val ) );
			
			
			//
			// component properties
			//
			
		//	case "skin":			// class(package.Class)
		//	case "cursor":			// auto, move, help, pointer, wait, text, n-resize, ne-resize, e-resize, se-resize, s-resize, sw-resize, w-resize, nw-resize, url(..)
		//	case "visibility":		// visible, hidden
		//	case "opacity":			// alpha value of entire element
		//	case "resize":			// horizontal / vertical / both / none;	/* makes a textfield resizable in the right bottom corner */
		
		
			// textfield properties
		//	case "word-wrap":					createFontBlock();			currentBlock.font.wordwrap		= parseWordWrap( val );
		//	case "column-count":				createFontBlock();			currentBlock.font.columnCount	= parseInt( val );
		//	case "column-gap":					createLayoutBlock();		currentBlock.layout.columnGap	= parseUnitFloat( val );
		//	case "column-width":				createLayoutBlock();		currentBlock.layout.childWidth	= parseUnitFloat( val );
			
			
			//
			// iconing elements
			//
			
		//	case "icon":
			
			
			//
			// layout properties
			//
			
		//	case "width":						createLayoutBlock();		parseAndSetWidth();
		//	case "height":						createLayoutBlock();		parseAndSetHeight();
			case "min-width":					createLayoutBlock();		currentBlock.layout.minWidth		= parseUnitInt( val );
			case "min-height":					createLayoutBlock();		currentBlock.layout.minHeight		= parseUnitInt( val );
			case "max-width":					createLayoutBlock();		currentBlock.layout.maxWidth		= parseUnitInt( val );
			case "max-height":					createLayoutBlock();		currentBlock.layout.maxHeight		= parseUnitInt( val );
			
	//		case "child-width":					createLayoutBlock();		currentBlock.layout.childWidth		= parseUnitInt( val );
	//		case "child-height":				createLayoutBlock();		currentBlock.layout.childHeight		= parseUnitInt( val );
			
		//	case "relative":					createLayoutBlock();		parseAndSetRelativeProperties( val );
			case "left":						createRelativeBlock();		currentBlock.layout.relative.left	= parseUnitInt( val );
			case "right":						createRelativeBlock();		currentBlock.layout.relative.right	= parseUnitInt( val );
			case "top":							createRelativeBlock();		currentBlock.layout.relative.top	= parseUnitInt( val );
			case "bottom":						createRelativeBlock();		currentBlock.layout.relative.bottom	= parseUnitInt( val );
			case "h-center":					createRelativeBlock();		currentBlock.layout.relative.hCenter= parseUnitInt( val );
			case "v-center":					createRelativeBlock();		currentBlock.layout.relative.vCenter= parseUnitInt( val );
			
		//	case "position":					//absolute and relative supported (=includeInLayout)
		//	case "algorithm":					createLayoutBlock();		currentBlock.layout.algorithm		= parseLayoutAlgorithm( val );
		//	case "transform":					createLayoutBlock();		currentBlock.layout.transform		= parseTransform( val );	//scale( 0.1 - 2 ) / 	rotate( [x]deg ) translate( [x]px, [y]px ) skew( [x]deg, [y]deg )
		//	case "rotation":
		//	case "rotation-point":
		
		//	case "padding":						createLayoutBlock();		parseAndSetPadding( val );
		//	case "padding-top":					createPaddingBlock();		currentBlock.layout.padding.top		= parseUnitFloat( val );
		//	case "padding-bottom":				createPaddingBlock();		currentBlock.layout.padding.bottom	= parseUnitFloat( val );
		//	case "padding-right":				createPaddingBlock();		currentBlock.layout.padding.right	= parseUnitFloat( val );
		//	case "padding-left":				createPaddingBlock();		currentBlock.layout.padding.left	= parseUnitFloat( val );
			
		//	case "clip":		// auto, rect([t],[r],[b],[l])	--> specifies the area of an absolutly positioned box that should be visible == scrollrect size?
		//	case "overflow":	// visible, hidden, scroll-mouse-move, drag-scroll, corner-scroll
			
			
			//
			// transition properties
			//
			
		//	case "move-transition":				createEffectsBlock();	// < effect( <duration>ms/s, <ease>, <delay>ms, reverted  ) | other-transition, ... > 
		//	case "resize-transition":			createEffectsBlock();
		//	case "rotate-transition":			createEffectsBlock();
		//	case "scale-transition":			createEffectsBlock();
		//	case "show-transition":				createEffectsBlock();
		//	case "hide-transition":				createEffectsBlock();
		//	case "transition":		// <property> <animation-name>	property: move, resize, rotate, scale, show, hide
			
			
			//
			// animation properties
			//
			
		//	case "animation":			// <name> <type> effect( <duration>ms/s, <ease>, <delay>ms, reverted  ) 
		//	case "animation-delay":
		//	case "animation-direction":
		//	case "animation-duration":
		//	case "animation-name":
		//	case "animation-timing-function":	
			
			
			
			//
			//filter properties
			//
			
		//	case "box-shadow":					// <color> <size> <inset?>
		//	case "filter":						createFiltersBlock();
			
			
			
			//
			// unsupported properties
			//
			
			case "font-variant":			//inherit, normal, small-caps
			case "text-shadow":
			case "line-height":
			case "word-spacing":
			case "vertical-align":
			case "white-space":
			
			case "list-style":
			case "list-style-image":
			case "list-style-position":
			case "list-style-type":
			
			case "background-clip":			//border-box, padding-box, content-box
			case "background-origin":		//border-box, padding-box, content-box
			case "background-attachment":	//scroll, fixed, local
			case "background-position":
			case "background-size":			//<length>,<percentage>|auto|{1,2}cover|contain
			case "background-repeat":		// repeat-all, no-repeat
			
			case "corner-shaping":
			case "corner-clipping":
			case "border-top":
			case "border-bottom":
			case "border-left":
			case "border-right":
			case "border-image-slice":
			case "border-image-width":
			case "border-image-outset":
			case "border-image-repeat":
			
			case "outline":
			case "outline-style":
			case "outline-color":
			case "outline-width":
			
			/** quite impossible to implement to orignal transition doc if there are 8 diffent transition types... :-S **/
			case "transition-property":
			case "transition-duration":
			case "transition-timing-function":
			case "transition-delay":
			case "animation-iteration-count":
			case "animation-play-state":
			
			case "box-sizing":				//currentBlock.layout.sizing		= parseBoxSizing (val); //content-box /*(box model)*/, border-box /*(padding and border will render inside box)*/
			case "z-index":
			case "margin":
			case "margin-top":
			case "margin-bottom":
			case "margin-right":
			case "margin-left":
			case "float":
			case "clear":
			case "display":
			
				trace(name+" is not yet supported");
		}
	}
	
	
	private inline function createFontBlock () : Void
	{
		if (currentBlock.font == null)
			currentBlock.font = new FontStyleDeclarations();
	}
	
	
	private inline function createLayoutBlock () : Void
	{
		if (currentBlock.layout == null)
			currentBlock.layout = new LayoutStyleDeclarations();
	}


	private inline function createEffectsBlock () : Void
	{
		if (currentBlock.effects == null)
			currentBlock.effects = new EffectStyleDeclarations();
	}


	private inline function createFiltersBlock () : Void
	{
		if (currentBlock.filters == null)
			currentBlock.filters = new FilterStyleDeclarations();
	}
	
	
	private inline function createRelativeBlock () : Void
	{
		createLayoutBlock();
		if (currentBlock.layout.relative == null)
			currentBlock.layout.relative = new RelativeLayout();
	}
	
	
	
	
	//
	// GENERAL UNIT CONVERSION METHODS
	//
	
	/**
	 * Method to convert the given value to an int and convert the value 
	 * according to the unit.
	 */
	private inline function parseInt (v:String) : Int
	{
		return (intValExpr.match(v)) ? intValExpr.matched(1).parseInt() : Number.INT_NOT_SET;
	}
	
	
	private inline function parseFloat (v:String) : Float
	{
		return (floatValExpr.match(v)) ? floatValExpr.matched(1).parseFloat() : Number.FLOAT_NOT_SET;
	}
	
	
	private inline function parseUnitInt (v:String) : Int
	{
		return (floatUnitValExpr.match(v)) ? floatUnitValExpr.matched(3).parseInt() : Number.INT_NOT_SET;
	}
	
	
	private inline function parseUnitFloat(v:String) : Float
	{
		return (floatUnitValExpr.match(v)) ? floatUnitValExpr.matched(3).parseFloat() : Number.FLOAT_NOT_SET;
	}
	
	
	private inline function parsePercentage (v:String) : Float
	{
		return (percValExpr.match(v)) ? percValExpr.matched(2).parseFloat() : Number.FLOAT_NOT_SET;
	}
	
	
	
	
	
	//
	// FONT METHODS
	//
	
	
	/**
	 * Method parses a color value like #aaa000 or 0xaaa000 to a RGBA value
	 * If the value is 'inherit', the method will return null.
	 */
	private inline function parseColor (v:String) : Null < RGBA >
	{
		var clr:Null< RGBA > = null;
		
		v = v.trim().toLowerCase();
		if (v != "inherit" && colorValExpr.match(v))
		{
			if (colorValExpr.matched(3) != null)
			{
				clr = colorValExpr.matched(3).rgba();
			}
			else if (colorValExpr.matched(4) != null)
			{
				var colors = colorValExpr.matched(6).split(",");
				var alpha = colorValExpr.matched(9).parseFloat().uint();
				
				clr = Color.create(colors[0].parseInt(), colors[1].parseInt(), colors[2].parseInt(), alpha);
			}
		}
		
		return clr;
	}
	
	
	private inline function parseTextAlign (v:String) : TextAlign
	{
		return switch (v.trim().toLowerCase()) {
			default:		TextAlign.left;
			case "center":	TextAlign.center;
			case "right":	TextAlign.right;
			case "jusitfy":	TextAlign.justify;
			case "inherit":	null;
		}
	}


	private inline function parseFontWeight (v:String) : FontWeight
	{
		return switch (v.trim().toLowerCase()) {
		default:			FontWeight.normal;
			case "bold":	FontWeight.bold;
			case "bolder":	FontWeight.bolder;
			case "lighter":	FontWeight.lighter;
			case "inherit":	null;
		}
	}


	private inline function parseFontStyle (v:String) : FontStyle
	{
		return switch (v.trim().toLowerCase()) {
			default:		FontStyle.normal;
			case "italic":	FontStyle.italic;
			case "oblique":	FontStyle.oblique;
			case "inherit":	null;
		}
	}
	
	
	private inline function parseWordWrap (v:String) : Bool
	{
		return v.trim().toLowerCase() == "off" ? false : true;
	}
	
	
	/**
	 * Interprets the values: inherit, none, underline
	 */
	private inline function parseTextDecoration (v:String) : TextDecoration
	{
		return switch (v.trim().toLowerCase()) {
			default:			TextDecoration.none;
			case "underline":	TextDecoration.underline;
			case "inherit":		null;
		}
	}
	
	
	/**
	 * Interprets the values: inherit, none, capitalize, uppercase, lowercase
	 */
	private inline function parseTextTransform (v:String) : TextTransform
	{
		return switch (v.trim().toLowerCase()) {
			default:			TextTransform.none;
			case "capitalize":	TextTransform.capitalize;
			case "uppercase":	TextTransform.uppercase;
			case "lowercase":	TextTransform.lowercase;
			case "inherit":		null;
		}
	}
	
	
	
	
	//
	// FILL METHODS
	//
	
	
	/**
	 * Method will set the given fill property in the current style block.
	 * If the current fill is not set or is of the same type as the new fill,
	 * the new fill will be set in the style block and overwrite the old value.
	 * 
	 * If the old-fill is of a different type, the method will create a 
	 * ComposedFill and will insert the old-fill an new fill in the 
	 * composedfill.
	 * In a composedfill, it will always try to first set the BitmapFill and
	 * then the rest of the fills.
	 */
	private inline function setBackground(newFill:IFill) : Void
	{
		if (newFill != null)
		{
			//
			//there is no background yet or the current background is of the same type as the new background (=replace it)
			//
			if ( currentBlock.background == null || currentBlock.background.is( newFill.getClass() ) )
			{
				currentBlock.background = newFill;
			}
			//
			//there is already another background property, but it's not a composed fill yet
			//
			else if (!currentBlock.background.is(ComposedFill))
			{
				var curFill		= currentBlock.background;
				var compFill	= new ComposedFill();
				
				//bitmap fill always has to be the first element in a composed fill
				if (newFill.is( BitmapFill ))
				{
					compFill.add( newFill );
					compFill.add( curFill );
				}
				else
				{	
					compFill.add( curFill );
					compFill.add( newFill );
				}
				
				currentBlock.background = compFill;
			}
			//
			//there is already an composed fill background property specified. Let's add the newFill to this composed fill.
			//
			else
			{
				var compFill = currentBlock.background.as(ComposedFill);
			
				if (newFill.is(BitmapFill))
				{
					//remove old bitmap fill (if any)
					for (curFill in compFill.fills) {
						if (curFill.is(BitmapFill))
							compFill.remove(curFill);
					}
					//add bitmap as first fill
					compFill.add(newFill, 0);
				}
				else
				{
					//add fill at the end of the fill list
					compFill.add(newFill);
				}
			}
		}
	}
	
	
	private inline function parseAndSetBackground (v:String) : Void
	{
		
	}
	
	
	/**
	 * Method will parse a Solid- or Gradient-color value.
	 * 
	 * Solid color allows:
	 * 		- 0x000000
	 * 		- #000000
	 * 		- #000
	 * 		- #000000FF	-> (RGBA)
	 * 
	 * Values that are not specified as RGBA will always have a transparancy 
	 * value of 100%.
	 * 
	 * Gradient color allows:
	 * 		- linear-gradient(deg, color1 <position>, color2 <position>, .., <spreadMethod>) 
	 * 		- radial-gradient(focal-point, color1 <position>, color2 <position>, ..)
	 * 
	 * Color values in a gradient can have the same format as a solid 
	 * background-color. The position of the gradientstop is optional. Without
	 * a position, the color will be placed on it's number devided by 255. If
	 * you do specify a color, it can have a px or % value.
	 * 
	 * SpreadMethod defines how the gradient is spread. Allowed values are:
	 * 		- pad		(no-repeat) (default)
	 * 		- reflect	(repeat gradient and reverse every odd repeat)
	 * 		- repeat	(repeat gradient)
	 */
	private inline function parseColorFill (v:String) : IFill
	{
		var fill:IFill = null;
		
		var isLinearGr	= linGradientExpr.match(v);
		var isRadialGr	= !isLinearGr && radGradientExpr.match(v);
		
		if (isLinearGr || isRadialGr)
		{
			var gradientExpr	= isLinearGr ? linGradientExpr : radGradientExpr;
			var type			= isLinearGr ? GradientType.linear : GradientType.radial;
			var colorsStr		= gradientExpr.matched(4);
			var focalPoint		= isLinearGr ? 0 : gradientExpr.matched(2).parseInt();
			var degr			= isRadialGr ? 0 : gradientExpr.matched(3).parseInt();
			var method			= parseGradientMethod( gradientExpr.matched(21) );
			
			var gr = new GradientFill(type, method, focalPoint, degr);
			
			//add colors
			if (colorsStr != null)
			{
			//	trace("FOUND COLORS!! "+colorsStr);
				while (true)
				{
					if ( !gradientColorExpr.match(colorsStr) )
						break;
					
					var pos = -1;
					if (gradientColorExpr.matched(16) != null) {
						//match px,pt,em etc value
						pos = gradientColorExpr.matched(16).parseInt();
					}
					else if (gradientColorExpr.matched(20) != null)	{
						//match percent value
						var a = gradientColorExpr.matched(21).parseFloat();
						pos = ((a / 100) * 255).int();
					}
					
					gr.add( new GradientStop( gradientColorExpr.matched(4).rgba(), pos ) );
					colorsStr = gradientColorExpr.matchedRight();
				}
				
				//loop through stops again to set the unknown positions (can only be done if the amount of stops is known)
				var i = 0;
				var stepPos = 255 / ( gr.gradientStops.length - 1);
				
				for (stop in gr.gradientStops) {
					if (stop.position == -1)
						stop.position = (stepPos * i).int();
					i++;
				}
				
				//only add the gradient if there are colors
				fill = gr;
			}
		}
		else if (colorValExpr.match(v))
		{
			fill = new SolidFill(parseColor(v));
		}
		
		return fill;
	}
	
	
	private inline function parseImage (v:String) : IFill
	{
		var fill:IFill	= null;
		var bmp:Bitmap	= null;
		var repeatStr	= "";
		
		if (imageURIExpr.match(v))
		{	
			repeatStr	= imageURIExpr.matched(5);
			bmp			= new Bitmap();
			bmp.setString( imageURIExpr.matched(2) );
		}
		else if (imageClassExpr.match(v))
		{	
			repeatStr	= imageURIExpr.matched(8);
			bmp			= new Bitmap();
			bmp.setClass( cast imageClassExpr.matched(2).resolveClass() );
		}
		
		if (bmp != null)
			fill = new BitmapFill( bmp, null, parseRepeatImage(repeatStr), false );
		
		return fill;
	}
	
	
	private inline function parseRepeatImage (v:String) : Bool
	{
		return switch (v.trim().toLowerCase()) {
			default:			true;
			case "no-repeat":	false;
		}
	}
	
	
	private inline function parseGradientMethod (v:String) : SpreadMethod
	{
		return switch (v) {
			case "pad":		SpreadMethod.normal;
			case "reflect":	SpreadMethod.reflect;
			case "repeat":	SpreadMethod.repeat;
		};
	}
	
	
	
	
	
	//
	// BORDER METHODS
	//
	
	
	private inline function parseAndSetBorder (v:String) : Void
	{
		
	}
	
	
	private inline function setBorderFill (newFill:IFill) : Void
	{
		if (newFill != null)
		{
			var t = currentBlock;
			
			//create correct border type
			if (t.border == null)
			{
				if		(newFill.is(SolidFill))		t.border = cast new SolidBorder( newFill.as( SolidFill ) );
				else if	(newFill.is(GradientFill))	t.border = cast new GradientBorder( newFill.as( GradientFill ) );
				else if	(newFill.is(BitmapFill))	t.border = cast new BitmapBorder( newFill.as( BitmapFill ) );
#if debug		else	throw "Fill type not supported for border";		#end
			}
			else
			{
				//copy settings from old border and create a new border bases on the new fill type
				if (newFill.is(SolidFill))
				{
					if (t.border.is(SolidBorder))		t.border.fill	= newFill;
					else								t.border		= copyBorderSettingsTo( t.border, cast new SolidBorder( newFill.as(SolidFill) ) );
				}
				else if (newFill.is(GradientFill))
				{
					if (t.border.is(GradientBorder))	t.border.fill	= newFill;
					else								t.border		= copyBorderSettingsTo( t.border, cast new GradientBorder( newFill.as(GradientFill) ) );
				}
				else if (newFill.is(BitmapFill))
				{
					if (t.border.is(BitmapBorder))		t.border.fill	= newFill;
					else								t.border		= copyBorderSettingsTo( t.border, cast new BitmapBorder( newFill.as(BitmapFill) ) );
				}
			}
		}
	}
	
	
	private inline function setBorderWidth (weight:Float) : Void
	{
		if (currentBlock.border != null)
			currentBlock.border = null;
		else {
			currentBlock.border = cast new SolidBorder( null );
			currentBlock.border.weight = weight;
		}
	}
	
	
	
	/**
	 * Method will copy the properties that the two borders share from the 
	 * 'from' obj to the 'to' obj, except for the fill-property.
	 */
	private inline function copyBorderSettingsTo (from:IBorder<IFill>, to:IBorder<IFill>) : IBorder<IFill>
	{
		if (from != null && to != null)
		{
			to.caps			= from.caps;
			to.innerBorder	= from.innerBorder;
			to.joint		= from.joint;
			to.pixelHinting	= from.pixelHinting;
			to.weight		= from.weight;
		}
		return to;
	}
	
	
	
	//
	// BORDER RADIUS METHODS
	//
	
	
	private inline function setBorderTopLeftRadius (v:Float) : Void
	{
		var corners = getCorners();
		if (corners != null)
			corners.topLeft = v;
	}
	
	
	private inline function setBorderTopRightRadius (v:Float) : Void
	{
		var corners = getCorners();
		if (corners != null)
			corners.topRight = v;
	}
	
	
	private inline function setBorderBottomLeftRadius (v:Float) : Void
	{
		var corners = getCorners();
		if (corners != null)
			corners.bottomLeft = v;
	}
	
	
	private inline function setBorderBottomRightRadius (v:Float) : Void
	{
		var corners = getCorners();
		if (corners != null)
			corners.bottomRight = v;
	}
	
	
	private inline function getCorners () : Corners
	{
		var r:Corners = null;
		if (currentBlock.shape != null && currentBlock.shape.is(RegularRectangle))
		{
			var shape = currentBlock.shape.as(RegularRectangle);
			if (shape.corners == null)
				shape.corners = new Corners();
			
			r = shape.corners;
		}
		return r;
	}
}