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
#if (flash8 || flash9 || js)
 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.UserEvents;
 import primevc.gui.input.Mouse;
 import primevc.gui.traits.IInteractive;
#end


/**
 * Window is wrapper class for the stage. It provides each Sprite and Shape 
 * with the ability to talk with the stage in a platform-indepedent way.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 13, 2010
 */
#if (flash8 || flash9 || js)
class Window
		implements IDisplayContainer
	,	implements IInteractive
{
	public static function startup (windowClass:Class<Window>) : Window
	{
		var stage:Stage = null;
		
#if flash9
		stage = flash.Lib.current.stage;
		stage.scaleMode	= flash.display.StageScaleMode.NO_SCALE;

	#if (debug && MonsterTrace)	
		var monster		= new nl.demonsters.debugger.MonsterDebugger(flash.Lib.current);
		haxe.Log.trace	= primevc.utils.MonsterTrace.trace;
		haxe.Log.clear	= nl.demonsters.debugger.MonsterDebugger.clearTraces;
		haxe.Log.clear();
	#end
#end		
		trace("started " + windowClass);
		return Type.createInstance( windowClass, [ stage ] );
	}
	
	
	//
	// IDISPLAYCONTAINER PROPERTIES
	//
	
	/**
	 * Target is the original, platform-specific, root object. Although this
	 * property is set as public, it's not recommended to use this property
	 * directly!
	 */
	public var target			(default, null)			: Stage;
	public var children			(default, null)			: DisplayList;
	
	//
	// IDISPLAYABLE PROPERTIES
	//
	
	public var window			(default, setWindow)	: Window;
	public var container		(default, setContainer)	: IDisplayContainer;
	public var displayEvents	(default, null)			: DisplayEvents;
	
	public var userEvents		(default, null)			: UserEvents;
	public var mouse			(default, null)			: Mouse;
	
	
	public function new (target:Stage)
	{
		this.target		= target;
		window			= this;
		container		= this;
		
		children		= new DisplayList( target, this );
		displayEvents	= new DisplayEvents( target );
		userEvents		= new UserEvents( target );
		mouse			= new Mouse( this );
		
		target.doubleClickEnabled = true;
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
		target.invalidate();
		displayEvents.render.send();
	}
	
	
	
	//
	// IINTERACTIVE OBJECT PROPERTIES
	//
	
	public var mouseEnabled			: Bool;
#if flash9	
	public var doubleClickEnabled	: Bool;
	public var tabEnabled			: Bool;
	public var tabIndex				: Int;
#end
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	
	private inline function setWindow (v)		{ return window = this; }
	private inline function setContainer (v)	{ return container = this; }
}

#else
class Window implements IDisplayContainer
{
	public function new () {}
}
#end