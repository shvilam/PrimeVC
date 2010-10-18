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
package primevc.gui.styling.declarations;
 import primevc.gui.effects.EffectFlags;
 import primevc.gui.styling.StyleSheet;
  using primevc.utils.BitUtil;


private typedef Flags = EffectFlags;


/**
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
class EffectStyleProxy extends EffectStyleDeclarations
{
	private var target : StyleSheet;
	
	
	public function new (target:StyleSheet)
	{	
		this.target = target;
		super();
	}
	
	
	override public function updateAllFilledPropertiesFlag () : Void
	{
		super.updateAllFilledPropertiesFlag();
		
		for (styleObj in target) {
			if (styleObj.has( StyleFlags.EFFECTS ))
				allFilledProperties = allFilledProperties.set( styleObj.effects.allFilledProperties );
			
			if (allFilledProperties == Flags.ALL_PROPERTIES)
				break;
		}
	}
	
	
	override private function getMove ()
	{
		if (!has(Flags.MOVE))
			return _move;
		
		var v = super.getMove();
		if (v != null)
			return v;
		
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.move))
				break;
		
		if (_move == null)
			_move = v;
		
		return v;
	}
	
	
	override private function getResize ()
	{
		if (!has(Flags.RESIZE))
			return _resize;
		
		var v = super.getResize();
		if (v != null)
			return v;
		
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.resize))
				break;
		
		if (_resize == null)
			_resize = v;
		
		return v;
	}
	
	
	override private function getRotate ()
	{
		if (!has(Flags.ROTATE))
			return _rotate;
		
		var v = super.getRotate();
		if (v != null)
			return v;
		
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.rotate))
				break;

		if (_rotate == null)
			_rotate = v;

		return v;
	}
	
	
	override private function getScale ()
	{
		if (!has(Flags.SCALE))
			return _scale;
		
		var v = super.getScale();
		if (v != null)
			return v;
		
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.scale))
				break;
		
		if (_scale == null)
			_scale = v;

		return v;
	}
	
	
	override private function getShow ()
	{
		if (!has(Flags.SHOW))
			return _show;
		
		var v = super.getShow();
		if (v != null)
			return v;
		
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.show))
				break;
		
		if (_show == null)
			_show = v;

		return v;
	}
	
	
	override private function getHide ()
	{
		if (!has(Flags.HIDE))
			return _hide;
		
		var v = super.getHide();
		if (v != null)
			return v;
		
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.hide))
				break;
		
		if (_hide == null)
			_hide = v;
		
		return v;
	}
}