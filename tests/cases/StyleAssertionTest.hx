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
package cases;
 import primevc.gui.core.UIComponent;
 import primevc.gui.styling.declarations.FontStyleDeclarations;
 import primevc.gui.styling.declarations.GraphicStyleDeclarations;
 import primevc.gui.styling.declarations.LayoutStyleDeclarations;
 import primevc.gui.styling.declarations.StyleContainer;
 import primevc.gui.styling.declarations.UIElementStyle;
 import primevc.gui.styling.StyleSheet;


/**
 * @author Ruben Weijers
 * @creation-date Aug 06, 2010
 */
class StyleAssertionTest
{
	public static function main ()
	{
		var styleSheet = new StyleSheet();
		styleSheet.loadStyles( TestStyles );
	}
}


class TestStyles extends StyleContainer
{
	public static inline var DEFAULT_BACKGROUND_FILL	: String = "defaultBackgroundFill";
	public static inline var APP_GREY					: String = "appGrey";
	public static inline var APP_BLACK					: String = "appBlack";
	
	
	override private function createGlobals ()
	{
		var appGray		= 0xaaaaaaff;
		var appBlack	= 0x99999933;
		
		var grayFill	= new GradientFill( GradientType.lineair );
		grayFill.add( new GradientStop( appGray, 0 ) );
		grayFill.add( new GradientStop( appBlack, 255 ) );
		
		globalFills.set( DEFAULT_BACKGROUND_FILL,	grayFill );
		
		globalColors.set( APP_GREY,		appGray );
		globalColors.set( APP_BLACK,	appBlack );
	}
	
	
	override private function createElementSelectors ()
	{
		var c = elementSelectors;
		c.set("primevc.gui.display.Sprite", new UIElementStyle(
			null,
			new FontStyleDeclarations(11, "Verdana")
		));
		
		
		c.set("cases.Button", new UIElementStyle(
			new LayoutStyleDeclarations(
				null,
				new Box( 10 ),
				new HorizontalFloatAlgorithm( Horizontal.left )
			),
			null,
			new GraphicStyleDeclarations( globalFills.get( DEFAULT_BACKGROUND_FILL ) )
		));
		
		
		c.set("cases.Checkbox", new UIElementStyle(
			
		));
		
		
		c.set("cases.RadioButton", c.get("cases.CheckBox"));
	}
	
	
	override private function createStyleNameSelectors ()
	{
		var c = styleNameSelectors;
		
		c.set("fillingButton", new UIElementStyle(
			new LayoutStyleDeclarations(
				new RelativeLayout( 5, 5, 5, 5 ), //t r b l	-> make button as big as it's parent with 5 px margin on all sides
			)
		));
	}
	
	
	override private function createIdSelectors ()
	{
		var c = idSelectors;
		
		c.set("userCheckbox", new UIElementStyle(
			null, null, new GraphicStyleDeclarations(
				new SolidFill(0xffff00dd);
			)
		));
	}
}


class Button extends UIComponent
{
	
}


/*

@inherit-stylesheet otherstyle.css
@red #ff0000aa;



Style {
	border {
		weight:	#;
		fill:	#filltypes
		
	}
	border: 1px solid @red;
	color: #fff;
	background-color:	gradient( linear, 0% 40px 100% 90deg, #ffff00ff, #00ff0faa, #f0fa3677 );
	background-image:	Assets(HAPPY_SMILEY), url(sad_smiley.jpg);
	background-repeat:	REPEAT_X, REPEAT_NONE;
	layout = {
		algorithm:	FloatHorizontal ( startDirection ) 
					FloatVertical( startDirection )
					FixedTile ( startHor, startVer )
					DynamicTile ( startHor, startVer)
					Relative
					CircleHorizontal (startDirection)
					CircleVertical (startDirection)
					Dynamic (algorithmHor, algorithmVer)
	}
}

.error {
	color: $red;
}

.critical_error {
	@extend .error;
	font-weight: bold;
}





*/