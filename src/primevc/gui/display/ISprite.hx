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
#if flash9
 import primevc.core.geom.Rectangle;
 import primevc.gui.behaviours.drag.DragInfo;
#end
 import primevc.gui.traits.IDisplayable;
 import primevc.gui.traits.IGraphicsOwner;


/**
 * Sprite interface for every platform.
 *
 * @creation-date	Jun 11, 2010
 * @author			Ruben Weijers
 */
interface ISprite 
		implements IDisplayContainer
	,	implements IInteractiveObject
	,	implements IGraphicsOwner
	,	implements IDisplayable
{
#if flash9
	public var buttonMode						: Bool;
	public var useHandCursor					: Bool;
	public var isDragging						: Bool;
	public var dropTarget		(default, null) : flash.display.DisplayObject;
	
	public function stopDrag()												: Void;
	public function startDrag(lockCenter:Bool = false, ?bounds:Rectangle)	: Void;
	public function createDragInfo ()										: DragInfo;
#else
	public var dropTarget		(default, null)	: IDisplayable;
#end
}