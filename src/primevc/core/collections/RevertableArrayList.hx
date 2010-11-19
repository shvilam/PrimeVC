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
 import primevc.core.RevertableBindableFlags;
 import primevc.utils.FastArray;
  using primevc.utils.BitUtil;
  using primevc.utils.ChangesUtility;
  using primevc.utils.FastArray;


private typedef Flags = RevertableBindableFlags;


/**
 * @author Ruben Weijers
 * @creation-date Nov 19, 2010
 */
class RevertableArrayList < DataType > extends ReadOnlyArrayList < DataType >
			,	implements IRevertableList < DataType >
//#if flash9	,	implements haxe.rtti.Generic	#end
{
	private static inline var REMEMBER_CHANGES = 32768;	// 0b_1000 0000 0000 0000
	/**
	 * Keeps track of settings.
	 */
	public var flags : Int;
	
	/**
	 * List with all the changes that are made when the list is in editing mode.
	 */
	public var changes (default,null) : FastArray<ListChange<DataType>>;
	
	
	
	//
	// EDITABLE VALUE-OBJECT METHODS
	//
	
	
	public inline function beginEdit ()
	{
		// Only set REMEMBER_CHANGES if IN_EDITMODE is not set
		Assert.that(Flags.IN_EDITMODE << 11 == REMEMBER_CHANGES);
		flags = flags.set( (((flags & Flags.IN_EDITMODE) << 11) ^ REMEMBER_CHANGES) | Flags.IN_EDITMODE );
		
		if (flags.has(REMEMBER_CHANGES))
			changes = FastArrayUtil.create();
	}
	
	
	public inline function commitEdit ()
	{
		// Check if REMEMBER_CHANGES is not set (value changed) and any dispatch flag is set.
		if (flags.has(REMEMBER_CHANGES) && flags.hasNone( Flags.DISPATCH_CHANGES_BEFORE_COMMIT ))
			while (changes.length > 0)
				change.send( changes.pop() );
		
		stopEdit();
	}
	
	
	public inline function cancelEdit ()
	{
		if (flags.hasAll(Flags.IN_EDITMODE | REMEMBER_CHANGES))
			while (changes.length > 0)
				this.undoListChange( changes.pop() );
		
		stopEdit();
	}
	
	
	private inline function stopEdit ()
	{
		if (changes != null) {
			changes.removeAll();
			changes = null;
		}
		flags = flags.unset(Flags.IN_EDITMODE);
	}
	
	
	
	//
	// IBINDABLE LIST METHODS
	//
	
	
	private inline function addChange (listChange:ListChange<DataType>)
	{
		if (flags.has( REMEMBER_CHANGES ))
			changes.push( listChange );

		if (flags.has( Flags.DISPATCH_CHANGES_BEFORE_COMMIT ))
			change.send( listChange );
	}
	
	
	public function removeAll ()
	{
		list.removeAll();
	}
	
	
	public function add (item:DataType, pos:Int = -1) : DataType
	{
		var f = flags;
		Assert.that( f.has(Flags.IN_EDITMODE) );
		
		pos = list.insertAt(item, pos);
		addChange( ListChange.added( item, pos ) );
		
		return item;
	}
	
	
	public function remove (item:DataType, oldPos:Int = -1) : DataType
	{
		var f = flags;
		Assert.that( f.has(Flags.IN_EDITMODE) );
		
		if (oldPos == -1)
			oldPos = list.indexOf(item);
		
		if (oldPos > -1 && list.removeItem(item, oldPos))
			addChange( ListChange.removed( item, oldPos ) );
		
		return item;
	}
	
	
	public function move (item:DataType, newPos:Int, curPos:Int = -1) : DataType
	{
		var f = flags;
		Assert.that( f.has(Flags.IN_EDITMODE) );
		
		if		(curPos == -1)				curPos = list.indexOf(item);
		if		(newPos > (length - 1))		newPos = length - 1;
		else if (newPos < 0)				newPos = length - newPos;
		
		if (curPos != newPos && list.move(item, newPos, curPos))
			addChange( ListChange.moved( item, newPos, curPos ) );
		
		return item;
	}
}