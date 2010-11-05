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
package primevc.types;
 import primevc.core.IDisposable;
 import primevc.tools.generator.ICSSFormattable;

#if neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
#end
#if (neko || debug)
 import primevc.utils.StringUtil;
#end
  using primevc.utils.TypeUtil;
  using Std;
  using Type;



/**
 * Class holding information about an instance to create.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 01, 2010
 */
class ClassInstanceFactory < InstanceType >
				implements IDisposable		
			,	implements ICSSFormattable
#if neko	,	implements ICodeFormattable		#end
{
	public static inline var EMPTY_ARRAY = [];
	
#if (debug || neko)
	public var uuid (default, null)	: String;
#end
	public var classRef				: Class < InstanceType >;
	public var params				: Array < Dynamic >;
	
	
	public function new ( classRef:Class<InstanceType> = null, params:Array< Dynamic > = null )
	{
#if (debug || neko)
		uuid = StringUtil.createUUID();
		if (params == null)
			params = [];
#end
		this.classRef	= classRef;
		this.params		= params;
	}
	
	
	public function dispose ()
	{
#if (debug || neko)
		uuid		= null;
#end
		classRef	= null;
		params		= null;
	}
	
	
	public function create () : InstanceType
	{
		Assert.notNull(classRef);
		if (params == null)
			return classRef.createInstance( EMPTY_ARRAY );
		else
			return classRef.createInstance( params );
	}
	

#if neko
	public function toCSS (prefix:String = "")
	{
		var i = create();
		if (i != null && i.is(ICSSFormattable))
			return i.as(ICSSFormattable).toCSS();
		else
			return i.string();
	}
	
	
	public function toString ()	{ return toCSS(); }
	public function isEmpty ()	{ return classRef == null; }
	
	
	public function toCode (code:ICodeGenerator)
	{
		code.construct( this, [ classRef, params ] );
	}
	
	
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