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
 import primevc.core.collections.iterators.FastArrayForwardIterator;
 import primevc.core.traits.IClonable;
 import primevc.core.traits.IDisposable;
#if neko
 import primevc.tools.generator.ICodeFormattable;
#end
 import primevc.utils.FastArray;
#if (neko || debug)
 import primevc.tools.generator.ICodeGenerator;
 import primevc.utils.ID;
 import primevc.utils.TypeUtil;
#end
  using primevc.utils.FastArray;
  using Std;


/**
 * Simple Dictionary implementation
 * 
 * @author Ruben Weijers
 * @creation-date Sep 30, 2010
 */
class SimpleDictionary < KType, VType > 
				implements IDisposable
			,	implements IClonable<SimpleDictionary<KType, VType>>
#if !neko	,	implements haxe.rtti.Generic
#else		,	implements ICodeFormattable		#end
{
	private var _keys	: FastArray < KType >;
	private var _values	: FastArray < VType >;
	public var length	(getLength, never)	: Int;
	
#if (neko || debug)
	public var _oid		(default, null)		: Int;
#end
	
	
	public function new (size:Int = 0, fixed:Bool = false)
	{
#if (neko || debug)
		_oid	= ID.getNext();
#end
		_keys	= FastArrayUtil.create(size, fixed);
		_values	= FastArrayUtil.create(size, fixed);
	}
	
	
	public function dispose ()
	{
		removeAll();
		_keys	= null;
		_values	= null;
	}
	
	
	public function clone ()
	{
		var inst = new SimpleDictionary<KType, VType>();
		for (i in 0...length)
			inst.set( _keys[i], _values[i] );
		
		return inst;
	}
	
	
	public function removeAll ()
	{
		_keys.removeAll();
		_values.removeAll();
	}
	
	
	public function set (key:KType, val:VType) : VType
	{
		Assert.notNull( key );
		Assert.notNull( val );
		var index = _keys.indexOf(key);
		if (index == -1)
		{
			_keys.push( key );
			_values.push( val );
		}
		else
		{
			_values[ index ] = val;
		}
		return val;
	}
	
	
	public function get (key:KType) : VType
	{
		var index = _keys.indexOf( key );
		return (index > -1) ? _values[ index ] : null;
	}
	
	
	public function unset (key:KType) : Void
	{
		var index = _keys.indexOf(key);
		
		if (index > -1)
			removeAt( index );
	}
	
	
	private function removeAt (index:Int) : Void
	{
		_values.removeAt( index );
		_keys.removeAt( index );
	}
	
	
	
	public inline function iterator ()				: Iterator < VType >	{ return new FastArrayForwardIterator < VType > ( _values ); }
	public inline function isEmpty ()				: Bool					{ return _values.length == 0; }
	private inline function getLength ()			: Int					{ return _values.length; }
	public inline function exists (key:KType)		: Bool					{ return _keys.indexOf( key ) > -1; }
	public inline function hasValue (value:VType)	: Bool					{ return _values.indexOf( value ) > -1; }
	public inline function keys ()					: Iterator < KType >	{ return new FastArrayForwardIterator < KType > ( _keys ); }
	public inline function keyList ()				: FastArray < KType >	{ return _keys; }
	public inline function valueList ()				: FastArray < VType >	{ return _values; }

#if debug
	public function keysToString () : String	{ return "keys: [ " +_keys.join(", ") + " ]"; }
	#if !neko
	public function toString ()		: String
	{
		var str = [];
		for (i in 0...length)
			str.push( "[ " + _keys[i] + " ] => " + _values[i] );
		
		return "dic: "+(length > 0 ? str.join(", ") : "empty");
	}
	#end
#end

#if neko
	public function toHash () : Hash<VType>
	{
		var hash = new Hash<VType>();
		
		for (i in 0...length)
			hash.set( Std.string( _keys[i] ), _values[i] );
		
		return hash;
	}
	
	
	public function cleanUp ()
	{
		var keysToRemove = [];
		
		for (i in 0...length)
		{
			if (!TypeUtil.is( _values[i], ICodeFormattable))
				continue;
			
			var item = TypeUtil.as( _values[i], ICodeFormattable);
			item.cleanUp();
			if (item.isEmpty())
				keysToRemove.push(_keys[i]);
		}
		
		//remove keys after the loop so that length property won't be messed up
		for (key in keysToRemove)
			unset(key);
		
	//	trace("end cleaning "+length+"; removed: "+keysToRemove.length);
	}
	
	
	public function toCode (code:ICodeGenerator) : Void
	{
		if (!isEmpty())
		{
			var type:Class<Dynamic> = null;
			if (length > 0)
			{
				var key0 = _keys[0];
				if		(key0.is(Int))		type = IntHash;
				else if (key0.is(String))	type = Hash;
			}
			
			if (type == null)	code.construct( this, [ _values.length ] );
			else				code.construct( this, null, type );
			
			for (i in 0...length)
				code.setAction( this, "set", [ _keys[i], _values[i] ] );
		}
	}
#end
}