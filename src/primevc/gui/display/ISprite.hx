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
 import primevc.core.IDisposable;
 import primevc.core.geom.Matrix2D;
 import primevc.core.geom.Rectangle;
 import primevc.gui.events.UserEvents;

#if flash9
 import flash.display.DisplayObject;
#else
#end


/**
 * Sprite interface for every platform.
 *
 * @creation-date	Jun 11, 2010
 * @author			Ruben Weijers
 */
interface ISprite implements IDisplayObject
{
	var userEvents		(default, null)									: UserEvents;
	
	function startDrag(lockCenter:Bool = false, ?bounds:Rectangle) 		: Void;
	function stopDrag()													: Void;
	
#if flash9
	
	var dropTarget (default,null)										: DisplayObject;
	var graphics (default,null)											: flash.display.Graphics;
	
	var mouseEnabled													: Bool;
	var doubleClickEnabled												: Bool;
	var mouseChildren													: Bool;
	
	var tabEnabled														: Bool;
	var tabIndex														: Int;
	var tabChildren														: Bool;
	
	var buttonMode														: Bool;
	var useHandCursor													: Bool;
	
	
	var numChildren(default,null)										: Int;
	
	function addChild (child:DisplayObject)								: DisplayObject;
	function addChildAt (child:DisplayObject, index:Int)				: DisplayObject;
	
	function contains (child:DisplayObject)								: Bool;
	function getChildAt (index:Int)										: DisplayObject;
	function getChildIndex (child:DisplayObject)						: Int;
	
	function removeChild (child:DisplayObject)							: DisplayObject;
	function removeChildAt (index:Int)									: DisplayObject;
	
	function setChildIndex (child:DisplayObject, index:Int)				: Void;
	
	function swapChildren (child1:DisplayObject, child2:DisplayObject)	: Void;
	function swapChildrenAt (index1:Int, index2:Int)					: Void;
	
#else

	var dropTarget		(default, null)									: IDisplayObject;
	var numChildren		(getNumChildren, never)							: Int;
	var mouseEnabled	(getEnabled, setEnabled)						: Bool;
	
	function addChild(child:ISprite)									: Void;
	function addChildAt(child:ISprite, depth:Int)						: Void;
	function getChildIndex(child:ISprite)								: Int;
	function swapChildren(a:Sprite, b:ISprite)							: Void;
#end
}