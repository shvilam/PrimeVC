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
 import primevc.gui.display.Stage;
 import primevc.gui.display.Window;


/**
 * @author Ruben Weijers
 * @creation-date Jul 13, 2010
 */
class Application
{
	public var window	(default, null)	: Window;
	
	
	public function new ( target:Stage, windowClass:Class<Window> )
	{
		window = Type.createInstance( windowClass, [ target, this ] );
	}
	
	
	
	//
	// STARTUP METHODS
	//
	
	
	public static function startup (?windowClass:Class<Window>, ?applicationClass:Class<Application>)
	{
		if (windowClass == null)		windowClass			= Window;
		if (applicationClass == null)	applicationClass	= Application;
		
#if debug
	#if (MonsterTrace && flash9)
		haxe.Log.trace	= doTrace;
	#end
		trace("started " + applicationClass + ", "+windowClass+".");
#end
		
#if flash9
		var stage		= flash.Lib.current.stage;
		stage.scaleMode	= flash.display.StageScaleMode.NO_SCALE;
		var app = Type.createInstance( applicationClass, [stage, windowClass] );
#else
		var app = Type.createInstance( applicationClass, [null, windowClass] );
#end

#if debug
		app.clearTraces = 
			#if MonsterTrace	nl.demonsters.debugger.MonsterDebugger.clearTraces;
			#else				haxe.Log.clear;	#end
#end
	}
	
	
	
	
	//
	// MONSTERDEBUGGER / TRACE SUPPORT
	//
	
#if debug
	public var clearTraces : Void -> Void;
	
	
	#if (MonsterTrace && flash9)
		static var monster = new nl.demonsters.debugger.MonsterDebugger(flash.Lib.current);
		
		
		private static inline function getClassName (infos : haxe.PosInfos) : String
		{
			return infos.className.split(".").pop(); //infos.fileName;
		}
	
	
		private static inline function getTraceColor (name:String) : Int
		{
			var length	= name.length; // - 3; // remove .hx
			return name.charCodeAt(0) * name.charCodeAt( length >> 1 ) * name.charCodeAt( length - 1 );
		}
		

		static function doTrace (v : Dynamic, ?infos : haxe.PosInfos)
		{
			monster = new nl.demonsters.debugger.MonsterDebugger(flash.Lib.current);
			var name	= getClassName( infos );
			var color	= getTraceColor( name );
			nl.demonsters.debugger.MonsterDebugger.trace(name +':' + infos.lineNumber +'\t -> ' + infos.methodName, v, color);
		}
	#end
#end
}