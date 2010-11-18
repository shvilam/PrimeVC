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
 import primevc.core.traits.IDisposable;
 import primevc.gui.display.ISprite;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.input.Mouse;
 import primevc.gui.traits.IDraggable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * Instance to help validate if a mouse-down operation is a drag start or not,
 * check if the user released the mousebutton somewhere and check if the user
 * pressed [esc] to cancel a drag operation.
 * 
 * Drag start when:
 * 	1. user presses mousebutton down on target
 * 	2. user doesn't move the mouse for Mouse.DRAG_DELAY ms
 * 
 * The handler that is given to this class will only be called when the 
 * mouse-down event is a valid drag operation.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
class DragHelper implements IDisposable
{
	private var target				: ISprite;
	private var startHandler		: MouseState -> Void;
	private var stopHandler			: MouseState -> Void;
	private var cancelHandler		: MouseState -> Void;
	
	private var timer				: Timer;
	private var lastMouseObj		: MouseState;
	private var isDragging			: Bool;
	
	private var mouseDownBinding	: Wire < Dynamic >;
	private var mouseUpBinding		: Wire < Dynamic >;
	private var mouseMoveBinding	: Wire < Dynamic >;
	private var keyDownBinding		: Wire < Dynamic >;
	
	
	public function new (target:ISprite, startHandler:MouseState -> Void, stopHandler:MouseState -> Void, cancelHandler:MouseState -> Void)
	{
		this.target			= target;
		this.startHandler	= startHandler;
		this.stopHandler	= stopHandler;
		this.cancelHandler	= cancelHandler;
		
		mouseDownBinding	= startTimer	.on( target.userEvents.mouse.down, this );
		mouseUpBinding		= stopDrag		.on( target.window.mouse.events.up, this );
		mouseMoveBinding	= stopDrag		.on( target.window.mouse.events.move, this );
		keyDownBinding		= checkCancel	.on( target.window.userEvents.key.down, this );
		
		mouseUpBinding	.disable();
		mouseMoveBinding.disable();
		keyDownBinding	.disable();
	}
	
	
	public function dispose ()
	{
		mouseDownBinding.dispose();
		mouseUpBinding	.dispose();
		mouseMoveBinding.dispose();
		keyDownBinding	.dispose();
		
		mouseDownBinding	= null;
		mouseUpBinding		= null;
		mouseMoveBinding	= null;
		keyDownBinding		= null;
		
		lastMouseObj		= null;
		timer				= null;
		target				= null;
		
		startHandler		= null;
		stopHandler			= null;
		cancelHandler		= null;
	}
	
	
	private function startTimer (mouseObj:MouseState)
	{
		var mouseTarget = mouseObj.target.as(ISprite);
		if (mouseTarget != null && mouseTarget != target && mouseTarget.is(IDraggable))
			return;
		
		mouseDownBinding.disable();
		mouseUpBinding	.enable();
		mouseMoveBinding.enable();
		keyDownBinding	.disable();
		
		lastMouseObj	= mouseObj;
		timer			= Timer.delay( startDragHandler, Mouse.DRAG_DELAY );
	}
	
	
	private function stopDrag (mouseObj:MouseState)
	{
		if (isDragging) {
			if (target.is(IDraggable))
				target.as(IDraggable).isDragging = false;
			
			stopHandler( mouseObj );
			isDragging = false;
		}
		
		timer.stop();
		mouseDownBinding.enable();
		mouseUpBinding	.disable();
		mouseMoveBinding.disable();
		keyDownBinding	.disable();
		
		lastMouseObj	= null;
		timer			= null;
	}
	
	
	private function startDragHandler ()
	{
#if debug			
	//	target.window.application.clearTraces();
#end	
		isDragging = true;
		
		if (target.is(IDraggable))
			target.as(IDraggable).isDragging = true;
		
		startHandler( lastMouseObj );
		
		mouseDownBinding.disable();
		mouseMoveBinding.disable();
		keyDownBinding	.enable();	//enable keydown binding to check for a cancel event
		mouseUpBinding	.enable();	//enable mouse up binding to check when the dragoperation has stopped
	}
	
	
	
	
	private function checkCancel (state:KeyboardState) : Void
	{
#if flash9
		if (state.keyCode() == flash.ui.Keyboard.ESCAPE) {
			cancelHandler( lastMouseObj );
			stopDrag(null);
			isDragging = false;
		}
#end
	}
}