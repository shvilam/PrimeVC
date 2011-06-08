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
package primevc.gui.core;
 import primevc.core.traits.IValueObject;
 import primevc.gui.layout.IScrollableLayout;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutContainer;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


/**
 * Container class with data
 * 
 * @author Ruben Weijers
 * @creation-date Aug 02, 2010
 */
class UIDataContainer <DataType> extends UIDataComponent <DataType>, implements IUIContainer
/*#if flash9	, implements haxe.rtti.Generic #end*/
{
	public var layoutContainer	(getLayoutContainer, never)		: LayoutContainer;
	public var scrollableLayout	(getScrollableLayout, never)	: IScrollableLayout;
	
	private inline function getLayoutContainer () 								{ return layout.as(LayoutContainer); }
	private inline function getScrollableLayout ()							 	{ return layout.as(IScrollableLayout); }
	public  inline function attach		(child:IUIElement)		: IUIContainer	{ child.attachTo(this); return this; }
	public  inline function attachLayout (layout:LayoutClient)	: IUIContainer	{ layoutContainer.children.add(layout); return this; }
	override private function createLayout ()									{ layout = new LayoutContainer(); }
}