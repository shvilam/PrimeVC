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
 import primevc.gui.styling.LayoutStyleFlags;
 import primevc.gui.styling.StyleChildren;
 import primevc.gui.styling.StyleBlockType;
 import primevc.gui.styling.StyleBlock;
 import primevc.types.Number;
 import primevc.gui.graphics.borders.JointStyle;
 import primevc.gui.text.TextTransform;
 import primevc.core.geom.Corners;
 import primevc.gui.graphics.borders.SolidBorder;
 import primevc.gui.layout.algorithms.RelativeAlgorithm;
 import primevc.core.geom.space.Horizontal;
 import primevc.gui.layout.RelativeLayout;
 import primevc.gui.graphics.shapes.RegularRectangle;
 import primevc.gui.styling.LayoutStyle;
 import primevc.types.ClassInstanceFactory;
 import primevc.core.geom.Box;
 import primevc.gui.styling.GraphicsStyle;
 import primevc.gui.graphics.borders.CapsStyle;
 import primevc.gui.styling.EffectsStyle;
 import primevc.gui.graphics.fills.SolidFill;
 import primevc.gui.styling.TextStyle;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.styling.StatesStyle;
 import primevc.gui.styling.StyleBlock;
 import primevc.gui.styling.StyleBlockType;
 import primevc.core.geom.space.Vertical;
 import primevc.gui.effects.MoveEffect;



/**
 * This class is a template for generating UIElementStyle classes
 */
