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
 import primevc.gui.styling.declarations.UIElementStyle;
 import primevc.types.RGBA;
 import Hash;


/**
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class StyleContainer extends UIElementStyle, implements IDisposable
{
	public var typeSelectors		(default, null) : Hash < UIElementStyle >;
	public var styleNameSelectors	(default, null) : Hash < UIElementStyle >;
	public var idSelectors			(default, null) : Hash < UIElementStyle >;
	
	public var globalFills			(default, null) : Hash < IFill >;
	public var globalBorders		(default, null) : Hash < IBorder<IFill> >;
	public var globalColors			(default, null) : Hash < RGBA >;
	
	
	public function new ()
	{
		super();
		typeSelectors		= new Hash();
		styleNameSelectors	= new Hash();
		idSelectors			= new Hash();
		
		globalFills			= new Hash();
		globalBorders		= new Hash();
		globalColors		= new Hash();
		
		createGlobals();
		createTypeSelectors();
		createStyleNameSelectors();
		createIdSelectors();
	}
	
	
	override public function dispose ()
	{
		typeSelectors		= null;
		styleNameSelectors	= null;
		idSelectors			= null;
	}
	
	
	private function createGlobals ()				: Void {}
	private function createTypeSelectors ()			: Void {} // Assert.abstract(); }
	private function createStyleNameSelectors ()	: Void {} // Assert.abstract(); }
	private function createIdSelectors ()			: Void {} // Assert.abstract(); }
	
	
#if debug
	override public function toString ()
	{
		var css = "";
		
		css += "\n/** ID STYLES **/";
		css += hashToCssString( idSelectors, "#" );
		
		css += "\n\n/** CLASS STYLES **/";
		css += hashToCssString( styleNameSelectors, "." );
		
		css += "\n\n/** ELEMENT STYLES **/";
		css += hashToCssString( typeSelectors, "" );
		
		return css;
	}
	
	
	private inline function hashToCssString (hash:Hash<UIElementStyle>, keyPrefix:String = "") : String
	{
		var css = "";
		var keys = hash.keys();
		while (keys.hasNext()) {
			var key = keys.next();
			var val = hash.get(key);
			css += "\n" + keyPrefix + key + " " + val;
		}
		return css;
	}
#end
}