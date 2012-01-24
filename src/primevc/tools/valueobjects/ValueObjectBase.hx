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
 import primevc.core.traits.IFlagOwner;
 import primevc.core.traits.IValueObject;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.RevertableBindableFlags;
  using primevc.utils.BitUtil;
  using primevc.utils.IfUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = RevertableBindableFlags;


/**
 * Base class for all generated ValueObjects
 * 
 * @author Danny Wilson
 * @creation-date Dec 03, 2010
 */
class ValueObjectBase implements IValueObject, implements IFlagOwner
{
	public var change (default, null) : Signal1<ObjectChangeSet>;
	
	private var _changedFlags	: Int;
	private var _propertiesSet	: Int;
	private var _flags			: Int;
	
	/**
	 * method to initialize an value-object. Create bindings to the properties of the vo in this method.
	 * this is done in a seperate method (instead of just the constructor) so that the method can also be
	 * callen when empty-VO's are created through deserialization (using Type.createEmptyInstance).
	 */
	private function init ()
	{
		change = new Signal1();
#if js	_changedFlags = _flags = 0; #end
	}
	
	
	public function dispose()
	{
		Assert.that(!isDisposed(), this+" is already disposed!");
	//	if (change.notNull()) {
		change.dispose();
		change = null;
	//	}
		_changedFlags = _propertiesSet = _flags = 0;
	}
	
	
	public inline function isEmpty() : Bool				{ return !_propertiesSet.not0(); }
	public inline function isEditable() : Bool			{ return _flags.has(Flags.IN_EDITMODE); }
	public inline function isDisposed() : Bool			{ return change == null; }
	public inline function changed () : Bool			{ return _changedFlags.not0(); }
	public function has (propertyID : Int) : Bool		{ return (_propertiesSet & (1 << ((propertyID & 0xFF) + _fieldOffset(propertyID >>> 8)))).not0(); }
	public function getPropertyById (id:Int) : Dynamic	{ Assert.abstract(); return null; }
	public function setPropertyById (id:Int, v:Dynamic)	{ Assert.abstract(); }
	
	private inline function setPropertyFlag(propertyID : Int) : Void {
		_propertiesSet = _propertiesSet.set(1 << ((propertyID & 0xFF) + _fieldOffset(propertyID >>> 8)));
	}
	private inline function unsetPropertyFlag(propertyID : Int) : Void {
		_propertiesSet = _propertiesSet.unset(1 << ((propertyID & 0xFF) + _fieldOffset(propertyID >>> 8)));
	}
	
	public function commitEdit()
	{
		if(!isEditable()) return;
		
		if (changed())
		{
			var set = ObjectChangeSet.make(this, _changedFlags);
			addChanges(set);
			this.change.send(set);
		}
		commitBindables();
		
		_flags			= _flags.unset( Flags.IN_EDITMODE );
		_changedFlags	= 0;
	}
	
	
	public function objectChangedHandler(propertyID : Int) : ObjectChangeSet -> Void
	{
		// Same ObjectPathVO instance reused
		return callback(objectChangedHandlerBody, propertyID, ObjectPathVO.make(this, propertyID));
	}
	
	private function objectChangedHandlerBody(propertyID : Int, pathNode : ObjectPathVO, change : ObjectChangeSet)
	{
    	Assert.notNull(this.change);
		Assert.notNull(change);
		
		var p = change.parent;
		
		if (p.notNull()) {
			// Find either pathNode, or the last parent
			while (p.notNull() && p.parent.notNull() && p.parent != pathNode) p = p.parent;
			untyped p.parent = pathNode;
		}
		else untyped change.parent = pathNode;
		
		if (change.vo.isEmpty())
			this.unsetPropertyFlag(propertyID);
		else
			this.setPropertyFlag(propertyID);
		
		this.change.send(change);
	}
	
	
	private function addChanges(changeSet:ObjectChangeSet) {} // Creates and adds all PropertyChangeVO and ListChangeVO
	private function commitBindables() {}
	private function _fieldOffset(typeID:Int): Int { Assert.abstract(); return -1; }
	
	
	public function beginEdit()
	{
	//	Assert.that( !isEditable() );
		_flags = _flags.set( Flags.IN_EDITMODE );
	}
	
	
	public function cancelEdit()
	{
		Assert.that( isEditable(), this + "; flags: "+_flags );
		_flags			= _flags.unset( Flags.IN_EDITMODE );
		_changedFlags	= 0;
	}


	//FIXME: Define different ValueObjectBase for the viewer (without ObjectChangeSet's)
	public static inline function addChangeListener (vo:IValueObject, owner:Dynamic, handler:ObjectChangeSet->Void)
	{
#if debug
		Assert.notNull(vo);
		Assert.that(vo.is(ValueObjectBase));
#end
		vo.as(ValueObjectBase).change.bind(owner, handler);
	}



	//FIXME: Define different ValueObjectBase for the viewer
	public static inline function removeChangeListener (vo:IValueObject, owner:Dynamic)
	{
#if debug
		Assert.notNull(vo);
		Assert.that(vo.is(ValueObjectBase));
#end
		vo.as(ValueObjectBase).change.unbind(owner);
	}
	
/*
	Kijken wat kleinere SWF geeft: calls hiernaar, of methods genereren...
	
	private static function propertyChangeHandler<T>(instance:ValueObjectBase, propertyBit : Int) : Void -> Void
	{
		return function() {
			instance._changedFlags |= propertyBit;
		}
	}
#if debug
	public function toString () return "ValueObjectBase"
#end
*/
}
