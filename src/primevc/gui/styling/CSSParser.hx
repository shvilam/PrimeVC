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
 import haxe.FastList;
 import primevc.core.geom.space.Direction;
 import primevc.core.geom.space.Horizontal;
 import primevc.core.geom.space.MoveDirection;
 import primevc.core.geom.space.Position;
 import primevc.core.geom.space.Vertical;
 import primevc.core.geom.Box;
 import primevc.core.geom.Corners;
 import primevc.core.geom.IntPoint;
 import primevc.core.IDisposable;
 import primevc.gui.behaviours.layout.ClippedLayoutBehaviour;
 import primevc.gui.behaviours.layout.UnclippedLayoutBehaviour;
 import primevc.gui.behaviours.scroll.CornerScrollBehaviour;
 import primevc.gui.behaviours.scroll.DragScrollBehaviour;
 import primevc.gui.behaviours.scroll.MouseMoveScrollBehaviour;
 import primevc.gui.effects.AnchorScaleEffect;
 import primevc.gui.effects.CompositeEffect;
 import primevc.gui.effects.Easing;
 import primevc.gui.effects.EffectProperties;
 import primevc.gui.effects.FadeEffect;
 import primevc.gui.effects.IEffect;
 import primevc.gui.effects.MoveEffect;
 import primevc.gui.effects.ParallelEffect;
 import primevc.gui.effects.ResizeEffect;
 import primevc.gui.effects.RotateEffect;
 import primevc.gui.effects.ScaleEffect;
 import primevc.gui.effects.SequenceEffect;
 import primevc.gui.effects.SetAction;
 import primevc.gui.effects.WipeEffect;
 import primevc.gui.filters.BevelFilter;
 import primevc.gui.filters.BitmapFilterType;
 import primevc.gui.filters.BlurFilter;
 import primevc.gui.filters.DropShadowFilter;
 import primevc.gui.filters.GlowFilter;
 import primevc.gui.filters.GradientBevelFilter;
 import primevc.gui.filters.GradientGlowFilter;
 import primevc.gui.filters.IBitmapFilter;
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
 import primevc.gui.graphics.shapes.IGraphicShape;
 import primevc.gui.graphics.shapes.Line;
 import primevc.gui.graphics.shapes.RegularRectangle;
 import primevc.gui.graphics.shapes.Triangle;
 import primevc.gui.layout.algorithms.circle.HorizontalCircleAlgorithm;
 import primevc.gui.layout.algorithms.circle.VerticalCircleAlgorithm;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.tile.DynamicTileAlgorithm;
 import primevc.gui.layout.algorithms.tile.FixedTileAlgorithm;
 import primevc.gui.layout.algorithms.DynamicLayoutAlgorithm;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.algorithms.RelativeAlgorithm;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.RelativeLayout;
 import primevc.gui.styling.declarations.EffectStyleDeclarations;
 import primevc.gui.styling.declarations.FilterCollectionType;
 import primevc.gui.styling.declarations.FilterStyleDeclarations;
 import primevc.gui.styling.declarations.FontStyleDeclarations;
 import primevc.gui.styling.declarations.LayoutStyleDeclarations;
 import primevc.gui.styling.declarations.StyleContainer;
 import primevc.gui.styling.declarations.StyleDeclarationType;
 import primevc.gui.styling.declarations.UIElementStyle;
 import primevc.gui.text.FontStyle;
 import primevc.gui.text.FontWeight;
 import primevc.gui.text.TextAlign;
 import primevc.gui.text.TextDecoration;
 import primevc.gui.text.TextTransform;
 import primevc.tools.Manifest;
 import primevc.types.Bitmap;
 import primevc.types.Number;
 import primevc.types.RGBA;
 import primevc.utils.Color;
  using primevc.utils.Bind;
  using primevc.utils.Color;
  using primevc.utils.ERegUtil;
  using primevc.utils.NumberUtil;
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
	
	public static inline var R_IMPORT_SHEET			: String = "@import" + R_SPACE_MUST + "(url" + R_SPACE + "[(])?['\"]" + R_SPACE + "(" + R_FILE_EXPR + ")" + R_SPACE + "['\"]" + R_SPACE + "[)]?;";
	
	public static inline var R_PROPERTY_NAME		: String = "a-z0-9-";
	public static inline var R_PROPERTY_VALUE		: String = R_WHITESPACE + "a-z0-9%#.,:)(/\"'-";
	
	public static inline var R_BLOCK_NAME			: String = "(([.#]?)([a-z][a-z0-9_]+)(:([a-z]+))?)";
	public static inline var R_BLOCK_NAMES			: String = "" + R_BLOCK_NAME + "(" + R_SPACE_MUST + R_BLOCK_NAME + ")*";
	public static inline var R_BLOCK_VALUE			: String = R_PROPERTY_VALUE + ":;";
	
	public static inline var R_HEX_VALUE			: String = "0-9a-f";
	public static inline var R_HEX_EXPR				: String = "(0x|#)(["+R_HEX_VALUE+"]{8}|["+R_HEX_VALUE+"]{6}|["+R_HEX_VALUE+"]{3})";
	public static inline var R_RGBA_EXPR			: String = "(rgba)" + R_WS + "[(]((" + R_WS + R_DEC_OCTET + R_WS + "," + R_WS + "){3})((0[.][0-9]+)|0|1)" + R_WS + "[)]";
	public static inline var R_COLOR_EXPR			: String = "("+R_HEX_EXPR+")|("+R_RGBA_EXPR+")";
	
	public static inline var R_RELATIVE_UNITS		: String = "px|ex|em";
	public static inline var R_ABSOLUTE_UNITS		: String = "in|cm|mm|pt|pc";
	public static inline var R_UNITS				: String = "(" + R_RELATIVE_UNITS + "|" + R_ABSOLUTE_UNITS + ")"; // + "|%";
	
	public static inline var R_SIMPLE_UNIT_VALUE	: String = R_FLOAT_VALUE + "[%a-z]+";			//matches floating points with a posible unit (flash player will crash if we make the search complexer...)
	
//	public static inline var R_ZERO_VALUE			: String = "((?![1-9]+)0)|(^0)"; // "[^1-9]+0|(?:(\\s|^)0)"; //"((" + R_SPACE_MUST + "|^)0)";
	public static inline var R_INT_VALUE			: String = "([-]?[0-9]+)";
	public static inline var R_FLOAT_VALUE			: String = "([-]?(([0-9]*[.][0-9]{1,3})|[0-9]+))";
	public static inline var R_INT_UNIT_VALUE		: String = "((" + R_INT_VALUE + R_UNITS + "))"; //"((" + R_INT_VALUE + R_UNITS + ")|" + R_ZERO_VALUE + ")";
	public static inline var R_FLOAT_UNIT_VALUE		: String = "((" + R_FLOAT_VALUE + R_UNITS + "))"; //"((" + R_FLOAT_VALUE + R_UNITS + ")|" + R_ZERO_VALUE + ")";
	public static inline var R_PERC_VALUE			: String = "((" + R_FLOAT_VALUE + "%))";
	public static inline var R_FLOAT_GROUP_VALUE	: String = R_FLOAT_UNIT_VALUE + "(" + R_SPACE_MUST + R_FLOAT_UNIT_VALUE + ")?(" + R_SPACE_MUST + R_FLOAT_UNIT_VALUE + ")?(" + R_SPACE_MUST + R_FLOAT_UNIT_VALUE + ")?";
	public static inline var R_POINT_VALUE			: String = R_FLOAT_UNIT_VALUE + R_SPACE + "," + R_SPACE + R_FLOAT_UNIT_VALUE;
	
	public static inline var R_SIMPLE_GRADIENT_COLOR: String = "(" + R_COLOR_EXPR + ")(" + R_SPACE_MUST + R_SIMPLE_UNIT_VALUE + ")?";
	public static inline var R_GRADIENT_COLOR		: String = "(" + R_COLOR_EXPR + ")(" + R_SPACE_MUST + "(" + R_FLOAT_UNIT_VALUE + "|" + R_PERC_VALUE + ")|0)?";
	public static inline var R_GRADIENT_SPREAD		: String = "pad|reflect|repeat";
	
	public static inline var R_DOMAIN_LABEL			: String = "[a-z]([a-z0-9-]*[a-z0-9])?";
	public static inline var R_CLASS_EXPR			: String = "(" + R_DOMAIN_LABEL + ")([.]" + R_DOMAIN_LABEL + ")*";
	
	public static inline var R_ROTATION				: String = R_FLOAT_VALUE + "deg";
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
	public static inline var R_URI_PRETENDER		: String = "['\"]?([/a-z0-9/&%.#+=\\;:$@?_-]+)['\"]?";
	public static inline var R_FILE_EXPR			: String = R_URI_PATH;
	
	
	public static inline var R_BG_REPEAT_EXPR		: String = "repeat-all|no-repeat";
	
	public static inline var R_FONT_STYLE_EXPR		: String = "normal|italic|oblique|inherit";
	public static inline var R_FONT_WEIGHT_EXPR		: String = "normal|bolder|bold|lighter|inherit";
	public static inline var R_GENERIC_FONT_FAMILIES: String = "serif|sans[-]serif|monospace|cursive|fantasy";
	public static inline var R_FONT_FAMILY_EXPR		: String = "("+R_GENERIC_FONT_FAMILIES+")|([a-z]+)|(['\"]([a-z0-9+.,+/\\ _-]+)['\"])";
	
	public static inline var R_HOR_DIR				: String = "(left|center|right)";
	public static inline var R_VER_DIR				: String = "(top|center|bottom)";
	public static inline var R_DIRECTIONS			: String = "(horizontal|vertical)";
	public static inline var R_POSITIONS			: String = "(top[-]" + R_HOR_DIR + "|middle[-](left|right)|bottom[-]" + R_HOR_DIR + "|(" + R_POINT_VALUE + "))";
	
	public static inline var R_COMMA				: String = R_SPACE + "," + R_SPACE;
	
	public static inline var R_TIME_MS				: String = "([1-9][0-9]*)ms";
	public static inline var R_EASING				: String = "(back|bounce|circ|cubic|elastic|expo|linear|quad|quart|quint|sine)[-]((in[-]out)|in|out)";
	
	
	
	
	public var blockExpr				(default, null) : EReg;
	public var blockNameExpr			(default, null) : EReg;
	public var propExpr					(default, null) : EReg;
	
	public var percValExpr				(default, null) : EReg;		//should match [float]%
	public var intValExpr				(default, null) : EReg;		//should match [int]
	public var intUnitValExpr			(default, null) : EReg;		//should match [int]unit
	public var floatValExpr				(default, null) : EReg;		//should match [float]
	public var floatUnitValExpr			(default, null) : EReg;		//should match [float]unit
	public var floatUnitGroupValExpr	(default, null) : EReg;		//should match [float]unit <[float]unit>? <[float]unit>? <[float]unit>?
	public var pointExpr				(default, null) : EReg;		//matched a point value: [float]unit, [float]unit
	public var angleExpr				(default, null) : EReg;		//matched a rotation value
	
	public var colorValExpr				(default, null) : EReg;
	public var linGradientExpr			(default, null) : EReg;
	public var radGradientExpr			(default, null) : EReg;
	public var gradientColorExpr		(default, null) : EReg;
