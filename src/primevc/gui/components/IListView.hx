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
package primevc.gui.components;
 import primevc.core.collections.IReadOnlyList;
 import primevc.gui.core.IUIContainer;
 import primevc.gui.core.IUIElement;
// import primevc.gui.display.IDisplayObject;


/**
 * @author Ruben Weijers
 * @creation-date Oct 26, 2010
 */
interface IListView < ListDataType > implements IUIContainer 
{
	public var createItemRenderer													: ListDataType -> Int -> IUIElement;
//	private function createItemRenderer ( item:ListDataType, pos:Int )				: IUIElement;
	private function addRenderer( item:ListDataType, newPos:Int = -1 )			: Void;
	private function removeRenderer( item:ListDataType, oldPos:Int = -1 )		: Void;
	private function moveRenderer ( item:ListDataType, newPos:Int, oldPos:Int )	: Void;
	public function getRendererFor ( item:ListDataType )						: IUIElement;
	public function getRendererAt ( pos:Int )									: IUIElement;
	public function getPositionFor ( item:ListDataType )						: Int;
}