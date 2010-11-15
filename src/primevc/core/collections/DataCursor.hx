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
package primevc.core.collections;



/**
 * @author Ruben Weijers
 * @creation-date Oct 28, 2010
 */
class DataCursor < DataType > implements IDataCursor < DataType > 
{
	public var target	(default, null)		: DataType;
	public var list		(default, setList)	: IList < DataType >;
	public var depth	(default, null)		: Int;
	
	
	public function new (target:DataType, list:IList < DataType > = null)
	{
		this.target	= target;
		this.list	= list;
	}
	
	
	public function dispose ()
	{
		target	= null;
		list	= null;
		depth	= -1;
	}
	
	
	private inline function setList (v)
	{
		if (v != list)
		{
			list = v;
			if (v != null)
				depth = v.indexOf( target );
		}
		return v;
	}
	
	
	public function removeTarget ()
	{
		Assert.notNull( list );
		list.remove( target, depth );
	}
	
	
	public function restore ()
	{
		Assert.notNull( list );
		if (!list.has(target))
			list.add( target, depth );
		else
			list.move( target, depth );
	}
	
	
	public function moveTarget (newDepth:Int, newList:IList < DataType > = null)
	{
		Assert.notNull( list );
	//	trace("Cursor.moveTarget "+target+" "+depth+" => "+newDepth+"; newList "+(newList == list));
		if (list == newList || newList == null)
		{
			if (list.has(target))
				list.move( target, newDepth, depth );
			else
				list.add( target, newDepth );
		}
		else
		{
			if (list.has(target))
				list.remove( target, depth );
			
			newList.add( target, newDepth );
			list = newList;
		}
		depth = newDepth;
	}
}