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
package primevc.gui.display;

typedef DisplayList = 
	#if		flash9	primevc.avm2.display.DisplayList;
	#elseif	flash8	primevc.avm1.display.DisplayList;
	#elseif	js		primevc.js  .display.DisplayList;
	#else			DisplayListImpl


 import primevc.core.collections.ArrayList;
 import primevc.gui.traits.IDisplayable;


/**
 * Class to add children to the specific DisplayObjectContainer
 * 
 * @author Ruben Weijers
 * @creation-date Jul 13, 2010
 */
class DisplayListImpl extends ArrayList <IDisplayable>
{
	public var window		(default, setWindow)		: Window;
	public var mouseEnabled (default, setMouseEnabled)	: Bool;
	public var tabEnabled	(default, setTabEnabled)	: Bool;
	
	private inline function setMouseEnabled (v)	{ return mouseEnabled = v; }
	private inline function setTabEnabled (v)	{ return tabEnabled = v; }
	private inline function setWindow (v)		{ return window = v; }
}

#end