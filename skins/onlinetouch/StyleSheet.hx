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
 import primevc.gui.styling.StyleChildren;
 import primevc.gui.styling.StyleBlockType;
 import primevc.gui.styling.StyleBlock;



/**
 * This class is a template for generating UIElementStyle classes
 */
class StyleSheet extends StyleBlock
{
	public function new ()
	{
		super(StyleBlockType.specific);
		children = new ApplicationStyleChildren();
	}
}


class ApplicationStyleChildren extends StyleChildren
{
	public function new ()
	{
		super( new SelectorMapType(), new SelectorMapType(), new SelectorMapType() );
	}
	
	override private function fillSelectors () : Void
	{
		//selectors
		var solidFill3 = new primevc.gui.graphics.fills.SolidFill( 0xF0FF0FFF );
		var solidBorder2 = new primevc.gui.graphics.borders.SolidBorder( cast solidFill3, 0x000001, false, primevc.gui.graphics.borders.CapsStyle.NONE, primevc.gui.graphics.borders.JointStyle.ROUND, false );
		var regularRectangle4 = new primevc.gui.graphics.shapes.RegularRectangle( null );
		var graphicsStyle1 = new primevc.gui.styling.GraphicsStyle( null, cast solidBorder2, cast regularRectangle4, null, true, 0.6, null, null );
		var styleBlock0 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle1, null, null, null, null, null, null );
		this.elementSelectors.set('primevc.gui.core.UIComponent', cast styleBlock0);
		var textStyle6 = new primevc.gui.styling.TextStyle( primevc.types.Number.INT_NOT_SET, null, 0x000000FF, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var styleBlock5 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, null, cast textStyle6, null, null, null, null );
		this.elementSelectors.set('primevc.gui.core.UITextField', cast styleBlock5);
		var relativeAlgorithm9 = new primevc.gui.layout.algorithms.RelativeAlgorithm(  );
		var layoutStyle8 = new primevc.gui.styling.LayoutStyle( null, null, cast relativeAlgorithm9, 100, 100, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock7 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, cast layoutStyle8, null, null, null, null, null );
		styleBlock7.superStyle = cast styleBlock0;
		this.elementSelectors.set('primevc.gui.components.ApplicationView', cast styleBlock7);
		var verticalFloatAlgorithm12 = new primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm( primevc.core.geom.space.Vertical.top, null );
		var layoutStyle11 = new primevc.gui.styling.LayoutStyle( null, null, cast verticalFloatAlgorithm12, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock10 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, cast layoutStyle11, null, null, null, null, null );
		styleBlock10.superStyle = cast styleBlock7;
		this.elementSelectors.set('cases.EditorView', cast styleBlock10);
		var solidFill15 = new primevc.gui.graphics.fills.SolidFill( 0x252525FF );
		var graphicsStyle14 = new primevc.gui.styling.GraphicsStyle( cast solidFill15, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var layoutStyle16 = new primevc.gui.styling.LayoutStyle( null, null, null, 100, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, 0x000028, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var textStyle17 = new primevc.gui.styling.TextStyle( 0x000009, 'Helvetica ', null, primevc.gui.text.FontWeight.bold, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var styleBlock13 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle14, cast layoutStyle16, cast textStyle17, null, null, null, null );
		styleBlock13.superStyle = cast styleBlock0;
		this.elementSelectors.set('cases.ApplicationMainBar', cast styleBlock13);
		var solidFill20 = new primevc.gui.graphics.fills.SolidFill( 0xD4D4D4FF );
		var graphicsStyle19 = new primevc.gui.styling.GraphicsStyle( cast solidFill20, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var horizontalFloatAlgorithm22 = new primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm( primevc.core.geom.space.Horizontal.center, null );
		var layoutStyle21 = new primevc.gui.styling.LayoutStyle( null, null, cast horizontalFloatAlgorithm22, 100, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, 0x000064, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock18 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle19, cast layoutStyle21, null, null, null, null, null );
		styleBlock18.superStyle = cast styleBlock0;
		this.elementSelectors.set('cases.FramesToolBar', cast styleBlock18);
		var solidFill25 = new primevc.gui.graphics.fills.SolidFill( 0xFFFFFFFF );
		var graphicsStyle24 = new primevc.gui.styling.GraphicsStyle( cast solidFill25, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var horizontalFloatAlgorithm27 = new primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm( primevc.core.geom.space.Horizontal.right, null );
		var layoutStyle26 = new primevc.gui.styling.LayoutStyle( null, null, cast horizontalFloatAlgorithm27, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x0000C8, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock23 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle24, cast layoutStyle26, null, null, null, null, null );
		styleBlock23.superStyle = cast styleBlock0;
		var simpleDictionary_String_primevc_gui_styling_StyleBlock29 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000001 );
		var solidFill32 = new primevc.gui.graphics.fills.SolidFill( 0x0F00F0FF );
		var graphicsStyle31 = new primevc.gui.styling.GraphicsStyle( cast solidFill32, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var textStyle33 = new primevc.gui.styling.TextStyle( 0x00000B, 'Helvetica ', null, primevc.gui.text.FontWeight.bold, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var styleBlock30 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.styleName, cast graphicsStyle31, null, cast textStyle33, null, null, null, null );
		styleBlock30.parentStyle = cast styleBlock23;
		simpleDictionary_String_primevc_gui_styling_StyleBlock29.set('title', cast styleBlock30);
		var styleChildren28 = new primevc.gui.styling.StyleChildren( null, cast simpleDictionary_String_primevc_gui_styling_StyleBlock29, null );
		styleBlock23.children = cast styleChildren28;
		this.elementSelectors.set('cases.FrameTypesBar', cast styleBlock23);
		var solidFill36 = new primevc.gui.graphics.fills.SolidFill( 0xFF0FF0FF );
		var graphicsStyle35 = new primevc.gui.styling.GraphicsStyle( cast solidFill36, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var horizontalFloatAlgorithm38 = new primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm( primevc.core.geom.space.Horizontal.right, null );
		var layoutStyle37 = new primevc.gui.styling.LayoutStyle( null, null, cast horizontalFloatAlgorithm38, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x0001F4, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock34 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle35, cast layoutStyle37, null, null, null, null, null );
		styleBlock34.superStyle = cast styleBlock0;
		var simpleDictionary_String_primevc_gui_styling_StyleBlock40 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000001 );
		var solidFill43 = new primevc.gui.graphics.fills.SolidFill( 0xF00F00FF );
		var graphicsStyle42 = new primevc.gui.styling.GraphicsStyle( cast solidFill43, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var layoutStyle44 = new primevc.gui.styling.LayoutStyle( null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x000064, 0x000041, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var textStyle45 = new primevc.gui.styling.TextStyle( 0x000008, 'Helvetica', null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.gui.text.TextTransform.capitalize, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var simpleDictionary_Int_primevc_gui_styling_StyleBlock47 = new primevc.types.SimpleDictionary_Int_primevc_gui_styling_StyleBlock( 0x000001 );
		var solidFill50 = new primevc.gui.graphics.fills.SolidFill( 0x0F00F0FF );
		var graphicsStyle49 = new primevc.gui.styling.GraphicsStyle( cast solidFill50, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock48 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.elementState, cast graphicsStyle49, null, null, null, null, null, null );
		simpleDictionary_Int_primevc_gui_styling_StyleBlock47.set(0x000001, cast styleBlock48);
		var statesStyle46 = new primevc.gui.styling.StatesStyle( cast simpleDictionary_Int_primevc_gui_styling_StyleBlock47 );
		var styleBlock41 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle42, cast layoutStyle44, cast textStyle45, null, null, null, cast statesStyle46 );
		styleBlock41.superStyle = cast styleBlock0;
		styleBlock41.parentStyle = cast styleBlock34;
		simpleDictionary_String_primevc_gui_styling_StyleBlock40.set('cases.FrameButton', cast styleBlock41);
		var styleChildren39 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock40, null, null );
		styleBlock34.children = cast styleChildren39;
		this.elementSelectors.set('cases.FrameTypesBarList', cast styleBlock34);
	}
}