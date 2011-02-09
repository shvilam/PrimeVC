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
package primevc.core;
  using primevc.utils.BitUtil;


/**
 * @creation-date	Jun 18, 2010
 * @author			Danny Wilson
 */
class RevertableBindableFlags
{
	/**
	 * When this flag is set, any (valid) value change will send
	 * the 'change' signal when in edit-mode.
	 * 
	 * If not set, only when not in (or leaving) edit-mode, changes
	 * will be signalled.
	 */
	public static inline var DISPATCH_CHANGES_BEFORE_COMMIT		=  1 << 0; // 0b_0000 0001
	/**
	 * When this flag is set, value changes which are not valid will send
	 * the 'change' signal anyway.
	 * In combination with DISPATCH_CHANGES_BEFORE_COMMIT, all value changes
	 * are sent at any time.
	 */
	public static inline var INVALID_CHANGES_DISPATCH_SIGNAL	=  1 << 1; // 0b_0000 0010
	
	/**
	 * When this flag is set, any (valid) value change will be sent to the
	 * Bindables bound to this when in edit-mode.
	 * 
	 * If not set, only when not in (or leaving) edit-mode, will the bound
	 * Bindables be updated.
	 */
	public static inline var UPDATE_BINDINGS_BEFORE_COMMIT		=  1 << 2; // 0b_0000 0100
	/**
	 * When this flag is set, value changes which are not valid will send
	 * the 'change' signal anyway.
	 * In combination with UPDATE_BINDINGS_BEFORE_COMMIT, all value changes
	 * are sent to 'the Bindables bound to this' at any time.
	 */
	public static inline var INVALID_CHANGES_UPDATE_BINDINGS	=  1 << 3; // 0b_0000 1000
	
	
	/**
	 * Whether in edit-mode, and shadowValue is set.
	 */
	public static inline var IN_EDITMODE						= 1 << 4; // 0b_0001 0000
	/**
	 * Whether 'value' is valid according to the configured validator.
	 */
	public static inline var IS_VALID							= 1 << 5; // 0b_0010 0000

	public static inline var MAKE_SHADOW_COPY					= 1 << 15; //32768;	// 0b_1000 0000 0000 0000
	
	
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
	public static inline function shouldSignal(f:Int)
	{
		return ((
			 (((f & IN_EDITMODE) >> 4) ^ 1)			// if not in editmode: 1
			|  (f & DISPATCH_CHANGES_BEFORE_COMMIT)	// if editmode && dispatchBeforeCommit: 1 else 0
		  )
		  &
		  ( // XOR: editmode && dispatchBeforeCommit should be true, or 
			  ((f & IS_VALID) >> 5)							// if valid:				1
		    | ((f & INVALID_CHANGES_DISPATCH_SIGNAL)) >> 1	// if dispatchOnInvalid:	1
		  )) == 1;
	}
	
	/**
	 * Tests in one go if Bindings should be updated.
	 * @see shouldSignal
	 */
	public static inline function shouldUpdateBindings(f:Int)
	{
		//return (((f & IS_VALID) >> 5)) | ((f & INVALID_CHANGES_UPDATE_BINDINGS) >> 3) & ((((f & IN_EDITMODE) >> 4) ^ 1) ^ ((f & UPDATE_BINDINGS_BEFORE_COMMIT) >> 2)) != 0;
		return ((
			 (((f & IN_EDITMODE) >> 4) ^ 1)				// if not in editmode: 1
			|  (f & UPDATE_BINDINGS_BEFORE_COMMIT) >> 2	// if editmode && dispatchBeforeCommit: 1 else 0
		  )
		  &
		  ( // XOR: editmode && dispatchBeforeCommit should be true, or 
			  ((f & IS_VALID) >> 5)							// if valid:				1
		    | ((f & INVALID_CHANGES_UPDATE_BINDINGS)) >> 3	// if dispatchOnInvalid:	1
		  )) == 1;
	}
	
	
	
#if debug
	public static inline function readProperties (flags:Int) : String
	{
		var props = [];
		
		if (flags.has( IN_EDITMODE ))						props.push( "editmode" );
		if (flags.has( DISPATCH_CHANGES_BEFORE_COMMIT ))	props.push( "dispatch-changes-before-commit" );
		if (flags.has( INVALID_CHANGES_DISPATCH_SIGNAL ))	props.push( "invalid-changes-dispatch-signal" );
		if (flags.has( UPDATE_BINDINGS_BEFORE_COMMIT ))		props.push( "update-bindings-before-commit" );
		if (flags.has( INVALID_CHANGES_UPDATE_BINDINGS ))	props.push( "invalid-changes-update-bindings" );
		
		return "properties: "+props.join(", ") + " ("+flags+")";
	}
#end
}