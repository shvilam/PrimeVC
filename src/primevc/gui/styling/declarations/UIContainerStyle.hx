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
 import primevc.gui.styling.StyleContainer;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end


/**
 * UIContainerStyle adds child-support to a style. That means a style for a
 * List component can also contain style information for the buttons in this
 * list.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 16, 2010
 */
class UIContainerStyle extends UIElementStyle
{
#if neko
	public var children (default, null)		: StyleContainer;
#else
	public var children (default, default)	: StyleContainer;
#end
	
	
	override private function init ()
	{
		children = new StyleContainer();
	}
	
	
	override public function dispose ()
	{
		children.dispose();
		children = null;
		super.dispose();
	}
	
	/*
#if (debug || neko)
	override public function toCSS (namePrefix:String = "")
	{
		var str = super.toCSS(namePrefix);
		str += "\n " + children.toCSS(namePrefix);
		return str;
	}
	
	
	/*override public function isEmpty ()
	{
		return (children == null || children.isEmpty()) && super.isEmpty();
	}*/
//#end
	
#if neko
	override public function toCode (code:ICodeGenerator)
	{
		super.toCode(code);
		
		if ((untyped children) != null)
			code.setProp(this, "children", children);
	}
#end
}