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

#if flash9
 import flash.utils.TypedDictionary;
 import primevc.core.IDisposable;
 import primevc.gui.styling.declarations.UIElementStyle;


/**
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class StyleContainer extends UIElementStyle, implements IDisposable
{
	private var typeSelectors		: TypedDictionary < String, UIElementStyle >;
	private var styleNameSelectors	: TypedDictionary < String, UIElementStyle >;
	private var idSelectors			: TypedDictionary < String, UIElementStyle >;
	
	
	public function new ()
	{
		super();
		typeSelectors		= new TypedDictionary();
		styleNameSelectors	= new TypedDictionary();
		idSelectors			= new TypedDictionary();
		
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
	
	
	private function createTypeSelectors ()			: Void { Assert.abstract(); }
	private function createStyleNameSelectors ()	: Void { Assert.abstract(); }
	private function createIdSelectors ()			: Void { Assert.abstract(); }
}

#end