class StyleSheet extends StyleBlock
{
	public function new ()
	{
		super(StyleBlockType.specific);
		elementChildren		= new ChildrenList();
		styleNameChildren	= new ChildrenList();
		idChildren			= new ChildrenList();
		
		
		var graphicsStyle1 = new GraphicsStyle( null, null, new RegularRectangle(  ), null, null, true, 1 );
		var styleBlock0 = new StyleBlock( StyleBlockType.element, graphicsStyle1 );
		this.elementChildren.set('primevc.gui.display.IDisplayObject', styleBlock0);
		var graphicsStyle3 = new GraphicsStyle( null, null, null, null, primevc.gui.behaviours.layout.ClippedLayoutBehaviour );
		var styleBlock2 = new StyleBlock( StyleBlockType.element, graphicsStyle3 );
		styleBlock2.superStyle = styleBlock0;
		this.elementChildren.set('primevc.gui.core.UIWindow', styleBlock2);
		var graphicsStyle5 = new GraphicsStyle( null, null, new RegularRectangle(  ) );
		var styleBlock4 = new StyleBlock( StyleBlockType.element, graphicsStyle5 );
		styleBlock4.superStyle = styleBlock0;
		this.elementChildren.set('primevc.gui.core.UIGraphic', styleBlock4);
		var array0 = [ Vertical.top, Horizontal.center ];
		var classInstanceFactory8 = new ClassInstanceFactory( VerticalFloatAlgorithm, array0 );
		var layoutStyle7 = new LayoutStyle( null, null, null, cast classInstanceFactory8, 1, 1 );
		var styleBlock6 = new StyleBlock( StyleBlockType.element, null, layoutStyle7 );
		styleBlock6.superStyle = styleBlock0;
		this.elementChildren.set('primevc.gui.components.ApplicationView', styleBlock6);
		var array1 = [ Vertical.top, Horizontal.left ];
		var classInstanceFactory11 = new ClassInstanceFactory( VerticalFloatAlgorithm, array1 );
		var layoutStyle10 = new LayoutStyle( null, null, null, cast classInstanceFactory11 );
		var styleBlock9 = new StyleBlock( StyleBlockType.element, null, layoutStyle10 );
		styleBlock9.superStyle = styleBlock0;
		var simpleDictionary12 = new Hash(  );
		var layoutStyle14 = new LayoutStyle( null, null, null, null, 1, 1 );
		var styleBlock13 = new StyleBlock( StyleBlockType.element, null, layoutStyle14 );
		styleBlock13.superStyle = styleBlock0;
		styleBlock13.parentStyle = styleBlock9;
		simpleDictionary12.set('primevc.gui.components.ListView', styleBlock13);
		styleBlock9.elementChildren = simpleDictionary12;
		this.elementChildren.set('primevc.gui.components.ListHolder', styleBlock9);
		var solidFill18 = new SolidFill( 0x000000FF );
		var solidBorder17 = new SolidBorder( solidFill18, 1, false, CapsStyle.NONE, JointStyle.ROUND, false );
		var graphicsStyle16 = new GraphicsStyle( null, solidBorder17 );
		var styleBlock15 = new StyleBlock( StyleBlockType.element, graphicsStyle16 );
		var solidFill21 = new SolidFill( 0xAAAAAAFF );
		var graphicsStyle20 = new GraphicsStyle( solidFill21 );
		var array2 = [ Horizontal.center, Vertical.center ];
		var classInstanceFactory23 = new ClassInstanceFactory( HorizontalFloatAlgorithm, array2 );
		var layoutStyle22 = new LayoutStyle( null, null, null, cast classInstanceFactory23 );
		var textStyle24 = new TextStyle( 10, 'Arial', 0xFFFFFFFF );
		var styleBlock19 = new StyleBlock( StyleBlockType.element, graphicsStyle20, layoutStyle22, textStyle24 );
		styleBlock19.superStyle = styleBlock0;
		var simpleDictionary26 = new IntHash(  );
		var solidFill29 = new SolidFill( 0xFFAAAAFF );
		var graphicsStyle28 = new GraphicsStyle( solidFill29 );
		var textStyle30 = new TextStyle( Number.INT_NOT_SET, null, 0x000000FF );
		var styleBlock27 = new StyleBlock( StyleBlockType.elementState, graphicsStyle28, null, textStyle30 );
		styleBlock27.parentStyle = styleBlock19;
		simpleDictionary26.set(2, styleBlock27);
		var statesStyle25 = new StatesStyle( simpleDictionary26 );
		styleBlock19.states = statesStyle25;
		styleBlock15.superStyle = styleBlock19;
		this.elementChildren.set('primevc.gui.components.InputField', styleBlock15);
		var textStyle32 = new TextStyle( 12, 'Verdana' );
		var styleBlock31 = new StyleBlock( StyleBlockType.element, null, null, textStyle32 );
		styleBlock31.superStyle = styleBlock0;
		this.elementChildren.set('primevc.gui.components.Label', styleBlock31);
		var solidFill36 = new SolidFill( 0xFF0000FF );
		var solidBorder35 = new SolidBorder( solidFill36, 1, false, CapsStyle.NONE, JointStyle.ROUND, false );
		var graphicsStyle34 = new GraphicsStyle( null, solidBorder35, new RegularRectangle(  ) );
		var layoutStyle37 = new LayoutStyle( null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, 20, 200, 20, 200 );
		var styleBlock33 = new StyleBlock( StyleBlockType.element, graphicsStyle34, layoutStyle37 );
		styleBlock33.superStyle = styleBlock4;
		this.elementChildren.set('primevc.gui.components.Image', styleBlock33);
		this.elementChildren.set('primevc.gui.components.Button', styleBlock19);
		var solidFill40 = new SolidFill( 0xFFFFFFFF );
		var graphicsStyle39 = new GraphicsStyle( solidFill40 );
		var classInstanceFactory42 = new ClassInstanceFactory( RelativeAlgorithm );
		var layoutStyle41 = new LayoutStyle( null, null, null, cast classInstanceFactory42 );
		var styleBlock38 = new StyleBlock( StyleBlockType.element, graphicsStyle39, layoutStyle41 );
		styleBlock38.superStyle = styleBlock0;
		this.elementChildren.set('primevc.gui.components.SliderBase', styleBlock38);
		var solidFill45 = new SolidFill( 0x212121FF );
		var graphicsStyle44 = new GraphicsStyle( solidFill45 );
		var styleBlock43 = new StyleBlock( StyleBlockType.element, graphicsStyle44 );
		styleBlock43.superStyle = styleBlock38;
		this.elementChildren.set('primevc.gui.components.ScrollBar', styleBlock43);
		var graphicsStyle47 = new GraphicsStyle( null, null, null, primevc.gui.components.skins.ButtonIconLabelSkin );
		var layoutStyle48 = new LayoutStyle( null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, 40 );
		var styleBlock46 = new StyleBlock( StyleBlockType.element, graphicsStyle47, layoutStyle48 );
		styleBlock46.superStyle = styleBlock19;
		this.elementChildren.set('primevc.gui.components.ComboBox', styleBlock46);
		var graphicsStyle50 = new GraphicsStyle( null, null, null, primevc.gui.components.skins.BasicPanelSkin );
		var styleBlock49 = new StyleBlock( StyleBlockType.element, graphicsStyle50 );
		styleBlock49.superStyle = styleBlock0;
		var simpleDictionary51 = new Hash(  );
		var graphicsStyle53 = new GraphicsStyle( null, null, null, primevc.gui.components.skins.ButtonIconSkin );
		var styleBlock52 = new StyleBlock( StyleBlockType.id, graphicsStyle53 );
		styleBlock52.parentStyle = styleBlock49;
		simpleDictionary51.set('closeBtn', styleBlock52);
		styleBlock49.idChildren = simpleDictionary51;
		this.elementChildren.set('primevc.gui.components.Panel', styleBlock49);
		var solidFill56 = new SolidFill( 0x111111FF );
		var graphicsStyle55 = new GraphicsStyle( solidFill56 );
		var array3 = [ Horizontal.center, Vertical.center ];
		var classInstanceFactory58 = new ClassInstanceFactory( HorizontalFloatAlgorithm, array3 );
		var layoutStyle57 = new LayoutStyle( null, null, null, cast classInstanceFactory58, 1 );
		var styleBlock54 = new StyleBlock( StyleBlockType.element, graphicsStyle55, layoutStyle57 );
		styleBlock54.superStyle = styleBlock0;
		var simpleDictionary59 = new Hash(  );
		var solidFill62 = new SolidFill( 0xCCCCCCFF );
		var graphicsStyle61 = new GraphicsStyle( solidFill62, null, null, primevc.gui.components.skins.ButtonLabelSkin );
		var box64 = new Box( 5, 5, 5, 5 );
		var layoutStyle63 = new LayoutStyle( null, null, box64, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, 20 );
		var textStyle65 = new TextStyle( Number.INT_NOT_SET, null, 0x333333FF );
		var styleBlock60 = new StyleBlock( StyleBlockType.element, graphicsStyle61, layoutStyle63, textStyle65 );
		styleBlock60.superStyle = styleBlock0;
		styleBlock60.extendedStyle = styleBlock19;
		styleBlock60.parentStyle = styleBlock54;
		var simpleDictionary67 = new IntHash(  );
		var solidFill70 = new SolidFill( 0xFFFFFFFF );
		var graphicsStyle69 = new GraphicsStyle( solidFill70 );
		var styleBlock68 = new StyleBlock( StyleBlockType.elementState, graphicsStyle69 );
		styleBlock68.extendedStyle = styleBlock27;
		styleBlock68.parentStyle = styleBlock60;
		simpleDictionary67.set(2, styleBlock68);
		var solidFill73 = new SolidFill( 0xFFFFFFFF );
		var graphicsStyle72 = new GraphicsStyle( solidFill73 );
		var styleBlock71 = new StyleBlock( StyleBlockType.elementState, graphicsStyle72 );
		styleBlock71.parentStyle = styleBlock60;
		simpleDictionary67.set(0x000800, styleBlock71);
		var statesStyle66 = new StatesStyle( simpleDictionary67 );
		styleBlock60.states = statesStyle66;
		simpleDictionary59.set('primevc.gui.components.Button', styleBlock60);
		styleBlock54.elementChildren = simpleDictionary59;
		this.elementChildren.set('primevc.gui.components.DebugBar', styleBlock54);
		var array4 = [ Vertical.center, Horizontal.center ];
		var classInstanceFactory76 = new ClassInstanceFactory( VerticalFloatAlgorithm, array4 );
		var layoutStyle75 = new LayoutStyle( null, null, null, cast classInstanceFactory76 );
		var styleBlock74 = new StyleBlock( StyleBlockType.element, null, layoutStyle75 );
		styleBlock74.superStyle = styleBlock2;
		this.elementChildren.set('sample.MainWindow', styleBlock74);
		var styleBlock77 = new StyleBlock( StyleBlockType.styleName );
		var simpleDictionary78 = new Hash(  );
		var solidFill82 = new SolidFill( 0xFF00FFFF );
		var solidBorder81 = new SolidBorder( solidFill82, 3, false, CapsStyle.NONE, JointStyle.ROUND, false );
		var graphicsStyle80 = new GraphicsStyle( null, solidBorder81, null, null, null, null, 0.7 );
		var styleBlock79 = new StyleBlock( StyleBlockType.element, graphicsStyle80 );
		styleBlock79.superStyle = styleBlock0;
		styleBlock79.parentStyle = styleBlock77;
		simpleDictionary78.set('primevc.gui.core.UIComponent', styleBlock79);
		styleBlock77.elementChildren = simpleDictionary78;
		this.styleNameChildren.set('debug', styleBlock77);
		var layoutStyle84 = new LayoutStyle( null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, 4, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, 30 );
		var styleBlock83 = new StyleBlock( StyleBlockType.styleName, null, layoutStyle84 );
		var simpleDictionary85 = new Hash(  );
		var layoutStyle87 = new LayoutStyle( null, null, null, null, 0, 1 );
		var styleBlock86 = new StyleBlock( StyleBlockType.element, null, layoutStyle87 );
		styleBlock86.superStyle = styleBlock0;
		styleBlock86.extendedStyle = styleBlock4;
		styleBlock86.parentStyle = styleBlock83;
		simpleDictionary85.set('primevc.gui.core.UIGraphic', styleBlock86);
		var solidFill90 = new SolidFill( 0x666666FF );
		var graphicsStyle89 = new GraphicsStyle( solidFill90, null, null, primevc.gui.components.skins.ButtonIconSkin );
		var relativeLayout92 = new RelativeLayout( Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0 );
		var layoutStyle91 = new LayoutStyle( relativeLayout92, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 6, 15 );
		var styleBlock88 = new StyleBlock( StyleBlockType.element, graphicsStyle89, layoutStyle91 );
		styleBlock88.superStyle = styleBlock0;
		styleBlock88.extendedStyle = styleBlock19;
		styleBlock88.parentStyle = styleBlock83;
		simpleDictionary85.set('primevc.gui.components.Button', styleBlock88);
		styleBlock83.elementChildren = simpleDictionary85;
		this.styleNameChildren.set('horizontalSlider', styleBlock83);
		var layoutStyle94 = new LayoutStyle( null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 4, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, Number.INT_NOT_SET, Number.INT_NOT_SET, 30 );
		var styleBlock93 = new StyleBlock( StyleBlockType.styleName, null, layoutStyle94 );
		var simpleDictionary95 = new Hash(  );
		var relativeLayout98 = new RelativeLayout( Number.INT_NOT_SET, Number.INT_NOT_SET, 0 );
		var layoutStyle97 = new LayoutStyle( relativeLayout98, null, null, null, 1, 0 );
		var styleBlock96 = new StyleBlock( StyleBlockType.element, null, layoutStyle97 );
		styleBlock96.superStyle = styleBlock0;
		styleBlock96.extendedStyle = styleBlock4;
		styleBlock96.parentStyle = styleBlock93;
		simpleDictionary95.set('primevc.gui.core.UIGraphic', styleBlock96);
		var solidFill101 = new SolidFill( 0x666666FF );
		var graphicsStyle100 = new GraphicsStyle( solidFill101, null, null, primevc.gui.components.skins.ButtonIconSkin );
		var relativeLayout103 = new RelativeLayout( Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0 );
		var layoutStyle102 = new LayoutStyle( relativeLayout103, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 15, 6 );
		var styleBlock99 = new StyleBlock( StyleBlockType.element, graphicsStyle100, layoutStyle102 );
		styleBlock99.superStyle = styleBlock0;
		styleBlock99.extendedStyle = styleBlock19;
		styleBlock99.parentStyle = styleBlock93;
		simpleDictionary95.set('primevc.gui.components.Button', styleBlock99);
		styleBlock93.elementChildren = simpleDictionary95;
		this.styleNameChildren.set('verticalSlider', styleBlock93);
		var relativeLayout106 = new RelativeLayout( Number.INT_NOT_SET, 8, 7, 8 );
		var layoutStyle105 = new LayoutStyle( relativeLayout106, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, 2 );
		var styleBlock104 = new StyleBlock( StyleBlockType.styleName, null, layoutStyle105 );
		var simpleDictionary107 = new Hash(  );
		var solidFill110 = new SolidFill( 0x212121FF );
		var graphicsStyle109 = new GraphicsStyle( solidFill110, null, null, primevc.gui.components.skins.ButtonIconSkin );
		var relativeLayout112 = new RelativeLayout( Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0 );
		var layoutStyle111 = new LayoutStyle( relativeLayout112, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 6, 9 );
		var styleBlock108 = new StyleBlock( StyleBlockType.element, graphicsStyle109, layoutStyle111 );
		styleBlock108.superStyle = styleBlock0;
		styleBlock108.extendedStyle = styleBlock19;
		styleBlock108.parentStyle = styleBlock104;
		simpleDictionary107.set('primevc.gui.components.Button', styleBlock108);
		styleBlock104.elementChildren = simpleDictionary107;
		this.styleNameChildren.set('horizontalScrollBar', styleBlock104);
		var relativeLayout115 = new RelativeLayout( 8, 7, 8 );
		var layoutStyle114 = new LayoutStyle( relativeLayout115, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 2 );
		var styleBlock113 = new StyleBlock( StyleBlockType.styleName, null, layoutStyle114 );
		var simpleDictionary116 = new Hash(  );
		var solidFill119 = new SolidFill( 0x212121FF );
		var graphicsStyle118 = new GraphicsStyle( solidFill119, null, null, primevc.gui.components.skins.ButtonIconSkin );
		var relativeLayout121 = new RelativeLayout( Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0 );
		var layoutStyle120 = new LayoutStyle( relativeLayout121, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 9, 6 );
		var styleBlock117 = new StyleBlock( StyleBlockType.element, graphicsStyle118, layoutStyle120 );
		styleBlock117.superStyle = styleBlock0;
		styleBlock117.extendedStyle = styleBlock19;
		styleBlock117.parentStyle = styleBlock113;
		simpleDictionary116.set('primevc.gui.components.Button', styleBlock117);
		styleBlock113.elementChildren = simpleDictionary116;
		this.styleNameChildren.set('verticalScrollBar', styleBlock113);
		var solidFill124 = new SolidFill( 0xF9F9F9FF );
		var solidFill126 = new SolidFill( 0x707070FF );
		var solidBorder125 = new SolidBorder( solidFill126, 1, false, CapsStyle.NONE, JointStyle.ROUND, false );
		var corners127 = new Corners( 10, 10, 10, 10 );
		var graphicsStyle123 = new GraphicsStyle( solidFill124, solidBorder125, null, null, null, null, Number.FLOAT_NOT_SET, null, null, corners127 );
		var box129 = new Box( 7, 0, 7, 0 );
		var layoutStyle128 = new LayoutStyle( null, box129 );
		var styleBlock122 = new StyleBlock( StyleBlockType.styleName, graphicsStyle123, layoutStyle128 );
		var simpleDictionary130 = new Hash(  );
		var graphicsStyle132 = new GraphicsStyle( null, null, null, null, primevc.gui.behaviours.scroll.ShowScrollbarsBehaviour );
		var array5 = [ Vertical.top, Horizontal.left ];
		var classInstanceFactory134 = new ClassInstanceFactory( VerticalFloatAlgorithm, array5 );
		var layoutStyle133 = new LayoutStyle( null, null, null, cast classInstanceFactory134, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.FLOAT_NOT_SET, null, null, 50, Number.INT_NOT_SET, 50, 0x00012C );
		var styleBlock131 = new StyleBlock( StyleBlockType.element, graphicsStyle132, layoutStyle133 );
		styleBlock131.superStyle = styleBlock0;
		styleBlock131.parentStyle = styleBlock122;
		var simpleDictionary135 = new Hash(  );
		var graphicsStyle137 = new GraphicsStyle( null, null, null, primevc.gui.components.skins.ButtonIconLabelSkin );
		var styleBlock136 = new StyleBlock( StyleBlockType.element, graphicsStyle137 );
		styleBlock136.superStyle = styleBlock0;
		styleBlock136.extendedStyle = styleBlock19;
		styleBlock136.parentStyle = styleBlock131;
		simpleDictionary135.set('primevc.gui.components.Button', styleBlock136);
		styleBlock131.elementChildren = simpleDictionary135;
		simpleDictionary130.set('primevc.gui.components.ListView', styleBlock131);
		styleBlock122.elementChildren = simpleDictionary130;
		this.styleNameChildren.set('comboList', styleBlock122);
		var solidFill140 = new SolidFill( 0x666666FF );
		var corners141 = new Corners( 5, 5, 5, 5 );
		var graphicsStyle139 = new GraphicsStyle( solidFill140, null, null, primevc.gui.components.skins.SlidingToggleButtonSkin, null, null, Number.FLOAT_NOT_SET, null, null, corners141 );
		var layoutStyle142 = new LayoutStyle( null, null, null, null, Number.FLOAT_NOT_SET, Number.FLOAT_NOT_SET, 50, 30 );
		var styleBlock138 = new StyleBlock( StyleBlockType.styleName, graphicsStyle139, layoutStyle142 );
		var simpleDictionary143 = new Hash(  );
		var solidFill146 = new SolidFill( 0xFF0000FF );
		var graphicsStyle145 = new GraphicsStyle( solidFill146 );
		var relativeLayout148 = new RelativeLayout( 1, Number.INT_NOT_SET, 1 );
		var layoutStyle147 = new LayoutStyle( relativeLayout148 );
		var styleBlock144 = new StyleBlock( StyleBlockType.id, graphicsStyle145, layoutStyle147 );
		styleBlock144.parentStyle = styleBlock138;
		simpleDictionary143.set('onBg', styleBlock144);
		var textStyle150 = new TextStyle( Number.INT_NOT_SET, null, 0xFFFFFFFF );
		var styleBlock149 = new StyleBlock( StyleBlockType.id, null, null, textStyle150 );
		styleBlock149.parentStyle = styleBlock138;
		simpleDictionary143.set('onLabel', styleBlock149);
		var solidFill153 = new SolidFill( 0xFFFFFFFF );
		var corners154 = new Corners( 5, 5, 5, 5 );
		var graphicsStyle152 = new GraphicsStyle( solidFill153, null, new RegularRectangle(  ), null, null, null, Number.FLOAT_NOT_SET, null, null, corners154 );
		var relativeLayout156 = new RelativeLayout( Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0 );
		var layoutStyle155 = new LayoutStyle( relativeLayout156, null, null, null, 0.51, 1.1 );
		var moveEffect158 = new MoveEffect( 180 );
		var effectsStyle157 = new EffectsStyle( moveEffect158 );
		var styleBlock151 = new StyleBlock( StyleBlockType.id, graphicsStyle152, layoutStyle155, null, effectsStyle157 );
		styleBlock151.parentStyle = styleBlock138;
		simpleDictionary143.set('slide', styleBlock151);
		styleBlock138.idChildren = simpleDictionary143;
		var simpleDictionary159 = new Hash(  );
		var relativeLayout162 = new RelativeLayout( Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, Number.INT_NOT_SET, 0 );
		var layoutStyle161 = new LayoutStyle( relativeLayout162 );
		var textStyle163 = new TextStyle( 8, 'Lucida Grande', 0xFFFFFFFF, null, null, Number.FLOAT_NOT_SET, null, null, Number.FLOAT_NOT_SET, TextTransform.uppercase );
		var styleBlock160 = new StyleBlock( StyleBlockType.element, null, layoutStyle161, textStyle163 );
		styleBlock160.superStyle = styleBlock0;
		styleBlock160.parentStyle = styleBlock138;
		simpleDictionary159.set('primevc.gui.core.UITextField', styleBlock160);
		styleBlock138.elementChildren = simpleDictionary159;
		this.styleNameChildren.set('slideToggleButton', styleBlock138);
		var solidFill166 = new SolidFill( 0x88888877 );
		var graphicsStyle165 = new GraphicsStyle( solidFill166 );
		var layoutStyle167 = new LayoutStyle( null, null, null, null, 1, 1 );
		var styleBlock164 = new StyleBlock( StyleBlockType.id, graphicsStyle165, layoutStyle167 );
		this.idChildren.set('modal', styleBlock164);
		var solidFill170 = new SolidFill( 0x555555FF );
		var graphicsStyle169 = new GraphicsStyle( solidFill170 );
		var textStyle171 = new TextStyle( 9, 'Verdana', 0xFFFFFFFF );
		var styleBlock168 = new StyleBlock( StyleBlockType.id, graphicsStyle169, null, textStyle171 );
		this.idChildren.set('toolTip', styleBlock168);
	}
}