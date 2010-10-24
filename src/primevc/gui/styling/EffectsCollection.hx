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
 import primevc.gui.effects.EffectFlags;
 import primevc.gui.styling.StyleCollectionBase;
  using primevc.utils.BitUtil;


private typedef Flags = EffectFlags;


/**
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
class EffectsCollection extends StyleCollectionBase < EffectsStyle >
{
	public function new (styleSheet:IUIElementStyle)			{ super( styleSheet, StyleFlags.EFFECTS ); }
	override public function forwardIterator ()					{ return cast new EffectsCollectionForwardIterator( styleSheet, propertyTypeFlag); }
	override public function reversedIterator ()				{ return cast new EffectsCollectionReversedIterator( styleSheet, propertyTypeFlag); }

#if debug
	override public function readProperties (props:Int = -1)	{ return Flags.readProperties( (props == -1) ? filledProperties : props ); }
#end
}


class EffectsCollectionForwardIterator extends StyleCollectionForwardIterator < EffectsStyle >
{
	override public function next ()	{ return setNext().data.effects; }
}


class EffectsCollectionReversedIterator extends StyleCollectionReversedIterator < EffectsStyle >
{
	override public function next ()	{ return setNext().data.effects; }
}

/*
class EffectsCollection extends EffectsStyle
{
	private var target					: UIElementStyle;
	public var change	(default, null)	: Signal1 < UInt >;
	
	
	public function new (newTarget:StyleSheet)
	{
		target	= newTarget;
		change	= new Signal1();
		super();
	}
	
	
	override public function dispose ()
	{	
		change.dispose();
		change	= null;
		target	= null;
		super.dispose();
	}
	
	
	override public function updateAllFilledPropertiesFlag () : Void
	{
		super.updateAllFilledPropertiesFlag();
		
		for (styleObj in target)
		{
			if (styleObj.has( StyleFlags.EFFECTS ))
				allFilledProperties = allFilledProperties.set( styleObj.effects.allFilledProperties );
			
			if (allFilledProperties == Flags.ALL_PROPERTIES)
				break;
		}
	}
	
	
	override public function invalidateCall (changes:UInt, sender:IInvalidatable)
	{
		var t = sender.as(EffectsStyle);
		
		if (t.owner.type != StyleDeclarationType.id)
		{
			for (styleObj in target)
			{
				if (!styleObj.has( StyleFlags.EFFECTS ))
					continue;
				
				if (styleObj.effects == t)
					break;
			
				changes = changes.unset( styleObj.effects.allFilledProperties );
			}
		}
		
		if (t.filledProperties.has(changes))	allFilledProperties = allFilledProperties.set( changes );
		else									updateAllFilledPropertiesFlag();
		
		invalidate( changes );
	}
	
	
	override public function invalidate (changes:UInt)
	{
		if (changes > 0)
			change.send( changes );
	}
	
	
	
	//
	// GETTERS
	//
	
	override private function getMove ()
	{
		if (!has(Flags.MOVE))
			return _move;
		
		var v = super.getMove();
		if (v == null)
			for (styleObj in target)
				if (styleObj.effects != null && null != (v = styleObj.effects.move))
					break;
		
		return v;
	}
	
	
	override private function getResize ()
	{
		if (!has(Flags.RESIZE))
			return _resize;
		
		var v = super.getResize();
		if (v == null)
			for (styleObj in target)
				if (styleObj.effects != null && null != (v = styleObj.effects.resize))
					break;
		
		return v;
	}
	
	
	override private function getRotate ()
	{
		if (!has(Flags.ROTATE))
			return _rotate;
		
		var v = super.getRotate();
		if (v == null)
			for (styleObj in target)
				if (styleObj.effects != null && null != (v = styleObj.effects.rotate))
					break;
		
		return v;
	}
	
	
	override private function getScale ()
	{
		if (!has(Flags.SCALE))
			return _scale;
		
		var v = super.getScale();
		if (v == null)
			for (styleObj in target)
				if (styleObj.effects != null && null != (v = styleObj.effects.scale))
					break;
		
		return v;
	}
	
	
	override private function getShow ()
	{
		if (!has(Flags.SHOW))
			return _show;
		
		var v = super.getShow();
		if (v == null)
			for (styleObj in target)
				if (styleObj.effects != null && null != (v = styleObj.effects.show))
					break;
		
		return v;
	}
	
	
	override private function getHide ()
	{
		if (!has(Flags.HIDE))
			return _hide;
		
		var v = super.getHide();
		if (v == null)
			for (styleObj in target)
				if (styleObj.effects != null && null != (v = styleObj.effects.hide))
					break;
		
		return v;
	}
}*/