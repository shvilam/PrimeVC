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
  using primevc.utils.NumberUtil;


/**
 * @author Ruben Weijers
 * @creation-date Sep 23, 2010
 */
class LayoutStyleProxy extends LayoutStyleDeclarations
{
	private var target : StyleSheet;
	
	
	public function new (target:StyleSheet)
	{	
		this.target = target;
		super();
	}
	
	
	override private function getRelative ()
	{
		var v = super.getRelative();
		var i = 0;
		for (styleObj in target)
		{
			i++;
			if (styleObj.layout != null && null != (v = styleObj.layout.relative))
				break;
		}
		return v;
	}
	
	
	override private function getAlgorithm ()
	{
		var v = super.getAlgorithm();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;
			if (null != (v = styleObj.layout.algorithm))
				break;
		}
		return v;
	}
	
	
	override private function getPadding ()
	{
		var v = super.getPadding();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;
			if (null != (v = styleObj.layout.padding))
				break;
		}
		return v;
	}
	
	
	override private function getWidth ()
	{
		var v = super.getWidth();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.width;
			if (v.isSet())
				break;
		}
		return v;
	}
	
	
	override private function getMaxWidth ()
	{
		var v = super.getMaxWidth();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;
			
			v = styleObj.layout.maxWidth;
			if (v.isSet())
				break;
		}
		return v;
	}
	
	
	
	override private function getMinWidth ()
	{
		var v = super.getMinWidth();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.minWidth;
			if (v.isSet())
				break;
		}
		return v;
	}
	
	
	override private function getPercentWidth ()
	{
		var v = super.getPercentWidth();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.percentWidth;
			if (v.isSet())
				break;
		}
		return v;
	}
	
	
	override private function getHeight ()
	{
		var v = super.getHeight();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.height;
			if (v.isSet())
				break;
		}
		return v;
	}
	
	
	override private function getMaxHeight ()
	{
		var v = super.getMaxHeight();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.maxHeight;
			if (v.isSet())
				break;
		}
		return v;
	}
	
	
	override private function getMinHeight ()
	{
		var v = super.getMinHeight();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.minHeight;
			if (v.isSet())
				break;
		}
		return v;
	}
	
	
	override private function getPercentHeight ()
	{
		var v = super.getPercentHeight();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.percentHeight;
			if (v.isSet())
				break;
		}
		return v;
	}
	
	
	override private function getChildWidth ()
	{
		var v = super.getChildWidth();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.childWidth;
			if (v.isSet())
				break;
		}
		return v;
	}
	
	
	override private function getChildHeight ()
	{
		var v = super.getChildHeight();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.childHeight;
			if (v.isSet())
				break;
		}
		return v;
	}
	
	
	override private function getRotation ()
	{
		var v = super.getRotation();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.rotation;
			if (v.isSet())
				break;
		}
		return v;
	}


	override private function getIncludeInLayout ()
	{
		var v = super.getIncludeInLayout();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.includeInLayout;
			if (v != null)
				break;
		}
		return v;
	}
	
	
	override private function getMaintainAspect ()
	{
		var v = super.getMaintainAspect();
		for (styleObj in target) {
			if (styleObj.layout == null)
				continue;

			v = styleObj.layout.maintainAspectRatio;
			if (v != null)
				break;
		}
		return v;
	}
}