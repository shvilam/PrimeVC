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
 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.UserEvents;


private typedef TargetType = 
	#if			flash9		flash.display.Stage;
	#else if	js			Window;
	#else					IDisplayObjectContainer;
	#end


/**
 * Window is wrapper class for the stage. It provides each Sprite and Shape 
 * with the ability to talk with the stage in a platform-indepedent way.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 13, 2010
 */
class Window implements IDisplayContainer, implements IInteractiveObject
{
	private var target			(default, null)		: TargetType;
	public var children			(default, null)		: DisplayList;
	
	public var displayEvents	(default, null)		: DisplayEvents;
	public var userEvents		(default, null)		: UserEvents;
	
	
	public function new (target:TargetType)
	{
		this.target		= target;
		children		= new DisplayList( target );
		displayEvents	= new DisplayEvents( target );
		userEvents		= new UserEvents( target );
	}
	
	
	public function dispose ()
	{
		if (displayEvents == null)
			return;
		
		children.dispose();
		displayEvents.dispose();
		userEvents.dispose();
		
		children		= null;
		displayEvents	= null;
		userEvents		= null;
	}
	
	
	//
	// IINTERACTIVE OBJECT PROPERTIES
	//
	
	public var doubleClickEnabled	: Bool;
	public var mouseEnabled			: Bool;
	public var tabEnabled			: Bool;
	public var tabIndex				: Int;
	
	
#if debug
	public inline function toString () { return "Window"; }
#end
}