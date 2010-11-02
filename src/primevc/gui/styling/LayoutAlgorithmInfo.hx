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
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.tools.generator.ICSSFormattable;

#if neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
#end
#if (neko || debug)
 import primevc.utils.StringUtil;
#end

  using Type;



/**
 * Class holding information about the algorithm to create.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 01, 2010
 */
class LayoutAlgorithmInfo implements IDisposable		
			,	implements ICSSFormattable
#if neko	,	implements ICodeFormattable		#end
{
	public static inline var EMPTY_ARRAY = [];
	
#if (debug || neko)
	public var uuid			(default, null)		: String;
#end
	public var algorithm	(default, default)	: Class < ILayoutAlgorithm >;
	public var params		(default, default)	: Array < Dynamic >;
	
	
	public function new (algorithm:Class < ILayoutAlgorithm > = null, params:Array< Dynamic > = null)
	{	
#if (debug || neko)
		uuid = StringUtil.createUUID();
		if (params == null)
			params = [];
#end
		this.algorithm	= algorithm;
		this.params		= params;
	}
	
	
	public function dispose ()
	{
#if (debug || neko)
		uuid		= null;
#end
		algorithm	= null;
		params		= null;
	}
	
	
	public function create () : ILayoutAlgorithm
	{
		Assert.notNull(algorithm);
		if (params == null)
			return algorithm.createInstance( EMPTY_ARRAY );
		else
			return algorithm.createInstance( params );
	}
	

#if (neko || debug)
	public function toString ()						{ return toCSS(); }
	public function toCSS (prefix:String = "")		{ return create().toCSS(); }
#end

#if neko
	public function isEmpty ()						{ return algorithm == null; }
	public function toCode (code:ICodeGenerator)	{ code.construct( this, [ algorithm, params ] ); }
	public function cleanUp ()
	{
		if (params == null)
			return;
		
		var emptyCounter = 0;
		for (item in params)
			if (item == null)
				emptyCounter++;
		
		if (emptyCounter == params.length)
			params = null;
	}
#end
}