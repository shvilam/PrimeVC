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
 import primevc.tools.generator.ICSSFormattable;
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
	
	
	public function new (
			elementSelectors:SelectorMapType = null,
			styleNameSelectors:SelectorMapType = null,
			idSelectors = null
		)
	{
#if neko
		uuid = StringUtil.createUUID();
#end
		this.elementSelectors	= elementSelectors;
		this.styleNameSelectors	= styleNameSelectors;
		this.idSelectors		= idSelectors;
	/*	elementSelectors	= new SelectorMapType();
		styleNameSelectors	= new SelectorMapType();
		idSelectors			= new SelectorMapType();*/
		
		fillSelectors();
	}
	
	
	public function dispose ()
	{
		if (elementSelectors != null)	elementSelectors.dispose();
		if (styleNameSelectors != null)	styleNameSelectors.dispose();
		if (idSelectors != null)		idSelectors.dispose();
		
		elementSelectors = styleNameSelectors = idSelectors = null;
	}
	
	
	private function fillSelectors () : Void {} // Assert.abstract(); }
	
	
	public function isEmpty ()
	{
		return (idSelectors == null || idSelectors.isEmpty())
			&& (styleNameSelectors == null || styleNameSelectors.isEmpty()) 
			&& (elementSelectors == null || elementSelectors.isEmpty());
	}
	
	
	private inline function getListForType (type:StyleBlockType) : SelectorMapType
	{
		Assert.notNull(type);
		return switch (type) {
				case element:	elementSelectors;
				case styleName:	styleNameSelectors;
				case id:		idSelectors;
				default:		null;
			}
	}
	
	
	/**
	 * Method checks if one of the lists with children has the requested child
	 */
	public function has (childName:String, childType:StyleBlockType) : Bool
	{
		var list = getListForType(childType);
		return list != null && list.exists(childName);
	}
	
	
	/**
	 * Method checks if one of the lists with children has the requested child
	 * and returns it
	 */
	public function get (childName:String, childType:StyleBlockType) : StyleBlock
	{
		var list = getListForType(childType);
		return (list != null) ? list.get(childName) : null;
	}
	
	
	/**
	 * Method add's the given child to the correct list
	 */
	public function set (childName:String, child:StyleBlock) : StyleBlock
	{
		var list = getListForType(child.type);
		if (list == null)
		{
			list = switch (child.type) {
				case element:	elementSelectors	= new SelectorMapType();
				case styleName:	styleNameSelectors	= new SelectorMapType();
				case id:		idSelectors			= new SelectorMapType();
				default:		null;
			}
		}
		
		if (list != null)
			list.set(childName, child);
		
		return child;
	}
	
	
#if (debug || neko)
	public function toString ()		{ return toCSS(); }
	

	public function toCSS (namePrefix:String = "")
	{
		var css = "";
		
		if (!isEmpty())
		{
			if (idSelectors != null)		css += hashToCSSString( namePrefix, idSelectors, "#" );
			if (styleNameSelectors != null)	css += hashToCSSString( namePrefix, styleNameSelectors, "." );
			if (elementSelectors != null)	css += hashToCSSString( namePrefix, elementSelectors, "" );
		}
		
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
			
			if (!val.isEmpty())
				css += "\n" + val.toCSS( name );
		}
		return css;
	}
#end

#if neko
	public function cleanUp ()
	{
		if (idSelectors != null)
		{
			idSelectors.cleanUp();
			if (idSelectors.isEmpty()) {
				idSelectors.dispose();
				idSelectors = null;
			}
		}
		
		if (styleNameSelectors != null)
		{
			styleNameSelectors.cleanUp();
			if (styleNameSelectors.isEmpty()) {
				styleNameSelectors.dispose();
				styleNameSelectors = null;
			}
		}
		
		if (elementSelectors != null)
		{
			elementSelectors.cleanUp();
			if (elementSelectors.isEmpty()) {
				elementSelectors.dispose();
				elementSelectors = null;
			}
		}
	}
	
	
	public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ elementSelectors, styleNameSelectors, idSelectors ] );
	}
#end
}