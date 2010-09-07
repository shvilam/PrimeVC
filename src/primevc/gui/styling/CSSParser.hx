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
 import primevc.gui.graphics.fills.BitmapFill;
 import primevc.gui.graphics.fills.ComposedFill;
 import primevc.gui.graphics.fills.GradientFill;
 import primevc.gui.graphics.fills.GradientStop;
 import primevc.gui.graphics.fills.GradientType;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.fills.SolidFill;
 import primevc.gui.graphics.fills.SpreadMethod;
 import primevc.gui.styling.declarations.FontStyleDeclarations;
 import primevc.gui.styling.declarations.GraphicStyleDeclarations;
 import primevc.gui.styling.declarations.LayoutStyleDeclarations;
 import primevc.gui.styling.declarations.UIElementStyle;
 import primevc.gui.styling.StyleContainer;
 import primevc.gui.text.FontStyle;
 import primevc.gui.text.FontWeight;
 import primevc.gui.text.TextAlign;
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
	public static inline var R_WHITESPACE		: String = "\\s"; //"\n\r\t ";
	public static inline var R_WS				: String = "[" + R_WHITESPACE + "]*";	//can have any kind of whitespace
	public static inline var R_WS_MUST			: String = "[" + R_WHITESPACE + "]+";	//must have at least one whitespace charater
	public static inline var R_PROPERTY_NAME	: String = "a-z0-9-";
	public static inline var R_PROPERTY_VALUE	: String = R_WHITESPACE + "a-z0-9#.,:)(/\"'-";
	public static inline var R_BLOCK_VALUE		: String = R_PROPERTY_VALUE + ":;";
	
	public static inline var R_HEX_VALUE		: String = "0-9a-f";
	public static inline var R_HEX_EXPR			: String = "(0x|#)(["+R_HEX_VALUE+"]{8}|["+R_HEX_VALUE+"]{6}|["+R_HEX_VALUE+"]{3})";
	public static inline var R_RGBA_EXPR		: String = "(rgba)" + R_WS + "[(]((" + R_WS + R_DEC_OCTET + R_WS + "," + R_WS + "){3})((0[.][0-9]+)|0|1)" + R_WS + "[)]";
	public static inline var R_COLOR_EXPR		: String = "("+R_HEX_EXPR+")|("+R_RGBA_EXPR+")";
	public static inline var R_GRADIENT_POS		: String = "([0-9]+)(px|%)";
	public static inline var R_GRADIENT_COLOR	: String = "("+R_COLOR_EXPR+")("+R_WS_MUST+R_GRADIENT_POS+")?";
	public static inline var R_GRADIENT_SPREAD	: String = "pad|reflect|repeat";
	
	public static inline var R_DOMAIN_LABEL		: String = "[a-z]([a-z0-9-]*[a-z0-9])?";
	public static inline var R_CLASS_EXPR		: String = "(" + R_DOMAIN_LABEL + ")([.]" + R_DOMAIN_LABEL + ")*";
	
	public static inline var R_ROTATION			: String = "([-]?[0-9]+)deg";
	
	//
	//URI Regexp
	//@see http://labs.apache.org/webarch/uri/rfc/rfc3986.html
	//
	public static inline var R_URI_SCHEME		: String = "[a-z][a-z0-9+.-]+";										//"file|http|https|ftp|ldap|news|telnet"
	public static inline var R_URI_USERINFO		: String = "[a-z0-9_-]+(:.+)?";										//match username and optional the password
	public static inline var R_URI_DNS			: String = "(" + R_DOMAIN_LABEL + ")([.]" + R_DOMAIN_LABEL + ")+";
	public static inline var R_DEC_OCTET		: String = "([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])";			//matches a number from 0 - 255
	public static inline var R_URI_IPV4			: String = "(" + R_DEC_OCTET + "[.]){3}" + R_DEC_OCTET;
	public static inline var R_URI_IPV6			: String = "((" + R_HEX_VALUE + "){4}){5}";							//TODO: not sure how to implement the full IPv6 range.. this just covers 60 bits
	public static inline var R_URI_HOST			: String = "(" + R_URI_DNS + "|" + R_URI_IPV4 + "|" + R_URI_IPV6 + "|localhost)";
	public static inline var R_URI_PORT			: String = "[0-9]{1,4}|[0-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9{2}|655[0-2][0-9]|6553[0-5]]";	//port range from 0 - 65535
	public static inline var R_URI_AUTHORITY	: String = "(" + R_URI_USERINFO + "@)?(" + R_URI_HOST + ")(:(" + R_URI_PORT + "))?";
	public static inline var R_URI_NAME			: String = "[a-z][a-z0-9+%_,-]*";
	public static inline var R_URI_FOLDERNAME	: String = "(" + R_URI_NAME + ")|([.]{1,2})";
	public static inline var R_URI_FILENAME		: String = R_URI_NAME + "[.][a-z0-9]+";
	public static inline var R_URI_PATH			: String = "((" + R_URI_FOLDERNAME + ")/)*((" + R_URI_FILENAME + ")|(" + R_URI_FOLDERNAME + ")/?)";		//match path with optional filename at the end
	public static inline var R_URI_QUERY_VALUE	: String = "[a-z][a-z0-9+.?/_%-]*";
	public static inline var R_URI_QUERY_VAR	: String = "((" + R_URI_QUERY_VALUE + "=" + R_URI_QUERY_VALUE + ")|(" + R_URI_QUERY_VALUE + "))";
	public static inline var R_URI_QUERY		: String = "[?]" + R_URI_QUERY_VAR + "(&" + R_URI_QUERY_VAR + ")*";
	public static inline var R_URI_FRAGMENT		: String = "#(" + R_URI_QUERY_VALUE + ")+";
	public static inline var R_URI_EXPR			: String = "((" + R_URI_SCHEME + ")://)?(" + R_URI_AUTHORITY + ")(/" + R_URI_PATH + ")?(" + R_URI_QUERY + ")?(" + R_URI_FRAGMENT + ")?";
	
	
	/**
	 * Greedy stupid URI/file matcher
	 * R_URI_EXPR took to much time
	 */
	public static inline var R_URI_PRETENDER	: String = "['\"]?([a-z0-9/&%.#+=\\;:$@?_-]+)['\"]?";
	public static inline var R_FILE_EXPR		: String = R_URI_PATH;
	
	
	public static inline var R_BG_REPEAT_EXPR	: String = "repeat-all|no-repeat";
	
	
	
	/**
	 * container with all the style blocks
	 */
	private var styles				: StyleContainer;
	/**
	 * block that is currently handled by the parser
	 */
	private var currentBlock		: UIElementStyle;
	
	
	public var blockExpr			(default, null) : EReg;
	public var propExpr				(default, null) : EReg;
	public var intValExpr			(default, null) : EReg;
	public var colorValExpr			(default, null) : EReg;
	public var linGradientExpr		(default, null) : EReg;
	public var radGradientExpr		(default, null) : EReg;
	public var gradientColorExpr	(default, null) : EReg;
	public var gradientStopExpr		(default, null) : EReg;
	public var bgImageExpr			(default, null) : EReg;
	
	
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
		
		intValExpr			= new EReg("([0-9]+[ a-z]*)", "i");
		colorValExpr		= new EReg("^"+R_COLOR_EXPR+"$", "i");
		linGradientExpr		= new EReg(
				  "(linear-gradient)"+R_WS+"[(]"					//match linear gradient		(1 = type)
				+ R_WS+"("+R_ROTATION+")"							//match rotation			(3 = degrees)
				+ "(("+R_WS+","+R_WS+R_GRADIENT_COLOR+"){2,})"		//match colors				(4 = colors)
				+ "("+R_WS+","+R_WS+"("+R_GRADIENT_SPREAD+"))?"		//match spread method		(21 = method)
			    + R_WS+"[)]", "im");
		
		radGradientExpr		= new EReg(
				  "(radial-gradient)"+R_WS+"[(]"					//match radial gradient		(1 = type)
				+ R_WS+"([-]?(0?[.][0-9]+|0|1))"					//match focal point			(2 = radial-point)
				+ "(("+R_WS+","+R_WS+R_GRADIENT_COLOR+"){2,})"		//match colors				(4 = colors)
				+ "("+R_WS+","+R_WS+"("+R_GRADIENT_SPREAD+"))?"		//match spread method		(21 = method)
			    + R_WS+"[)]", "im");
		
		gradientColorExpr	= new EReg(R_GRADIENT_COLOR, "i");
		gradientStopExpr	= new EReg(R_GRADIENT_POS, "i");
		
		bgImageExpr			= new EReg(
			  "("
				+ "("
					+ "(url)"										//match url opener			3
					+ R_WS+"[(]"									//match opening '('
					+ R_WS+"['\"]?"									//match possible opening ' or "
		//			+ R_WS+"(("+R_FILE_EXPR+")|("+R_URI_EXPR+"))"	//match the url content		4 = local file. 19 = URI
					+ R_WS+"("+R_URI_PRETENDER+")"					//match the url content		4 = local file. 19 = URI
					+ R_WS+"['\"]?"									//match possible closing ' or "
					+ R_WS+"[)]"									//match closing ')'
				+ ")|("
					+ "(Class)"										//match Class opener		6
					+ R_WS+"[(]"									//match opening '('
					+ R_WS+"("+R_CLASS_EXPR+")"						//match the class content	7
					+ R_WS+"[)]"									//match closing ')'
				+ ")"
			+ ")"
			+ "["+R_WHITESPACE+"]*("+R_BG_REPEAT_EXPR+")?"						//match possible repeat value
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
			//font properties
			case "font-size":			createFontBlock(); currentBlock.font.size	= parseInt(val);
			case "font-family":			createFontBlock(); currentBlock.font.family	= val;
			case "color":				createFontBlock(); currentBlock.font.color	= parseColor(val);
			case "text-align":			createFontBlock(); currentBlock.font.align	= parseTextAlign(val);
			case "font-weight":			createFontBlock(); currentBlock.font.weight	= parseFontWeight(val);
			case "font-style":			createFontBlock(); currentBlock.font.style	= parseFontStyle(val);
			
			//graphic properties
			case "background":			parseBackground(val);
			case "background-color":	parseColorFill(val);
			case "background-image":	parseBgImage(val);
			case "background-repeat":	parseBgRepeat(val);
			
			//layout properties
		}
	}
	
	
	private inline function createFontBlock () : Void
	{
		if (currentBlock.font == null)
			currentBlock.font = new FontStyleDeclarations();
	}
	
	
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
	private inline function setGraphicsFill (newFill:IFill) : Void
	{
		if (currentBlock.graphics == null)
			currentBlock.graphics = new GraphicStyleDeclarations();
		
		if ( currentBlock.graphics.background == null || currentBlock.graphics.background.is( newFill.getClass() ) )
		{
			currentBlock.graphics.background = newFill;
		}
		else if (!currentBlock.graphics.background.is(ComposedFill))
		{
			var curFill		= currentBlock.graphics.background;
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
			
			currentBlock.graphics.background = compFill;
		}
		else
		{
			var compFill = currentBlock.graphics.background.as(ComposedFill);
			
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
	
	
	//
	// FONT PARSE METHODS
	//
	
	/**
	 * Method to convert the given value to an int and convert the value 
	 * according to the unit.
	 */
	private inline function parseInt (v:String) : Int
	{
		return (intValExpr.match(v)) ? intValExpr.matched(1).parseInt() : Number.INT_NOT_SET;
	}
	
	
	/**
	 * Method parses a color value like #aaa000 or 0xaaa000 to a RGBA value
	 */
	private inline function parseColor (v:String) : RGBA
	{
		var clr:RGBA = 0x00;
		if (colorValExpr.match(v.trim()))
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
		return switch (v.trim()) {
			default:		TextAlign.left;
			case "center":	TextAlign.center;
			case "right":	TextAlign.right;
		}
	}


	private inline function parseFontWeight (v:String) : FontWeight
	{
		return switch (v.trim()) {
		default:			FontWeight.normal;
			case "bold":	FontWeight.bold;
			case "bolder":	FontWeight.bolder;
			case "lighter":	FontWeight.lighter;
		}
	}


	private inline function parseFontStyle (v:String) : FontStyle
	{
		return switch (v.trim()) {
			default:		FontStyle.normal;
			case "italic":	FontStyle.italic;
			case "oblique":	FontStyle.oblique;
		}
	}
	
	
	
	//
	// FILLS PARSE METHODS
	//
	
	private inline function parseBackground (v:String) : Void
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
	private function parseColorFill (v:String) : Void
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
				while (true)
				{
					if ( !gradientColorExpr.match(colorsStr) )
						break;
					
					var pos = -1;
					if (gradientColorExpr.matched(5) != null)	pos = gradientColorExpr.matched(5).parseInt();
					if (gradientColorExpr.matched(6) == "%")	pos = ((pos / 100) * 255).int();
					
					gr.add( new GradientStop( gradientColorExpr.matched(3).rgba(), pos ) );
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
		
		//add fill to styleBlock
		if (fill != null)
			setGraphicsFill(fill);
	}
	
	
	private function parseBgImage (v:String) : Void
	{
		if (bgImageExpr.match(v))
		{
			trace("BACKGROUND IMAGE FOUND "+v);
			trace(bgImageExpr.resultToString());
			
			var bmp = new Bitmap();
			if (bgImageExpr.matched(3) != null)
				bmp.setString( bgImageExpr.matched(4) );
			
		//	bmp.loadClass( cast bgImageExpr.matched(7).resolveClass() );
			
			var fill = new BitmapFill( bmp );
		}
		else
			trace("no-bg-image-match");
	}
	
	
	private inline function parseBgRepeat (v:String) : Void
	{
		
	}
	
	
	private inline function parseGradientMethod (v:String) : SpreadMethod
	{
		return switch (v) {
			case "pad":		SpreadMethod.normal;
			case "reflect":	SpreadMethod.reflect;
			case "repeat":	SpreadMethod.repeat;
		};
	}
}