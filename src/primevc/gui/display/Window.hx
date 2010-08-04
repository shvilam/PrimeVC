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
 import haxe.FastList;
 import primevc.core.Application;
 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.UserEvents;
 import primevc.gui.input.Mouse;
 import primevc.gui.traits.IInteractive;


typedef DocumentType = 
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
class Window implements IDisplayContainer, implements IInteractive
{
	/**
	 * Target is the original, platform-specific, root object. Although this
	 * property is set as public, it's not recommended to use this property
	 * directly!
	 */
	public var target			(default, null)		: DocumentType;
	public var children			(default, null)		: DisplayList;
	public var window			(default, setWindow): Window;
	public var application		(default, null)		: Application;
	
	public var displayEvents	(default, null)		: DisplayEvents;
	public var userEvents		(default, null)		: UserEvents;
	
	public var mouse			(default, null)		: Mouse;
	
	
	public function new (target:DocumentType, app:Application)
	{
		this.target			= target;
		children			= new DisplayList( target, this );
		window				= this;
		application			= app;
		displayEvents		= new DisplayEvents( target );
		userEvents			= new UserEvents( target );
		mouse				= new Mouse( this );
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
	
	
	public function invalidate ()
	{
#if flash9
		target.invalidate();
#end
		displayEvents.render.send();
	}
	
	
	
	//
	// IINTERACTIVE OBJECT PROPERTIES
	//
	
	public var doubleClickEnabled	: Bool;
	public var mouseEnabled			: Bool;
	public var tabEnabled			: Bool;
	public var tabIndex				: Int;
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	
	private inline function setWindow (v) {
		return window = this;
	}
	
#if debug
	public inline function toString () { return "Window"; }
#end
}