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
package primevc.gui.styling.declarations;
 import primevc.core.traits.IInvalidatable;
 import primevc.tools.generator.ICSSFormattable;
#if neko
 import primevc.tools.generator.ICodeFormattable;
#end


/**
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
interface IStyleDeclaration
				implements IInvalidatable	
			,	implements ICSSFormattable
#if neko	,	implements ICodeFormattable		#end
{
	/**
	 * Variable defining which properties in the style-declaration have been
	 * set or not according to the flags of the style-declaration.
	 */
	public var filledProperties (default, null)						: UInt;
	
	/**
	 * bit-flag with the filled properties of this style-object and it's
	 * extended, super, inherited and parent style.
	 */
	public var allFilledProperties	(default, null)					: UInt;
	
	
	/**
	 * Method that will set or unset the flag of the property that is set in 
	 * to the variable 'filledProperties'.
	 */
	private function markProperty ( propFlag:UInt, isSet:Bool )		: Void;
	
	
	/**
	 * Method which will update the flags in allFilledProperties when it's 
	 * style or that of it's extended, super, inherited and parent style 
	 * changes.
	 */
	public function updateAllFilledPropertiesFlag ()				: Void;
	
#if debug
	
	/**
	 * Method to format the given flags of properties to a readable string.
	 * If flags is -1, the property 'filledProperties' will be used.
	 */
	public function readProperties ( flags:UInt = -1 )				: String;
	
	/**
	 * Method to format the changed properties to a readable string.
	 * If flags is -1, the property 'changes' will be used.
	 */
	public function readChanges ( flags:UInt = -1 )					: String;
#end
}