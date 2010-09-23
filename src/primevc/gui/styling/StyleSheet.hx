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

#if flash9
 import primevc.core.IDisposable;
 import primevc.gui.styling.declarations.StyleDeclarationType;
 import primevc.gui.styling.declarations.UIElementStyle;
 import primevc.gui.traits.IStylable;
 import primevc.utils.FastArray;
  using primevc.utils.Bind;
  using primevc.utils.FastArray;
  using primevc.utils.TypeUtil;
  using Type;



/**
 * StyleSheet contains all style objects that are used by one IUIElement.
 * It's a unique collection of id-selectors, styleName-selectors and 
 * element-selectors.
 * 
 * The StyleSheet of an element has to be rebuild everytime the element is 
 * changing of parent.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 22, 2010
 */
class StyleSheet implements IDisposable
{
	private var idStyle			: UIElementStyle;
	private var styleNameStyles	: FastArray < UIElementStyle >;
	private var elementStyle	: UIElementStyle;
	
	/**
	 * object on which the style applies
	 */
	private var target			: IStylable;
	
	/**
	 * cached classname (incl package) of target since target won't change.
	 */
	private var targetClassName	: String;
	
	
	
	public function new (target:IStylable)
	{
		styleNameStyles = FastArrayUtil.create();
		this.target		= target;
		targetClassName	= target.getClass().getClassName();
		
		updateStyleClasses	.on( target.styleClasses.change, this );
		updateIdStyle		.on( target.id.change, this );
		init();
		
	//	updateStyles();
	}
	
	
	private function init ()
	{
		updateStyles	.on( target.displayEvents.addedToStage, this );
		clearStyles		.on( target.displayEvents.removedFromStage, this );
	}
	
	
	public function dispose ()
	{
		if (target == null)
			return;
		
		target.styleClasses.change.unbind( this );
		target.id.change.unbind( this );
		target.displayEvents.addedToStage.unbind( this );
		target.displayEvents.removedFromStage.unbind( this );
		
		clearStyles();
		styleNameStyles = null;
		targetClassName	= null;
		target			= null;
	}
	
	
	public function findStyle ( name:String, type:StyleDeclarationType, ?exclude:UIElementStyle ) : UIElementStyle
	{
		var style : UIElementStyle = null;
		
		//search in the id-style
		if (style == null && idStyle != null)
			style = idStyle.findStyle(name, type, exclude);
		
		//search in stylenames list
		if (style == null && styleNameStyles.length > 0)
		{
			for (styleNameStyle in styleNameStyles)
			{
				style = styleNameStyle.findStyle(name, type, exclude);
				if (style != null)
					break;
			}
		}
		
		//search in the element style
		if (style == null && elementStyle != null)
			style = elementStyle.findStyle(name, type, exclude);
		return style;
	}
	
	
	private function clearStyles () : Void
	{
		styleNameStyles.removeAll();
		idStyle			= null;
		elementStyle	= null;
	}
	
	
	private function updateStyleClasses () : Void
	{	
		//remove all styles
		styleNameStyles.removeAll();
		
		if (target.styleClasses.value == null || target.styleClasses.value == "")
			return;
		
		var parentStyle = getParentStyle();
		Assert.notNull( parentStyle );
		
		
		//search the style-object of each stylename
		var styleNames = target.styleClasses.value.split(",");
		for ( styleName in styleNames )
		{
			var tmp = parentStyle.findStyle( styleName, StyleDeclarationType.styleName );
			if (tmp != null)
				styleNameStyles.push( tmp );
		}
	}
	
	
	private function updateIdStyle () : Void
	{
		//remove old id style
		idStyle = null;
		
		if (target.id.value == "")
			return;
		
		var parentStyle = getParentStyle();
		Assert.notNull( parentStyle );
		idStyle = parentStyle.findStyle( target.id.value, StyleDeclarationType.id );
	}
	
	
	private function updateElementStyle () : Void
	{
		var parentStyle = getParentStyle();
		Assert.notNull( parentStyle );
		elementStyle = parentStyle.findStyle( targetClassName, StyleDeclarationType.element );
	}
	
	
	public function updateStyles () : Void
	{
		if (getParentStyle() == null)
			return;
		
		updateIdStyle();
		updateStyleClasses();
		updateElementStyle();
	}
	
	
	private inline function getParentStyle () : StyleSheet
	{
		Assert.notNull( target.container );
		Assert.that( target.container.is( IStylable ) );
		Assert.notNull( target.container.as( IStylable ).style );
		return target.container.as( IStylable ).style;
	}
}

#else

class StyleSheet {}

#end