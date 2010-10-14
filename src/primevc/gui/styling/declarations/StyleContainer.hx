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
 import primevc.core.IDisposable;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;
 import primevc.tools.generator.ICSSFormattable;
 import primevc.types.RGBA;
 import Hash;
#if (debug || neko)
  using StringTools;
#end

#if neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.utils.StringUtil;
#end


/**
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class StyleContainer 
				implements IDisposable
			,	implements ICSSFormattable
#if neko	,	implements ICodeFormattable		#end
{
#if neko
	public var uuid					(default, null) : String;
#end
	
	public var elementSelectors		(default, null) : Hash < UIElementStyle >;
	public var styleNameSelectors	(default, null) : Hash < UIElementStyle >;
	public var idSelectors			(default, null) : Hash < UIElementStyle >;
	
	
	public function new ()
	{
#if neko
		uuid = StringUtil.createUUID();
#end
		elementSelectors	= new Hash();
		styleNameSelectors	= new Hash();
		idSelectors			= new Hash();
		
		createSelectors();
	//	createElementSelectors();
	//	createStyleNameSelectors();
	//	createIdSelectors();
	}
	
	
	public function dispose ()
	{
		elementSelectors	= null;
		styleNameSelectors	= null;
		idSelectors			= null;
	}
	
	
	private function createSelectors ()				: Void {} // Assert.abstract(); }
//	private function createElementSelectors ()		: Void {} // Assert.abstract(); }
//	private function createStyleNameSelectors ()	: Void {} // Assert.abstract(); }
//	private function createIdSelectors ()			: Void {} // Assert.abstract(); }
	
	
#if (debug || neko)
	public function toString ()		{ return toCSS(); }
	
	
	public function isEmpty ()
	{
		return !idSelectors.iterator().hasNext() && !styleNameSelectors.iterator().hasNext() && !elementSelectors.iterator().hasNext();
	}
	

	public function toCSS (namePrefix:String = "")
	{
		var css = "";
		
		if (idSelectors.iterator().hasNext()) {
		//	css += "\n/** ID STYLES **/";
			css += hashToCSSString( namePrefix, idSelectors, "#" );
		}
		
		if (styleNameSelectors.iterator().hasNext()) {
		//	css += "\n\n/** CLASS STYLES **/";
			css += hashToCSSString( namePrefix, styleNameSelectors, "." );
		}
		
		if (elementSelectors.iterator().hasNext()) {
		//	css += "\n\n/** ELEMENT STYLES **/";
			css += hashToCSSString( namePrefix, elementSelectors, "" );
		}
		
		return css;
	}
	
	
	private  function hashToCSSString (namePrefix:String, hash:Hash<UIElementStyle>, keyPrefix:String = "") : String
	{
		var css = "";
		var keys = hash.keys();
		while (keys.hasNext()) {
			var key = keys.next();
			var val = hash.get(key);
			var name = (namePrefix + " " + keyPrefix + key).trim();
			
			if (!val.allPropertiesEmpty())
				css += "\n" + name + " " + val.toCSS( name );
			if (!val.children.isEmpty())
				css += "\n" + val.children.toCSS( name );
		}
		return css;
	}
#end

#if neko
	public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
		{
			code.construct( this );
			
			var style:UIElementStyle;
			var keys = elementSelectors.keys();
			
			for (key in keys)
			{
				style = elementSelectors.get(key);
				if (!style.isEmpty())
					code.setAction(this, "elementSelectors.set", [ key, style ]);
			}
		
			keys = styleNameSelectors.keys();
			for (key in keys)
			{
				style = styleNameSelectors.get(key);
				if (!style.isEmpty())
					code.setAction(this, "styleNameSelectors.set", [ key, style ]);
			}
			
			keys = idSelectors.keys();
			for (key in keys)
			{
				style = idSelectors.get(key);
				if (!style.isEmpty())
					code.setAction(this, "idSelectors.set", [ key, style ]);
			}
		}
	}
#end
}