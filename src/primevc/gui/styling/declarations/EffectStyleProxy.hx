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
 import primevc.gui.styling.StyleSheet;


/**
 * Class description
 * 
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
	
	
	override private function getMove ()
	{
		var v = super.getMove();
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.move))
				break;
		return v;
	}
	
	
	override private function getResize ()
	{
		var v = super.getResize();
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.resize))
				break;
		return v;
	}
	
	
	override private function getRotate ()
	{
		var v = super.getRotate();
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.rotate))
				break;
		return v;
	}
	
	
	override private function getScale ()
	{
		var v = super.getScale();
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.scale))
				break;
		return v;
	}
	
	
	override private function getShow ()
	{
		var v = super.getShow();
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.show))
				break;
		return v;
	}
	
	
	override private function getHide ()
	{
		var v = super.getHide();
		for (styleObj in target)
			if (styleObj.effects != null && null != (v = styleObj.effects.hide))
				break;
		return v;
	}
}