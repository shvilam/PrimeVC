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
package ;
 import primevc.gui.styling.StyleContainer;



/**
 * This class is a template for generating StyleSheet classes
 */
class Style extends StyleContainer
{
	override private function createTypeSelectors () : Void
	{
		//typeSelectors
		var fontStyleDeclarations1 = new primevc.gui.styling.declarations.FontStyleDeclarations( null, null, null, primevc.gui.text.FontWeight.bold, null, null, primevc.gui.text.TextAlign.left, null, null, null );
		var composedFill2 = new primevc.gui.graphics.fills.ComposedFill(  );
		var bitmap4 = new primevc.types.Bitmap(  );
		bitmap4.setString("../images/test.png");
		var bitmapFill3 = new primevc.gui.graphics.fills.BitmapFill( bitmap4, null, false, false );
		composedFill2.add(bitmapFill3);
		var solidFill5 = new primevc.gui.graphics.fills.SolidFill( 0xFFAFFAFF );
		composedFill2.add(solidFill5);
		var uIElementStyle0 = new primevc.gui.styling.declarations.UIElementStyle( null, fontStyleDeclarations1, null, composedFill2, null, null, null, null );
		this.typeSelectors.set("Label", uIElementStyle0);
		var relativeLayout8 = new primevc.gui.layout.RelativeLayout( 10, 400, null, null );
		var horizontalCircleAlgorithm10 = new primevc.gui.layout.algorithms.circle.HorizontalCircleAlgorithm( primevc.core.geom.space.Horizontal.left, null );
		var verticalCircleAlgorithm11 = new primevc.gui.layout.algorithms.circle.VerticalCircleAlgorithm( primevc.core.geom.space.Vertical.top, null );
		var dynamicLayoutAlgorithm9 = new primevc.gui.layout.algorithms.DynamicLayoutAlgorithm( horizontalCircleAlgorithm10, verticalCircleAlgorithm11 );
		var layoutStyleDeclarations7 = new primevc.gui.styling.declarations.LayoutStyleDeclarations( relativeLayout8, null, dynamicLayoutAlgorithm9, nan, nan, null, null, null, null, nan, null, null );
		var composedFill12 = new primevc.gui.graphics.fills.ComposedFill(  );
		var gradientFill13 = new primevc.gui.graphics.fills.GradientFill( primevc.gui.graphics.fills.GradientType.linear, primevc.gui.graphics.fills.SpreadMethod.normal, 0, 90 );
		var gradientStop14 = new primevc.gui.graphics.fills.GradientStop( 0xAAAAAAFF, 0 );
		gradientFill13.add(gradientStop14);
		var gradientStop15 = new primevc.gui.graphics.fills.GradientStop( 0xDDDDDDFF, 85 );
		gradientFill13.add(gradientStop15);
		var gradientStop16 = new primevc.gui.graphics.fills.GradientStop( 0xEEEEEEFF, 170 );
		gradientFill13.add(gradientStop16);
		var gradientStop17 = new primevc.gui.graphics.fills.GradientStop( 0xFFFFFFFF, 255 );
		gradientFill13.add(gradientStop17);
		composedFill12.add(gradientFill13);
		var solidFill18 = new primevc.gui.graphics.fills.SolidFill( 0xFFAD9700 );
		composedFill12.add(solidFill18);
		var uIElementStyle6 = new primevc.gui.styling.declarations.UIElementStyle( layoutStyleDeclarations7, null, null, composedFill12, null, null, null, null );
		this.typeSelectors.set("TextArea", uIElementStyle6);
		var fontStyleDeclarations20 = new primevc.gui.styling.declarations.FontStyleDeclarations( null, null, 0x320CC819, null, null, null, primevc.gui.text.TextAlign.center, null, null, null );
		var uIElementStyle19 = new primevc.gui.styling.declarations.UIElementStyle( null, fontStyleDeclarations20, null, null, null, null, null, null );
		this.typeSelectors.set("UIComponent", uIElementStyle19);
	}
	
	
	override private function createStyleNameSelectors () : Void
	{
		//styleNameSelectors
		var box2 = new primevc.core.geom.Box( 4, 3, 4, 3 );
		var horizontalFloatAlgorithm3 = new primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm( primevc.core.geom.space.Horizontal.right, null );
		var layoutStyleDeclarations1 = new primevc.gui.styling.declarations.LayoutStyleDeclarations( null, box2, horizontalFloatAlgorithm3, nan, 10, 50, null, 3, 400, nan, false, null );
		var fontStyleDeclarations4 = new primevc.gui.styling.declarations.FontStyleDeclarations( 12, "Verdana", null, primevc.gui.text.FontWeight.bold, primevc.gui.text.FontStyle.italic, null, null, null, null, null );
		var gradientFill5 = new primevc.gui.graphics.fills.GradientFill( primevc.gui.graphics.fills.GradientType.radial, primevc.gui.graphics.fills.SpreadMethod.normal, -1, 0 );
		var gradientStop6 = new primevc.gui.graphics.fills.GradientStop( 0xAAAAAAFF, 0 );
		gradientFill5.add(gradientStop6);
		var gradientStop7 = new primevc.gui.graphics.fills.GradientStop( 0x000000FF, 40 );
		gradientFill5.add(gradientStop7);
		var gradientStop8 = new primevc.gui.graphics.fills.GradientStop( 0xADFC6700, 127 );
		gradientFill5.add(gradientStop8);
		var gradientStop9 = new primevc.gui.graphics.fills.GradientStop( 0x0F0F0F00, 153 );
		gradientFill5.add(gradientStop9);
		var gradientStop10 = new primevc.gui.graphics.fills.GradientStop( 0x222222FF, 181 );
		gradientFill5.add(gradientStop10);
		var gradientStop11 = new primevc.gui.graphics.fills.GradientStop( 0xABCDEF00, 254 );
		gradientFill5.add(gradientStop11);
		var uIElementStyle0 = new primevc.gui.styling.declarations.UIElementStyle( layoutStyleDeclarations1, fontStyleDeclarations4, null, gradientFill5, null, null, null, null );
		this.styleNameSelectors.set("eenVeld", uIElementStyle0);
	}
	
	
	override private function createIdSelectors () : Void
	{
		//idSelectors
		var uIElementStyle0 = new primevc.gui.styling.declarations.UIElementStyle( null, null, null, null, null, null, null, null );
		this.idSelectors.set("idable", uIElementStyle0);
	}
}