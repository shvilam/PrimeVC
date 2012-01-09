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
  using primevc.utils.Bind;
  using primevc.utils.FastArray;



/**
 * @author Ruben Weijers
 * @creation-date Jan 5, 2012
 */
class Sort<DataType> extends ReadOnlyArrayList<DataType>
{
	public  var source 	(default, setSource) 	: IReadOnlyList<DataType>;
	public  var sort 	(default, setSort) 		: DataType -> DataType -> Int;


	public function new (source:IReadOnlyList<DataType>, sort:DataType->DataType->Int)
	{
		super();
		this.source 	= source;
		this.sort 		= sort;
	}


	override public function dispose ()
	{
		this.source = null;
		(untyped this).sort = null;
		super.dispose();
	}


	private function setSort (v:DataType->DataType->Int)
	{
		if (v != sort) {
			sort = v;
			if (v != null)
				array.sort(v);	//apply sorting
		}
		return v;
	}


	private function setSource (v:IReadOnlyList<DataType>)
	{
		if (v != source)
		{
			if (source != null) {
				this.source.change.unbind(this);
				list.removeAll();
			}

			source = v;
			
			if (v != null) {
				for (i in v)
					list.push(i);
				
				applySourceChange.on( v.change, this );
			}

			change.send(reset);
		}
		return v;
	}



	private function applySourceChange (c:ListChange<DataType>) switch (c)
	{
		case ListChange.added(item, pos):
			var added = false;
			for (i in 0...list.length) 	if (sort(list[i], item) == 1) {
				added = true;
				add(item, i);
				break;
			}
			if (!added)
				add(item, list.length);


		case removed(item, pos):
			removeAt(item, list.indexOf(item));

		case moved(item, n, o):


		case reset:
			list.removeAll();
			for (i in source)
				list.push(i);
			
			list.sort(sort);
			change.send( ListChange.reset );
	}


	private inline function add (item:DataType, pos:Int)
	{
		list.insertAt(item, pos);
		change.send( ListChange.added( item, pos ) );
	}


	private inline function removeAt (item:DataType, pos:Int)
	{
		list.removeAt(pos);
		change.send( ListChange.removed( item, pos ) );
	}
}