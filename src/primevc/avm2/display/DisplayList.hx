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
package primevc.avm2.display;
 import flash.display.DisplayObjectContainer;
 import flash.display.DisplayObject;
 import primevc.core.collections.iterators.IIterator;
 import primevc.core.collections.IEditableList;
 import primevc.core.collections.ListChange;
 import primevc.core.collections.IReadOnlyList;
 import primevc.core.events.ListChangeSignal;
 import primevc.core.traits.IDisposable;
 import primevc.gui.display.IDisplayContainer;
 import primevc.gui.display.IDisplayObject;
  using primevc.utils.TypeUtil;


private typedef TargetChildType	= DisplayObject;
private typedef ChildType		= IDisplayObject;


/**
 * Wrapper class to add children to the given DisplayObjectContainer.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 13, 2010
 */
class DisplayList implements IEditableList <ChildType>
{
	/**
	 * Target display-object. This display-object will be controlled by the
	 * DisplayList instance.
	 */
	public var target		(default, null)				: DisplayObjectContainer;
	/**
	 * Owner contains a reference to the object that created this displaylist
	 * instance. Normally this reference is the same as the target property
	 * but the DisplayObject will in some cases be a different object than
	 * the owner.
	 */
	public var owner		(default, null)				: IDisplayContainer;
	
	public var change		(default, null)				: ListChangeSignal < ChildType >;
	public var length		(getLength, never)			: Int;
	
	/**
	 * Property to enable mouse events on children or not
	 */
	public var mouseEnabled	(default, setMouseEnabled)	: Bool;
	
	/**
	 * Property to enable tab events on children or not
	 */
	public var tabEnabled	(default, setTabEnabled)	: Bool;
	
	
	public function new ( target:DisplayObjectContainer, ?owner:IDisplayContainer )
	{
		Assert.notEqual( target, null, "No target given");
		
		if (owner == null && target.is(IDisplayContainer))
			owner = target.as(IDisplayContainer);
		
		Assert.notEqual( owner, null, "Owner object can't be null." );
		
		this.target		= target;
		this.owner		= owner;
		change			= new ListChangeSignal();
		tabEnabled		= target.tabChildren;
		mouseEnabled	= target.mouseChildren;
	}
	
	
	public function dispose ()
	{
		removeAll();
		change.dispose();
		change	= null;
		target	= null;
		owner	= null;
	}
	
	
	public inline function isEmpty () : Bool
	{
		return length == 0;
	}
	
	
	public inline function clone () : IReadOnlyList <ChildType>
	{
		return new DisplayList( target, owner );
	}
	
	
	public inline function duplicate () : IReadOnlyList <ChildType>
	{
		return new DisplayList( target, owner );
	}
	
	
	public inline function disposeAll ()
	{
		for (child in this)
			if (child != null)		//<- is needed for children that are not IDisplayable!
				child.dispose();
	}
	
	
	public inline function removeAll ()
	{
		while (length > 0)
		{
			var child = target.getChildAt(0).as(ChildType);
			target.removeChildAt(0);
			child.container = null;
		}
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setMouseEnabled (v)		{ return mouseEnabled	= target.mouseChildren = v; }
	private inline function setTabEnabled (v)		{ return tabEnabled		= target.tabChildren = v; }
	private inline function getLength	()			{ return target.numChildren; }
	
	
	//
	// LIST METHODS
	//

	public function iterator () : Iterator <ChildType>			{ return forwardIterator(); }
	public function forwardIterator () : IIterator <ChildType>	{ return new DisplayListForwardIterator(this); }
	public function reversedIterator () : IIterator <ChildType>	{ return new DisplayListReversedIterator(this); }
	
	public inline function getItemAt	(pos:Int)				{ var v = target.getChildAt( pos ); return v.is(ChildType) ? v.as(ChildType) : null; }
	public inline function has			(item:ChildType)		{ return target.contains( item.as( TargetChildType ) ); } 
	public inline function indexOf		(item:ChildType)		{ return target.getChildIndex( item.as( TargetChildType ) ); }
	
	
	public function add (item:ChildType, pos:Int = -1) : ChildType
	{
		if (pos > length)
			Assert.that(pos <= length, "Index to add child is to high! "+pos+" instead of max "+length);
		
		if		(pos > length)	pos = length;
		else if (pos < 0)		pos = length; // -pos;
		
		//make sure that if the child is in another displaylist, it will fire an remove event when the child is removed.
		if (item.container != null && item.container != owner)
			item.container.children.remove(item);
		
		item.container = owner;
		target.addChildAt( item.as( TargetChildType ), pos );
		change.send( ListChange.added( item, pos ) );
		return item;
	}
	
	
	public function remove (item:ChildType, oldPos:Int = -1) : ChildType
	{
		Assert.that( has(item), "remove: Child "+item+" is not in "+this );
		
		if (oldPos == -1)
			oldPos = indexOf(item);
		
		target.removeChild(item.as( TargetChildType ));
		item.container = null;
		
		change.send( ListChange.removed( item, oldPos ) );
		return item;
	}
	
	
	public function move (item:ChildType, newPos:Int, curPos:Int = -1) : ChildType
	{
		if (curPos == -1 && has(item))
			curPos = indexOf(item);
		
		Assert.that( curPos >= 0, "Child to move is not in this DisplayList: "+item );
		
	//	target.addChildAt( item.as( TargetChildType ), newPos );
		target.setChildIndex( item.as( TargetChildType ), newPos );
		change.send( ListChange.moved( item, newPos, curPos ) );
		return item;
	}

#if debug
	public var name : String;
	
	public function childrenToString () {
		var items = [];
		var i = 0;
		for (curChild in this) {
			items.push( "[ " + i + " ] = " + curChild );
			i++;
		}
		return name + "DisplayList ("+items.length+")\n" + items.join("\n");
	}
	public inline function toString () { return name + "DisplayList( "+length+" ) of " + target; }
#end
}



/**
 * Iterator for displaylist
 * 
 * @author Ruben Weijers
 * @creation-date Jul 13, 2010
 */
class DisplayListForwardIterator implements IIterator <ChildType>
{
	private var list 	: DisplayList;
	public var current	: Int;
	
	public function new (list:DisplayList)			{ this.list = list; rewind(); }
	public inline function setCurrent (val:Dynamic)	{ current = val; }
	public inline function rewind ()				{ current = 0; }
	public inline function hasNext ()				{ return current < list.length; }
	public inline function next ()					{ return list.getItemAt( current++ ); }
	public inline function value ()					{ return list.getItemAt( current ); }
}



/**
 * Iterator for displaylist
 * 
 * @author Ruben Weijers
 * @creation-date Jul 23, 2010
 */
class DisplayListReversedIterator implements IIterator <ChildType>
{
	private var list 	: DisplayList;
	public var current	: Int;

	public function new (list:DisplayList)			{ this.list = list; rewind(); }
	public inline function setCurrent (val:Dynamic)	{ current = val; }
	public inline function rewind ()				{ current = list.length; }
	public inline function hasNext ()				{ return current >= 0; }
	public inline function next ()					{ return list.getItemAt( current-- ); }
	public inline function value ()					{ return list.getItemAt( current ); }
}