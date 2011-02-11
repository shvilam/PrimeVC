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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.behaviours.components;
 import primevc.core.dispatcher.Wire;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.behaviours.layout.FollowObjectBehaviour;
 import primevc.gui.components.Button;
 import primevc.gui.core.IUIContainer;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.events.MouseEvents;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * Class will help with opening and closing a popup for combobox components.
 * 
 * @author Ruben Weijers
 * @creation-date Feb 10, 2011
 */
class ComboBoxBehaviour extends BehaviourBase < Button >
{
	private var list				: IUIContainer;
	private var mouseOpenSignal		: MouseSignal;
	private var mouseCloseSignal	: MouseSignal;
	private var openBinding			: Wire<Dynamic>;
	private var closeBinding		: Wire<Dynamic>;
	private var windowCloseBinding	: Wire<Dynamic>;
	
	
	public function new (target, list:IUIContainer, mouseOpenSignal:MouseSignal, mouseCloseSignal:MouseSignal)
	{
		super(target);
		this.list				= list;
		this.mouseOpenSignal	= mouseOpenSignal;
		this.mouseCloseSignal	= mouseCloseSignal;
	}
	
	
	override public function dispose ()
	{
		list = null;
		mouseOpenSignal = mouseCloseSignal = null;
		super.dispose();
	}
	
	
	override private function init ()
	{
		Assert.notNull( mouseOpenSignal );
		Assert.notNull( mouseCloseSignal );
		
		list.layout.includeInLayout = false;
		list.behaviours.add( new FollowObjectBehaviour( list, target ) );
		
		openBinding			= openList.on( mouseOpenSignal, this );
		closeBinding		= checkToCloseList.on( mouseCloseSignal, this );
		windowCloseBinding	= checkToCloseList.on( target.window.mouse.events.down, this );
		
		Assert.notEqual( openBinding, closeBinding );
		
		closeBinding.disable();
		windowCloseBinding.disable();
	}
	
	
	override private function reset ()
	{
		windowCloseBinding.dispose();
		openBinding.dispose();
		closeBinding.dispose();
	}
	
	
	public function openList ()
	{
		if (list.window != null)
			return;
		
		Assert.notNull( list );
		openBinding.disable();
		closeBinding.enable();
		windowCloseBinding.enable();
		
		target.select();
		target.system.popups.add( list );
	}
	
	
	public function closeList ()
	{
		if (list.window == null)
			return;
		
		openBinding.enable();
		closeBinding.disable();
		windowCloseBinding.disable();
		
		target.deselect();
		list.system.popups.remove( list );
	}
	
	
	public function checkToCloseList (mouseObj:MouseState)
	{
		if (list.window == null) // || mouseObj.related == null)
			return;
		
#if flash9
		if (mouseObj.target.is(IDisplayObject))
		{
			var newTarget = mouseObj.target.as(IDisplayObject);
			
			if (newTarget != list && newTarget != target && !list.children.has( newTarget ))
				closeList();
		}
		else
			closeList();
#else
		closeList();
#end
	}
}