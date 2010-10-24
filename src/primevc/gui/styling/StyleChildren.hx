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
 import primevc.core.IDisposable;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;
 import primevc.tools.generator.ICSSFormattable;
 import primevc.types.RGBA;
 import primevc.types.SimpleDictionary;
 import Hash;
#if (debug || neko)
  using StringTools;
#end

#if neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.utils.StringUtil;
#end


typedef SelectorMapType = SimpleDictionary < String, StyleBlock >;

/**
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class StyleChildren 
				implements IDisposable
			,	implements ICSSFormattable
#if neko	,	implements ICodeFormattable		#end
{
#if neko
	public var uuid					(default, null) : String;
#end
	
	public var elementSelectors		(default, null) : SelectorMapType;
	public var styleNameSelectors	(default, null) : SelectorMapType;
	public var idSelectors			(default, null) : SelectorMapType;
	
	
	public function new ()
	{
#if neko
		uuid = StringUtil.createUUID();
#end
		elementSelectors	= new SelectorMapType();
		styleNameSelectors	= new SelectorMapType();
		idSelectors			= new SelectorMapType();
		
		createSelectors();
	}
	
	
	public function dispose ()
	{
		elementSelectors.dispose();
		styleNameSelectors.dispose();
		idSelectors.dispose();
		
		elementSelectors = styleNameSelectors = idSelectors = null;
	}
	
	
	private function createSelectors ()				: Void {} // Assert.abstract(); }
	
	
	public function isEmpty ()
	{
		return idSelectors.isEmpty() && styleNameSelectors.isEmpty() && elementSelectors.isEmpty();
	}
	
	
#if (debug || neko)
	public function toString ()		{ return toCSS(); }
	

	public function toCSS (namePrefix:String = "")
	{
		var css = "";
		
		if (!idSelectors.isEmpty())			css += hashToCSSString( namePrefix, idSelectors, "#" );
		if (!styleNameSelectors.isEmpty())	css += hashToCSSString( namePrefix, styleNameSelectors, "." );
		if (!elementSelectors.isEmpty())	css += hashToCSSString( namePrefix, elementSelectors, "" );
		
		return css;
	}
	
	
	private  function hashToCSSString (namePrefix:String, hash:SelectorMapType, keyPrefix:String = "") : String
	{
		var css = "";
		var keys = hash.keys();
		while (keys.hasNext())
		{
			var key = keys.next();
			var val = hash.get(key);
			var name = (namePrefix + " " + keyPrefix + key).trim();
			
			if (!val.allPropertiesEmpty())
				css += "\n" + val.toCSS( name );
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
			
			var style:StyleBlock;
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