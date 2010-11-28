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
		var graphicsStyle1 = new primevc.gui.styling.GraphicsStyle( null, null, new primevc.gui.graphics.shapes.RegularRectangle(  ), null, null, true, 1, null, null );
		var styleBlock0 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle1, null, null, null, null, null );
		this.elementSelectors.set('primevc.gui.display.IDisplayObject', cast styleBlock0);
		var graphicsStyle3 = new primevc.gui.styling.GraphicsStyle( null, null, null, null, primevc.gui.behaviours.layout.ClippedLayoutBehaviour, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock2 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle3, null, null, null, null, null );
		styleBlock2.superStyle = cast styleBlock0;
		this.elementSelectors.set('primevc.gui.core.UIWindow', cast styleBlock2);
		var array0 = [ primevc.core.geom.space.Vertical.top, primevc.core.geom.space.Horizontal.center ];
		var classInstanceFactory6 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm, array0 );
		var layoutStyle5 = new primevc.gui.styling.LayoutStyle( null, null, null, cast classInstanceFactory6, 1, 1, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock4 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, cast layoutStyle5, null, null, null, null );
		var relativeLayout9 = new primevc.gui.layout.RelativeLayout( primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, 0x000000, primevc.types.Number.INT_NOT_SET );
		var layoutStyle8 = new primevc.gui.styling.LayoutStyle( cast relativeLayout9, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock7 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, cast layoutStyle8, null, null, null, null );
		styleBlock7.superStyle = cast styleBlock0;
		styleBlock4.superStyle = cast styleBlock7;
		this.elementSelectors.set('primevc.gui.components.ApplicationView', cast styleBlock4);
		var graphicsStyle11 = new primevc.gui.styling.GraphicsStyle( null, null, null, null, primevc.gui.behaviours.layout.ClippedLayoutBehaviour, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock10 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle11, null, null, null, null, null );
		styleBlock10.superStyle = cast styleBlock7;
		this.elementSelectors.set('primevc.gui.components.ListView', cast styleBlock10);
		var solidFill14 = new primevc.gui.graphics.fills.SolidFill( 0x005005FF );
		var solidFill16 = new primevc.gui.graphics.fills.SolidFill( 0x000000FF );
		var solidBorder15 = new primevc.gui.graphics.borders.SolidBorder( cast solidFill16, 1, false, primevc.gui.graphics.borders.CapsStyle.NONE, primevc.gui.graphics.borders.JointStyle.ROUND, false );
		var graphicsStyle13 = new primevc.gui.styling.GraphicsStyle( cast solidFill14, cast solidBorder15, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var box18 = new primevc.core.geom.Box( 0x000005, 0x000005, 0x000005, 0x000005 );
		var box19 = new primevc.core.geom.Box( 0x00000A, 0x000000, 0x00000A, 0x000000 );
		var layoutStyle17 = new primevc.gui.styling.LayoutStyle( null, cast box18, cast box19, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		layoutStyle17.minWidth = 0x000064;
		var textStyle20 = new primevc.gui.styling.TextStyle( primevc.types.Number.INT_NOT_SET, null, 0xFFFFFFFF, primevc.gui.text.FontWeight.bold, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var styleBlock12 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle13, cast layoutStyle17, cast textStyle20, null, null, null );
		var solidFill23 = new primevc.gui.graphics.fills.SolidFill( 0x050050FF );
		var graphicsStyle22 = new primevc.gui.styling.GraphicsStyle( cast solidFill23, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var box25 = new primevc.core.geom.Box( 0x00000A, 0x000000, 0x00000A, 0x000000 );
		var layoutStyle24 = new primevc.gui.styling.LayoutStyle( null, null, cast box25, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var textStyle26 = new primevc.gui.styling.TextStyle( 0x000014, 'Verdana', 0xFFFFFFFF, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var styleBlock21 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle22, cast layoutStyle24, cast textStyle26, null, null, null );
		styleBlock21.superStyle = cast styleBlock7;
		styleBlock12.superStyle = cast styleBlock21;
		this.elementSelectors.set('primevc.gui.components.InputField', cast styleBlock12);
		this.elementSelectors.set('primevc.gui.components.Label', cast styleBlock21);
		var graphicsStyle28 = new primevc.gui.styling.GraphicsStyle( null, null, new primevc.gui.graphics.shapes.RegularRectangle(  ), null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var layoutStyle29 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		layoutStyle29.maxWidth = 0x000064;
		layoutStyle29.maxHeight = 0x0000C8;
		var styleBlock27 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle28, cast layoutStyle29, null, null, null, null );
		styleBlock27.superStyle = cast styleBlock0;
		this.elementSelectors.set('primevc.gui.components.Image', cast styleBlock27);
		var solidFill32 = new primevc.gui.graphics.fills.SolidFill( 0xAAAAAAFF );
		var graphicsStyle31 = new primevc.gui.styling.GraphicsStyle( cast solidFill32, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var box34 = new primevc.core.geom.Box( 0x000005, 0x000005, 0x000005, 0x000005 );
		var box35 = new primevc.core.geom.Box( 0x00000A, 0x000000, 0x00000A, 0x000000 );
		var array1 = [ primevc.core.geom.space.Horizontal.center, primevc.core.geom.space.Vertical.center ];
		var classInstanceFactory36 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm, array1 );
		var layoutStyle33 = new primevc.gui.styling.LayoutStyle( null, cast box34, cast box35, cast classInstanceFactory36, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var textStyle37 = new primevc.gui.styling.TextStyle( 0x000014, 'Verdana', 0x000000FF, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var styleBlock30 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle31, cast layoutStyle33, cast textStyle37, null, null, null );
		styleBlock30.superStyle = cast styleBlock7;
		var simpleDictionary_String_primevc_gui_styling_StyleBlock39 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000001 );
		var layoutStyle41 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x000096, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock40 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, cast layoutStyle41, null, null, null, null );
		styleBlock40.extendedStyle = cast styleBlock27;
		styleBlock40.parentStyle = cast styleBlock30;
		simpleDictionary_String_primevc_gui_styling_StyleBlock39.set('primevc.gui.components.Image', cast styleBlock40);
		var styleChildren38 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock39, null, null );
		styleBlock30.children = cast styleChildren38;
		var simpleDictionary_Int_primevc_gui_styling_StyleBlock43 = new primevc.types.SimpleDictionary_Int_primevc_gui_styling_StyleBlock( 0x000002 );
		var textStyle45 = new primevc.gui.styling.TextStyle( primevc.types.Number.INT_NOT_SET, 'Courier New', null, primevc.gui.text.FontWeight.bold, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var styleBlock44 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.elementState, null, null, cast textStyle45, null, null, null );
		styleBlock44.parentStyle = cast styleBlock30;
		simpleDictionary_Int_primevc_gui_styling_StyleBlock43.set(0x000001, cast styleBlock44);
		var textStyle47 = new primevc.gui.styling.TextStyle( primevc.types.Number.INT_NOT_SET, 'Courier New', null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, primevc.gui.text.TextDecoration.underline, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var styleBlock46 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.elementState, null, null, cast textStyle47, null, null, null );
		styleBlock46.parentStyle = cast styleBlock30;
		simpleDictionary_Int_primevc_gui_styling_StyleBlock43.set(0x000002, cast styleBlock46);
		var statesStyle42 = new primevc.gui.styling.StatesStyle( cast simpleDictionary_Int_primevc_gui_styling_StyleBlock43 );
		styleBlock30.states = cast statesStyle42;
		this.elementSelectors.set('primevc.gui.components.Button', cast styleBlock30);
		var solidFill50 = new primevc.gui.graphics.fills.SolidFill( 0xAAAAAAFF );
		var graphicsStyle49 = new primevc.gui.styling.GraphicsStyle( cast solidFill50, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var box52 = new primevc.core.geom.Box( 0x00000A, 0x000000, 0x00000A, 0x000000 );
		var classInstanceFactory53 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.RelativeAlgorithm, null );
		var layoutStyle51 = new primevc.gui.styling.LayoutStyle( null, null, cast box52, cast classInstanceFactory53, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock48 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle49, cast layoutStyle51, null, null, null, null );
		styleBlock48.superStyle = cast styleBlock7;
		this.elementSelectors.set('primevc.gui.components.Slider', cast styleBlock48);
		var array2 = [ primevc.core.geom.space.Vertical.top, primevc.core.geom.space.Horizontal.center ];
		var classInstanceFactory56 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm, array2 );
		var layoutStyle55 = new primevc.gui.styling.LayoutStyle( null, null, null, cast classInstanceFactory56, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock54 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, cast layoutStyle55, null, null, null, null );
		styleBlock54.superStyle = cast styleBlock2;
		this.elementSelectors.set('cases.ComponentsTest', cast styleBlock54);
		this.elementSelectors.set('primevc.gui.core.UIComponent', cast styleBlock7);
		var styleBlock57 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.styleName );
		var simpleDictionary_String_primevc_gui_styling_StyleBlock59 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000007 );
		var solidFill63 = new primevc.gui.graphics.fills.SolidFill( 0xF0FF0FFF );
		var solidBorder62 = new primevc.gui.graphics.borders.SolidBorder( cast solidFill63, 3, false, primevc.gui.graphics.borders.CapsStyle.NONE, primevc.gui.graphics.borders.JointStyle.ROUND, false );
		var graphicsStyle61 = new primevc.gui.styling.GraphicsStyle( null, cast solidBorder62, null, null, null, null, 0.7, null, null );
		var styleBlock60 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle61, null, null, null, null, null );
		styleBlock60.extendedStyle = cast styleBlock7;
		styleBlock60.parentStyle = cast styleBlock57;
		simpleDictionary_String_primevc_gui_styling_StyleBlock59.set('primevc.gui.core.UIComponent', cast styleBlock60);
		var styleBlock64 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock64.superStyle = cast styleBlock60;
		styleBlock64.parentStyle = cast styleBlock57;
		simpleDictionary_String_primevc_gui_styling_StyleBlock59.set('primevc.gui.components.ApplicationView', cast styleBlock64);
		var styleBlock65 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock65.superStyle = cast styleBlock60;
		styleBlock65.parentStyle = cast styleBlock57;
		simpleDictionary_String_primevc_gui_styling_StyleBlock59.set('primevc.gui.components.Button', cast styleBlock65);
		var styleBlock66 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		var styleBlock67 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock67.superStyle = cast styleBlock60;
		styleBlock67.parentStyle = cast styleBlock57;
		styleBlock66.superStyle = cast styleBlock67;
		styleBlock66.parentStyle = cast styleBlock57;
		simpleDictionary_String_primevc_gui_styling_StyleBlock59.set('primevc.gui.components.InputField', cast styleBlock66);
		simpleDictionary_String_primevc_gui_styling_StyleBlock59.set('primevc.gui.components.Label', cast styleBlock67);
		var styleBlock68 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock68.superStyle = cast styleBlock60;
		styleBlock68.parentStyle = cast styleBlock57;
		simpleDictionary_String_primevc_gui_styling_StyleBlock59.set('primevc.gui.components.ListView', cast styleBlock68);
		var styleBlock69 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock69.superStyle = cast styleBlock60;
		styleBlock69.parentStyle = cast styleBlock57;
		simpleDictionary_String_primevc_gui_styling_StyleBlock59.set('primevc.gui.components.Slider', cast styleBlock69);
		var styleChildren58 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock59, null, null );
		styleBlock57.children = cast styleChildren58;
		this.styleNameSelectors.set('debug', cast styleBlock57);
		var layoutStyle71 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x0000C8, 0x000004, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock70 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.styleName, null, cast layoutStyle71, null, null, null, null );
		var simpleDictionary_String_primevc_gui_styling_StyleBlock73 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000003 );
		var solidFill76 = new primevc.gui.graphics.fills.SolidFill( 0x000000FF );
		var graphicsStyle75 = new primevc.gui.styling.GraphicsStyle( cast solidFill76, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var layoutStyle77 = new primevc.gui.styling.LayoutStyle( null, null, null, null, 0, 1, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock74 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle75, cast layoutStyle77, null, null, null, null );
		styleBlock74.superStyle = cast styleBlock0;
		styleBlock74.parentStyle = cast styleBlock70;
		simpleDictionary_String_primevc_gui_styling_StyleBlock73.set('primevc.gui.core.UIGraphic', cast styleBlock74);
		var solidFill80 = new primevc.gui.graphics.fills.SolidFill( 0x666666FF );
		var graphicsStyle79 = new primevc.gui.styling.GraphicsStyle( cast solidFill80, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var relativeLayout82 = new primevc.gui.layout.RelativeLayout( primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, 0x000000 );
		var layoutStyle81 = new primevc.gui.styling.LayoutStyle( cast relativeLayout82, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x000006, 0x00000F, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock78 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle79, cast layoutStyle81, null, null, null, null );
		styleBlock78.extendedStyle = cast styleBlock30;
		styleBlock78.parentStyle = cast styleBlock70;
		simpleDictionary_String_primevc_gui_styling_StyleBlock73.set('primevc.gui.components.Button', cast styleBlock78);
		var styleBlock83 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock83.superStyle = cast styleBlock74;
		styleBlock83.parentStyle = cast styleBlock70;
		simpleDictionary_String_primevc_gui_styling_StyleBlock73.set('primevc.gui.components.Image', cast styleBlock83);
		var styleChildren72 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock73, null, null );
		styleBlock70.children = cast styleChildren72;
		this.styleNameSelectors.set('horizontalSlider', cast styleBlock70);
		var layoutStyle85 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x000004, 0x0000C8, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock84 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.styleName, null, cast layoutStyle85, null, null, null, null );
		var simpleDictionary_String_primevc_gui_styling_StyleBlock87 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000003 );
		var solidFill90 = new primevc.gui.graphics.fills.SolidFill( 0x000000FF );
		var graphicsStyle89 = new primevc.gui.styling.GraphicsStyle( cast solidFill90, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var relativeLayout92 = new primevc.gui.layout.RelativeLayout( primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, 0x000000, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var layoutStyle91 = new primevc.gui.styling.LayoutStyle( cast relativeLayout92, null, null, null, 1, 0, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock88 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle89, cast layoutStyle91, null, null, null, null );
		styleBlock88.superStyle = cast styleBlock0;
		styleBlock88.parentStyle = cast styleBlock84;
		simpleDictionary_String_primevc_gui_styling_StyleBlock87.set('primevc.gui.core.UIGraphic', cast styleBlock88);
		var solidFill95 = new primevc.gui.graphics.fills.SolidFill( 0x666666FF );
		var graphicsStyle94 = new primevc.gui.styling.GraphicsStyle( cast solidFill95, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var relativeLayout97 = new primevc.gui.layout.RelativeLayout( primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, 0x000000, primevc.types.Number.INT_NOT_SET );
		var layoutStyle96 = new primevc.gui.styling.LayoutStyle( cast relativeLayout97, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x00000F, 0x000006, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock93 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle94, cast layoutStyle96, null, null, null, null );
		styleBlock93.extendedStyle = cast styleBlock30;
		styleBlock93.parentStyle = cast styleBlock84;
		simpleDictionary_String_primevc_gui_styling_StyleBlock87.set('primevc.gui.components.Button', cast styleBlock93);
		var styleBlock98 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock98.superStyle = cast styleBlock88;
		styleBlock98.parentStyle = cast styleBlock84;
		simpleDictionary_String_primevc_gui_styling_StyleBlock87.set('primevc.gui.components.Image', cast styleBlock98);
		var styleChildren86 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock87, null, null );
		styleBlock84.children = cast styleChildren86;
		this.styleNameSelectors.set('verticalSlider', cast styleBlock84);
	}
}