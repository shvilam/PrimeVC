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
package primevc.avm2;
 import flash.display.DisplayObjectContainer;
 import flash.display.DisplayObject;
 import primevc.core.collections.FastArrayIterator;
 import primevc.core.collections.IList;
 import primevc.core.events.ListEvents;
 import primevc.core.IDisposable;
 import primevc.gui.display.IDisplayContainer;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.display.Window;
  using primevc.utils.TypeUtil;


private typedef ChildType = DisplayObject;


/**
 * Wrapper class to add children to the given DisplayObjectContainer.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 13, 2010
 */
class DisplayList implements IList <ChildType>
{
	public var target		(default, null)				: DisplayObjectContainer;
	public var events		(default, null)				: ListEvents < ChildType >;
	public var length		(getLength, never)			: Int;
	
	/**
	 * Wrapper object for the stage.
	 */
	public var window		(default, setWindow)		: Window;
	
	public var mouseEnabled	(default, setMouseEnabled)	: Bool;
	public var tabEnabled	(default, setTabEnabled)	: Bool;
	
	
	public function new ( target:DisplayObjectContainer )
	{
		Assert.notEqual( target, null, "No target given");
		this.target = target;
		events = new ListEvents();
	}
	
	
	public inline function dispose ()
	{
		removeAll();
		events.dispose();
		events	= null;
		target	= null;
		window	= null;
	}
	
	
	public inline function removeAll ()
	{
		for (child in this)
			if (child.is(IDisposable))
				child.as(IDisposable).dispose();
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setMouseEnabled (v)		{ return mouseEnabled = target.mouseChildren = v; }
	private inline function setTabEnabled (v)		{ return tabEnabled = target.tabChildren = v; }
	
	
	private function setWindow (v)
	{
		if (window != v)
		{
			window = v;
			for (child in this)
				if (child.is(IDisplayContainer))
					child.as(IDisplayContainer).children.window = v;
		}
		return v;
	}
	
	
	//
	// LIST METHODS
	//

	public inline function iterator		() : Iterator <ChildType>	{ return new DisplayListIterator(this); }
	public inline function getItemAt	(pos:Int)					{ return target.getChildAt(pos); }
	public inline function has			(item:ChildType)			{ return target.contains(item); } 
	public inline function indexOf		(item:ChildType)			{ return target.getChildIndex(item); }
	private inline function getLength	()							{ return target.numChildren; }
	
	
	public inline function add (item:ChildType, pos:Int = -1) : ChildType
	{
		Assert.that(pos <= length, "Index to add child is to high! "+pos+" instead of max "+length);
		if (pos < 0 || pos > length)
			pos = length;
		
		//make sure that if the child is in another displaylist, it will fire an remove event when the child is removed.
		if (item.is(IDisplayObject)) {
			var child = item.as(IDisplayObject);
			if (child.displayList != null && child.displayList != this)
				child.displayList.remove(item);
			
			child.displayList = this;
			
			if (child.is(IDisplayContainer))
				child.as(IDisplayContainer).children.window = window;
		//	if		(target.is(IDisplayObject))		child.window = target.as(IDisplayObject).window;
		//	else if	(target.is(Window))				child.window = target.as(Window);
		}
		
		item = target.addChildAt( item, pos );
		events.added.send( item, pos );
		return item;
	}
	
	
	public inline function remove (item:ChildType) : ChildType
	{
		Assert.that( has(item), "remove: Child "+item+" is not in "+this );
		
		if (item.is(IDisplayObject)) {
			var child = item.as(IDisplayObject);
			child.displayList	= null;
		//	child.window		= null;
		}
		
		var pos = indexOf(item);
		target.removeChild(item);
		events.removed.send( item, pos );
		return item;
	}
	
	
	public inline function move (item:ChildType, newPos:Int, curPos:Int = -1) : ChildType
	{
		if (curPos == -1)
			curPos = indexOf(item);
		
		Assert.that( curPos >= 0, "Child to move is not in this DisplayList: "+item );
		
		target.addChildAt( item, newPos );
		events.moved.send( item, curPos, newPos );
		return item;
	}

#if debug
	public inline function toString () { return "DisplayList( "+length+" ) of " + target; }
#end
}



/**
 * Iterator for displaylist
 * 
 * @author Ruben Weijers
 * @creation-date Jul 13, 2010
 */
class DisplayListIterator
{
	private var list (default, null)	: DisplayList;
	public var current 					: Int;
	
	
	public function new (list:DisplayList) {
		this.list = list;
	}
	
	
	public inline function rewind () { current = 0; }
	public inline function forward () { current = list.length; }
	
	
	public inline function hasNext () { return current < list.length; }
	public inline function hasPrev () { return current > 0; }
	
	
	public inline function next () { return list.getItemAt(current++); }
	public inline function prev () { return list.getItemAt(current--); }
}