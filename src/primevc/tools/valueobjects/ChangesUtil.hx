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
package primevc.tools.valueobjects;
 import primevc.core.collections.IEditableList;
 import primevc.core.collections.ListChange;
 import primevc.core.traits.IEditableValueObject;
 import primevc.core.traits.IValueObject;
 private typedef IBindable = primevc.core.IBindable<Dynamic>;
  using primevc.utils.TypeUtil;
  using Std;
  using Type;


/**
 * Utility providing methods to deal with ListChange or PropertyChange values
 * (to undo/redo them).
 * 
 * @author Ruben Weijers
 * @creation-date Nov 19, 2010
 */
class ChangesUtil
{
	public static function undoListChange<T> (list:IEditableList<T>, change:ListChange<T>) : Void
	{
		switch (change)
		{
			case added (item, newPos):				list.remove(item);
			case removed (item, oldPos):			list.add( item, oldPos );
			case moved (item, newPos, oldPos):		list.move( item, oldPos, newPos );
			default:								//what to do with a reset :-S
		}
	}
	
	
	public static function redoListChange<T> (list:IEditableList<T>, change:ListChange<T>) : Void
	{
		switch (change)
		{
			case added (item, newPos):				list.add(item, newPos);
			case removed (item, oldPos):			list.remove( item, oldPos );
			case moved (item, newPos, oldPos):		list.move( item, newPos, oldPos );
			default:								//what to do with a reset :-S
		}
	}
	
	
	
	
	public static function undo (changes:ObjectChangeSet) : Void
	{
		trace("undo changes "+Date.fromTime(changes.timestamp) + ", " + changes);
		var vo = changes.vo;
		vo.beginEdit();
		
		var change:PropertyChangeVO = changes.next;
		while( change != null )
		{
			var property = propertyIdToString( vo, change.propertyID );
			Assert.notNull( property );
			
			if (change.is(ListChangeVO))	undoListChanges( 	change.as(ListChangeVO), 			vo, property);
			else							undoPropertyChange( change.as(PropertyValueChangeVO), 	vo, property );
			
			change = change.next;
		}
		
		vo.commitEdit();
	}
	
	
	public static function redo (changes:ObjectChangeSet) : Void
	{
		trace("redo changes "+Date.fromTime(changes.timestamp) + ", " + changes);
		var vo = changes.vo;
		vo.beginEdit();
		
		var change:PropertyChangeVO = changes.next;
		while( change != null )
		{
			var property = propertyIdToString( vo, change.propertyID );
			Assert.notNull( property );
			
			if (change.is(ListChangeVO))	redoListChanges( 	change.as(ListChangeVO), 			vo, property);
			else							redoPropertyChange( change.as(PropertyValueChangeVO), 	vo, property );
			
			change = change.next;
		}
		vo.commitEdit();
	}
	
	
	
	
	private static inline function undoListChanges (changesVO:ListChangeVO, owner:ValueObjectBase, property:String) : Void
	{
	//	trace("for "+property);
		var list	= getProperty( owner, property ).as(IEditableList);
		var changes = changesVO.changes;
		
		for (i in 0...changes.length)
			undoListChange( list, cast changes[i] );
	}
	
	
	private static function redoListChanges (changesVO:ListChangeVO, owner:ValueObjectBase, property:String) : Void
	{
	//	trace("for "+property);
		var list	= getProperty( owner, property ).as(IEditableList);
		var changes = changesVO.changes;
		
		for (i in 0...changes.length)
			redoListChange( list, cast changes[i] );
	}
	
	
	
	
	private static function undoPropertyChange (change:PropertyValueChangeVO, owner:ValueObjectBase, property:String) : Void
	{
	//	trace("for "+property+": "+change.newValue+" => "+change.oldValue);
		setProperty( owner, property, change.oldValue );
	}
	
	
	private static function redoPropertyChange (change:PropertyValueChangeVO, owner:ValueObjectBase, property:String) : Void
	{
	//	trace("for "+property+": "+change.oldValue+" => "+change.newValue);
		setProperty( owner, property, change.newValue );
	}
	
	
	
	
	private static inline function getProperty( owner:Dynamic, property:String ) : Dynamic
	{
		return Reflect.field( owner, property );
	}
	
	
	private static function setProperty( owner:Dynamic, property:String, value:Dynamic ) : Dynamic
	{	
		Assert.notNull( owner );
		Assert.notNull( property );
		var field:Dynamic = getProperty( owner, property );
//		Assert.notNull( field, "owner: "+owner +", property: "+property );
		
//		trace("set "+owner+"."+property+" to "+value);
		
		if (field.is(IBindable))
			field.as(IBindable).value = value;
		else {
			var setter : Dynamic -> Dynamic = Reflect.field(owner, "set" + property.substr(0,1).toUpperCase() + property.substr(1));
			if (setter != null) {
				trace("try setter: "+setter);
				setter(value);
			}
			else
				Reflect.setField( owner, property, value );
		}
	}
	
	
	/**
	 * Method will return the property name based on the given property-id. 
	 * Since there's no clean way to get the name of a property when only the
	 * property-id is available, the method will loop over all properties 
	 * within the given object until the property is found
	 * 
	 * @param owner			object containing the property
	 * @param propertyId 	id of property
	 * @return property name
	 */
	public static function propertyIdToString (owner:ValueObjectBase, propertyId:Int) : String
	{
		var propFlags		= owner.getClass();
		var property:String	= null;
		var fields			= propFlags.getInstanceFields();
		
		for (propField in fields)
		{
			var val = Reflect.field( propFlags, propField.toUpperCase() );
			
		//	trace("searching for "+property+"( "+propertyId+" ) => "+propField+" ( " + val + " )");
			if (val != null && propertyId == Std.parseInt( val ) )
			{
				property = propField;
				break;
			}
		}
		
		return property;
	}
	
	
	
	public static inline function findChangedVOOfClass (change:ObjectChangeSet, classType:Class<Dynamic>) : IValueObject
	{
		var vo:IValueObject = null;
		if (change.vo.is(classType))
		{
			vo = change.vo;
		}
		else
		{
			// a property of the shapestylevo is changed or a property of a 
			// property etc.. In order to find the ShapeStyleVO that is changed,
			// we walk down all the parents until we find one.
			var path = change.parent;
			while (path != null && !path.object.is(classType))
				path = path.parent;
		
			Assert.notNull(path);
			vo = path.object;
		}
		return vo;
	}
}