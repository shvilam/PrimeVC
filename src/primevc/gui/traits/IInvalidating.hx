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
package primevc.gui.traits;


/**
 * Interface describes how changes in properties won't directly affect other
 * properties. The consequence of a changed property will be applied in 
 * validate.
 * 
 * @example
 * 		label.value = "new value";
 * 		The width of the label will be changed after validate is called. 
 * 			Changing the width while the label isn't on the stage won't 
 * 			influence the width.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
interface IInvalidating
{
	/**
	 * Flags of properties that are changed
	 */
	public var changes							: UInt;
	
	/**
	 * Invalidate will add the given change flag to the list with invalidated
	 * properties.
	 * It will in most cases add an eventlistener to an enter-frame event to
	 * validate all the changed properties.
	 */
	public function invalidate ( change:UInt )	: Void;
	
	/**
	 * Method to update all the properties that have changed.
	 */
	public function validate ()					: Void;
	
#if debug
	
	/**
	 * Method will return a textual version of all change flags.
	 * @param	changes		flags property to use. If it's -1, the classes 
	 * 						'changes' will be used.
	 */
	public function readChanges (changes:UInt = -1)	: String;
	/**
	 * Method will return a textual version of the given change flag
	 */
	public function readChange (change:UInt)		: String;
#end
}