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
package primevc.gui.layout;
 

/**
 * Collection of change flags for the layout-objects.
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class LayoutFlags 
{
	public static inline var WIDTH					: UInt = 1;
	public static inline var HEIGHT					: UInt = 2;
	public static inline var X						: UInt = 4;
	public static inline var Y						: UInt = 8;
	/**
	 * Flag indicating the includeInLayout property has changed
	 */
	public static inline var INCLUDE				: UInt = 16;
	/**
	 * The relative property or properties of the relative object are changed.
	 */
	public static inline var RELATIVE				: UInt = 32;
	/**
	 * Flag indicating that when the list with children of a layoutgroup have 
	 * changed.
	 */
	public static inline var LIST					: UInt = 64;
	/**
	 * Flag indicating that the children of the layout algorithm have changed.
	 */
	public static inline var CHILDREN_INVALIDATED	: UInt = 128;
	/**
	 * Flag indicating that a property of the layout algorithm is changed and
	 * the layout needs to be validated again.
	 */
	public static inline var ALGORITHM				: UInt = 256;
	/**
	 * Flag indicating that the size-constraUInt of the layout-client is changed
	 */
	public static inline var SIZE_CONSTRAINT		: UInt = 512;
	
	public static inline var MAX_WIDTH				: UInt = 1024;
	public static inline var MIN_WIDTH				: UInt = 2048;
	public static inline var PERCENT_WIDTH			: UInt = 4096;
	
	public static inline var MAX_HEIGHT				: UInt = 8192;
	public static inline var MIN_HEIGHT				: UInt = 16384;
	public static inline var PERCENT_HEIGHT			: UInt = 32768;
	
	public static inline var PADDING				: UInt = 65536;
	public static inline var MAINTAIN_ASPECT		: UInt = 131072;
	public static inline var ROTATION				: UInt = 262144;
	
	
	
	/**
	 * Property is not meant as a flag but to incicate that a layout-client.
	 * percentage property is set to fill the left space
	 */
	public static inline var FILL					: UInt = 2147483647;
}