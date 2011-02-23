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
 import primevc.gui.core.IUIElement;
 import primevc.gui.effects.EffectFlags;
 import primevc.gui.effects.UIElementEffects;
 import primevc.gui.styling.StyleCollectionBase;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = EffectFlags;


/**
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
class EffectsCollection extends StyleCollectionBase < EffectsStyle >
{
	public function new (elementStyle:IUIElementStyle)			{ super( elementStyle, StyleFlags.EFFECTS ); }
	override public function forwardIterator ()					{ return cast new EffectsCollectionForwardIterator( elementStyle, propertyTypeFlag); }
	override public function reversedIterator ()				{ return cast new EffectsCollectionReversedIterator( elementStyle, propertyTypeFlag); }

#if debug
	override public function readProperties (props:Int = -1)	{ return Flags.readProperties( (props == -1) ? filledProperties : props ); }
#end
	
	
	override public function apply ()
	{
		if (changes == 0 || !elementStyle.target.is(IUIElement))
			return;
		
		var target = elementStyle.target.as(IUIElement);
		if (target.effects == null)
			target.effects = new UIElementEffects(target);
		
	//	trace(target + ".applyEffectStyling "+style.readProperties( changes )+"; has "+style.readProperties());
		
		for (styleObj in this)
		{
			if (changes == 0)
				break;
			
			if (!styleObj.allFilledProperties.has( changes ))
				continue;
			
			var propsToSet	= styleObj.allFilledProperties.filter( changes );
			changes			= changes.unset( propsToSet );
			applyStyleObject( propsToSet, styleObj );
		}
		
		//properties that are changed but are not found in any style-object need to be unset
		if (changes > 0)
		{
			applyStyleObject( changes, null );
			changes = 0;
		}
	}
	
	
	private inline function applyStyleObject ( propsToSet:Int, styleObj:EffectsStyle )
	{
		var target	= elementStyle.target.as(IUIElement);
		var effects	= target.effects;
		if (propsToSet.has( Flags.MOVE ))		effects.move	= styleObj != null ? styleObj.move	.createEffectInstance( target ) : null;
		if (propsToSet.has( Flags.RESIZE ))		effects.resize	= styleObj != null ? styleObj.resize.createEffectInstance( target ) : null;
		if (propsToSet.has( Flags.ROTATE ))		effects.rotate	= styleObj != null ? styleObj.rotate.createEffectInstance( target ) : null;
		if (propsToSet.has( Flags.SCALE ))		effects.scale	= styleObj != null ? styleObj.scale	.createEffectInstance( target ) : null;
		if (propsToSet.has( Flags.SHOW ))		effects.show	= styleObj != null ? styleObj.show	.createEffectInstance( target ) : null;
		if (propsToSet.has( Flags.HIDE ))		effects.hide	= styleObj != null ? styleObj.hide	.createEffectInstance( target ) : null;
	}
}


class EffectsCollectionForwardIterator extends StyleCollectionForwardIterator < EffectsStyle >
{
	override public function next ()	{ return setNext().data.effects; }
}


class EffectsCollectionReversedIterator extends StyleCollectionReversedIterator < EffectsStyle >
{
	override public function next ()	{ return setNext().data.effects; }
}