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
 import primevc.gui.core.IUIContainer;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.graphics.GraphicProperties;
 import primevc.gui.styling.StyleCollectionBase;
 import primevc.gui.traits.IDrawable;
 import primevc.gui.traits.ISkinnable;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = GraphicFlags;

/**
 * @author Ruben Weijers
 * @creation-date Okt 25, 2010
 */
class GraphicsCollection extends StyleCollectionBase < GraphicsStyle >
{
	public function new (elementStyle:IUIElementStyle)			{ super( elementStyle, StyleFlags.GRAPHICS ); }
	override public function forwardIterator ()					{ return cast new GraphicsCollectionForwardIterator( elementStyle, propertyTypeFlag); }
	override public function reversedIterator ()				{ return cast new GraphicsCollectionReversedIterator( elementStyle, propertyTypeFlag); }

#if debug
	override public function readProperties (props:Int = -1)	{ return Flags.readProperties( (props == -1) ? filledProperties : props ); }
#end
	
	
	override public function apply ()
	{
		if (changes == 0)
			return;
		
		var target = elementStyle.target;
		
		if (!target.is(ISkinnable))		changes = changes.unset( Flags.SKIN );
		if (!target.is(IDrawable))		changes = changes.unset( Flags.DRAWING_PROPERTIES );
		if (!target.is(IUIContainer))	changes = changes.unset( Flags.OVERFLOW );
		if (!target.is(IDisplayObject))	changes = changes.unset( Flags.OPACITY | Flags.VISIBLE );
		
		if (changes == 0)
			return;
		
		//
		// LOOP THROUGH ALL AVAILABLE STLYE-BLOCKS TO FIND THE STYLING PROPERTIES
		//
		
		var graphicProps = (changes.has( Flags.DRAWING_PROPERTIES )) ? getGraphicsObj() : null;
	//	trace(target + ".applyGeneralStyling "+readProperties( changes ));
		
		for (styleObj in this)
		{
			if (changes == 0)
				break;
			
			if (!styleObj.allFilledProperties.has( changes ))
				continue;
			
			var propsToSet	= styleObj.allFilledProperties.filter( changes );
			changes			= changes.unset( propsToSet );
			applyGraphicsStyleObj( propsToSet, styleObj, graphicProps );
		}
		
		if (changes > 0) {
			applyGraphicsStyleObj( changes, null, graphicProps );
			changes = 0;
		}
	}
	
	
	private function applyGraphicsStyleObj (propsToSet:UInt, styleObj:GraphicsStyle, graphicProps:GraphicProperties)
	{
		var target = elementStyle.target;
		
		if ( propsToSet.has( Flags.SKIN ) )			target.as(ISkinnable).skin			= (styleObj.skin != null) ? Type.createInstance( styleObj.skin, null ) : null;
		if ( propsToSet.has( Flags.SHAPE ) )		graphicProps.shape					= styleObj.shape;
		if ( propsToSet.has( Flags.BACKGROUND ) )	graphicProps.fill					= styleObj.background;
		if ( propsToSet.has( Flags.BORDER ) )		graphicProps.border					= styleObj.border;
		if ( propsToSet.has( Flags.OPACITY ) )		target.as(IDisplayObject).alpha		= styleObj.opacity;
		if ( propsToSet.has( Flags.VISIBLE ) )		target.as(IDisplayObject).visible	= styleObj.visible;
		if ( propsToSet.has( Flags.OVERFLOW ) )
		{
			if (styleObj.overflow != null)
				target.as(IUIContainer).behaviours.add( Type.createInstance( styleObj.overflow, [ target ] ) );
		//	else
		//		target.behaviours.remove(  )
		}
	}
	
	
	private  function getGraphicsObj () : GraphicProperties
	{
		var target = elementStyle.target.as(IDrawable);
		if (target.graphicData.value == null)
			return target.graphicData.value = new GraphicProperties(null, target.rect);
		else
			return target.graphicData.value;
	}
}


class GraphicsCollectionForwardIterator extends StyleCollectionForwardIterator < GraphicsStyle >
{
	override public function next ()	{ return setNext().data.graphics; }
}


class GraphicsCollectionReversedIterator extends StyleCollectionReversedIterator < GraphicsStyle >
{
	override public function next ()	{ return setNext().data.graphics; }
}