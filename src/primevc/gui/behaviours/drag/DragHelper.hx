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
package primevc.gui.behaviours.drag;
 import haxe.Timer;
 import primevc.core.dispatcher.Wire;
 import primevc.core.traits.IDisablable;
 import primevc.core.traits.IDisposable;
 import primevc.gui.display.ISprite;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.input.KeyCodes;
 import primevc.types.Number;
  using apparat.math.FastMath;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * Instance to help validate if a mouse-down operation is a drag start or not,
 * check if the user released the mousebutton somewhere and check if the user
 * pressed [esc] to cancel a drag operation.
 * 
 * Drag start when:
 * 	1. user presses mousebutton down on target
 * 	2. user moves mouse cursor at least 3 pixels while holding mousebutton
 * 
 * The handler that is given to this class will only be called when the 
 * mouse-down event is a valid drag operation.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
class DragHelper implements IDisposable, implements IDisablable
{
	private var target				: ISprite;
	private var startHandler		: MouseState -> Void;
	private var stopHandler			: MouseState -> Void;
	private var cancelHandler		: MouseState -> Void;
	
	public var lastMouseObj			(default, null) : MouseState;
//	private var mouseDownBinding	: Wire < Dynamic >;
	public var mouseUpBinding		(default, null)	: Wire < Dynamic >;
	public var mouseMoveBinding		(default, null)	: Wire < MouseState -> Void >;
	public var keyDownBinding		(default, null)	: Wire < Dynamic >;
	
	
	public function new (target:ISprite, startHandler:MouseState -> Void, stopHandler:MouseState -> Void, cancelHandler:MouseState -> Void)
	{
		Assert.notNull(target);
		this.target			= target;
		this.startHandler	= startHandler;
		this.stopHandler	= stopHandler;
		this.cancelHandler	= cancelHandler;
		
		if (target.window != null)
			init();
	//	mouseDownBinding	= startTimer	.on( target.userEvents.mouse.down, this );
	}
	
	
	public inline function init ()
	{
		mouseUpBinding		= stopDrag		.on( target.window.userEvents.mouse.up, this );
		mouseMoveBinding	= preStartDrag	.on( target.window.userEvents.mouse.move, this );
		keyDownBinding		= checkCancel	.on( target.window.userEvents.key.down, this );
		
		mouseUpBinding	.disable();
		mouseMoveBinding.disable();
		keyDownBinding	.disable();
	}
	
	
	public function dispose ()
	{
	//	mouseDownBinding.dispose();
		if (mouseUpBinding != null)		mouseUpBinding	.dispose();
		if (mouseMoveBinding != null)	mouseMoveBinding.dispose();
		if (keyDownBinding != null)		keyDownBinding	.dispose();
		
	//	mouseDownBinding	= null;
		mouseUpBinding		= null;
		mouseMoveBinding	= null;
		keyDownBinding		= null;
		
		lastMouseObj		= null;
		target				= null;
		
		startHandler		= null;
		stopHandler			= null;
		cancelHandler		= null;
	}
	
	
	public function start (mouseObj:MouseState)
	{
	//	trace(mouseObj);
		if (mouseObj.target == null || !mouseObj.target.is(ISprite))
			return;
		
		var mouseTarget	= mouseObj.target.as(ISprite);
	//	if (mouseTarget != target)
	//		return;
		
		lastMouseObj	= mouseObj;
		Assert.notNull(lastMouseObj);
		
		preStartDragClickLocalLength = mouseObj.local.length;
		mouseUpBinding	.enable();
		mouseMoveBinding.enable();
	//	keyDownBinding	.enable();
	}
	
	
	private function stopDrag (mouseObj:MouseState)
	{
		if (target.isDragging) {
			target.isDragging = false;
			stopHandler( mouseObj );
		}
		
	//	mouseDownBinding.enable();
		mouseUpBinding	.disable();
		mouseMoveBinding.disable();
		keyDownBinding	.disable();
		
		lastMouseObj = null;
	}
	
	
	var preStartDragClickLocalLength : Float;
	
	private function preStartDrag (mouseObj:MouseState)
	{
		var offset = mouseObj.local.length - preStartDragClickLocalLength;
		if (offset.abs() > 3)
			startDrag();
	}
	
	
	public function startDrag ()
	{
		target.isDragging = true;
		startHandler( lastMouseObj );
		
		mouseMoveBinding.disable();
		keyDownBinding	.enable();	//enable keydown binding to check for a cancel event
		mouseUpBinding	.enable();	//enable mouse up binding to check when the dragoperation has stopped
	}
	
	
	public function cancel ()
	{
		cancelHandler( lastMouseObj );
		stopDrag(null);
	}
	
	
	
	private function checkCancel (state:KeyboardState) : Void
	{
		if (state.keyCode() == KeyCodes.ESCAPE)
			cancel();
	}
	
	
	public inline function enable ()
	{
		if (target.isDragging) {
			mouseUpBinding	.enable();
			mouseMoveBinding.disable();
			keyDownBinding	.enable();
		}
	}
	
	
	public inline function disable ()
	{
		if (target.isDragging)
			stopDrag(null);
		
		mouseUpBinding	.disable();
		mouseMoveBinding.disable();
		keyDownBinding	.disable();
	}
	
	
	public inline function isEnabled ()
	{
		return mouseUpBinding.isEnabled();
	}
}