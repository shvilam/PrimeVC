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
 import primevc.core.collections.iterators.IIterator;
 import primevc.core.events.ListChangeSignal;
 import primevc.core.traits.IClonable;
 import primevc.core.traits.IDuplicatable;
 import primevc.core.traits.IValueObject;
 import primevc.core.traits.IDisposable;

/**
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
interface IReadOnlyList < DataType >
		implements IClonable < IReadOnlyList < DataType > >
	,	implements IDuplicatable < IReadOnlyList < DataType > >
	,	implements IValueObject
	,	implements IDisposable
{
	public var change		(default, null)									: ListChangeSignal<DataType>;
	/**
	 * TODO - Ruben sep 5, 2011:
	 * Maybe combine change and beforeChange to one Signal2 that has an extra parameter
	 * to indicate if the change is before or after applying the change..
	 */
//	public var beforeChange	(default, null)									: ListChangeSignal<DataType>;
	public var length		(getLength, never)								: Int;
	
	/**
	 * Method will check if the requested item is in this collection
	 * @param	item
	 * @return	true if the item is in the list, otherwise false
	 */
	public function has		(item:DataType)										: Bool;
	
	/**
	 * Method will return the index of the requested item or -1 of the item is 
	 * not in the list.
	 * @param	item
	 * @return	position of the requested item
	 */
	public function indexOf	(item:DataType)										: Int;
	
	
	//
	// ITERATION METHODS
	//
	
	public function getItemAt (pos:Int)		: DataType;
	public function iterator ()				: Iterator <DataType>;
	public function forwardIterator ()		: IIterator <DataType>;
	public function reversedIterator ()		: IIterator <DataType>;
	
	
#if debug
	public var name : String;
#end
}