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
package primevc.gui.styling;


/**
 * @see primevc.gui.styling.StyleBlockType
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class StyleTypes
{
	/**
	 * Styles declared to match with IStyleable class-types (the packagename + classname)
	 * Equal to css "H1" rule.
	 */
	public inline static var ELEMENT_SELECTOR			= 1 << 0;
	
	/**
	 * Styles declared to match with a value from IStyleable.styleNames
	 * Equal to css ".stylename" rule.
	 */
	public inline static var STYLENAME_SELECTOR			= 1 << 1;
	
	/**
	 * Styles declared with the id of a IStyleable classes
	 * Equal to css "#idname" rule.
	 */
	public inline static var ID_SELECTOR				= 1 << 2;
	
	/**
	 * Styles declared as a state of another selector.
	 * Equal to css "elementSelector:statename" rule.
	 */
	public inline static var ELEMENT_STATE_SELECTOR		= 1 << 3;
	
	/**
	 * Styles declared as a state of another selector.
	 * Equal to css "styleNameSelector:statename" rule.
	 */
	public inline static var STYLENAME_STATE_SELECTOR	= 1 << 4;
	
	/**
	 * Styles declared as a state of another selector.
	 * Equal to css "idSelector:statename" rule.
	 */
	public inline static var ID_STATE_SELECTOR			= 1 << 5;
}
