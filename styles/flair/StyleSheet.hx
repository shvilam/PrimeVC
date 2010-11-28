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
		styleBlock4.superStyle = cast styleBlock0;
		this.elementSelectors.set('primevc.gui.components.ApplicationView', cast styleBlock4);
		var graphicsStyle8 = new primevc.gui.styling.GraphicsStyle( null, null, null, null, primevc.gui.behaviours.layout.ClippedLayoutBehaviour, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock7 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle8, null, null, null, null, null );
		styleBlock7.superStyle = cast styleBlock0;
		this.elementSelectors.set('primevc.gui.components.ListView', cast styleBlock7);
		var solidFill12 = new primevc.gui.graphics.fills.SolidFill( 0x000000FF );
		var solidBorder11 = new primevc.gui.graphics.borders.SolidBorder( cast solidFill12, 1, false, primevc.gui.graphics.borders.CapsStyle.NONE, primevc.gui.graphics.borders.JointStyle.ROUND, false );
		var graphicsStyle10 = new primevc.gui.styling.GraphicsStyle( null, cast solidBorder11, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock9 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle10, null, null, null, null, null );
		var textStyle14 = new primevc.gui.styling.TextStyle( 0x000014, 'Verdana', null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var styleBlock13 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, null, cast textStyle14, null, null, null );
		styleBlock13.superStyle = cast styleBlock0;
		styleBlock9.superStyle = cast styleBlock13;
		this.elementSelectors.set('primevc.gui.components.InputField', cast styleBlock9);
		this.elementSelectors.set('primevc.gui.components.Label', cast styleBlock13);
		var graphicsStyle16 = new primevc.gui.styling.GraphicsStyle( null, null, new primevc.gui.graphics.shapes.RegularRectangle(  ), null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock15 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle16, null, null, null, null, null );
		styleBlock15.superStyle = cast styleBlock0;
		this.elementSelectors.set('primevc.gui.components.Image', cast styleBlock15);
		var solidFill19 = new primevc.gui.graphics.fills.SolidFill( 0xFFFFFF00 );
		var graphicsStyle18 = new primevc.gui.styling.GraphicsStyle( cast solidFill19, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var array1 = [ primevc.core.geom.space.Horizontal.center, primevc.core.geom.space.Vertical.center ];
		var classInstanceFactory21 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm, array1 );
		var layoutStyle20 = new primevc.gui.styling.LayoutStyle( null, null, null, cast classInstanceFactory21, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var textStyle22 = new primevc.gui.styling.TextStyle( 0x000014, 'Verdana', 0x000000FF, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var styleBlock17 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle18, cast layoutStyle20, cast textStyle22, null, null, null );
		styleBlock17.superStyle = cast styleBlock0;
		this.elementSelectors.set('primevc.gui.components.Button', cast styleBlock17);
		var solidFill25 = new primevc.gui.graphics.fills.SolidFill( 0xFFFFFFFF );
		var graphicsStyle24 = new primevc.gui.styling.GraphicsStyle( cast solidFill25, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var classInstanceFactory27 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.RelativeAlgorithm, null );
		var layoutStyle26 = new primevc.gui.styling.LayoutStyle( null, null, null, cast classInstanceFactory27, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock23 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle24, cast layoutStyle26, null, null, null, null );
		styleBlock23.superStyle = cast styleBlock0;
		this.elementSelectors.set('primevc.gui.components.Slider', cast styleBlock23);
		var classInstanceFactory30 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.RelativeAlgorithm, null );
		var layoutStyle29 = new primevc.gui.styling.LayoutStyle( null, null, null, cast classInstanceFactory30, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock28 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, cast layoutStyle29, null, null, null, null );
		styleBlock28.superStyle = cast styleBlock2;
		this.elementSelectors.set('cases.GlobalTest', cast styleBlock28);
		var solidFill34 = new primevc.gui.graphics.fills.SolidFill( 0x000000FF );
		var solidBorder33 = new primevc.gui.graphics.borders.SolidBorder( cast solidFill34, 1, true, primevc.gui.graphics.borders.CapsStyle.NONE, primevc.gui.graphics.borders.JointStyle.ROUND, false );
		var graphicsStyle32 = new primevc.gui.styling.GraphicsStyle( null, cast solidBorder33, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var relativeLayout36 = new primevc.gui.layout.RelativeLayout( 0x000005, 0x000005, 0x000037, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var box37 = new primevc.core.geom.Box( 0x000005, 0x000005, 0x000005, 0x000005 );
		var classInstanceFactory38 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm, null );
		var layoutStyle35 = new primevc.gui.styling.LayoutStyle( cast relativeLayout36, cast box37, null, cast classInstanceFactory38, 0.6, primevc.types.Number.EMPTY, primevc.types.Number.INT_NOT_SET, primevc.types.Number.EMPTY, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock31 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle32, cast layoutStyle35, null, null, null, null );
		styleBlock31.superStyle = cast styleBlock4;
		this.elementSelectors.set('cases.GlobalApp', cast styleBlock31);
		var solidFill41 = new primevc.gui.graphics.fills.SolidFill( 0xFF0000FF );
		var solidFill43 = new primevc.gui.graphics.fills.SolidFill( 0x000000FF );
		var solidBorder42 = new primevc.gui.graphics.borders.SolidBorder( cast solidFill43, 1, false, primevc.gui.graphics.borders.CapsStyle.NONE, primevc.gui.graphics.borders.JointStyle.ROUND, false );
		var graphicsStyle40 = new primevc.gui.styling.GraphicsStyle( cast solidFill41, cast solidBorder42, null, null, null, null, 0.5, null, null );
		var box45 = new primevc.core.geom.Box( 0x000003, 0x000003, 0x000003, 0x000003 );
		var layoutStyle44 = new primevc.gui.styling.LayoutStyle( null, null, cast box45, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		layoutStyle44.minWidth = 0x00000F;
		layoutStyle44.minHeight = 0x00000F;
		var textStyle46 = new primevc.gui.styling.TextStyle( primevc.types.Number.INT_NOT_SET, null, 0x000000FF, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var moveEffect48 = new primevc.gui.effects.MoveEffect( 0x0000C8, primevc.types.Number.INT_NOT_SET, feffects.easing.Circ.easeOut, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET );
		var effectsStyle47 = new primevc.gui.styling.EffectsStyle( cast moveEffect48, null, null, null, null, null );
		var styleBlock39 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle40, cast layoutStyle44, cast textStyle46, cast effectsStyle47, null, null );
		styleBlock39.superStyle = cast styleBlock0;
		this.elementSelectors.set('cases.Tile', cast styleBlock39);
		var solidFill51 = new primevc.gui.graphics.fills.SolidFill( 0xABCDEF44 );
		var solidFill53 = new primevc.gui.graphics.fills.SolidFill( 0xFEDCBAAA );
		var solidBorder52 = new primevc.gui.graphics.borders.SolidBorder( cast solidFill53, 3, false, primevc.gui.graphics.borders.CapsStyle.NONE, primevc.gui.graphics.borders.JointStyle.ROUND, false );
		var graphicsStyle50 = new primevc.gui.styling.GraphicsStyle( cast solidFill51, cast solidBorder52, null, null, primevc.gui.behaviours.layout.ClippedLayoutBehaviour, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var box55 = new primevc.core.geom.Box( 0x00000A, 0x00000A, 0x00000A, 0x00000A );
		var layoutStyle54 = new primevc.gui.styling.LayoutStyle( null, cast box55, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var moveEffect57 = new primevc.gui.effects.MoveEffect( 0x00012C, primevc.types.Number.INT_NOT_SET, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET );
		var resizeEffect58 = new primevc.gui.effects.ResizeEffect( 0x00012C, primevc.types.Number.INT_NOT_SET, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET );
		var effectsStyle56 = new primevc.gui.styling.EffectsStyle( cast moveEffect57, cast resizeEffect58, null, null, null, null );
		var styleBlock49 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle50, cast layoutStyle54, null, cast effectsStyle56, null, null );
		styleBlock49.superStyle = cast styleBlock7;
		this.elementSelectors.set('cases.TileList', cast styleBlock49);
		var styleBlock59 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.styleName );
		var simpleDictionary_String_primevc_gui_styling_StyleBlock61 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x00000A );
		var solidFill65 = new primevc.gui.graphics.fills.SolidFill( 0xF0FF0FFF );
		var solidBorder64 = new primevc.gui.graphics.borders.SolidBorder( cast solidFill65, 3, false, primevc.gui.graphics.borders.CapsStyle.NONE, primevc.gui.graphics.borders.JointStyle.ROUND, false );
		var graphicsStyle63 = new primevc.gui.styling.GraphicsStyle( null, cast solidBorder64, null, null, null, null, 0.7, null, null );
		var styleBlock62 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle63, null, null, null, null, null );
		styleBlock62.superStyle = cast styleBlock0;
		styleBlock62.parentStyle = cast styleBlock59;
		simpleDictionary_String_primevc_gui_styling_StyleBlock61.set('primevc.gui.core.UIComponent', cast styleBlock62);
		var styleBlock66 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock66.superStyle = cast styleBlock62;
		styleBlock66.parentStyle = cast styleBlock59;
		simpleDictionary_String_primevc_gui_styling_StyleBlock61.set('primevc.gui.components.ApplicationView', cast styleBlock66);
		var styleBlock67 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock67.superStyle = cast styleBlock62;
		styleBlock67.parentStyle = cast styleBlock59;
		simpleDictionary_String_primevc_gui_styling_StyleBlock61.set('primevc.gui.components.Button', cast styleBlock67);
		var styleBlock68 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		var styleBlock69 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock69.superStyle = cast styleBlock62;
		styleBlock69.parentStyle = cast styleBlock59;
		styleBlock68.superStyle = cast styleBlock69;
		styleBlock68.parentStyle = cast styleBlock59;
		simpleDictionary_String_primevc_gui_styling_StyleBlock61.set('primevc.gui.components.InputField', cast styleBlock68);
		simpleDictionary_String_primevc_gui_styling_StyleBlock61.set('primevc.gui.components.Label', cast styleBlock69);
		var styleBlock70 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock70.superStyle = cast styleBlock62;
		styleBlock70.parentStyle = cast styleBlock59;
		simpleDictionary_String_primevc_gui_styling_StyleBlock61.set('primevc.gui.components.ListView', cast styleBlock70);
		var styleBlock71 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock71.superStyle = cast styleBlock62;
		styleBlock71.parentStyle = cast styleBlock59;
		simpleDictionary_String_primevc_gui_styling_StyleBlock61.set('primevc.gui.components.Slider', cast styleBlock71);
		var styleBlock72 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock72.superStyle = cast styleBlock62;
		styleBlock72.parentStyle = cast styleBlock59;
		simpleDictionary_String_primevc_gui_styling_StyleBlock61.set('cases.Tile', cast styleBlock72);
		var styleBlock73 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock73.superStyle = cast styleBlock70;
		styleBlock73.parentStyle = cast styleBlock59;
		simpleDictionary_String_primevc_gui_styling_StyleBlock61.set('cases.TileList', cast styleBlock73);
		var styleBlock74 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock74.superStyle = cast styleBlock66;
		styleBlock74.parentStyle = cast styleBlock59;
		simpleDictionary_String_primevc_gui_styling_StyleBlock61.set('cases.GlobalApp', cast styleBlock74);
		var styleChildren60 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock61, null, null );
		styleBlock59.children = cast styleChildren60;
		this.styleNameSelectors.set('debug', cast styleBlock59);
		var layoutStyle76 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x0000C8, 0x000004, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock75 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.styleName, null, cast layoutStyle76, null, null, null, null );
		var simpleDictionary_String_primevc_gui_styling_StyleBlock78 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000003 );
		var layoutStyle80 = new primevc.gui.styling.LayoutStyle( null, null, null, null, 0, 1, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock79 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, cast layoutStyle80, null, null, null, null );
		styleBlock79.superStyle = cast styleBlock0;
		styleBlock79.parentStyle = cast styleBlock75;
		simpleDictionary_String_primevc_gui_styling_StyleBlock78.set('primevc.gui.core.UIGraphic', cast styleBlock79);
		var solidFill83 = new primevc.gui.graphics.fills.SolidFill( 0x666666FF );
		var graphicsStyle82 = new primevc.gui.styling.GraphicsStyle( cast solidFill83, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var relativeLayout85 = new primevc.gui.layout.RelativeLayout( primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, 0x000000 );
		var layoutStyle84 = new primevc.gui.styling.LayoutStyle( cast relativeLayout85, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x000006, 0x00000F, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock81 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle82, cast layoutStyle84, null, null, null, null );
		styleBlock81.extendedStyle = cast styleBlock17;
		styleBlock81.parentStyle = cast styleBlock75;
		simpleDictionary_String_primevc_gui_styling_StyleBlock78.set('primevc.gui.components.Button', cast styleBlock81);
		var styleBlock86 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock86.superStyle = cast styleBlock79;
		styleBlock86.parentStyle = cast styleBlock75;
		simpleDictionary_String_primevc_gui_styling_StyleBlock78.set('primevc.gui.components.Image', cast styleBlock86);
		var styleChildren77 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock78, null, null );
		styleBlock75.children = cast styleChildren77;
		this.styleNameSelectors.set('horizontalSlider', cast styleBlock75);
		var layoutStyle88 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x000004, 0x0000C8, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock87 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.styleName, null, cast layoutStyle88, null, null, null, null );
		var simpleDictionary_String_primevc_gui_styling_StyleBlock90 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000003 );
		var relativeLayout93 = new primevc.gui.layout.RelativeLayout( primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, 0x000000, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var layoutStyle92 = new primevc.gui.styling.LayoutStyle( cast relativeLayout93, null, null, null, 1, 0, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock91 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, cast layoutStyle92, null, null, null, null );
		styleBlock91.superStyle = cast styleBlock0;
		styleBlock91.parentStyle = cast styleBlock87;
		simpleDictionary_String_primevc_gui_styling_StyleBlock90.set('primevc.gui.core.UIGraphic', cast styleBlock91);
		var solidFill96 = new primevc.gui.graphics.fills.SolidFill( 0x666666FF );
		var graphicsStyle95 = new primevc.gui.styling.GraphicsStyle( cast solidFill96, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var relativeLayout98 = new primevc.gui.layout.RelativeLayout( primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, 0x000000, primevc.types.Number.INT_NOT_SET );
		var layoutStyle97 = new primevc.gui.styling.LayoutStyle( cast relativeLayout98, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x00000F, 0x000006, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock94 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle95, cast layoutStyle97, null, null, null, null );
		styleBlock94.extendedStyle = cast styleBlock17;
		styleBlock94.parentStyle = cast styleBlock87;
		simpleDictionary_String_primevc_gui_styling_StyleBlock90.set('primevc.gui.components.Button', cast styleBlock94);
		var styleBlock99 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element );
		styleBlock99.superStyle = cast styleBlock91;
		styleBlock99.parentStyle = cast styleBlock87;
		simpleDictionary_String_primevc_gui_styling_StyleBlock90.set('primevc.gui.components.Image', cast styleBlock99);
		var styleChildren89 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock90, null, null );
		styleBlock87.children = cast styleChildren89;
		this.styleNameSelectors.set('verticalSlider', cast styleBlock87);
		var graphicsStyle101 = new primevc.gui.styling.GraphicsStyle( null, null, null, null, null, true, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var layoutStyle102 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x00003C, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock100 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.styleName, cast graphicsStyle101, cast layoutStyle102, null, null, null, null );
		this.styleNameSelectors.set('odd', cast styleBlock100);
		var graphicsStyle104 = new primevc.gui.styling.GraphicsStyle( null, null, null, null, primevc.gui.behaviours.scroll.DragScrollBehaviour, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var relativeLayout106 = new primevc.gui.layout.RelativeLayout( 0x00005A, primevc.types.Number.INT_NOT_SET, 0x000005, 0x000005, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var array2 = [ primevc.core.geom.space.Direction.vertical, 0x000008, primevc.core.geom.space.Horizontal.left, primevc.core.geom.space.Vertical.top ];
		var classInstanceFactory107 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.tile.FixedTileAlgorithm, array2 );
		var layoutStyle105 = new primevc.gui.styling.LayoutStyle( cast relativeLayout106, null, null, cast classInstanceFactory107, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock103 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.id, cast graphicsStyle104, cast layoutStyle105, null, null, null, null );
		var simpleDictionary_String_primevc_gui_styling_StyleBlock109 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000001 );
		var graphicsStyle111 = new primevc.gui.styling.GraphicsStyle( null, null, new primevc.gui.graphics.shapes.Triangle( null ), null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var layoutStyle112 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		layoutStyle112.minWidth = 0x00001E;
		var sequenceEffect114 = new primevc.gui.effects.SequenceEffect( 0x00015E, primevc.types.Number.INT_NOT_SET, null );
		var parallelEffect115 = new primevc.gui.effects.ParallelEffect( 0x00015E, primevc.types.Number.INT_NOT_SET, null );
		var fadeEffect116 = new primevc.gui.effects.FadeEffect( 0x0001F4, primevc.types.Number.INT_NOT_SET, null, primevc.types.Number.FLOAT_NOT_SET, 0.4 );
		parallelEffect115.add(cast fadeEffect116);
		var moveEffect117 = new primevc.gui.effects.MoveEffect( 0x00012C, primevc.types.Number.INT_NOT_SET, feffects.easing.Circ.easeOut, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET );
		parallelEffect115.add(cast moveEffect117);
		sequenceEffect114.add(cast parallelEffect115);
		var fadeEffect118 = new primevc.gui.effects.FadeEffect( 0x000258, primevc.types.Number.INT_NOT_SET, null, primevc.types.Number.FLOAT_NOT_SET, 1 );
		sequenceEffect114.add(cast fadeEffect118);
		var effectsStyle113 = new primevc.gui.styling.EffectsStyle( cast sequenceEffect114, null, null, null, null, null );
		var styleBlock110 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle111, cast layoutStyle112, null, cast effectsStyle113, null, null );
		styleBlock110.extendedStyle = cast styleBlock39;
		styleBlock110.parentStyle = cast styleBlock103;
		simpleDictionary_String_primevc_gui_styling_StyleBlock109.set('cases.Tile', cast styleBlock110);
		var simpleDictionary_String_primevc_gui_styling_StyleBlock119 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000001 );
		var solidFill122 = new primevc.gui.graphics.fills.SolidFill( 0x000000FF );
		var graphicsStyle121 = new primevc.gui.styling.GraphicsStyle( cast solidFill122, null, new primevc.gui.graphics.shapes.RegularRectangle(  ), null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var layoutStyle123 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, 0x000064, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock120 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.styleName, cast graphicsStyle121, cast layoutStyle123, null, null, null, null );
		styleBlock120.extendedStyle = cast styleBlock100;
		styleBlock120.parentStyle = cast styleBlock103;
		simpleDictionary_String_primevc_gui_styling_StyleBlock119.set('odd', cast styleBlock120);
		var styleChildren108 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock109, cast simpleDictionary_String_primevc_gui_styling_StyleBlock119, null );
		styleBlock103.children = cast styleChildren108;
		this.idSelectors.set('frame2', cast styleBlock103);
		var graphicsStyle125 = new primevc.gui.styling.GraphicsStyle( null, null, null, null, primevc.gui.behaviours.scroll.CornerScrollBehaviour, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var array3 = [ primevc.core.geom.space.Vertical.bottom, primevc.core.geom.space.Horizontal.center ];
		var classInstanceFactory127 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm, array3 );
		var layoutStyle126 = new primevc.gui.styling.LayoutStyle( null, null, null, cast classInstanceFactory127, primevc.types.Number.FLOAT_NOT_SET, 1, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock124 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.id, cast graphicsStyle125, cast layoutStyle126, null, null, null, null );
		var simpleDictionary_String_primevc_gui_styling_StyleBlock129 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000001 );
		var solidFill132 = new primevc.gui.graphics.fills.SolidFill( 0x0000FFFF );
		var graphicsStyle131 = new primevc.gui.styling.GraphicsStyle( cast solidFill132, null, new primevc.gui.graphics.shapes.Ellipse(  ), null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var moveEffect134 = new primevc.gui.effects.MoveEffect( 0x000190, primevc.types.Number.INT_NOT_SET, feffects.easing.Elastic.easeOut, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET );
		var effectsStyle133 = new primevc.gui.styling.EffectsStyle( cast moveEffect134, null, null, null, null, null );
		var styleBlock130 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle131, null, null, cast effectsStyle133, null, null );
		styleBlock130.extendedStyle = cast styleBlock39;
		styleBlock130.parentStyle = cast styleBlock124;
		simpleDictionary_String_primevc_gui_styling_StyleBlock129.set('cases.Tile', cast styleBlock130);
		var styleChildren128 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock129, null, null );
		styleBlock124.children = cast styleChildren128;
		this.idSelectors.set('frame0', cast styleBlock124);
		var graphicsStyle136 = new primevc.gui.styling.GraphicsStyle( null, null, null, null, primevc.gui.behaviours.scroll.MouseMoveScrollBehaviour, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var relativeLayout138 = new primevc.gui.layout.RelativeLayout( 0x000005, 0x000005, primevc.types.Number.INT_NOT_SET, 0x000005, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET );
		var array4 = [ primevc.core.geom.space.Horizontal.left, null ];
		var classInstanceFactory139 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm, array4 );
		var layoutStyle137 = new primevc.gui.styling.LayoutStyle( cast relativeLayout138, null, null, cast classInstanceFactory139, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.INT_NOT_SET, 0x00003C, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock135 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.id, cast graphicsStyle136, cast layoutStyle137, null, null, null, null );
		var simpleDictionary_String_primevc_gui_styling_StyleBlock141 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000001 );
		var solidFill144 = new primevc.gui.graphics.fills.SolidFill( 0x00FF00FF );
		var graphicsStyle143 = new primevc.gui.styling.GraphicsStyle( cast solidFill144, null, new primevc.gui.graphics.shapes.Circle(  ), null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock142 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, cast graphicsStyle143, null, null, null, null, null );
		styleBlock142.extendedStyle = cast styleBlock39;
		styleBlock142.parentStyle = cast styleBlock135;
		simpleDictionary_String_primevc_gui_styling_StyleBlock141.set('cases.Tile', cast styleBlock142);
		var styleChildren140 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock141, null, null );
		styleBlock135.children = cast styleChildren140;
		this.idSelectors.set('frame1', cast styleBlock135);
		var array6 = [ null, null, false ];
		var classInstanceFactory148 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.circle.HorizontalCircleAlgorithm, array6 );
		var array7 = [ null, null, false ];
		var classInstanceFactory149 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.circle.VerticalCircleAlgorithm, array7 );
		var array5 = [ cast classInstanceFactory148, cast classInstanceFactory149 ];
		var classInstanceFactory147 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.DynamicLayoutAlgorithm, array5 );
		var layoutStyle146 = new primevc.gui.styling.LayoutStyle( null, null, null, cast classInstanceFactory147, 1, 0.4, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock145 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.id, null, cast layoutStyle146, null, null, null, null );
		var simpleDictionary_String_primevc_gui_styling_StyleBlock151 = new primevc.types.SimpleDictionary_String_primevc_gui_styling_StyleBlock( 0x000001 );
		var sequenceEffect154 = new primevc.gui.effects.SequenceEffect( 0x00015E, primevc.types.Number.INT_NOT_SET, null );
		var parallelEffect155 = new primevc.gui.effects.ParallelEffect( 0x00015E, primevc.types.Number.INT_NOT_SET, null );
		var rotateEffect156 = new primevc.gui.effects.RotateEffect( 0x0001F4, primevc.types.Number.INT_NOT_SET, null, primevc.types.Number.FLOAT_NOT_SET, 360 );
		parallelEffect155.add(cast rotateEffect156);
		var moveEffect157 = new primevc.gui.effects.MoveEffect( 0x0001F4, primevc.types.Number.INT_NOT_SET, null, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET );
		parallelEffect155.add(cast moveEffect157);
		sequenceEffect154.add(cast parallelEffect155);
		var rotateEffect158 = new primevc.gui.effects.RotateEffect( 0x000190, primevc.types.Number.INT_NOT_SET, null, primevc.types.Number.FLOAT_NOT_SET, -360 );
		sequenceEffect154.add(cast rotateEffect158);
		var fadeEffect159 = new primevc.gui.effects.FadeEffect( 0x00015E, primevc.types.Number.INT_NOT_SET, null, 0, 1 );
		var effectsStyle153 = new primevc.gui.styling.EffectsStyle( cast sequenceEffect154, null, null, null, cast fadeEffect159, null );
		var styleBlock152 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.element, null, null, null, cast effectsStyle153, null, null );
		styleBlock152.extendedStyle = cast styleBlock39;
		styleBlock152.parentStyle = cast styleBlock145;
		simpleDictionary_String_primevc_gui_styling_StyleBlock151.set('cases.Tile', cast styleBlock152);
		var styleChildren150 = new primevc.gui.styling.StyleChildren( cast simpleDictionary_String_primevc_gui_styling_StyleBlock151, null, null );
		styleBlock145.children = cast styleChildren150;
		this.idSelectors.set('frame8', cast styleBlock145);
		var classInstanceFactory162 = new primevc.types.ClassInstanceFactory( primevc.gui.layout.algorithms.tile.DynamicTileAlgorithm, null );
		var layoutStyle161 = new primevc.gui.styling.LayoutStyle( null, null, null, cast classInstanceFactory162, 1, 0.4, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock160 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.id, null, cast layoutStyle161, null, null, null, null );
		this.idSelectors.set('frame3', cast styleBlock160);
		var solidFill165 = new primevc.gui.graphics.fills.SolidFill( 0xA00A00FF );
		var graphicsStyle164 = new primevc.gui.styling.GraphicsStyle( cast solidFill165, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var layoutStyle166 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.gui.layout.LayoutFlags.FILL, 1, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock163 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.id, cast graphicsStyle164, cast layoutStyle166, null, null, null, null );
		this.idSelectors.set('frame4', cast styleBlock163);
		var solidFill169 = new primevc.gui.graphics.fills.SolidFill( 0x0A00A0FF );
		var graphicsStyle168 = new primevc.gui.styling.GraphicsStyle( cast solidFill169, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var layoutStyle170 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.gui.layout.LayoutFlags.FILL, 1, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock167 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.id, cast graphicsStyle168, cast layoutStyle170, null, null, null, null );
		this.idSelectors.set('frame5', cast styleBlock167);
		var solidFill173 = new primevc.gui.graphics.fills.SolidFill( 0x00A00AFF );
		var graphicsStyle172 = new primevc.gui.styling.GraphicsStyle( cast solidFill173, null, null, null, null, null, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var layoutStyle174 = new primevc.gui.styling.LayoutStyle( null, null, null, null, primevc.gui.layout.LayoutFlags.FILL, 1, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock171 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.id, cast graphicsStyle172, cast layoutStyle174, null, null, null, null );
		this.idSelectors.set('frame6', cast styleBlock171);
		var layoutStyle176 = new primevc.gui.styling.LayoutStyle( null, null, null, null, 0.6, 0.05, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.INT_NOT_SET, primevc.types.Number.FLOAT_NOT_SET, null, null );
		var styleBlock175 = new primevc.gui.styling.StyleBlock( primevc.gui.styling.StyleBlockType.id, null, cast layoutStyle176, null, null, null, null );
		this.idSelectors.set('frame7', cast styleBlock175);
	}
}