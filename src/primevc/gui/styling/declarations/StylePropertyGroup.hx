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
 import primevc.core.traits.Invalidatable;
 import primevc.tools.generator.ICSSFormattable;
 import primevc.utils.StringUtil;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end



/**
 * Base class for each property group (fonts, layout, graphics, etc.).
 * 
 * @author Ruben Weijers
 * @creation-date Sep 22, 2010
 */
class StylePropertyGroup extends Invalidatable, implements IStyleDeclaration
{
	public var owner				: UIElementStyle;
	public var uuid (default, null) : String;
	
	
	public function new ()
	{
		super();
		this.uuid = StringUtil.createUUID();
	}
	
	
	override public function dispose ()
	{
		owner = null;
		uuid = null;
		super.dispose();
	}


	private inline function getExtended ()		{ return owner != null ? owner.extendedStyle : null; }
	private inline function getNesting ()		{ return owner != null ? owner.nestingInherited : null; }
	private inline function getSuper ()			{ return owner != null ? owner.superStyle : null; }
	private inline function getParent ()		{ return owner != null ? owner.parentStyle : null; }
	
	
#if (debug || neko)
	public function toString ()					{ return toCSS(); }
	public function isEmpty ()					{ Assert.abstract(); return false; }
	public function toCSS (prefix:String = "") 	{ Assert.abstract(); return ""; }
#end
	
#if neko
	public function toCode (code:ICodeGenerator){ Assert.abstract(); }
#end
}