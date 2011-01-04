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
package primevc.gui.graphics;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.core.collections.FastCell;
 import primevc.core.geom.IRectangle;
 import primevc.gui.traits.IGraphicsOwner;
  using primevc.utils.TypeUtil;



/**
 * Base class for composed property classes.
 * It doesn't implement an iterator since the class is an iterator of it's own.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 04, 2010
 */
class ComposedGraphicProperty extends GraphicElement, implements IComposedGraphicProperty 
{
	/**
	 * Reference to the first cell with a GraphicProperty (needed to start looping)
	 */
	private var firstCell	: FastCell < IGraphicProperty >;
	/**
	 * Reference to the last added cell with a GraphicProperty (needed to add new cells)
	 */
	private var lastCell	: FastCell < IGraphicProperty >;
	/**
	 * Cursor the cell on which it is currently looping. (instance can only be used in one loop at the time)
	 */
	private var nextCell	: FastCell < IGraphicProperty >;
	
	public var length		(default, null): Int;
	
	
	public function new ()
	{
		length = 0;
		super();
	}
	
	override public function dispose ()
	{
		var cur = firstCell;
		while (cur != null)
		{
			var tmp = cur;
			cur = cur.next;
			tmp.dispose();
		}
		
		length = 0;
		firstCell = lastCell = null;
		super.dispose();
	}
	
	
	//
	// IGRAPHICPROPERTY METHODS
	//
	
	public function begin (target:IGraphicsOwner, bounds:IRectangle)
	{
		if (nextCell != null)
			nextCell.data.begin( target, bounds );
	}
	
	
	public function end (target:IGraphicsOwner, bounds:IRectangle)
	{
		if (nextCell != null) {
			nextCell.data.end(target, bounds);
			next();
		}	
	}
	
	
	
	//
	// IITERATOR METHODS
	//
	
	public function rewind ()		{ nextCell = firstCell; }
	public function hasNext ()		{ return nextCell != null; }
	public function setCurrent (v)	{}
	
	
	public function next () : IGraphicProperty
	{
		var cur = nextCell;
		nextCell = nextCell.next;
		return cur.data;
	}
	
	
	//
	// LIST METHODS
	//
	
	public function add (property:IGraphicProperty) : Bool
	{
		Assert.that(property != this);
		
		if (property == null)
			return false;
		
		if (property.is(IComposedGraphicProperty))
		{
			merge(cast property);
		}
		else
		{
			var cell = new FastCell<IGraphicProperty>(property, lastCell);
			if (firstCell == null)
				nextCell = firstCell = cell;
	
			lastCell = cell;
			length++;
		}
		return true;
	}
	
	
	public function remove (property:IGraphicProperty) : Bool
	{	
		var prev:FastCell<IGraphicProperty> = null;
		var cur		= firstCell;
		var success = false;
		while (cur != null)
		{
			if (cur.data == property)
			{
				//remove cell
				if (prev == null)		firstCell	= cur.next;
				else					prev.next	= cur.next;
				
				if (lastCell == cur)	lastCell	= prev;
				
				cur.dispose();
				success = true;
				length--;
				break;
			}
			
			prev = cur;
			cur	 = cur.next;
		}
		return success;
	}
	
	
	public function merge (other:IComposedGraphicProperty)
	{
		Assert.that(other != this);
		other.rewind();
		
		while (other.hasNext())
		{
			var n = other.next();
			Assert.that(n != this);
			other.remove( n );
			add( n );
		}
		
		other.dispose();
	}
	
	
#if neko
	
	//
	// CSS / ICODEFORMATTABLE METHODS
	//
	
	override public function toCSS (prefix:String = "")
	{
		var str = "";
		var cur = firstCell;
		while (cur != null)
		{
			Assert.notThat( cur.data.is(IComposedGraphicProperty) );
			Assert.notEqual( cur, cur.next );
			
			str += cur.data.toCSS(prefix);
			cur  = cur.next;
		}
		return str;
	}
	
	
	override public function isEmpty () : Bool
	{
		return firstCell == null || firstCell.data == null;
	}
	
	
	override public function toCode (code:ICodeGenerator)
	{
		code.construct( this );
		
		var cur = firstCell;
		while (cur != null)
		{
			code.setAction(this, "add", [ cur.data ]);
			cur = cur.next;
		}
	}
#end
}