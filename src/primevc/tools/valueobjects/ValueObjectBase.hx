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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Danny Wilson	<danny @ onlinetouch.nl>
 */
package primevc.tools.valueobjects;
 import primevc.core.collections.ListChange;
 import primevc.core.traits.IEditableValueObject;
 import primevc.core.traits.IValueObject;
 import primevc.core.collections.RevertableArrayList;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.RevertableBindable;
 import primevc.utils.FastArray;
#if debug
  using primevc.utils.ChangesUtil;
#end
  using primevc.utils.IfUtil;
  using primevc.utils.TypeUtil;

typedef PropertyID = Int;

/**
 * Base class for all generated ValueObjects
 * 
 * @author Danny Wilson
 * @creation-date Dec 03, 2010
 */
class ValueObjectBase implements IValueObject
{
	public var change (default, null) : Signal1<ObjectChangeSet>;
	
	private var _changedFlags	: Int;
	private var _propertiesSet	: Int;
	
	private function new ()
	{
		change = new Signal1();
	}
	
	
	public function dispose()
	{
		if (change.notNull()) {
			change.dispose();
			change = null;
		}
		_changedFlags = 0;
	}
	
	public function isEmpty() {
		return _propertiesSet == 0;
	}
	
	public function commitEdit()
	{
		if (_changedFlags.not0())
		{
			var set = ObjectChangeSet.make(this, _changedFlags);
			addChanges(set);
			this.change.send(set);
		}
		commitBindables();
		_changedFlags = 0;
	}
	
	public function objectChangedHandler(propertyID : Int) : ObjectChangeSet -> Void
	{
		var changeSignal = this.change;
		var pathNode = ObjectPathVO.make(this, propertyID); // Same ObjectPathVO instance reused
		
		return function(change:ObjectChangeSet)
		{
			Assert.notNull(changeSignal);
			Assert.notNull(change);
			
			var p = change.parent;
			
			if (p.notNull()) {
				// Find either pathNode, or the last parent
				while (p.notNull() && p.parent.notNull() && p.parent != pathNode) p = p.parent;
				untyped p.parent = pathNode;
			}
			changeSignal.send(change);
		}
	}
	
	private function addChanges(changeSet:ObjectChangeSet); // Creates and adds all PropertyChangeVO and ListChangeVO
	private function commitBindables();
	public function beginEdit();
	public function cancelEdit()
	{
		_changedFlags = 0;
	}
	
/*
	Kijken wat kleinere SWF geeft: calls hiernaar, of methods genereren...
	
	private static function propertyChangeHandler<T>(instance:ValueObjectBase, propertyBit : Int) : Void -> Void
	{
		return function() {
			instance._changedFlags |= propertyBit;
		}
	}
*/
}

class PropertyChangeVO extends ChangeVO
{
	public var propertyID	(default, null) : Int;
}

class ChangeVO implements IValueObject
{
	public var next (default,null) : PropertyChangeVO;
	
	
	public function dispose()
	{
		if (next.notNull()) {
			next.dispose();
			next = null;
		}
	}
}

class PropertyValueChangeVO extends PropertyChangeVO
{
	public var oldValue		(default, null) : Dynamic;
	public var newValue		(default, null) : Dynamic;
	
	private function new();
	
	static inline public function make(propertyID, oldValue, newValue)
	{
		var p = new PropertyValueChangeVO(); // Could come from freelist if profiling tells us to
		p.propertyID = propertyID;
		p.oldValue   = oldValue;
		p.newValue   = newValue;
		return p;
	}
	
	override public function dispose() {
		propertyID = -1;
		this.oldValue = this.newValue = null;
		super.dispose();
	}
	
#if debug
	public function toString ()
	{
		return oldValue + " -> " + newValue;
	}
#end
}

class ListChangeVO extends PropertyChangeVO
{
	public var changes : FastArray<ListChange<Dynamic>>;
	
	private function new();
	
	static inline public function make(propertyID, changes : FastArray<ListChange<Dynamic>>)
	{
		var l = new ListChangeVO(); // Could come from freelist if profiling tells us to
		l.propertyID = propertyID;
		l.changes = changes.concat();
		return l;
	}
	
	override public function dispose()
	{
		if (this.changes.notNull()) {
			for (i in 0 ... this.changes.length) changes[i] = null;
			this.changes = null;
		}
		super.dispose();
	}
	
#if debug
	public function toString ()
	{
		var output = [];
		for (change in changes)
			output.push( change );
		
		return output.length > 0 ? "\n\t\t\t\t" + output.join("\n\t\t\t\t") : "no-changes";
	}
#end
}
/*
ObjectChangeVO {
  vo : instanceof PublicationVO
  id : "pub1"
  propertiesChanged: SPREAD
  
  next: ObjectChangeVO {
    vo: instanceof SpreadVO
    id: "spread1"
    propertiesChanged: (bits)[ X, Y ]
    next: PropertyChangeVO { propertyID: X, oldValue: 0, newValue: 100,
      next: PropertyChangeVO { propertyID: Y, oldValue: 0, newValue: 100 }
    }
  }
}
*/

class ObjectChangeSet extends ChangeVO
{
	public var vo					(default, null) : ValueObjectBase;
	public var parent				(default, null) : ObjectPathVO;
	public var timestamp			(default, null) : Float;
	public var propertiesChanged	(default, null) : Int;
	
	private function new(); 
	
	static inline public function make(vo:ValueObjectBase, changes:Int)
	{
		var s = new ObjectChangeSet(); // Could come from freelist if profiling tells us to
		s.vo = vo;
		s.timestamp = haxe.Timer.stamp();
		s.propertiesChanged = changes;
		return s;
	}
	
	public function add(change:PropertyChangeVO) {
		untyped change.next = next;
		next = change;
	}
	
	inline public function addChange(id:Int, flagBit:Int, value:Dynamic)
	{
		if (flagBit.not0())
			add(PropertyValueChangeVO.make(id, null, value));
	}
	
	inline public function addBindableChange<T>(id:Int, flagBit:Int, bindable:RevertableBindable<T>)
	{
		if (flagBit.not0())
			add(PropertyValueChangeVO.make(id, bindable.shadowValue, bindable.value));
	}
	
	inline public function addListChanges<T>(id:Int, flagBit:Int, list:RevertableArrayList<T>)
	{
		if (flagBit.not0())
			add(ListChangeVO.make(id, list.changes));
	}
	
	
#if debug
	public function toString ()
	{
		var output = [];
		
		var change = next;
		while(change != null)
		{
			output.push( vo.propertyIdToString(change.propertyID) + ": " + change );
			change = change.next;
		}
		
		return "ChangeSet of " + Date.fromTime( timestamp * 1000 ) + " on "+vo+"; changes: \n\t\t\t" + output.join("\n\t\t\t");
	}
#end
}

class ObjectPathVO implements IValueObject
{
	public var parent		(default, null) : ObjectPathVO;
	public var object		(default, null) : IValueObject;
	public var propertyID	(default, null) : Int;
	
	private function new(); 
	
	public function dispose()
	{
		this.parent = null;
		this.object = null;
	}
	
	static inline public function make(vo:ValueObjectBase, propertyID:Int)
	{
		var p = new ObjectPathVO();
		p.object = vo;
		p.propertyID = propertyID;
		return p;
	}
}