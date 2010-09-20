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
		var fontStyleDeclarations1 = new primevc.gui.styling.declarations.FontStyleDeclarations( primevc.types.Number.INT_NOT_SET, null, null, primevc.gui.text.FontWeight.bold, null, primevc.types.Number.INT_NOT_SET, primevc.gui.text.TextAlign.left, null, primevc.types.Number.INT_NOT_SET, null );
		var composedFill2 = new primevc.gui.graphics.fills.ComposedFill(  );
		var bitmap4 = new primevc.types.Bitmap(  );
		bitmap4.setString("../images/test.png");
		var bitmapFill3 = new primevc.gui.graphics.fills.BitmapFill( bitmap4, null, false, false );
		composedFill2.add(bitmapFill3);
		var solidFill5 = new primevc.gui.graphics.fills.SolidFill( 0xFFAFFAFF );
		composedFill2.add(solidFill5);
		var uIContainerStyle0 = new primevc.gui.styling.declarations.UIContainerStyle( null, fontStyleDeclarations1, null, composedFill2, null, null, null, null );
		var styleContainer6 = new primevc.gui.styling.StyleContainer(  );
		uIContainerStyle0.children = styleContainer6;
		this.typeSelectors.set("Label", uIContainerStyle0);
		var relativeLayout9 = new primevc.gui.layout.RelativeLayout( primevc.types.Number.INT_NOT_SET, 400, primevc.types.Number.INT_NOT_SET, 0 );
		relativeLayout9.vCenter = 0;
		var horizontalCircleAlgorithm11 = new primevc.gui.layout.algorithms.circle.HorizontalCircleAlgorithm( primevc.core.geom.space.Horizontal.left, null );
		var verticalCircleAlgorithm12 = new primevc.gui.layout.algorithms.circle.VerticalCircleAlgorithm( primevc.core.geom.space.Vertical.top, null );
		var dynamicLayoutAlgorithm10 = new primevc.gui.layout.algorithms.DynamicLayoutAlgorithm( horizontalCircleAlgorithm11, verticalCircleAlgorithm12 );
		var layoutStyleDeclarations8 = new primevc.gui.styling.declarations.LayoutStyleDeclarations( relativeLayout9, null, dynamicLayoutAlgorithm10, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, null, null );
		layoutStyleDeclarations8.minWidth = 50;
		layoutStyleDeclarations8.minHeight = 10;
		layoutStyleDeclarations8.maxHeight = 20;
		var composedFill13 = new primevc.gui.graphics.fills.ComposedFill(  );
		var gradientFill14 = new primevc.gui.graphics.fills.GradientFill( primevc.gui.graphics.fills.GradientType.linear, primevc.gui.graphics.fills.SpreadMethod.normal, 0, 90 );
		var gradientStop15 = new primevc.gui.graphics.fills.GradientStop( 0xAAAAAAFF, 0 );
		gradientFill14.add(gradientStop15);
		var gradientStop16 = new primevc.gui.graphics.fills.GradientStop( 0xDDDDDDFF, 85 );
		gradientFill14.add(gradientStop16);
		var gradientStop17 = new primevc.gui.graphics.fills.GradientStop( 0xEEEEEEFF, 170 );
		gradientFill14.add(gradientStop17);
		var gradientStop18 = new primevc.gui.graphics.fills.GradientStop( 0xFFFFFFFF, 255 );
		gradientFill14.add(gradientStop18);
		composedFill13.add(gradientFill14);
		var solidFill19 = new primevc.gui.graphics.fills.SolidFill( 0xFFAD9700 );
		composedFill13.add(solidFill19);
		var uIContainerStyle7 = new primevc.gui.styling.declarations.UIContainerStyle( layoutStyleDeclarations8, null, null, composedFill13, null, null, null, null );
		var styleContainer20 = new primevc.gui.styling.StyleContainer(  );
		var uIContainerStyle21 = new primevc.gui.styling.declarations.UIContainerStyle( null, null, null, null, null, null, null, null );
		var styleContainer22 = new primevc.gui.styling.StyleContainer(  );
		var uIContainerStyle23 = new primevc.gui.styling.declarations.UIContainerStyle( null, null, null, null, null, null, null, null );
		var styleContainer24 = new primevc.gui.styling.StyleContainer(  );
		var layoutStyleDeclarations26 = new primevc.gui.styling.declarations.LayoutStyleDeclarations( null, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, 40, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, null, null );
		var uIContainerStyle25 = new primevc.gui.styling.declarations.UIContainerStyle( layoutStyleDeclarations26, null, null, null, null, null, null, null );
		var styleContainer27 = new primevc.gui.styling.StyleContainer(  );
		uIContainerStyle25.children = styleContainer27;
		styleContainer24.styleNameSelectors.set("eenVeld", uIContainerStyle25);
		uIContainerStyle23.children = styleContainer24;
		styleContainer22.typeSelectors.set("Aap", uIContainerStyle23);
		uIContainerStyle21.children = styleContainer22;
		styleContainer20.typeSelectors.set("Button", uIContainerStyle21);
		uIContainerStyle7.children = styleContainer20;
		this.typeSelectors.set("TextArea", uIContainerStyle7);
		var fontStyleDeclarations29 = new primevc.gui.styling.declarations.FontStyleDeclarations( primevc.types.Number.INT_NOT_SET, null, 0x320CC819, null, null, primevc.types.Number.INT_NOT_SET, primevc.gui.text.TextAlign.center, null, primevc.types.Number.INT_NOT_SET, null );
		var uIContainerStyle28 = new primevc.gui.styling.declarations.UIContainerStyle( null, fontStyleDeclarations29, null, null, null, null, null, null );
		var styleContainer30 = new primevc.gui.styling.StyleContainer(  );
		uIContainerStyle28.children = styleContainer30;
		this.typeSelectors.set("UIComponent", uIContainerStyle28);
	}
	
	
	override private function createStyleNameSelectors () : Void
	{
		//styleNameSelectors
		var box2 = new primevc.core.geom.Box( 4, 3, 4, 3 );
		var horizontalFloatAlgorithm3 = new primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm( primevc.core.geom.space.Horizontal.right, null );
		var layoutStyleDeclarations1 = new primevc.gui.styling.declarations.LayoutStyleDeclarations( null, box2, horizontalFloatAlgorithm3, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, 50, 0, 3, 400, primevc.types.Number.INT_NOT_SET, false, null );
		var fontStyleDeclarations4 = new primevc.gui.styling.declarations.FontStyleDeclarations( 12, "Verdana", null, primevc.gui.text.FontWeight.bold, primevc.gui.text.FontStyle.italic, primevc.types.Number.INT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, null );
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
		var uIContainerStyle0 = new primevc.gui.styling.declarations.UIContainerStyle( layoutStyleDeclarations1, fontStyleDeclarations4, null, gradientFill5, null, null, null, null );
		var styleContainer12 = new primevc.gui.styling.StyleContainer(  );
		uIContainerStyle0.children = styleContainer12;
		this.styleNameSelectors.set("eenVeld", uIContainerStyle0);
	}
	
	
	override private function createIdSelectors () : Void
	{
		//idSelectors
		var uIContainerStyle0 = new primevc.gui.styling.declarations.UIContainerStyle( null, null, null, null, null, null, null, null );
		var styleContainer1 = new primevc.gui.styling.StyleContainer(  );
		uIContainerStyle0.children = styleContainer1;
		this.idSelectors.set("idable", uIContainerStyle0);
	}
}