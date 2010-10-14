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



/**
 * @author Ruben Weijers
 * @creation-date Sep 05, 2010
 */
class StyleFlags
{
	public static inline var NESTING_STYLE		: UInt = 1;
	public static inline var SUPER_STYLE		: UInt = 2;
	public static inline var EXTENDED_STYLE		: UInt = 4;
	public static inline var PARENT_STYLE		: UInt = 8;
	
	public static inline var LAYOUT				: UInt = 16;
	public static inline var FONT				: UInt = 32;
	public static inline var SKIN				: UInt = 64;
	
	public static inline var BACKGROUND			: UInt = 128;
	public static inline var BORDER				: UInt = 256;
	public static inline var EFFECTS			: UInt = 512;
	public static inline var SHAPE				: UInt = 1024;
	public static inline var BOX_FILTERS		: UInt = 2048;
	public static inline var BACKGROUND_FILTERS	: UInt = 4096;
	
	public static inline var VISIBLE			: UInt = 8192;
	public static inline var OPACITY			: UInt = 16384;
	public static inline var ICON				: UInt = 32768;
	public static inline var OVERFLOW			: UInt = 65536;
	public static inline var STATES				: UInt = 131072;
}