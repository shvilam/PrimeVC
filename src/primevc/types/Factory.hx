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
#if neko
 import primevc.core.traits.IDisposable;
 import primevc.neko.traits.IHasTypeParameters;

 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.tools.generator.ICSSFormattable;

 import primevc.utils.ID;
  using primevc.utils.TypeUtil;
  using Std;
  using Type;
#end

#if !neko
typedef Factory<C> = Void -> C;
typedef Factory1<A, C> = A -> C;
#else

typedef Factory1<A,C> = Factory<C>;

/**
 * Class holding information about an instance to create.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 01, 2010
 */
class Factory <InstanceType >
				implements IDisposable		
#if neko	,	implements ICSSFormattable
			,	implements ICodeFormattable
			,	implements IHasTypeParameters		#end
{
	public static inline var EMPTY_ARRAY = [];
	
#if (debug || neko)
	public var _oid (default, null)	: Int;
#end
	public var classRef				: String; //Class < InstanceType >;
	public var params				: Array <Dynamic>;	//properties that will be added to the class when it's instantiated
	public var arguments			: Array <String>;	//properties that should be given to the classfactory function to instantiate the class
	public var cssValue				: String;
	
	
	public function new ( classRef:String = null, params:Array<Dynamic> = null, args:Array<String> = null, cssValue:String = null )
	{
#if (debug || neko)
		_oid = ID.getNext();
		if (params == null)
			params = [];
#end
		this.classRef	= classRef;
		this.params		= params;
		this.arguments	= args;
		this.cssValue	= cssValue;
	}
	
	
	public function dispose ()
	{
#if (debug || neko)
		_oid		= 0;
#end
		classRef	= null;
		params		= null;
		arguments	= null;
	}
	
	
	/*public function create () : InstanceType
	{
		Assert.notNull(classRef);
		if (params == null)
			return classRef.createInstance( EMPTY_ARRAY );
		else
			return classRef.createInstance( params );
	}*/
	

#if neko
	public function toCSS (prefix:String = "")
	{
		return cssValue == null ? classRef : cssValue;
	/*	var i = create();
		if (i != null && i.is(ICSSFormattable))
			return i.as(ICSSFormattable).toCSS();
		else
			return i.string();*/
	}
	
	
	public function toString ()	{ return toCSS(); }
	public function isEmpty ()	{ return classRef == null; }
	
	
	public function toCode (code:ICodeGenerator)
	{
		code.createFactory( this, classRef, (params == null ? EMPTY_ARRAY : params), arguments );
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
#end