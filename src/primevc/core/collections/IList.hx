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
 import primevc.core.dispatcher.Signal1;
 import primevc.core.traits.IClonable;
 import primevc.core.IDisposable;


typedef OldPos = Int;
typedef NewPos = Int;

/**
 * @author			Ruben Weijers
 * @creation-date	Oct 26, 2010
 */
enum ListChanges <T>
{
	added ( item:T, newPos:NewPos );
	removed ( item:T, oldPos:OldPos );
	moved ( item:T, newPos:NewPos, oldPos:OldPos );
	reset;
}
 

/**
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
interface IList <DataType> 
		implements IClonable < IList < DataType > >
	,	implements IDisposable
{
//	public var events		(default, null)									: ListEvents <DataType>;
	public var change		(default, null)									: Signal1 < ListChanges < DataType > >;
	public var length		(getLength, never)								: Int;
	
	
	//
	// LIST MANIPULATION METHODS
	//
	
	/**
	 * Method will add the item on the given position. It will add the 
	 * item at the end of the childlist when the value is equal to -1.
	 * 
	 * @param	item
	 * @param	pos		default-value: -1
	 * @return	item
	 */
	public function add		(item:DataType, pos:Int = -1)						: DataType;
	/**
	 * Method will try to remove the given item from the childlist.
	 * 
	 * @param	item
	 * @return	item
	 */
	public function remove	(item:DataType, oldPos:Int = -1)					: DataType;
	/**
	 * Method will change the depth of the given item.
	 * 
	 * @param	item
	 * @param	newPos
	 * @param	curPos	Optional parameter that can be used to speed up the 
	 * 					moving process since the list doesn't have to search 
	 * 					for the original location of the item.
	 * @return	item
	 */
	public function move	(item:DataType, newPos:Int, curPos:Int = -1)		: DataType;
	
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
	
	public function getItemAt (pos:Int)			: DataType;
	public function iterator ()					: Iterator <DataType>;
	public function forwardIterator ()		: IIterator <DataType>;
	public function reversedIterator ()		: IIterator <DataType>;
	
	
#if debug
	public var name : String;
#end
}