//	public var gradientStopExpr			(default, null) : EReg;
	public var imageURIExpr				(default, null) : EReg;
	public var imageRepeatExpr			(default, null) : EReg;
	public var classRefExpr				(default, null) : EReg;
	
	public var fontFamilyExpr			(default, null) : EReg;
	public var fontWeightExpr			(default, null) : EReg;
	public var fontStyleExpr			(default, null) : EReg;
	
	public var floatHorExpr				(default, null)	: EReg;
	public var floatVerExpr				(default, null)	: EReg;
	public var floatExpr				(default, null)	: EReg;
	
	public var horCircleExpr			(default, null)	: EReg;
	public var verCircleExpr			(default, null)	: EReg;
	public var circleExpr				(default, null)	: EReg;
	
	public var horEllipseExpr			(default, null)	: EReg;
	public var verEllipseExpr			(default, null)	: EReg;
	public var ellipseExpr				(default, null)	: EReg;
	
	public var dynamicTileExpr			(default, null) : EReg;
	public var fixedTileExpr			(default, null) : EReg;
	
	public var triangleExpr				(default, null) : EReg;
	
	public var filterBlurExpr			(default, null) : EReg;
	public var filterInnerExpr			(default, null) : EReg;
	public var filterHideExpr			(default, null) : EReg;
	public var filterKnockoutExpr		(default, null) : EReg;
	public var filterQualityExpr		(default, null) : EReg;
	public var filterTypeExpr			(default, null) : EReg;
	
	public var anchorScaleEffExpr		(default, null) : EReg;
	public var fadeEffExpr				(default, null) : EReg;
	public var moveEffExpr				(default, null) : EReg;
	public var parallelEffExpr			(default, null) : EReg;
	public var resizeEffExpr			(default, null) : EReg;
	public var rotateEffExpr			(default, null) : EReg;
	public var scaleEffExpr				(default, null) : EReg;
	public var sequenceEffExpr			(default, null) : EReg;
	public var setActionEffExpr			(default, null) : EReg;
	public var wipeEffExpr				(default, null) : EReg;
	
	public var effectChildrenExpr		(default, null) : EReg;
	
	public var easingExpr				(default, null) : EReg;
	public var timingExpr				(default, null) : EReg;
	
	
	
	private var manifest				: Manifest;
	
	/**
	 * container with all the style blocks that are found and parsed. The
	 * direct styleproperties in this object are used as global properties.
	 */
	private var styles					: UIElementStyle;
	
	/**
	 * List with all styleSheets url's that should be loaded and parsed.
	 */
	private var styleSheetQueue			: FastList < StyleQueueItem >;
	
	/**
	 * block that is currently handled by the parser
	 */
	private var currentBlock			: UIElementStyle;
	
	/**
	 * The path to the current css sheet. This path (combined with the 
	 * 'swfBasePath') is added to each relative path that is found to make 
	 * sure that references keep working.
	 * 
	 * I.e. './styles/flair'
	 */
	private var styleSheetBasePath		: String;
	/**
	 * Path from the directory where the swf is placed to the current stylesheet
	 * location (i.e. '../../').
	 */
	public var swfBasePath				: String;
	
	
	
	
	public function new (styles:UIElementStyle, manifest:Manifest = null)
	{
		this.styles		= styles;
		this.manifest	= manifest;
		styleSheetQueue = new FastList < StyleQueueItem >();
		init();
	}
	
	
	private inline function init ()
	{
		blockNameExpr	= new EReg ( R_BLOCK_NAME, "i" );
		blockExpr		= new EReg(
			  "(^" + R_BLOCK_NAMES+")"		//match style selectors containing .name, #name or name
			+ "[" + R_WHITESPACE + "]*{"	//match opening of a block
			+ "([" + R_BLOCK_VALUE + "]*)"	//match content of a block
			+ "[" + R_WHITESPACE + "]*}"	//match closing of a block
			, "im");
		
		propExpr = new EReg(
			  "[" + R_WHITESPACE + "]*([" + R_PROPERTY_NAME + "]+)[" + R_WHITESPACE + "]*:"		//match property name
			+ "[" + R_WHITESPACE + "]*([" + R_PROPERTY_VALUE + "]+)[" + R_WHITESPACE + "]*;"	//match property value
			, "im");
		
		intValExpr				= new EReg(R_INT_VALUE, "i");				//1 = value
		intUnitValExpr			= new EReg(R_INT_UNIT_VALUE, "i");			//3 = value, 4 = unit
		percValExpr				= new EReg(R_PERC_VALUE, "i");				//2 = value
		floatValExpr			= new EReg(R_FLOAT_VALUE, "i");				//1 = value
		floatUnitValExpr		= new EReg(R_FLOAT_UNIT_VALUE, "i");		//3 = value, 6 = unit
		floatUnitGroupValExpr	= new EReg(R_FLOAT_GROUP_VALUE, "i");		//1 = prop1 ( 3 = val, 6 = unit ), 8 = prop2 ( 10 = val, 13 = unit ), 15 = prop3 ( 17 = val, 20 = unit ), 22 = prop4 ( 24 = val, 27 = unit )
		pointExpr				= new EReg(R_POINT_VALUE, "i");				//1 = prop1 ( 3 = val, 6 = unit ), 8 = prop2 ( 10 = val, 13 = unit )
		angleExpr				= new EReg(R_ROTATION, "i");
		
		colorValExpr			= new EReg(R_COLOR_EXPR, "i");
		fontFamilyExpr			= new EReg("("+R_FONT_FAMILY_EXPR+")", "i");
		fontWeightExpr			= new EReg("("+R_FONT_WEIGHT_EXPR+")", "i");
		fontStyleExpr			= new EReg("("+R_FONT_STYLE_EXPR+")", "i");
		
		linGradientExpr = new EReg(
				  "(linear-gradient)"+R_WS+"[(]"							//match linear gradient		(1 = type)
				+ R_WS+"("+R_ROTATION+")"									//match rotation			(3 = degrees)
				+ "((" + R_COMMA + R_SIMPLE_GRADIENT_COLOR+"){2,})"			//match colors				(4 = colors)
				+ "(" + R_COMMA + "("+R_GRADIENT_SPREAD+"))?"				//match spread method		(21 = method)
			    + R_WS+"[)]", "im");
		
		radGradientExpr = new EReg(
				  "(radial-gradient)"+R_WS+"[(]"							//match radial gradient		(1 = type)
				+ R_WS+"([-]?(0?[.][0-9]+|0|1))"							//match focal point			(2 = radial-point)
				+ "((" + R_COMMA + R_SIMPLE_GRADIENT_COLOR+"){2,})"			//match colors				(4 = colors)
				+ "(" + R_COMMA + "("+R_GRADIENT_SPREAD+"))?"				//match spread method		(21 = method)
			    + R_WS+"[)]", "im");
		
		gradientColorExpr = new EReg(R_GRADIENT_COLOR, "i");
		
		imageURIExpr = new EReg(
				  "(url)"													//match url opener				1
				+ R_SPACE+"[(]"												//match opening '('
				+ R_SPACE+"['\"]?"											//match possible opening ' or "
		//		+ R_WS+"(("+R_FILE_EXPR+")|("+R_URI_EXPR+"))"				//match the url content			4 = local file. 19 = URI
				+ R_SPACE+"("+R_URI_PRETENDER+")"							//match the url content			2 
				+ R_SPACE+"['\"]?"											//match possible closing ' or "
				+ R_SPACE+"[)]"												//match closing ')'
			, "i");
		
		imageRepeatExpr = new EReg("("+R_BG_REPEAT_EXPR+")", "i");			//match possible repeat value	1
		
		classRefExpr = new EReg(
			  	"(Class)"													//match Class opener			1
				+ R_SPACE+"[(]"												//match opening '('
				+ R_SPACE+"("+R_CLASS_EXPR+")"								//match the class content		2
				+ R_SPACE+"[)]"												//match closing ')'
			, "i");
		
		var horLayoutEnding = R_SPACE
		 	+ "([(]" + R_SPACE + R_HOR_DIR 									//2 = hor-dir
			+ "(" + R_COMMA + R_VER_DIR + ")?" 								//4 - ver-dir
			+ R_SPACE + "[)])?";
		
		var verLayoutEnding = R_SPACE
		 	+ "([(]" + R_SPACE + R_VER_DIR 									//2 = ver-dir
			+ "(" + R_COMMA + R_HOR_DIR + ")?" 								//4 - hor-dir
			+ R_SPACE + "[)])?";
		
		
		floatHorExpr	= new EReg( "float-hor" + horLayoutEnding, "i");
		floatVerExpr	= new EReg( "float-ver" + verLayoutEnding, "i");
		floatExpr		= new EReg( "float" + horLayoutEnding, "i");
		
		horCircleExpr	= new EReg( "hor-circle" + horLayoutEnding, "i");	
		verCircleExpr	= new EReg( "ver-circle" + verLayoutEnding, "i");
		circleExpr		= new EReg( "circle" + horLayoutEnding, "i");
		
		horEllipseExpr	= new EReg( "hor-ellipse" + horLayoutEnding, "i");
		verEllipseExpr	= new EReg( "ver-ellipse" + verLayoutEnding, "i");
		ellipseExpr		= new EReg( "ellipse" + horLayoutEnding, "i");
		
		dynamicTileExpr	= new EReg(
			  "dynamic-tile"
			+ "("
				+ R_SPACE + "[(]" + R_SPACE + R_DIRECTIONS					// 3 = start-direction
				+ "(" + R_COMMA + R_HOR_DIR									// 5 = horizontal direction
					+ "(" + R_COMMA + R_VER_DIR + ")?"						// 7 = vertical direction
			 		+ ")?"
				+ R_SPACE + "[)]"
			+ ")?"
			, "i");
		
		fixedTileExpr	= new EReg(
			  "fixed-tile"
			+ "("
				+ R_SPACE + "[(]" + R_SPACE + R_DIRECTIONS					// 3 = start-direction
				+ "(" + R_COMMA + R_INT_VALUE								// 5 = number of rows or columns (depending on the start-direction)
					+ "(" + R_COMMA + R_HOR_DIR								// 7 = horizontal direction
						+ "(" + R_COMMA + R_VER_DIR + ")?"					// 9 = vertical direction
			 		+ ")?"	
		 		+ ")?"
				+ R_SPACE + "[)]"
			+ ")?"
			, "i");
		
		triangleExpr	= new EReg(
			  "triangle"
			+ "("
			 	+ R_SPACE + "[(]"
			 	+ R_SPACE + R_POSITIONS
			 	+ R_SPACE + "[)]"
			+ ")?"
			, "i");
		
		
		//
		//filter expressions
		//
		
		filterBlurExpr		= new EReg(R_FLOAT_UNIT_VALUE + R_SPACE_MUST + R_FLOAT_UNIT_VALUE, "i");		//1 = prop1 ( 3 = val, 6 = unit ), 8 = prop2 ( 10 = val, 13 = unit )
		filterInnerExpr		= new EReg("inner", "i");
		filterHideExpr		= new EReg("hide-object", "i");
		filterKnockoutExpr	= new EReg("knockout", "i");
		filterQualityExpr	= new EReg("(low|medium|high)", "i");
		filterTypeExpr		= new EReg("(inner|outer|full)", "i");
		
		
		
		easingExpr	= new EReg(R_EASING, "i");
		timingExpr	= new EReg(R_TIME_MS, "i");
		
		//parameters for a effect with 2 or 4 float-unit parameters
		var effectFloatGroupParams = 
			  "("
			+		R_SPACE + R_POINT_VALUE					//start pos x = 3, y = 9
			+		R_SPACE_MUST + R_POINT_VALUE			//end pos x = 15, y = 21
			+ ")|("
			+		R_SPACE + R_POINT_VALUE					//end pos x = 28, y = 34
			+ ")";
		
		var fadeParams = 
			  "("
			+ 		R_SPACE + R_PERC_VALUE					//start-alpha = 3
			+		R_SPACE_MUST + R_PERC_VALUE				//end-alpha = 8
			+  ")|("
			+		R_SPACE + R_PERC_VALUE					//end-alpha = 14
			+  ")";
		
		var rotateParams = 
			  "("
			+		R_SPACE + "(" + R_ROTATION + ")"		//start-rotation = 3
			+		R_SPACE_MUST + "(" + R_ROTATION + ")"	//end-rotation = 7
			+ ")|("
			+		R_SPACE + R_ROTATION					//end-rotation = 10
			+ ")";
		
		var scaleParams = 
			  "("
			+		R_SPACE + R_PERC_VALUE					// start-scaleX	= 3
			+		R_SPACE + "," + R_SPACE + R_PERC_VALUE	// start-scaleY	= 8
			+		R_SPACE_MUST + R_PERC_VALUE				// end-scaleX	= 13
			+		R_SPACE + "," + R_SPACE + R_PERC_VALUE	// end-scaleY	= 18
			+ ")|("
			+		R_SPACE + R_PERC_VALUE					// end-scaleX	= 24
			+		R_SPACE + "," + R_SPACE + R_PERC_VALUE	// end-scaleY	= 29
			+ ")";
		
		anchorScaleEffExpr = new EReg(
			  "^anchor-scale"
			+	"(" + R_SPACE_MUST + R_POSITIONS + ")?"		// position		= 2
			+	"(" + R_SPACE_MUST + R_PERC_VALUE + ")?"	// end-scaleX	= 20
			+	"(" + R_SPACE_MUST + R_PERC_VALUE + ")?"	// end-scaleY	= 25
			, "i");
		
		fadeEffExpr		= new EReg("^fade(" + R_SPACE_MUST + fadeParams + ")?" , "i");
		moveEffExpr		= new EReg("^move(" + R_SPACE_MUST + effectFloatGroupParams + ")?", "i");
		resizeEffExpr	= new EReg("^resize(" + R_SPACE_MUST + effectFloatGroupParams + ")?", "i");
		rotateEffExpr	= new EReg("^rotate(" + R_SPACE_MUST + rotateParams + ")?", "i" );
		scaleEffExpr	= new EReg("^scale(" + R_SPACE_MUST + scaleParams + ")?", "i");
		
		wipeEffExpr = new EReg(
			  "^wipe"
			+	"(" + R_SPACE_MUST + R_DIRECTIONS + ")?"		// direction	= 1
			+	"(" + R_SPACE_MUST + R_FLOAT_UNIT_VALUE + ")?"	// end-scaleX	= 19
			+	"(" + R_SPACE_MUST + R_FLOAT_UNIT_VALUE + ")?"	// end-scaleY	= 26
			, "i");
		
		setActionEffExpr = new EReg ( 
			  "^set-action" + R_SPACE + "("
			+	"("
			+		"alpha" + R_SPACE + "[(](" + fadeParams + ")" + R_SPACE + "[)]"
			+	")|("
			+		"position" + R_SPACE + "[(](" + effectFloatGroupParams + ")" + R_SPACE + "[)]"
			+	")|("
			+		"rotation" + R_SPACE + "[(](" + rotateParams + ")" + R_SPACE + "[)]"
			+	")|("
			+		"size" + R_SPACE + "[(](" + effectFloatGroupParams + ")" + R_SPACE + "[)]"
			+	")|("
			+		"scale" + R_SPACE + "[(](" + scaleParams + ")" + R_SPACE + "[)]"
			+	")|("
			+		"any" + R_SPACE + "[(]" + R_SPACE + "([a-z][a-z0-9_+.-]*)" + R_SPACE + "," + R_SPACE + "([a-z0-9_+.-]+)(" + R_SPACE + "," + R_SPACE + "([a-z0-9_+.-]+))?" + R_SPACE + "[)]"
			+	")"
			+ ")?"
			, "i" );
		
		
		sequenceEffExpr = new EReg( "^sequence([^(]*)[(](.+)[)]", "i" );
		parallelEffExpr = new EReg( "^parallel([^(]*)[(]([^)]+)[)]", "i" );
		
		effectChildrenExpr	= new EReg( "([a-z0-9 \\t_+%#.-]+([(]([^)]*|(?1))[)])?)("+R_SPACE+"[,]"+R_SPACE+")?", "i");
	}
	
	
	private inline function getBasePath () : String
	{
		return (swfBasePath + "/" + styleSheetBasePath).replace("//", "/");
	}
	
	
	private inline function loadFileContent (file:String) : String
	{
#if neko
		try {
			return neko.io.File.getContent( file );
		}
		catch (e:Dynamic)
		{
			trace("ERROR IMPORTING STYLESHEET (" + file + "): " + e);
			return "";
		}
#else
		throw "not implemented yet!";
		return "";
#end
	}
	
	
	/**
	 * Find style blocks and parse their content to valid haxe code blocks.
	 * Method will first import other css sheets that are defined in the 
	 * document and then remove all the comments
	 */
	public function parse (styleSheet:String, swfBasePath:String = ".") : Void
	{
		this.swfBasePath = swfBasePath;
		addStyleSheet(styleSheet);
		
		while (!styleSheetQueue.isEmpty())
			parseStyleSheet( styleSheetQueue.pop() );
		
		createStyleStructure( "", styles );
		trace("--- DONE ----");
		trace(styles.toCSS());
	}
	
	
	
	
	
	
	//
	// STYLESHEET METHODS
	//
	
	private function addStyleSheet (file:String) : Void
	{
		var content = loadFileContent(file);
		
		if (content != "")
		{
			//find base path of stylesheet
			var pathEndPos	= file.lastIndexOf("/");
			var path		= "";
			if (pathEndPos > -1)
				path = file.substr(0, pathEndPos);
			
			styleSheetBasePath = path;
			
			//first add stylesheet to the queue with stylesheets that want to get parsed
			var item = new StyleQueueItem(path);
			styleSheetQueue.add( item );
			
			//strip content of bloat
			content = importStyleSheets( content );
			content = removeComments( content );
			item.content = content;
		}
	}
	
	
	private function parseStyleSheet (item:StyleQueueItem) : Void
	{
		styleSheetBasePath = item.path;
		blockExpr.matchAll(item.content, handleMatchedBlock);
		trace("PARSED: "+item.path);
	}
	
	
	
	/**
	 * Method will import all @import tags in the given stylesheet. 
	 * 
	 * It's important that the 'importExpr' variable is local, otherwise their
	 * might be errors when stylesheets in stylesheets are imported.
	 */
	private function importStyleSheets ( styleContent ) : String
	{
		var importExpr = new EReg ( R_IMPORT_SHEET, "i" );
		return importExpr.customReplace(styleContent, importStyleSheet);
	}
	
	
	private function importStyleSheet (expr:EReg) : String {
		addStyleSheet( styleSheetBasePath + "/" + expr.matched(2) );
		return "";
	}
	
	
	
	
	
	
	//
	// PARENT SEARCH METHODS
	//
	
	
	/**
	 * Method will try to find all the "super" and "extended" styles of the 
	 * style-objects in the given stylegroup (recursivly through all 
	 * child-items).
	 */
	private function createStyleStructure (name:String, style:UIElementStyle) : Void
	{
		//search in children
		if (style.hasChildren())
		{
			findExtendedClassesInList( style.children.idSelectors );
			findExtendedClassesInList( style.children.styleNameSelectors );
			findExtendedClassesInList( style.children.elementSelectors );
			
			findSuperClassesInList( style.children.elementSelectors );
		}
	}
	
	
	private function findExtendedClassesInList (list:SelectorMapType) : Void
	{
		var keys = list.keys();
		
		for (name in keys)
		{
			Assert.that(name != null);
			var style = list.get(name);
			setExtendedStyle( name, style );
			createStyleStructure( name, style );
			
			if (style.hasStates())
				findExtendedStatesForStyle( name, style );
		}
	}
	
	
	private function findSuperClassesInList (list:SelectorMapType) : Void
	{
		var keys = list.keys();
		for (name in keys)
		{
			var style = list.get(name);
			setSuperStyle( name, style );
			
			if (style.hasStates())
				findSuperStatesForStyle( name, style );
		}
	}
	
	
	private function setExtendedStyle (name:String, style:UIElementStyle)
	{
		if (style == null || style.parentStyle == null)
			return;
		
		style.extendedStyle = style.parentStyle.findStyle( name, style.type, style );
	}
	
	
	private function setSuperStyle (name:String, style:UIElementStyle) : Void
	{
		var parentName = manifest.getFullSuperClassName( name );
		while (parentName != null && parentName != "")
		{
			style.superStyle = style.parentStyle.findStyle( parentName, element, style );
			
			if (style.superStyle != null)
				break;
			
			parentName = manifest.getFullSuperClassName( parentName );
		}
	}
	
	
	private function findExtendedStatesForStyle (styleName:String, style:UIElementStyle) : Void
	{
		var states	= style.states;
		var keys	= states.keys();
		
		for (stateName in keys)
		{
			Assert.that(stateName != null);
			var state = states.get(stateName);
			setExtendedState( stateName, state, styleName, style );
			createStyleStructure( stateName, state );
		}
	}
	
	
	private function setExtendedState (stateName:String, state:UIElementStyle, styleName:String, style:UIElementStyle)
	{
		if (state == null || style == null)
			return;
		
		state.extendedStyle = style.findState( stateName, styleName, style.type, state );
	}
	
	
	private function findSuperStatesForStyle (styleName:String, style:UIElementStyle) : Void
	{
		var states	= style.states;
		var keys	= states.keys();
		
		for (stateName in keys)
		{
			Assert.that(stateName != null);
			var state		= states.get(stateName);
			var superName	= manifest.getFullSuperClassName( styleName );
			while (state.superStyle == null && superName != null && superName != "")
			{
				setSuperState( stateName, state, superName, style );
				superName = manifest.getFullSuperClassName( superName );
			}
		}
	}
	
	
	private function setSuperState (stateName:String, state:UIElementStyle, styleName:String, style:UIElementStyle)
	{
		if (state == null)
			return;
		
		state.superStyle = style.findState( stateName, styleName, StyleDeclarationType.element, state );
	}
	
	
	
	/**
	 * Searches recursivly to all superclasses until a super is found or null
	 * when there is no super class.
	 */
	/*private function findParentElemStyle (name:String, list:Hash<UIElementStyle>) : UIElementStyle
	{
		//get parent from manifest
		var parent = manifest.getFullParentName( name );
		
		if (parent == null)
			return null;
		
		if (!list.exists(parent))
			return findSuperElemStyle(parent, list);
		
		trace("parent found for "+name+": "+parent);
		return list.get( parent );
	}*/
	
	
	
	
	
	
	//
	// CSS METHODS
	//
	
	
	/**
	 * Method will replace all comments with empty strings with support for
	 * literal strings.
	 * @see http://ostermiller.org/findcomment.html
	 */
	private inline function removeComments (style:String):String
	{
		var commentExpr = new EReg(
			  "("
		/*	+ 	"['\"]"
			+	"([^'\"]|[\r\n])*"
			+	"['\"]"
			+	"("
			+		"[/]*"
			+		"([^/][^*])|[\r\n]"
			+	")*"
			+ ")?"	//matches any opening and closing of a literal string, followed by any text accept for a comment
			+ "("*/
			+	"/[*]"
			+	"([^*]|[\r\n]|([*]+([^*/]|[\r\n])))*"
			+	"[*]+/"
			+ ")"			//matches comments opening and closing /* */
		, "im");
		return commentExpr.removeAll(style);
	}
	
	
	/**
	 * Method to handle each matched style block and put it in the right
	 * style-container.
	 */
	private function handleMatchedBlock (expr:EReg) : Void
	{
		//find correct block
		getContentBlock( expr.matched(1) );
		
		var content = expr.matched(13).trim();
		if (content != "")
			parseBlock(content.trim());
	}
	
	
	
	/**
	 * Method will find or create the correct UIElementBlock for the given 
	 * names.
	 */
	private function getContentBlock ( names:String ):Void
	{
		trace("getContentBlock "+names);
		var styleGroup	: UIElementStyle = styles;
		var type		: StyleDeclarationType;
		var curList 	: SelectorMapType = null;
		var depth		= 0;
		var expr		= blockNameExpr;
		currentBlock	= null;
		var stateName:String = null;
		
		//
		// PARSE NAMES
		//
		
		while (true)
		{
			if ( !expr.match(names) )
				break;
			
			if ( currentBlock != null )
				styleGroup = currentBlock;
			
			var name = expr.matched(3);
			Assert.notNull(name);
			
			if (expr.matched(2) == "#") {
				type	= StyleDeclarationType.id;
				curList	= styleGroup.children.idSelectors;
			}
			else if (expr.matched(2) == ".") {
				type	= StyleDeclarationType.styleName;
				curList	= styleGroup.children.styleNameSelectors;
			}
			else {
				type	= StyleDeclarationType.element;
				curList	= styleGroup.children.elementSelectors;
				
				//find fullname of element styles
				name	= manifest.getFullName( name );
			}
			
			//create a styleobject for this name if it doens't exist
			if (curList.exists(name))
				currentBlock = curList.get(name);
			else
			{
				currentBlock = new UIElementStyle(type);
				currentBlock.parentStyle = styleGroup;
				curList.set( name, currentBlock );
			}
			
			//matched a state
			if (expr.matched(4) != null)
			{
				getStateContentBlock(expr.matched(5));
			}
			
			names = expr.matchedRight().trim();
			depth++;
		}
		
	//	currentBlock = curBlock;
	//	trace("final depth: "+depth);
	}
	
	
	private function getStateContentBlock (stateName:String)
	{
		if (stateName == null || currentBlock == null)
			return;
		
		var stateList	: StatesListType	= (currentBlock.states != null) ? currentBlock.states : new StatesListType();
		var stateBlock	: UIElementStyle	= (stateList.exists( stateName )) ? stateList.get( stateName ) : new UIElementStyle( StyleDeclarationType.state );
		
		if (currentBlock.states == null)
			currentBlock.states = stateList;
		
		if (stateBlock != null)
		{
		//	stateBlock.parentStyle = currentBlock;
			currentBlock.states.set( stateName, stateBlock );
			currentBlock = stateBlock;
		}
	}
	
	
	/**
	 * Method to find all the style properties in one style block
	 */
	private function parseBlock (content:String) : Void
	{
	//	trace("parseBlock "+content);
		propExpr.matchAll(content, handleMatchedProperty);
	}
	
	
	/**
	 * Method to handle each matched property
	 */
	private function handleMatchedProperty (expr:EReg)
	{
		var name	= expr.matched(1).trim();
		var val		= expr.matched(2).trim();
	//	trace("handleMatchedProperty "+name+" = "+val);
		switch (name)
		{
			//
			// font properties
			//
			
			case "font":						parseAndSetFont(val);																		// [[ <font-style> || <font-weight> || <font-size> ]]? <font-family>
			case "font-size":					parseAndSetFontSize( val );																	//inherit, font-size
			case "font-family":					parseAndSetFontFamily( val );																//inherit, font-name
			case "color":						if (isColor(val)) { createFontBlock(); currentBlock.font.color = parseColor( val ); }		//inherit, color-values
			case "font-weight":					parseAndSetFontWeight( val );																//normal, bold, bolder, lighter
			case "font-style":					parseAndSetFontStyle( val );																//inherit, normal, italic, oblique
			case "letter-spacing":				createFontBlock();			currentBlock.font.letterSpacing	= parseUnitFloat( val );		//inherit, normal, [length]
			case "text-align":					createFontBlock();			currentBlock.font.align			= parseTextAlign( val );		//inherit, left, center, right, justify
			case "text-decoration":				createFontBlock();			currentBlock.font.decoration	= parseTextDecoration( val );	//inherit, none, underline
			case "text-indent":					createFontBlock();			currentBlock.font.indent		= parseUnitFloat( val );
			case "text-transform":				createFontBlock();			currentBlock.font.transform		= parseTextTransform( val );	//inherit, none, capitalize, uppercase, lowercase
			
			
			//
			// fill properties
			//
			
			case "background":					parseAndSetBackground( val );		// <background-color> <background-image>
			case "background-color":			parseAndSetBackgroundColor( val );	// #fff, 0xfff, #fffddd, 0xfff000, #ffddeeaa, 0xffddeeaa, rgba(255,255,255,0.9)
			case "background-image":			parseAndSetBackgroundImage( val );	// url( www.rubenw.nl/img.jpg ), class( package.of.Asset ) <background-repeat>
			
			
			//
			// border properties
			//
			
			case "border":						parseAndSetBorder( val );			// <border-color> <border-width> <border-image> <border-style>
			case "border-color":				parseAndSetBorderColor( val );
			case "border-image":
			case "border-image-source":			parseAndSetBorderImage( val );
			
		//	case "border-style":				parseAndSetBorderStyle( val );		//none, solid, dashed, dotted
			case "border-width":				parseAndSetBorderWidth( val );
			
			case "border-radius":				parseAndSetBorderRadius( val );		//[top-left]px <[top-right]px> <[bottom-right]px> <[bottom-left]px>
			case "border-top-left-radius":		setBorderTopLeftRadius( parseUnitFloat( val ) );
			case "border-top-right-radius":		setBorderTopRightRadius( parseUnitFloat( val ) );
			case "border-bottom-left-radius":	setBorderBottomLeftRadius( parseUnitFloat( val ) );
			case "border-bottom-right-radius":	setBorderBottomRightRadius( parseUnitFloat( val ) );
			
			
			case "shape":						parseAndSetShape( val );
			
			
			//
			// component properties
			//
			
			case "skin":						parseAndSetSkin( val ); // class(package.Class)
		//	case "cursor":			// auto, move, help, pointer, wait, text, n-resize, ne-resize, e-resize, se-resize, s-resize, sw-resize, w-resize, nw-resize, url(..)
			case "visibility":					parseAndSetVisibility( val );	// visible, hidden
			case "opacity":						parseAndSetOpacity( val );		// alpha value of entire element
		//	case "resize":			// horizontal / vertical / both / none;	/* makes a textfield resizable in the right bottom corner */	
			
		//	case "clip":		// auto, rect([t],[r],[b],[l])	--> specifies the area of an absolutly positioned box that should be visible == scrollrect size?
			case "overflow":					parseAndSetOverflow( val ); // visible, hidden, scroll-mouse-move, drag-scroll, corner-scroll, scrollbars
		
		
			// textfield properties
		//	case "word-wrap":					createFontBlock();				//normal / break-word
			case "text-wrap":					parseAndSetTextWrap( val ); 	//normal / suppress
			case "column-count":				parseAndSetColumnCount( val );	//int value
			case "column-gap":					parseAndSetColumnGap( val );	//unit value
			case "column-width":				parseAndSetColumnWidth( val );	//unit value
			
			
			//
			// iconing elements
			//
			
			case "icon":						parseAndSetIcon( val ); // @see background-image
			
			
			//
			// layout properties
			//
			
			case "width":						parseAndSetWidth( val );
			case "height":						parseAndSetHeight( val );
			case "min-width":					if (isUnitInt(val))	{ createLayoutBlock();		currentBlock.layout.minWidth		= parseUnitInt( val ); }
			case "min-height":					if (isUnitInt(val))	{ createLayoutBlock();		currentBlock.layout.minHeight		= parseUnitInt( val ); }
			case "max-width":					if (isUnitInt(val))	{ createLayoutBlock();		currentBlock.layout.maxWidth		= parseUnitInt( val ); }
			case "max-height":					if (isUnitInt(val))	{ createLayoutBlock();		currentBlock.layout.maxHeight		= parseUnitInt( val ); }
			
			case "child-width":					if (isUnitInt(val))	{ createLayoutBlock();		currentBlock.layout.childWidth		= parseUnitInt( val ); }
			case "child-height":				if (isUnitInt(val))	{ createLayoutBlock();		currentBlock.layout.childHeight		= parseUnitInt( val ); }
			
			case "relative":					parseAndSetRelativeProperties( val );			// [top]px <[right]px> <[bottom]px> <[left]px>
			case "left":						if (isUnitInt(val))	{ createRelativeBlock();	currentBlock.layout.relative.left	= parseUnitInt( val ); }
			case "right":						if (isUnitInt(val))	{ createRelativeBlock();	currentBlock.layout.relative.right	= parseUnitInt( val ); }
			case "top":							if (isUnitInt(val))	{ createRelativeBlock();	currentBlock.layout.relative.top	= parseUnitInt( val ); }
			case "bottom":						if (isUnitInt(val))	{ createRelativeBlock();	currentBlock.layout.relative.bottom	= parseUnitInt( val ); }
			case "h-center":					if (isUnitInt(val))	{ createRelativeBlock();	currentBlock.layout.relative.hCenter= parseUnitInt( val ); }
			case "v-center":					if (isUnitInt(val))	{ createRelativeBlock();	currentBlock.layout.relative.vCenter= parseUnitInt( val ); }
			
			case "position":					parseAndSetPosition(val);						//absolute and relative supported (=includeInLayout)
			case "algorithm":					parseAndSetLayoutAlgorithm(val);
		//	case "transform":					createLayoutBlock();		currentBlock.layout.transform		= parseTransform( val );	//scale( 0.1 - 2 ) / 	rotate( [x]deg ) translate( [x]px, [y]px ) skew( [x]deg, [y]deg )
		//	case "rotation":
		//	case "rotation-point":
		
			case "padding":						parseAndSetPadding( val );						// [top]px <[right]px> <[bottom]px> <[left]px>
			case "padding-top":					if (isUnitInt(val))	{ createPaddingBlock();		currentBlock.layout.padding.top		= parseUnitInt( val ); }
			case "padding-bottom":				if (isUnitInt(val))	{ createPaddingBlock();		currentBlock.layout.padding.bottom	= parseUnitInt( val ); }
			case "padding-right":				if (isUnitInt(val))	{ createPaddingBlock();		currentBlock.layout.padding.right	= parseUnitInt( val ); }
			case "padding-left":				if (isUnitInt(val))	{ createPaddingBlock();		currentBlock.layout.padding.left	= parseUnitInt( val ); }
			
			
			//
			// transition properties
			//
			
			case "move-transition":				parseAndSetMoveTransition( val );	// < effect( <duration>ms/s, <ease>, <delay>ms, reverted  ) | other-transition, ... > 
			case "resize-transition":			parseAndSetResizeTransition( val );
			case "rotate-transition":			parseAndSetRotateTransition( val );
			case "scale-transition":			parseAndSetScaleTransition( val );
			case "show-transition":				parseAndSetShowTransition( val );
			case "hide-transition":				parseAndSetHideTransition( val );
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
			
			case "box-bevel":					parseAndSetBoxBevel( val );			// ( <distance>px? <blurX>px? <blurY>px? <strength>? ) | <angle>deg? | ( <rgba-shadow>? | <rgba-highlight>? ) | <inner|outer|full>? | <knockout>? | <quality>?
			case "box-blur":					parseAndSetBoxBlur( val );			// <blurX>px? | <blurY>px? | <quality>?
			case "box-shadow":					parseAndSetBoxShadow( val );		// ( <distance>px? <blurX>px? <blurY>px? <strength>? ) | <angle>deg? | <rgba>? | <inner>? | <hide-object>? | <knockout>? | <quality>?
			case "box-glow":					parseAndSetBoxGlow( val );			// ( <blurX>px? <blurY>px? <strength>? ) | <rgba>? | <inner>? | <knockout>? | <quality>?
			case "box-gradient-bevel":			parseAndSetBoxGradientBevel( val );	// ( <distance>px? <blurX>px? <blurY>px? <strength>? ) | <angle>deg? | ( (<rgba> <pos>) (<rgba> <pos>).. ) | <inner>? | <knockout>? | <quality>?
			case "box-gradient-glow":			parseAndSetBoxGradientGlow( val );	// ( <distance>px? <blurX>px? <blurY>px? <strength>? ) | <angle>deg? | ( (<rgba> <pos>) (<rgba> <pos>).. ) | <inner>? | <knockout>? | <quality>?
			
			case "background-bevel":			parseAndSetBackgroundBevel( val );
			case "background-blur":				parseAndSetBackgroundBlur( val );
			case "background-shadow":			parseAndSetBackgroundShadow( val );
			case "background-glow":				parseAndSetBackgroundGlow( val );
			case "background-gradient-bevel":	parseAndSetBackgroundGradientBevel( val );
			case "background-gradient-glow":	parseAndSetBackgroundGradientGlow( val );
			
			
			
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


	private inline function createBoxFiltersBlock () : Void
	{
		if (currentBlock.boxFilters == null)
			currentBlock.boxFilters = new FilterStyleDeclarations( FilterCollectionType.box );
	}


	private inline function createBackgroundFiltersBlock () : Void
	{
		if (currentBlock.bgFilters == null)
			currentBlock.bgFilters = new FilterStyleDeclarations( FilterCollectionType.background );
	}
	
	
	private inline function createRelativeBlock () : Void
	{
		createLayoutBlock();
		if (currentBlock.layout.relative == null)
			currentBlock.layout.relative = new RelativeLayout();
	}
	
	
	private inline function createPaddingBlock () : Void
	{
		createLayoutBlock();
		if (currentBlock.layout.padding == null)
			currentBlock.layout.padding = new Box();
	}
	
	
	
	
	
	
	//
	// GENERAL UNIT CONVERSION / MATCH METHODS
	//
	
	
	
	private inline function getFloat (match:String) : Float
	{
		return (match == null) ? 0.0 : match.parseFloat();
	}
	
	
	private inline function getInt (match:String) : Int
	{
		return (match == null) ? 0 : match.parseInt();
	}
	
	
	/**
	 * Method to convert the given value to an int and convert the value 
	 * according to the unit.
	 */
	private inline function parseInt (v:String) : Int
	{
		return (v != null && isInt(v)) ? getInt( intValExpr.matched(1) ) : Number.INT_NOT_SET;
	}
	
	
	private inline function parseFloat (v:String) : Float
	{
		return (v != null && isFloat(v)) ? getFloat( floatValExpr.matched(1) ) : Number.FLOAT_NOT_SET;
	}
	
	
	private inline function parseUnitInt (v:String) : Int
	{
		var n = Number.INT_NOT_SET;
		if (v != null && isUnitInt(v))
			n = getInt( floatUnitValExpr.matched(3) );
		//	trace(floatUnitValExpr.resultToString(7));
		
		return n;
	}
	
	
	private inline function parseUnitFloat(v:String) : Float
	{
		var n = Number.FLOAT_NOT_SET;
		if (v != null && isUnitFloat(v))
			n = getFloat( floatUnitValExpr.matched(3) );
		//	trace(floatUnitValExpr.resultToString(7));
		
		return n;
	}
	
	
	private inline function parsePercentage (v:String) : Float
	{
		return (v != null && isPercentage(v)) ? getFloat( percValExpr.matched(3) ) : Number.FLOAT_NOT_SET;
	}
	
	
	private function parseIntPoint (v:String) : IntPoint
	{
		var p:IntPoint = null;
		if (v != null && pointExpr.match(v)) {
			p = new IntPoint(
				getInt( pointExpr.matched(3) ),
				getInt( pointExpr.matched(10) )
			);
		}
		return p;
	}
	
	
	private inline function parseAngle (v:String) : Float
	{
		var n = Number.FLOAT_NOT_SET;
		
	//	trace("parseAngle "+v);
		if (v != null && angleExpr.match(v)) {
			n = getFloat( angleExpr.matched(1) );
	//		trace(angleExpr.resultToString(4));
		}
		
		return n;
	}


	private inline function parseClassReference (v:String) : Class < Dynamic >
	{
		var c : Class<Dynamic> = null;
		if (isClassReference(v))
			c = cast classRefExpr.matched(2).resolveClass();

		return c;
	}
	
	
	
	
	private inline function isInt (v:String)				: Bool		{ return intValExpr.match(v); }
	private inline function isFloat (v:String)				: Bool		{ return floatValExpr.match(v); }
	private inline function isUnitInt (v:String)			: Bool		{ return floatUnitValExpr.match(v) && floatUnitValExpr.matched(1) != null; }
	private inline function isUnitFloat (v:String)			: Bool		{ return floatUnitValExpr.match(v) && floatUnitValExpr.matched(1) != null; }
	private inline function isPercentage (v:String)			: Bool		{ return percValExpr.match(v); }
	private inline function isColor (v:String)				: Bool		{ return v.trim().toLowerCase() != "inherit" && colorValExpr.match(v); }
	private inline function isAngle (v:String)				: Bool		{ return angleExpr.match(v); }
	private inline function isClassReference (v:String) 	: Bool		{ return v != null && classRefExpr.match(v); }
	
	private inline function removeInt (v:String)			: String	{ return intValExpr.removeMatch(v); }
	private inline function removeFloat (v:String)			: String	{ return floatValExpr.removeMatch(v); }
	private inline function removeUnitInt (v:String)		: String	{ return floatUnitValExpr.removeMatch(v); }
	private inline function removeUnitFloat (v:String)		: String	{ return floatUnitValExpr.removeMatch(v); }
	private inline function removePercentage (v:String)		: String	{ return percValExpr.removeMatch(v); }
	private inline function removeColor (v:String)			: String	{ return colorValExpr.removeMatch(v); }
	private inline function removeAngle (v:String)			: String	{ return angleExpr.removeMatch(v); }
	private inline function removeClassReference (v:String) : String	{ return classRefExpr.removeMatch(v); }
	
	
	
	/**
	 * Method parses a color value like #aaa000 or 0xaaa000 to a RGBA value
	 * If the value is 'inherit', the method will return null.
	 */
	private function parseColor (v:String) : Null < RGBA >
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
				var alpha = getFloat( colorValExpr.matched(9) ).uint();
				
				clr = Color.create(getInt( colors[0] ), getInt( colors[1] ), getInt( colors[2] ), alpha);
			}
		}
		
		return clr;
	}
	
	
	private inline function parseDirection (v:String) : Direction
	{
		return v == null ? null : switch (v.trim().toLowerCase()) {
			default:			Direction.horizontal;
			case "vertical":	Direction.vertical;
		}
	}
	
	
	private inline function parseHorDirection (v:String) : Horizontal
	{
		return v == null ? null : switch (v.trim().toLowerCase()) {
			default:		Horizontal.left;
			case "center":	Horizontal.center;
			case "right":	Horizontal.right;
		}
	}


	private inline function parseVerDirection (v:String) : Vertical
	{
		return v == null ? null : switch (v.trim().toLowerCase()) {
			default:		Vertical.top;
			case "center":	Vertical.center;
			case "bottom":	Vertical.bottom;
		}
	}
	
	
	private inline function parsePosition (v:String) : Position
	{
		return v == null ? null : switch (v.trim().toLowerCase()) {
			case "top-left":		Position.TopLeft;
			case "top-center":		Position.TopCenter;
			case "top-right":		Position.TopRight;
			case "middle-left":		Position.MiddleLeft;
			case "middle-center":	Position.MiddleCenter;
			case "middle-right":	Position.MiddleRight;
			case "bottom-left":		Position.BottomLeft;
			case "bottom-center":	Position.BottomCenter;
			case "bottom-right":	Position.BottomRight;
			default:				Position.Custom( parseIntPoint(v) );
		}
	}
	
	
	private inline function parseMoveDirection (v:String) : MoveDirection
	{
		return v == null ? null : switch (v.trim().toLowerCase()) {
			default:				MoveDirection.TopToBottom;
			case "top-to-bottom":	MoveDirection.TopToBottom;
			case "bottom-to-top":	MoveDirection.BottomToTop;
			case "left-to-right":	MoveDirection.LeftToRight;
			case "right-to-left":	MoveDirection.RightToLeft;
		}
	}
	
	
	





	//
	// FONT METHODS
	//
	
	
	private function parseAndSetFont (v:String) : Void
	{	
		v = parseAndSetFontStyle(v);
		v = parseAndSetFontWeight(v);
		v = parseAndSetFontSize(v);
		v = parseAndSetFontFamily(v);
	}
	
	
	private function parseAndSetFontSize (val:String) : String
	{
		var v = parseUnitInt( val );
		if (v.isSet()) {
			createFontBlock();
			currentBlock.font.size = v;
			val = floatUnitValExpr.replace(val, "");
		}
		return val;
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
	
	
	/**
	 * @see		http://www.w3.org/TR/CSS2/fonts.html#propdef-font-family
	 * @return 	val without the matched font-family
	 */
	private inline function parseAndSetFontFamily (val:String) : String
	{
		var isFam	= fontFamilyExpr.match(val);
		var fam		= "";
		
		//make sure the font-family doesn't match font-weight or font-style properties
		if (isFam) {
			fam		= fontFamilyExpr.matched(4) != null ? fontFamilyExpr.matched(5) : fontFamilyExpr.matched(1);
			isFam	= !fontWeightExpr.match(fam) && !fontStyleExpr.match(fam);
		}
		
		if (isFam) {
			createFontBlock();
			currentBlock.font.family = fam;
			val = val.replace(fam, "");
		}
		return val;
	}

	
	/**
	 * Matches the font-weight in the given string and sets it in the font
	 * style property of the current block.
	 * Method will return the input-string without the mathed weight.
	 */
	private inline function parseAndSetFontWeight (v:String) : String
	{
		if (fontWeightExpr.match(v))
		{
			createFontBlock();
			currentBlock.font.weight = 
				switch (fontWeightExpr.matched(1).toLowerCase()) {
					default:		FontWeight.normal;
					case "bold":	FontWeight.bold;
					case "bolder":	FontWeight.bolder;
					case "lighter":	FontWeight.lighter;
					case "inherit":	null;
				}
			
			v = fontWeightExpr.removeMatch(v);
		}
		return v;
	}

	
	/**
	 * Matches the font-style in the given string and sets it in the font
	 * style property of the current block.
	 * Method will return the input-string without the mathed style.
	 */
	private inline function parseAndSetFontStyle (v:String) : String
	{
		if (fontStyleExpr.match(v))
		{
			createFontBlock();
			currentBlock.font.style =
			 	switch (fontStyleExpr.matched(1).toLowerCase()) {
					default:		FontStyle.normal;
					case "italic":	FontStyle.italic;
					case "oblique":	FontStyle.oblique;
					case "inherit":	null;
				}
			
			v = fontStyleExpr.removeMatch(v);
		}
		return v;
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
	
	
	/**
	 * @see http://www.w3.org/TR/css3-text/#text-wrap
	 */
	private inline function parseAndSetTextWrap (v:String) : Void
	{
		createFontBlock();
		currentBlock.font.textWrap = switch (v.trim().toLowerCase()) {
			default:			null;
			case "normal":		false;
			case "suppress":	true;
			case "inherit":		null;
		}
	}
	
	
	/**
	 * 
	 */
	private inline function parseAndSetColumnCount (v:String) : Void
	{
		if (isInt(v))
		{
			createFontBlock();
			currentBlock.font.columnCount = parseInt(v);
		}
	}
	
	
	/**
	 * 
	 */
	private inline function parseAndSetColumnGap (v:String) : Void
	{
		if (isUnitInt(v))
		{
			createFontBlock();
			currentBlock.font.columnGap = parseUnitInt(v);
		}
	}
	
	
	/**
	 * 
	 */
	private inline function parseAndSetColumnWidth (v:String) : Void
	{
		if (isUnitInt(v))
		{
			createFontBlock();
			currentBlock.font.columnWidth = parseUnitInt(v);
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
	private function setBackground(newFill:IFill) : Void
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
				compFill.add( curFill );
				compFill.add( newFill );
				
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

		//	if (currentBlock.background != null)
		//		setDefaultShape();
		}
	}
	
	
	private inline function parseAndSetBackground (v:String) : Void
	{
		parseAndSetBackgroundColor( v );
		parseAndSetBackgroundImage( v );
	}
	
	
	private inline function parseAndSetBackgroundColor (v:String) : Void	{ setBackground( parseColorFill( v ) ); }
	private inline function parseAndSetBackgroundImage (v:String) : Void	{ setBackground( parseImage( v ) ); }
	
	
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
	private function parseColorFill (v:String) : IFill
	{
		var fill:IFill = null;
		
		var isLinearGr	= linGradientExpr.match(v);
		var isRadialGr	= !isLinearGr && radGradientExpr.match(v);
		
		if (isLinearGr || isRadialGr)
		{
			var gradientExpr	= isLinearGr ? linGradientExpr : radGradientExpr;
			var type			= isLinearGr ? GradientType.linear : GradientType.radial;
			var colorsStr		= gradientExpr.matched(4);
			var focalPoint		= isLinearGr ? 0 : getInt( gradientExpr.matched(2) );
			var degr			= isRadialGr ? 0 : getInt( gradientExpr.matched(3) );
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
						pos = getInt( gradientColorExpr.matched(16) );
					}
					else if (gradientColorExpr.matched(20) != null)	{
						//match percent value
						var a = getFloat( gradientColorExpr.matched(21) );
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
		else if (isColor(v))
		{
			fill = new SolidFill(parseColor(v));
		}
		
		return fill;
	}
	
	
	private function parseBitmap (v:String) : Bitmap
	{
		var bmp:Bitmap	= null;
		
		if (imageURIExpr.match(v))
		{
			bmp = new Bitmap();
			bmp.setString( (getBasePath() + "/" + imageURIExpr.matched(2)).replace("//", "/") );
		}
		else if (isClassReference(v))
		{
			bmp = new Bitmap();
			bmp.setClass( parseClassReference(v) );
		}
		
		return bmp;
	}
	
	
	private function parseImage (v:String) : IFill
	{
		var fill:IFill	= null;
		var bmp:Bitmap	= parseBitmap(v);
		if (bmp != null)
			fill = new BitmapFill( bmp, null, parseRepeatImage(v), false );
		
		return fill;
	}
	
	
	private inline function parseRepeatImage (v:String) : Bool
	{
		var repeatStr = "";
		
		if (v != null && imageRepeatExpr.match(v))
			repeatStr = imageRepeatExpr.matched(1);
		
		return switch (repeatStr.trim().toLowerCase()) {
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
	// SHAPE METHODS
	//
	
	
	/**
	 * Method to make sure that the shape property isn't empty. If there's no
	 * shape defined but there is a background or border, the shape proeprty
	 * will be filled with a regular-rectangle.
	 */
	/*private function setDefaultShape ()
	{
		if (currentBlock.shape == null)
			currentBlock.shape = new RegularRectangle();
	}*/
	
	
	private inline function parseAndSetShape (v:String) : Void
	{
		v = v.trim().toLowerCase();
		
		var shape:IGraphicShape = switch (v) {
			case "line":		cast new Line();
			case "circle":		cast new Circle();
			case "ellipse":		cast new Ellipse();
			case "rectangle":	cast new RegularRectangle();
			default:			null;
		}
		
		//try matching triangle shape..
		if (shape == null && triangleExpr.match(v))
			shape = new Triangle( parsePosition( triangleExpr.matched(2) ) );
		
		currentBlock.shape = shape;
	}
	
	
	
	
	//
	// BORDER METHODS
	//
	
	
	private inline function parseAndSetBorder (v:String) : Void
	{
		parseAndSetBorderColor(v);
		parseAndSetBorderImage(v);
		parseAndSetBorderWidth(v);
	}
	
	
	private inline function parseAndSetBorderImage (v:String) : Void	{ setBorderFill( parseImage( v ) ); }
	private inline function parseAndSetBorderColor (v:String) : Void	{ setBorderFill( parseColorFill( v ) ); }
	private inline function parseAndSetBorderWidth (v:String) : Void	{ setBorderWidth( parseUnitFloat( v ) ); }
	
	
	private function setBorderFill (newFill:IFill) : Void
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
#if debug		else	throw "Fill type: "+Std.string(newFill)+" not supported for border";	#end
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
			
		//	if (t.border != null)
		//		setDefaultShape();
		}
	}
	
	
	private function setBorderWidth (weight:Float) : Void
	{
		if (currentBlock.border != null)
			currentBlock.border.weight = weight;
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
	
	
	/**
	 * Parses the border-radius with max 4 values:
	 * 		1. top-left
	 * 		2. top-right
	 * 		3. bottom-right
	 * 		4. bottom-left
	 * 
	 * If bottom-left is omitted, bottom-left will be equal to top-right.
	 * 		1. top-left
	 * 		2. top-right 		= bottom-left
	 * 		3. bottom-right
	 * 
	 * If bottom-right is ommited as well, bottom-right will be equal to top-left.
	 * 		1. top-left 		= bottom-right
	 * 		2. top-right 		= bottom-left
	 * 
	 * If top-right is ommitted as well, top-right will be equal to top-left.
	 * 		1. top-left 		= top-right = bottom-right = bottom-left
	 * 
	 * Border radius does not yet support different values for horizontal and 
	 * vertical radius.
	 * 
	 * @see http://www.w3.org/TR/css3-background/#the-border-radius
	 */
	private function parseAndSetBorderRadius (v:String) : Void
	{
		var expr = floatUnitGroupValExpr;
		
		if (expr.match(v))
		{
			if (currentBlock.shape != null && currentBlock.shape.is(RegularRectangle))
			{
				var shape = currentBlock.shape.as(RegularRectangle);
				
				var topLeft		= getFloat( expr.matched(3) );
				var topRight	= expr.matched( 8) != null ? getFloat( expr.matched(10) ) : topLeft;
				var bottomRight	= expr.matched(15) != null ? getFloat( expr.matched(17) ) : topLeft;
				var bottomLeft	= expr.matched(22) != null ? getFloat( expr.matched(24) ) : topRight;
				
				if (shape.corners == null)
				{
					shape.corners = new Corners( topLeft, topRight, bottomRight, bottomLeft );
				}
				else
				{
					shape.corners.topLeft		= topLeft;
					shape.corners.topRight		= topRight;
					shape.corners.bottomRight	= bottomRight;
					shape.corners.bottomLeft	= bottomLeft;
				}
			}
		}
	}
	
	
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
	
	
	
	//
	// LAYOUT METHODS
	//
	
	
	private function isAutoSize (v:String) : Bool
	{
		return v.trim().toLowerCase() == "auto";
	}
	
	
	/**
	 * Method will parse the given width and set the value in the layout object.
	 * Parsing is done in a separate method since the with can be a 
	 * percent-value and an absolute value. In the LayoutObject these two 
	 * values are stored in two different variables.
	 */
	private function parseAndSetWidth (v:String) : Void
	{
		var w:Int = parseUnitInt(v);
		
		if (w.isSet())
		{
			createLayoutBlock();
			currentBlock.layout.width = w;
		}
		else
		{
			var pw:Float = isAutoSize(v) ? LayoutFlags.FILL : parsePercentage(v);
			if (pw.isSet())
			{
				createLayoutBlock();
				currentBlock.layout.percentWidth = pw;
			}
		}
	}
	
	
	/**
	 * Method will parse the given height and set the value in the layout object.
	 * Parsing is done in a separate method since the with can be a 
	 * percent-value and an absolute value. In the LayoutObject these two 
	 * values are stored in two different variables.
	 */
	private function parseAndSetHeight (v:String) : Void
	{
		var h:Int = isAutoSize(v) ? LayoutFlags.FILL : parseUnitInt(v);
		if (h.isSet())
		{
			createLayoutBlock();
			currentBlock.layout.height = h;
		}
		else
		{
			var ph:Float = parsePercentage(v);
			if (ph.isSet())
			{
				createLayoutBlock();
				currentBlock.layout.percentHeight = ph;
			}
		}
	}
	
	
	/**
	 * Parses the padding with max 4 values:
	 * 		1. top
	 * 		2. right
	 * 		3. bottom
	 * 		4. left
	 * 
	 * If left is omitted, left will be equal to right.
	 * 		1. top
	 * 		2. right	= left
	 * 		3. bottom
	 * 
	 * If bottom is ommited as well, bottom will be equal to top.
	 * 		1. top 		= bottom
	 * 		2. right	= left
	 * 
	 * If right is ommitted as well, right will be equal to top.
	 * 		1. top 		= right = bottom = left
	 * 
	 * @see http://www.w3.org/TR/CSS2/box.html#padding-properties
	 */
	private function parseAndSetPadding (v:String) : Void
	{
		var expr = floatUnitGroupValExpr;
		
		if (expr.match(v))
		{
			createLayoutBlock();
			
			var top		= getInt( expr.matched(3) );
			var right	= expr.matched( 8) != null ? getInt( expr.matched(10) ) : top;
			var bottom	= expr.matched(15) != null ? getInt( expr.matched(17) ) : top;
			var left	= expr.matched(22) != null ? getInt( expr.matched(24) ) : right;
			
			if (currentBlock.layout.padding == null)
			{
				currentBlock.layout.padding = new Box( top, right, bottom, left );
			}
			else
			{
				var p		= currentBlock.layout.padding;
				p.top		= top;
				p.right		= right;
				p.bottom	= bottom;
				p.left		= left;
			}
		}
	}
	
	
	
	/**
	 * @see CSSParser.parseAndSetPadding
	 */
	private function parseAndSetRelativeProperties (v:String) : Void
	{
		var expr = floatUnitGroupValExpr;
		
		if (expr.match(v))
		{
			createLayoutBlock();
			
			var top		= getInt( expr.matched(3) );
			var right	= expr.matched( 8) != null ? getInt( expr.matched(10) ) : Number.INT_NOT_SET; //top;
			var bottom	= expr.matched(15) != null ? getInt( expr.matched(17) ) : Number.INT_NOT_SET; //top;
			var left	= expr.matched(22) != null ? getInt( expr.matched(24) ) : Number.INT_NOT_SET; //right;
			
			if (currentBlock.layout.relative == null)
			{
				currentBlock.layout.relative = new RelativeLayout( top, right, bottom, left );
			}
			else
			{
				var r		= currentBlock.layout.relative;
				r.top		= top;
				r.right		= right;
				r.bottom	= bottom;
				r.left		= left;
			}
		}
	}
	
	
	private inline function parseAndSetPosition (v:String) : Void
	{
		v = v.trim().toLowerCase();
		
		if (v == "absolute" || v == "relative")
		{
			createLayoutBlock();
			currentBlock.layout.includeInLayout = v == "relative";
		}
	}
	
	
	/**
	 * Checks if the given string contains a layout algorithm and parses the
	 * properties of the algorithm to a algorithm instance.
	 * If an algorithm is found, the value will be set in 
	 * LayoutStyleDeclarations.algorithm.
	 * 
	 * Supported algorithms are:
	 * 		+ float-hor ( [[ direction ]], [[ ver-pos ]]? )			(ver-pos defines how the children should be positioned vertical)
	 * 		+ float-ver ( [[ direction ]], [[ hor-pos ]]? )			(hor-pos defines how the children should be positioned horizontal)
	 * 		+ float ( [[ hor-dir ]], [[ ver-dir ]] )
	 * 		
	 * 		+ circle ( [[ hor-dir ]], [[ ver-dir ]] )				(circle will always keep the same width and height dimensions)
	 * 		+ ellipse ( [[ hor-dir ]], [[ ver-dir ]] )				(ellipse will use the width and the height of the target object)
	 * 		+ hor-circle (( [[ direction ]], [[ ver-pos ]]? ))
	 * 		+ ver-circle (( [[ direction ]], [[ hor-pos ]]? ))
	 * 		+ hor-ellipse (( [[ direction ]], [[ ver-pos ]]? ))
	 * 		+ ver-ellipse (( [[ direction ]], [[ hor-pos ]]? ))
	 * 		
	 * 		+ dynamic( [[ hor-algorithm ]], [[ ver-algorithm ]] )
	 * 		+ relative
	 * 
	 * 		+ dynamic-tile ( [[ start-direction ]], [[ hor-dir]]?, [[ ver-dir ]]? )
	 * 		+ fixed-tile ( [[ start-direction ]], [[ rows/columns ]], [[ hor-dir]]?, [[ ver-dir ]]? )
	 * 		
	 * 		+ inherit
	 * 		+ none
	 */
	private function parseAndSetLayoutAlgorithm (v:String) : Void
	{
		var algorithm:ILayoutAlgorithm = null;
		var v = v.trim().toLowerCase();
		
		if		(v == "relative")			algorithm = new RelativeAlgorithm ();
		else if	(v == "none")				algorithm = null;						//FIXME -> none and inherit are the same now. none is not implemented yet..
		else if	(v == "inherit")			algorithm = null;
		
		//
		// match floating layout
		//
		
		else if (floatHorExpr.match(v))		algorithm = new HorizontalFloatAlgorithm ( parseHorDirection( floatHorExpr.matched(2) ), parseVerDirection( floatHorExpr.matched(4) ) );
		else if (floatVerExpr.match(v))		algorithm = new VerticalFloatAlgorithm ( parseVerDirection( floatVerExpr.matched(2) ), parseHorDirection( floatVerExpr.matched(4) ) );
		else if (floatExpr.match(v))		algorithm = new DynamicLayoutAlgorithm (
			new HorizontalFloatAlgorithm ( parseHorDirection( floatExpr.matched(2) ) ), 
			new VerticalFloatAlgorithm ( parseVerDirection( floatExpr.matched(4) ) )
		);
		
		//
		//match circle layout
		//
		
		else if (horCircleExpr.match(v))	algorithm = new HorizontalCircleAlgorithm ( parseHorDirection( horCircleExpr.matched(2) ), parseVerDirection( horCircleExpr.matched(4) ), false );
		else if (verCircleExpr.match(v))	algorithm = new VerticalCircleAlgorithm ( parseVerDirection( verCircleExpr.matched(2) ), parseHorDirection( verCircleExpr.matched(4) ), false );
		else if (circleExpr.match(v))		algorithm = new DynamicLayoutAlgorithm (
			new HorizontalCircleAlgorithm ( parseHorDirection( circleExpr.matched(2) ), null, false ), 
			new VerticalCircleAlgorithm ( parseVerDirection( circleExpr.matched(4) ), null, false )
		);
		
		//
		//match ellipse layout
		//
		
		else if (horEllipseExpr.match(v))	algorithm = new HorizontalCircleAlgorithm ( parseHorDirection( horEllipseExpr.matched(2) ), parseVerDirection( horEllipseExpr.matched(4) ) );
		else if (verEllipseExpr.match(v))	algorithm = new VerticalCircleAlgorithm ( parseVerDirection( verEllipseExpr.matched(2) ), parseHorDirection( verEllipseExpr.matched(4) ) );
		else if (ellipseExpr.match(v))		algorithm = new DynamicLayoutAlgorithm (
			new HorizontalCircleAlgorithm ( parseHorDirection( horEllipseExpr.matched(2) ) ), 
			new VerticalCircleAlgorithm ( parseVerDirection( horEllipseExpr.matched(4) ) )
		);
		
		//
		//match dynamic
		//
		
		
		//
		// tile layouts
		//
		
		else if (dynamicTileExpr.match(v))
		{
			if (dynamicTileExpr.matched(1) == null)
				algorithm = new DynamicTileAlgorithm();
			else
			{
				var tileAlg = new DynamicTileAlgorithm( parseDirection( dynamicTileExpr.matched( 3 ) ) );
				if (dynamicTileExpr.matched( 5 ) != null)	tileAlg.horizontalDirection	= parseHorDirection( dynamicTileExpr.matched( 5 ) );
				if (dynamicTileExpr.matched( 7 ) != null)	tileAlg.verticalDirection	= parseVerDirection( dynamicTileExpr.matched( 7 ) );
				algorithm = tileAlg;
			}
		}
		else if (fixedTileExpr.match(v))
		{
			if (fixedTileExpr.matched(1) == null)
				algorithm = new FixedTileAlgorithm();
			else
			{
				var tileAlg = new FixedTileAlgorithm( parseDirection( fixedTileExpr.matched( 2 ) ) );
				if (fixedTileExpr.matched( 4 ) != null)		tileAlg.maxTilesInDirection	= getInt( fixedTileExpr.matched( 4 ) );
				if (fixedTileExpr.matched( 6 ) != null)		tileAlg.horizontalDirection	= parseHorDirection( fixedTileExpr.matched( 6 ) );
				if (fixedTileExpr.matched( 8 ) != null)		tileAlg.verticalDirection	= parseVerDirection( fixedTileExpr.matched( 8 ) );
				algorithm = tileAlg;
			}
		}
		
		
		//insert the found algorithm in the layout-style-block
		if (algorithm != null)
		{
			createLayoutBlock();
			currentBlock.layout.algorithm = algorithm;
		}
	}
	
	
	
	
	
	
	//
	// FILTER METHODS
	//
	
	
	private function parseFilterType (v:String) : BitmapFilterType
	{
		return switch (v.toLowerCase()) {
			default:		BitmapFilterType.INNER;
			case "inner":	BitmapFilterType.INNER;
			case "outer":	BitmapFilterType.OUTER;
			case "full":	BitmapFilterType.FULL;
		};
	}
	
	
	
	
	/**
	 * Matches and creates a bevel-filter.
	 * The first found color is used as hightlight color, the second (if any) as shadow color.
	 *  
	 * Syntax:
	 * ( <distance>px? <blurX>px? <blurY>px? <strength>? ) | <angle>deg? | ( <rgba-shadow>? | <rgba-highlight>? ) | <inner|outer|full>? | <knockout>? | <quality>?
	 */
	private function parseBevelFilter (v:String) : BevelFilter
	{
		var f = new BevelFilter();
		var isValid = false;
		
		//match rotation
		if (isAngle(v))
		{
			f.angle	= parseAngle(v);
			isValid	= true;
			v		= removeAngle(v);
		}
		
		//match highlight-color and highlight-alpha
		if (isColor(v))
		{
			var c				= parseColor(v);
			f.highlightColor	= c.rgb();
			f.highlightAlpha	= c.alpha().float();
			isValid				= true;
			v					= removeColor(v);
		}

		//match shadow-color and shadow-alpha
		if (isColor(v))
		{
			var c			= parseColor(v);
			f.shadowColor	= c.rgb();
			f.shadowAlpha	= c.alpha().float();
			isValid			= true;
			v				= removeColor(v);
		}
		
		//match distance
		if (isUnitFloat(v))
		{
			f.distance	= parseUnitFloat(v);
			isValid		= true;
			v = removeUnitFloat(v);
		}
		
		//match blur
		if (filterBlurExpr.match(v))
		{
			f.blurX	= getFloat( filterBlurExpr.matched(3) );
			f.blurY	= getFloat( filterBlurExpr.matched(10) );
			isValid	= true;
			v		= filterBlurExpr.removeMatch(v);
		}
		
		//match strength
		if (isInt(v))
		{
			f.strength	= parseInt(v);
			isValid		= true;
			v			= removeInt(v);
		}
		
		//match filter type
		if (filterTypeExpr.match(v))
		{
			var tStr	= filterTypeExpr.matched(1);
			f.type		= parseFilterType(tStr); 
			isValid		= true;
			v			= filterTypeExpr.removeMatch(v);
		}
		
		//match knockout bool
		if (filterKnockoutExpr.match(v))
		{
			f.knockout	= true;
			isValid		= true;
			v			= filterKnockoutExpr.removeMatch(v);
		}
		
		//match quality flag
		if (filterQualityExpr.match(v))
		{
			var qStr	= filterQualityExpr.matched(1);
			isValid		= true;
			f.quality	= switch (qStr.toLowerCase()) {
				default:		1;
				case "low":		1;
				case "medium":	2;
				case "high":	3;
			}
			v = filterQualityExpr.removeMatch(v);
		}
		
		return isValid ? f : null;
	}

	
	/**
	 * Syntax:
	 * <blurX>px? | <blurY>px? | <quality>?
	 */
	private function parseBlurFilter (v:String) : BlurFilter
	{
		var f = new BlurFilter();
		var isValid = false;
		
		//match blur
		if (filterBlurExpr.match(v))
		{
			f.blurX	= getFloat( filterBlurExpr.matched(3) );
			f.blurY	= getFloat( filterBlurExpr.matched(10) );
			isValid	= true;
			v		= filterBlurExpr.removeMatch(v);
		}
		
		//match quality flag
		if (filterQualityExpr.match(v))
		{
			var qStr	= filterQualityExpr.matched(1);
			isValid		= true;
			f.quality	= switch (qStr.toLowerCase()) {
				default:		1;
				case "low":		1;
				case "medium":	2;
				case "high":	3;
			}
			v = filterQualityExpr.removeMatch(v);
		}
		
		return isValid ? f : null;
	}
	


	/**
	 * Matches the shadow values for a drop-shadow filter.
	 * Can't use the CSS3 standard here since flash uses completly different properties.
	 * 
	 * Syntax:
	 * ( <distance>px? <blurX>px? <blurY>px? <strength>? ) | <angle>deg? | <rgba>? | <inner>? | <hide-object>? | <knockout>? | <quality>?
	 */
	private function parseShadowFilter (v:String) : DropShadowFilter
	{
		var f = new DropShadowFilter();
		var isValid = false;
		
		//match rotation
		if (isAngle(v))
		{
			f.angle	= parseAngle(v);
			isValid	= true;
			v		= removeAngle(v);
		}
		
		//match color and alpha
		if (isColor(v))
		{
			var c	= parseColor(v);
			f.color	= c.rgb();
			f.alpha	= c.alpha().float();
			isValid	= true;
			v		= removeColor(v);
		}
		
		//match distance
		if (isUnitFloat(v))
		{
			f.distance	= parseUnitFloat(v);
			isValid		= true;
			v = removeUnitFloat(v);
		}
		
		//match blur
		if (filterBlurExpr.match(v))
		{
			f.blurX	= getFloat( filterBlurExpr.matched(3) );
			f.blurY	= getFloat( filterBlurExpr.matched(10) );
			isValid	= true;
			v		= filterBlurExpr.removeMatch(v);
		}
		
		//match strength
		if (isInt(v))
		{
			f.strength	= parseInt(v);
			isValid		= true;
			v			= removeInt(v);
		}
		
		//match inner bool
		if (filterInnerExpr.match(v))
		{
			f.inner	= true;
			isValid	= true;
			v		= filterInnerExpr.removeMatch(v);
		}
		
		//match hide bool
		if (filterHideExpr.match(v))
		{
			f.hideObject= true;
			isValid		= true;
			v			= filterHideExpr.removeMatch(v);
		}
		
		//match knockout bool
		if (filterKnockoutExpr.match(v))
		{
			f.knockout	= true;
			isValid		= true;
			v			= filterKnockoutExpr.removeMatch(v);
		}
		
		//match quality flag
		if (filterQualityExpr.match(v))
		{
			var qStr	= filterQualityExpr.matched(1);
			isValid		= true;
			f.quality	= switch (qStr.toLowerCase()) {
				default:		1;
				case "low":		1;
				case "medium":	2;
				case "high":	3;
			}
			v = filterQualityExpr.removeMatch(v);
		}
		
		return isValid ? f : null;
	}
	
	
	/**
	 * Syntax:
	 * ( <blurX>px? <blurY>px? <strength>? ) | <rgba>? | <inner>? | <knockout>? | <quality>?
	 */
	private function parseGlowFilter (v:String) : GlowFilter
	{
		var f = new GlowFilter();
		var isValid = false;
		
		//match color and alpha
		if (isColor(v))
		{
			var c	= parseColor(v);
			f.color	= c.rgb();
			f.alpha	= c.alpha().float();
			isValid	= true;
			v		= removeColor(v);
		}
		
		//match blur
		if (filterBlurExpr.match(v))
		{
			f.blurX	= getFloat( filterBlurExpr.matched(3) );
			f.blurY	= getFloat( filterBlurExpr.matched(10) );
			isValid	= true;
			v		= filterBlurExpr.removeMatch(v);
		}
		
		//match strength
		if (isInt(v))
		{
			f.strength	= parseInt(v);
			isValid		= true;
			v			= removeInt(v);
		}
		
		//match inner bool
		if (filterInnerExpr.match(v))
		{
			f.inner	= true;
			isValid	= true;
			v		= filterInnerExpr.removeMatch(v);
		}
		
		//match knockout bool
		if (filterKnockoutExpr.match(v))
		{
			f.knockout	= true;
			isValid		= true;
			v			= filterKnockoutExpr.removeMatch(v);
		}
		
		//match quality flag
		if (filterQualityExpr.match(v))
		{
			var qStr	= filterQualityExpr.matched(1);
			isValid		= true;
			f.quality	= switch (qStr.toLowerCase()) {
				default:		1;
				case "low":		1;
				case "medium":	2;
				case "high":	3;
			}
			v = filterQualityExpr.removeMatch(v);
		}
		
		return isValid ? f : null;
	}
	
	
	/**
	 * Syntax:
	 *  ( <distance>px? <blurX>px? <blurY>px? <strength>? ) | <angle>deg? | ( (<rgba> <pos>) (<rgba> <pos>).. ) | <inner>? | <knockout>? | <quality>?
	 */
	private function parseGradientBevelFilter (v:String, f:GradientBevelFilter = null) : GradientBevelFilter
	{
		if (f == null)
			f = new GradientBevelFilter();
		
		var isValid = false;
		
		//match rotation
		if (isAngle(v))
		{
			f.angle	= parseAngle(v);
			isValid	= true;
			v		= removeAngle(v);
		}
		
		//match colors, ratios and alphas
		while (true)
		{
			if ( !gradientColorExpr.match(v) )
				break;
			
			var pos = -1;
			//match px,pt,em etc value
			if (gradientColorExpr.matched(16) != null)
				pos = getInt( gradientColorExpr.matched(16) );
			
			//match percent value
			else if (gradientColorExpr.matched(20) != null)	{
				var a = getFloat( gradientColorExpr.matched(21) );
				pos = ((a / 100) * 255).int();
			}
			
			var c = gradientColorExpr.matched(4).rgba();
			f.colors.push( c.rgb() );
			f.alphas.push( c.alpha().float() );
			f.ratios.push( pos );
			
			v = removeColor(v);
		}
		
		if (f.colors.length > 0)
		{
			//make sure that all ratios values are set
			var stepSize	= 255 / (f.ratios.length - 1);
			for (i in 0...f.ratios.length)
				if (f.ratios[i] == -1)
					f.ratios[i] = (stepSize * i).int();
		}
		
		isValid	= f.colors.length > 1;
		
		//match distance
		if (isValid && isUnitFloat(v))
		{
			f.distance = parseUnitFloat(v);
			v = removeUnitFloat(v);
		}
		
		//match blur
		if (isValid && filterBlurExpr.match(v))
		{
			f.blurX	= getFloat( filterBlurExpr.matched(3) );
			f.blurY	= getFloat( filterBlurExpr.matched(10) );
			v		= filterBlurExpr.removeMatch(v);
		}
		
		//match strength
		if (isValid && isInt(v))
		{
			f.strength	= parseInt(v);
			v			= removeInt(v);
		}
		
		//match filter type
		if (isValid && filterTypeExpr.match(v))
		{
			var tStr	= filterTypeExpr.matched(1);
			f.type		= parseFilterType(tStr); 
			v			= filterTypeExpr.removeMatch(v);
		}
		
		//match knockout bool
		if (isValid && filterKnockoutExpr.match(v))
		{
			f.knockout	= true;
			v			= filterKnockoutExpr.removeMatch(v);
		}
		
		//match quality flag
		if (isValid && filterQualityExpr.match(v))
		{
			var qStr	= filterQualityExpr.matched(1);
			f.quality	= switch (qStr.toLowerCase()) {
				default:		1;
				case "low":		1;
				case "medium":	2;
				case "high":	3;
			}
			v = filterQualityExpr.removeMatch(v);
		}
		
		return isValid ? f : null;
	}
	
	
	/**
	 * @see CSSParser.parseGradientBevelFilter
	 */
	private function parseGradientGlowFilter (v:String) : GradientGlowFilter
	{
		return cast parseGradientBevelFilter( v, new GradientGlowFilter() );
	}
	
	
	
	//
	// BOX FILTERS
	//
	
	private function parseAndSetBoxBevel (v:String) : Void
	{
		var filter = parseBevelFilter(v);
		if (filter != null) {
			createBoxFiltersBlock();
			currentBlock.boxFilters.bevel = filter;
		}
	}

	
	private function parseAndSetBoxBlur (v:String) : Void
	{
		var filter = parseBlurFilter(v);
		if (filter != null) {
			createBoxFiltersBlock();
			currentBlock.boxFilters.blur = filter;
		}
	}
	

	private function parseAndSetBoxShadow (v:String) : Void
	{
		var filter = parseShadowFilter(v);
		if (filter != null) {
			createBoxFiltersBlock();
			currentBlock.boxFilters.shadow = filter;
		}
	}
	

	private function parseAndSetBoxGlow (v:String) : Void
	{
		var filter = parseGlowFilter(v);
		if (filter != null) {
			createBoxFiltersBlock();
			currentBlock.boxFilters.glow = filter;
		}
	}
	

	private function parseAndSetBoxGradientBevel (v:String) : Void
	{
		var filter = parseGradientBevelFilter(v);
		if (filter != null) {
			createBoxFiltersBlock();
			currentBlock.boxFilters.gradientBevel = filter;
		}
	}
	

	private function parseAndSetBoxGradientGlow (v:String) : Void
	{
		var filter = parseGradientGlowFilter(v);
		if (filter != null) {
			createBoxFiltersBlock();
			currentBlock.boxFilters.gradientGlow = filter;
		}
	}
	
	
	
	//
	// BACKGROUND FILTERS
	//
	
	private function parseAndSetBackgroundBevel (v:String) : Void
	{
		var filter = parseBevelFilter(v);
		if (filter != null) {
			createBackgroundFiltersBlock();
			currentBlock.bgFilters.bevel = filter;
		}
	}

	
	private function parseAndSetBackgroundBlur (v:String) : Void
	{
		var filter = parseBlurFilter(v);
		if (filter != null) {
			createBackgroundFiltersBlock();
			currentBlock.bgFilters.blur = filter;
		}
	}
	

	private function parseAndSetBackgroundShadow (v:String) : Void
	{
		var filter = parseShadowFilter(v);
		if (filter != null) {
			createBackgroundFiltersBlock();
			currentBlock.bgFilters.shadow = filter;
		}
	}
	

	private function parseAndSetBackgroundGlow (v:String) : Void
	{
		var filter = parseGlowFilter(v);
		if (filter != null) {
			createBackgroundFiltersBlock();
			currentBlock.bgFilters.glow = filter;
		}
	}
	

	private function parseAndSetBackgroundGradientBevel (v:String) : Void
	{
		var filter = parseGradientBevelFilter(v);
		if (filter != null) {
			createBackgroundFiltersBlock();
			currentBlock.bgFilters.gradientBevel = filter;
		}
	}
	

	private function parseAndSetBackgroundGradientGlow (v:String) : Void
	{
		var filter = parseGradientGlowFilter(v);
		if (filter != null) {
			createBackgroundFiltersBlock();
			currentBlock.bgFilters.gradientGlow = filter;
		}
	}
	
	
	
	
	
	//
	// COMPONENT PROPERTIES
	//
	
	private function parseAndSetSkin (v:String) : Void
	{
		if (isClassReference(v))
			currentBlock.skin = cast parseClassReference(v);
	}
	
	
	private function parseAndSetVisibility (v:String) : Void
	{
		currentBlock.visible = switch (v.trim().toLowerCase()) {
			default:		null;
			case "visible":	true;
			case "hidden":	false;
		}
	}
	
	
	private function parseAndSetOpacity (v:String) : Void
	{
		if (isFloat(v))
			currentBlock.opacity = parseFloat(v);
	}
	
	
	private function parseAndSetIcon (v:String) : Void
	{
		var bmp = parseBitmap(v);
		if (bmp != null)
			currentBlock.icon = bmp;
	}
	
	
	/**
	 * The overflow declaration tells the framework what to do with content 
	 * that doesn't fit in the box.
	 * 
	 * Allowed values:
	 * 	- visible					content of a box can flow over the edges
	 * 	- hidden					overflowing content is completly hidden
	 * 	- scroll-mouse-move			same as hidden, but the hidden content is reachable by scrolling. Scrolling will happen by moving the mouse over the box.
	 * 	- drag-scroll				same as hidden, but the hidden content is reachable by scrolling. Scrolling will happen by dragging the box.
	 * 	- corner-scroll				same as hidden, but the hidden content is reachable by scrolling. Scrolling will happen when the mouse reaches the edges of the box.
	 * 	- scrollbars				same as hidden, but the hidden content is reachable by scrolling. Scrolling will happen by moving the scrollbars.
	 */
	private function parseAndSetOverflow (v:String) : Void
	{
		currentBlock.overflow = switch (v.trim().toLowerCase()) {
			case "visible":				cast UnclippedLayoutBehaviour;
			case "hidden":				cast ClippedLayoutBehaviour;
			case "scroll-mouse-move":	cast MouseMoveScrollBehaviour;
			case "drag-scroll":			cast DragScrollBehaviour;
			case "corner-scroll":		cast CornerScrollBehaviour;
			case "scrollbars":			null;
			default:					null;
		}
	}
	
	
	
	
	
	//
	// EFFECTS
	//
	
	
	private function isEffect (v:String) : Bool
	{
		return anchorScaleEffExpr.match(v)
			|| fadeEffExpr.match(v)
			|| moveEffExpr.match(v)
			|| resizeEffExpr.match(v)
			|| rotateEffExpr.match(v)
			|| scaleEffExpr.match(v)
			|| wipeEffExpr.match(v)
			|| parallelEffExpr.match(v)
			|| sequenceEffExpr.match(v);
	}
	
	
	private function parseEasing (v:String) : Easing
	{
		var easing : Easing = null;
		if (easingExpr.match(v))
		{
			var e : Dynamic = switch (easingExpr.matched(1).toLowerCase())
			{
				case "back":	cast feffects.easing.Back;		// trace(easingExpr.matched(1).toLowerCase());
				case "bounce":	cast feffects.easing.Bounce;	// trace(easingExpr.matched(1).toLowerCase());
				case "circ":	cast feffects.easing.Circ;		// trace(easingExpr.matched(1).toLowerCase());
				case "cubic":	cast feffects.easing.Cubic;		// trace(easingExpr.matched(1).toLowerCase());
				case "elastic":	cast feffects.easing.Elastic;	// trace(easingExpr.matched(1).toLowerCase());
				case "expo":	cast feffects.easing.Expo;		// trace(easingExpr.matched(1).toLowerCase());
				case "linear":	cast feffects.easing.Linear;	// trace(easingExpr.matched(1).toLowerCase());
				case "quad":	cast feffects.easing.Quad;		// trace(easingExpr.matched(1).toLowerCase());
				case "quart":	cast feffects.easing.Quart;		// trace(easingExpr.matched(1).toLowerCase());
				case "quint":	cast feffects.easing.Quint;		// trace(easingExpr.matched(1).toLowerCase());
				case "sine":	cast feffects.easing.Sine;		// trace(easingExpr.matched(1).toLowerCase());
				default:		null;
			}
			
			if (e != null)
			{
				easing = switch (easingExpr.matched(2).toLowerCase()) {
					case "in":	e.easeIn;
					case "out":	e.easeOut;
					default:	e.easeInOut;
				}
			}
		}
		
		return easing;
	}
	
	
	private function getEasingName (v:String ) : String
	{
		return v != null && easingExpr.match(v) ? easingExpr.matched(0).toLowerCase() : null;
	}
	
	
	private function removeEffectFromParamStr (v:String) : String
	{
		if (v == null)
			return null;
		
		v = easingExpr.removeMatch(v);
		v = timingExpr.removeMatch(v);
		v = timingExpr.removeMatch(v);
		
		if (lastUsedEffectExpr != null)
			v = lastUsedEffectExpr.removeMatch(v);
		
		return v;
	}
	
	
	private function parseEffectChildren (params:String, effect:CompositeEffect)
	{
		while (true)
		{
			if (!effectChildrenExpr.match(params))
				break;
			
			params = effectChildrenExpr.removeMatch(params);
			var cEffect = parseEffect( effectChildrenExpr.matched(1).trim() );
			if (cEffect != null)
				effect.add(cEffect);
		}
		
		return effect;
	}
	
	
	/**
	 * Reference to the EReg object that has matched the last effect. This
	 * is used to remove the effect from the string without the need of 
	 * returning the string.
	 */
	private var lastUsedEffectExpr : EReg;
	
	/**
	 * Method to match the correct effect and create an effect-object from the
	 * given parameters.
	 * 
	 * Every effect has it's own parameters, but can also have the following
	 * general parameters:
	 * 		- duration (ms)
	 * 		- 'delay ( duration ms )'
	 * 		- easing
	 * 
	 * Possible easing values (In / Out / InOut):
	 * 		Back / Bounce / Circ / Cubic / Elastic / Expo / Linear / Quad / Quart / Quint / Sine
	 */
	private function parseEffect (v:String) : EffectType
	{
		var effect : EffectType	= null;
		
		if (v == "" || v == null)
			return effect;
		
		//
		// FIRST TRY TO MATCH COMPOSITE EFFECTS
		//
		
		
		
		//match parallel effect		('parallel ( comma seperated list of effects )')
		if (parallelEffExpr.match(v))
		{
		//	trace("PARALLEL MATCH FOR "+v);
		//	trace(parallelEffExpr.resultToString(2));
			var	tmpEffect = parseEffectChildren( parallelEffExpr.matched(2), new ParallelEffect() );
			
			if (tmpEffect.effects.length > 0)
				effect = tmpEffect;
			
			parallelEffExpr.match(v);	//match the current str again...
			v = parallelEffExpr.matched(1);
			lastUsedEffectExpr = parallelEffExpr;
		}
		
		
		
		//match sequence effect		('sequence ( comma seperated list of effects )')
		else if (sequenceEffExpr.match(v))
		{
		//	trace("SEQUENCE MATCH FOR "+v);
			var	tmpEffect = parseEffectChildren( sequenceEffExpr.matched(2), new SequenceEffect() );
			
			if (tmpEffect.effects.length > 0)
				effect = tmpEffect;
			
			sequenceEffExpr.match(v);	//match the current str again...
			v = sequenceEffExpr.matched(1);
			lastUsedEffectExpr = sequenceEffExpr;
		}
		
		
		
		//
		// TRY TO MATCH DEFAULT EFFECT PARAMETERS
		//
		
		var duration : Int	= Number.INT_NOT_SET;
		var delay : Int		= Number.INT_NOT_SET;
		var easing : Easing	= parseEasing(v);
		var easingName		= getEasingName(v);
		
	//	trace("testing str = "+v);
		
		//remove easing
		if (easing != null)
			v = easingExpr.removeMatch(v);
		
		//parse duration
		if (timingExpr.match(v)) {
			duration = getInt( timingExpr.matched(1) );
			v = timingExpr.removeMatch(v);
		}
		
		//parse delay
		if (timingExpr.match(v)) {
			delay = getInt( timingExpr.matched(1) );
			v = timingExpr.removeMatch(v);
		}
		
		
		if (effect != null) {
			if (easing != null)		effect.easing	= easing;
			if (duration.isSet())	effect.duration	= duration;
			if (delay.isSet())		effect.delay	= delay;
		}
		
		
		//
		// THEN TRY TO MATCH THE OTHER EFFECT TYPES
		//
		
		//match anchorScale effect	(end-scaleX, end-scaleY, anchorPoint)
		else if (anchorScaleEffExpr.match(v))
		{
		//	trace(anchorScaleEffExpr.resultToString(40));
			var start	= parsePercentage( anchorScaleEffExpr.matched(20) );
			var end		= parsePercentage( anchorScaleEffExpr.matched(25) );
			
			if (start.isSet())		start	/= 100;
			if (end.isSet())		end		/= 100;
			
			effect = new AnchorScaleEffect ( duration, delay, easing, parsePosition( anchorScaleEffExpr.matched(2) ), start, end );
			lastUsedEffectExpr = anchorScaleEffExpr;
		}
		
		
		
		//match fade effect			(start-alpha, end-alpha)
		else if (fadeEffExpr.match(v))
		{
		//	trace(fadeEffExpr.resultToString(40));
			var start	= fadeEffExpr.matched(2) != null ? parsePercentage( fadeEffExpr.matched(3) ) : Number.FLOAT_NOT_SET;
			var end		= fadeEffExpr.matched(2) != null ? parsePercentage( fadeEffExpr.matched(8) ) : parsePercentage( fadeEffExpr.matched(13) );
			
			if (start.isSet())		start	/= 100;
			if (end.isSet())		end		/= 100;
			
			effect = new FadeEffect ( duration, delay, easing, start, end );
			lastUsedEffectExpr = fadeEffExpr;
		}
		
		
		
		//match move effect			(startX, startY, endX, endY)
		else if (moveEffExpr.match(v))
		{
		//	trace(moveEffExpr.resultToString(40));
			var startX	= moveEffExpr.matched(2) != null ? parseUnitFloat( moveEffExpr.matched(3) )		: Number.FLOAT_NOT_SET;
			var startY	= moveEffExpr.matched(2) != null ? parseUnitFloat( moveEffExpr.matched(9) )		: Number.FLOAT_NOT_SET;
			var endX	= moveEffExpr.matched(2) != null ? parseUnitFloat( moveEffExpr.matched(15) )	: parseUnitFloat( moveEffExpr.matched(28) );
			var endY	= moveEffExpr.matched(2) != null ? parseUnitFloat( moveEffExpr.matched(21) )	: parseUnitFloat( moveEffExpr.matched(34) );
			effect		= new MoveEffect ( duration, delay, easing, startX, startY, endX, endY );
			lastUsedEffectExpr = moveEffExpr;
		}
		
		
		//match resize effect		(start-width, start-height, end-width, end-height)
		else if (resizeEffExpr.match(v))
		{
		//	trace(resizeEffExpr.resultToString(40));
			var startW	= resizeEffExpr.matched(2) != null ? parseUnitFloat( resizeEffExpr.matched(3) )		: Number.FLOAT_NOT_SET;
			var startH	= resizeEffExpr.matched(2) != null ? parseUnitFloat( resizeEffExpr.matched(9) )		: Number.FLOAT_NOT_SET;
			var endW	= resizeEffExpr.matched(2) != null ? parseUnitFloat( resizeEffExpr.matched(15) )	: parseUnitFloat( resizeEffExpr.matched(28) );
			var endH	= resizeEffExpr.matched(2) != null ? parseUnitFloat( resizeEffExpr.matched(21) )	: parseUnitFloat( resizeEffExpr.matched(34) );
			effect		= new ResizeEffect ( duration, delay, easing, startW, startH, endW, endH );
			lastUsedEffectExpr = resizeEffExpr;
		}
		
		
		
		//match rotate effect		(start-value, end-value)
		else if (rotateEffExpr.match(v))
		{
		//	trace(rotateEffExpr.resultToString(13));
			var start	= rotateEffExpr.matched(2) != null ? parseAngle( rotateEffExpr.matched(3) ) : Number.FLOAT_NOT_SET;
			var end		= rotateEffExpr.matched(2) != null ? parseAngle( rotateEffExpr.matched(7) ) : parseAngle( rotateEffExpr.matched(11) );
			effect		= new RotateEffect ( duration, delay, easing, start, end );
			lastUsedEffectExpr = rotateEffExpr;
		}
		
		
		
		//match scale effect		(start-scaleX, start-scaleY, end-scaleX, end-scaleY)
		else if (scaleEffExpr.match(v))
		{
		//	trace(scaleEffExpr.resultToString(34));
			var startX	= scaleEffExpr.matched(2) != null ? parsePercentage( scaleEffExpr.matched(3) ) : Number.FLOAT_NOT_SET;
			var startY	= scaleEffExpr.matched(2) != null ? parsePercentage( scaleEffExpr.matched(8) ) : Number.FLOAT_NOT_SET;
			var endX	= scaleEffExpr.matched(2) != null ? parsePercentage( scaleEffExpr.matched(13) ) : parsePercentage( scaleEffExpr.matched(24) );
			var endY	= scaleEffExpr.matched(2) != null ? parsePercentage( scaleEffExpr.matched(18) ) : parsePercentage( scaleEffExpr.matched(29) );
			
			if (startX.isSet())		startX	/= 100;
			if (startY.isSet())		startY	/= 100;
			if (endX.isSet())		endX	/= 100;
			if (endY.isSet())		endY	/= 100;
			
			effect		= new ScaleEffect ( duration, delay, easing, startX, startY, endX, endY );
			lastUsedEffectExpr = scaleEffExpr;
		}
		
		
		
		//match wipe effect			(direction, start-value, end-value)
		else if (wipeEffExpr.match(v))
		{
		//	trace(wipeEffExpr.resultToString(17));
			var direction	= parseMoveDirection( wipeEffExpr.matched(1) );
			var start		= wipeEffExpr.matched(10) != null ? parseUnitFloat( wipeEffExpr.matched(4) ) : Number.FLOAT_NOT_SET;
			var end			= wipeEffExpr.matched(10) != null ? parseUnitFloat( wipeEffExpr.matched(11) ) : parseUnitFloat( wipeEffExpr.matched(4) );
			effect			= new WipeEffect ( duration, delay, easing, direction, start, end );
			lastUsedEffectExpr = wipeEffExpr;
		}
		
		
		
		//match set-action effect		(size | position | scale | rotation | alpha | any)
		else if (setActionEffExpr.match(v))
		{
			var props = parseEffectProperties(v);
			effect = new SetAction( duration, delay, easing, props );
			lastUsedEffectExpr = setActionEffExpr;
		}
				
		
#if neko
		if (effect != null)
			effect.easingName = easingName;
#end
		
	//	trace("p effect2 = "+effect);
		
		return effect;
	}
	
	
	
	
	
	
	private function parseEffectProperties (v:String) : EffectProperties
	{
		if (!setActionEffExpr.match(v)) {
			trace("no effect property match");
			return null;
		}
		
		var props : EffectProperties = null;
	//	trace(setActionEffExpr.resultToString(155));
		
		
		
		// alpha
		if (setActionEffExpr.matched(2) != null)
		{
			var start	= setActionEffExpr.matched(4) != null ? parsePercentage( setActionEffExpr.matched(5) ) : Number.FLOAT_NOT_SET;
			var end		= setActionEffExpr.matched(4) != null ? parsePercentage( setActionEffExpr.matched(10) ) : parsePercentage( setActionEffExpr.matched(15) );
			
			if (start.isSet())		start	/= 100;
			if (end.isSet())		end		/= 100;
			
			if (start.isSet() || end.isSet())
				props = EffectProperties.alpha( start, end );
		}
		
		//position
		if (setActionEffExpr.matched(21) != null)
		{
			var startX	= setActionEffExpr.matched(23) != null ? parseUnitFloat( setActionEffExpr.matched(24) )	: Number.FLOAT_NOT_SET;
			var startY	= setActionEffExpr.matched(23) != null ? parseUnitFloat( setActionEffExpr.matched(30) )	: Number.FLOAT_NOT_SET;
			var endX	= setActionEffExpr.matched(23) != null ? parseUnitFloat( setActionEffExpr.matched(36) )	: parseUnitFloat( setActionEffExpr.matched(49) );
			var endY	= setActionEffExpr.matched(23) != null ? parseUnitFloat( setActionEffExpr.matched(42) )	: parseUnitFloat( setActionEffExpr.matched(55) );
			
			if (startX.isSet() || startY.isSet() || endX.isSet() || endY.isSet())
				props = EffectProperties.position( startX, startY, endX, endY );
		}
		
		//rotation
		if (setActionEffExpr.matched(61) != null)
		{
			var start	= setActionEffExpr.matched(63) != null ? parseAngle( setActionEffExpr.matched(64) ) : Number.FLOAT_NOT_SET;
			var end		= setActionEffExpr.matched(63) != null ? parseAngle( setActionEffExpr.matched(68) ) : parseAngle( setActionEffExpr.matched(72) );
			
			if (start.isSet() || end.isSet())
				props = EffectProperties.rotation( start, end );
		}
		
		//size
		if (setActionEffExpr.matched(76) != null)
		{
			var startW	= setActionEffExpr.matched(78) != null ? parseUnitFloat( setActionEffExpr.matched(79) )	: Number.FLOAT_NOT_SET;
			var startH	= setActionEffExpr.matched(78) != null ? parseUnitFloat( setActionEffExpr.matched(85) )	: Number.FLOAT_NOT_SET;
			var endW	= setActionEffExpr.matched(78) != null ? parseUnitFloat( setActionEffExpr.matched(91) )	: parseUnitFloat( setActionEffExpr.matched(104) );
			var endH	= setActionEffExpr.matched(78) != null ? parseUnitFloat( setActionEffExpr.matched(97) )	: parseUnitFloat( setActionEffExpr.matched(110) );
			
			if (startW.isSet() || startH.isSet() || endW.isSet() || endH.isSet())
				props = EffectProperties.size( startW, startH, endW, endH );
		}
		
		//scale
		if (setActionEffExpr.matched(116) != null)
		{
			var startX	= setActionEffExpr.matched(118) != null ? parsePercentage( setActionEffExpr.matched(119) )	: Number.FLOAT_NOT_SET;
			var startY	= setActionEffExpr.matched(118) != null ? parsePercentage( setActionEffExpr.matched(124) )	: Number.FLOAT_NOT_SET;
			var endX	= setActionEffExpr.matched(118) != null ? parsePercentage( setActionEffExpr.matched(129) )	: parsePercentage( setActionEffExpr.matched(140) );
			var endY	= setActionEffExpr.matched(118) != null ? parsePercentage( setActionEffExpr.matched(134) )	: parsePercentage( setActionEffExpr.matched(145) );
			
			if (startX.isSet())		startX	/= 100;
			if (startY.isSet())		startY	/= 100;
			if (endX.isSet())		endX	/= 100;
			if (endY.isSet())		endY	/= 100;
			
			if (startX.isSet() || startY.isSet() || endX.isSet() || endY.isSet())
				props = EffectProperties.scale( startX, startY, endX, endY );
		}
		
		//any
		if (setActionEffExpr.matched(150) != null)
		{
			var prop	= setActionEffExpr.matched(151).trim();
			var startV	= setActionEffExpr.matched(153) != null ? setActionEffExpr.matched(152)	: null;
			var endV	= setActionEffExpr.matched(153) != null ? setActionEffExpr.matched(154)	: setActionEffExpr.matched(152);
			
			if (prop != null && endV != null)
				props = EffectProperties.any( prop, startV, endV );
		}
		
		return props;
	}
	
	
	
	//
	// TRANSITIONS
	//
	
	
	private function parseAndSetMoveTransition (v:String) : Void
	{
		if (isEffect(v))
		{
			createEffectsBlock();
			currentBlock.effects.move = parseEffect(v);
		}
	}
	
	
	private function parseAndSetResizeTransition (v:String) : Void
	{
		if (isEffect(v))
		{
			createEffectsBlock();
			currentBlock.effects.resize = parseEffect(v);
		}
	}
	
	
	private function parseAndSetRotateTransition (v:String) : Void
	{
		if (isEffect(v))
		{
			createEffectsBlock();
			currentBlock.effects.rotate = parseEffect(v);
		}
	}
	
	
	private function parseAndSetScaleTransition (v:String) : Void
	{
		if (isEffect(v))
		{
			createEffectsBlock();
			currentBlock.effects.scale = parseEffect(v);
		}
	}
	
	
	private function parseAndSetShowTransition (v:String) : Void
	{
		if (isEffect(v))
		{
			createEffectsBlock();
			currentBlock.effects.show = parseEffect(v);
		}
	}
	
	
	private function parseAndSetHideTransition (v:String) : Void
	{
		if (isEffect(v))
		{
			createEffectsBlock();
			currentBlock.effects.hide = parseEffect(v);
		}
	}
}





class StyleQueueItem implements IDisposable
{
	public var path		: String;
	public var content	: String;
	
	
	public function new (path:String = "", content:String = "")
	{
		this.path		= path;
		this.content	= content;
	}
	
	
	public function dispose ()
	{
		path = content = null;
	}
}