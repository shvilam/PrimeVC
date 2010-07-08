package primevc.core;
 import primevc.core.IDisposable;
 import primevc.core.Bindable;
 import primevc.core.dispatcher.Signal1;
 import haxe.FastList;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;

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
 * @creation-date	Jun 18, 2010
 * @author			Danny Wilson
 */
class RevertableBindable <DataType> extends Bindable<DataType>//, implements haxe.rtti.Generic //- compiler crash
{
	/**
	 * Keeps track of settings.
	 */
	public var flags : Int;
	
	/**
	 * The last valid value. Zero/null until this.value is changed while in editing mode.
	 */
	public var shadowValue (default,null) : DataType;
	
	
	override private function setValue (newValue:DataType) : DataType
	{
		if (newValue == this.value) return newValue;
		// ---
		
		var f = flags;
		
		if (f.has(MAKE_SHADOW_COPY)) {
			f ^= MAKE_SHADOW_COPY;
		//	trace("Saving shadow copy: "+value+", before changing to:"+newValue);
			shadowValue = value;
		}
		
		
	//TODO: Validation..	
	/*
		if (validator != null)
			f |= Std.int(validator.validate(this.shadowValue)) << 5; // IS_VALID
		else
	*/		f |= RevertableBindableFlags.IS_VALID;
		
		this.flags = f;
		this.value = newValue;
		
		if (RevertableBindableFlags.shouldSignal(f))
			change.send(newValue);
		
		if (RevertableBindableFlags.shouldUpdateBindings(f))
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
		Assert.that(RevertableBindableFlags.IN_EDITMODE << 11 == MAKE_SHADOW_COPY);
		flags |= (((flags & RevertableBindableFlags.IN_EDITMODE) << 11) ^ MAKE_SHADOW_COPY) | RevertableBindableFlags.IN_EDITMODE;
	}
	
	/**
	 * Finishes edit-mode and propagates the new value if needed.
	 */
	public inline function commitEdit()
	{
		// Check if MAKE_SHADOW_COPY is not set (value changed) and any dispatch flag is set.
		if (flags & (MAKE_SHADOW_COPY | RevertableBindableFlags.DISPATCH_CHANGES_BEFORE_COMMIT | RevertableBindableFlags.UPDATE_BINDINGS_BEFORE_COMMIT)
		    - MAKE_SHADOW_COPY > 0)
		{
			if (flags.hasNot(RevertableBindableFlags.DISPATCH_CHANGES_BEFORE_COMMIT))
				change.send(value);
			
			if (flags.hasNot(RevertableBindableFlags.UPDATE_BINDINGS_BEFORE_COMMIT))
				BindableTools.dispatchValueToBound(writeTo, value);
		}
		flags = flags.unset(RevertableBindableFlags.IN_EDITMODE | MAKE_SHADOW_COPY);
	}
	
	/**
	 * Discards the new value and finishes edit-mode.
	 */
	public inline function cancelEdit()
	{
		if (flags.has(RevertableBindableFlags.IN_EDITMODE))
		{
			if (flags.hasNot(MAKE_SHADOW_COPY)) // value was changed
				setValue(shadowValue);
			
			flags = flags.unset(RevertableBindableFlags.IN_EDITMODE | MAKE_SHADOW_COPY);
		}
	}

	private static inline var MAKE_SHADOW_COPY = 32768;	// 0b_1000 0000 0000 0000
}

class RevertableBindableFlags
{
	/**
	 * When this flag is set, any (valid) value change will send
	 * the 'change' signal when in edit-mode.
	 * 
	 * If not set, only when not in (or leaving) edit-mode, changes
	 * will be signalled.
	 */
	static inline public var DISPATCH_CHANGES_BEFORE_COMMIT		=  1; // 0b_0000 0001
	/**
	 * When this flag is set, value changes which are not valid will send
	 * the 'change' signal anyway.
	 * In combination with DISPATCH_CHANGES_BEFORE_COMMIT, all value changes
	 * are sent at any time.
	 */
	static inline public var INVALID_CHANGES_DISPATCH_SIGNAL	=  2; // 0b_0000 0010
	
	/**
	 * When this flag is set, any (valid) value change will be sent to the
	 * Bindables bound to this when in edit-mode.
	 * 
	 * If not set, only when not in (or leaving) edit-mode, will the bound
	 * Bindables be updated.
	 */
	static inline public var UPDATE_BINDINGS_BEFORE_COMMIT		=  4; // 0b_0000 0100
	/**
	 * When this flag is set, value changes which are not valid will send
	 * the 'change' signal anyway.
	 * In combination with UPDATE_BINDINGS_BEFORE_COMMIT, all value changes
	 * are sent to 'the Bindables bound to this' at any time.
	 */
	static inline public var INVALID_CHANGES_UPDATE_BINDINGS	=  8; // 0b_0000 1000
	
	
	/**
	 * Whether in edit-mode, and shadowValue is set.
	 */
	static inline public var IN_EDITMODE						= 16; // 0b_0001 0000
	/**
	 * Whether 'value' is valid according to the configured validator.
	 */
	static inline public var IS_VALID							= 32; // 0b_0010 0000
	
	/**
	 *  Tests in one go if change signal should be dispatched.
	 *  
	 *  It returns true in these cases:
	 *  -  valid && !editmode
	 *  -  valid &&  editmode && dispatchBeforeCommit
	 *  - !valid &&  dispatchOnInvalid && !editmode
	 *  - !valid &&  dispatchOnInvalid &&  editmode && dispatchBeforeCommit
	 *  
	 *  otherwise, it returns false.
	 */
	static inline public function shouldSignal(f:Int)
	{
		return ((
			 ((f & IN_EDITMODE >> 4) ^ 1)			// if not in editmode: 1
			| (f & DISPATCH_CHANGES_BEFORE_COMMIT)	// if editmode && dispatchBeforeCommit: 1 else 0
		  )
		  &
		  ( // XOR: editmode && dispatchBeforeCommit should be true, or 
			  (f & IS_VALID) >> 5							// if valid:				1
		    | (f & INVALID_CHANGES_DISPATCH_SIGNAL) >> 1	// if dispatchOnInvalid:	1
		  )) == 1;
	}
	
	/**
	 * Tests in one go if Bindings should be updated.
	 * @see shouldSignal
	 */
	static inline public function shouldUpdateBindings(f:Int)
	{
		return ((
			 ((f & IN_EDITMODE >> 4) ^ 1)				// if not in editmode: 1
			| (f & UPDATE_BINDINGS_BEFORE_COMMIT) >> 2	// if editmode && dispatchBeforeCommit: 1 else 0
		  )
		  &
		  ( // XOR: editmode && dispatchBeforeCommit should be true, or 
			  (f & IS_VALID) >> 5							// if valid:				1
		    | (f & INVALID_CHANGES_UPDATE_BINDINGS) >> 3	// if dispatchOnInvalid:	1
		  )) == 1;
	}
}
