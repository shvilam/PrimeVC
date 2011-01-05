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
 *  Danny Wilson	<danny @ onlinetouch.nl>
 */
package primevc.core;
 import primevc.core.Bindable;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.traits.IEditableValueObject;
 import haxe.FastList;
  using primevc.utils.BitUtil;


private typedef Flags = RevertableBindableFlags;


/**
 * A Bindable that keeps a copy of its value when entering edit-mode:
 * using beginEdit(), and reverts to it when editing is cancelled by calling
 * cancelEdit().
 * 
 * The value change signalling and bindings to other Bindables are
 * configurable through RevertableBindableFlags.
 * 
 * The default behaviour is to only dispatch/propagate _valid_ changes
 * when: _not_ in, or leaving; edit-mode.
 * 
 * The value can only change when in edit-mode (by calling beginEdit()),
 * or directly through set(). When setting 'this.value' is tried while not
 * in edit-mode, the new value is discarded. Additionally when compiled in
 * debug-mode an assertion exception is thrown.
 * 
 * 
 * @creation-date	Jun 18, 2010
 * @author			Danny Wilson
 */
class RevertableBindable <DataType> extends Bindable<DataType>, implements IEditableValueObject //, implements haxe.rtti.Generic //- compiler crash
{
	/**
	 * Keeps track of settings.
	 */
	public var flags : Int;
	
	/**
	 * The last valid value. Zero/null until this.value is changed while in editing mode.
	 */
	public var shadowValue (default,null) : DataType;
	
	
	public inline function isEditable () : Bool { return flags.has(Flags.IN_EDITMODE); }
	
	
	override private function setValue (newValue:DataType) : DataType
	{
		var f = flags;
		Assert.that( isEditable() );
		
		if (f.hasNone(Flags.IN_EDITMODE) || newValue == this.value) return newValue;
		// ---
		
		if (f.has(MAKE_SHADOW_COPY)) {
			f = f.unset( MAKE_SHADOW_COPY );
		//	trace("Saving shadow copy: "+value+", before changing to:"+newValue);
			shadowValue = value;
		}
		
		
	//TODO: Validation..	
	/*
		if (validator != null)
			f |= Std.int(validator.validate(this.shadowValue)) << 5; // IS_VALID
		else
	*/		f = f.set( Flags.IS_VALID );
		
		this.flags	= f;
		var oldV	= this.value;
		this.value	= newValue;
		
		if (Flags.shouldSignal(f))
			change.send(newValue, oldV);
		
		if (Flags.shouldUpdateBindings(f))
			BindableTools.dispatchValueToBound(writeTo, newValue);
		
		return newValue;
	}
	
	
	/**
	 * Puts this in editing-mode and keeps a copy of the current value
	 * if not already in edit-mode.
	 */
	public inline function beginEdit()
	{
		// Only set MAKE_SHADOW_COPY if IN_EDITMODE is not set
		Assert.that(Flags.IN_EDITMODE << 11 == MAKE_SHADOW_COPY);
		flags = flags.set( (((flags & Flags.IN_EDITMODE) << 11) ^ MAKE_SHADOW_COPY) | Flags.IN_EDITMODE );
	}
	
	/**
	 * Finishes edit-mode and propagates the new value if needed.
	 */
	public inline function commitEdit()
	{
		// Check if MAKE_SHADOW_COPY is not set (value changed) and any dispatch flag is set.
		if (flags.hasNone(MAKE_SHADOW_COPY) && flags.has( Flags.DISPATCH_CHANGES_BEFORE_COMMIT | Flags.UPDATE_BINDINGS_BEFORE_COMMIT ))
		{
			if (flags.hasNone(Flags.DISPATCH_CHANGES_BEFORE_COMMIT))
				change.send(value, shadowValue);
			
			if (flags.hasNone(Flags.UPDATE_BINDINGS_BEFORE_COMMIT))
				BindableTools.dispatchValueToBound(writeTo, value);
		}
		flags = flags.unset(Flags.IN_EDITMODE | MAKE_SHADOW_COPY);
	}
	
	/**
	 * Discards the new value and finishes edit-mode.
	 */
	public inline function cancelEdit()
	{
		if (flags.has(Flags.IN_EDITMODE))
		{
			if (flags.hasNone(MAKE_SHADOW_COPY)) // value was changed
				setValue(shadowValue);
			
			flags = flags.unset(Flags.IN_EDITMODE | MAKE_SHADOW_COPY);
		}
	}

	private static inline var MAKE_SHADOW_COPY = 32768;	// 0b_1000 0000 0000 0000
}
