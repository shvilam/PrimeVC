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
 import primevc.gui.components.Button;
 import primevc.gui.core.IUIContainer;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.events.MouseEvents;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * Class will help with opening and closing a popup for combobox components.
 * The popup will be opened when the component is selected and when the
 * selected value changes to false, the popup will be removed again.
 * 
 * @author Ruben Weijers
 * @creation-date Feb 10, 2011
 */
class OpenPopupBehaviour extends BehaviourBase < Button >
{
	private var popup					: IUIContainer;
	private var selectSignal			: MouseSignal;
	private var deselectSignal			: MouseSignal;
	private var selectBinding			: Wire<Dynamic>;
	private var deselectBinding			: Wire<Dynamic>;
	private var windowDeselectBinding	: Wire<Dynamic>;
	
	
	public function new (target, popup:IUIContainer, selectSignal:MouseSignal, deselectSignal:MouseSignal)
	{
		super(target);
		this.popup			= popup;
		this.deselectSignal	= deselectSignal;
		this.selectSignal	= selectSignal;
	}
	
	
	override public function dispose ()
	{
		popup = null;
		selectSignal = deselectSignal = null;
		super.dispose();
	}
	
	
	override private function init ()
	{
		Assert.notNull( deselectSignal );
		Assert.notNull( selectSignal );
		
		popup.layout.includeInLayout = false;
		
		if (deselectSignal == selectSignal)
		{
			selectBinding			= toggleSelect	.on( selectSignal, this );
		}
		else
		{
			selectBinding			= target.select.on( selectSignal, this );
			deselectBinding			= checkToDeselect.on( deselectSignal, this );
			windowDeselectBinding	= checkToDeselect.on( target.window.mouse.events.down, this );
			
		//	deselectBinding.disable();
			windowDeselectBinding.disable();
		}
		
		handleSelectChange.on( target.selected.change, this );
		
		//check if the popup should already be opened
		handleSelectChange( target.selected.value, false );
	}
	
	
	override private function reset ()
	{
		if (windowDeselectBinding != null)	windowDeselectBinding.dispose();
		if (selectBinding != null)			selectBinding.dispose();
		if (deselectBinding != null)		deselectBinding.dispose();
		
		selectBinding = deselectBinding = windowDeselectBinding = null;
	}
	
	
	public function handleSelectChange (newVal:Bool, oldVal:Bool)
	{
		if (newVal)		openList();
		else			closeList();
	}
	
	
	private function toggleSelect ()
	{
		target.selected.value = !target.selected.value;
	}
	
	
	public function openList ()
	{
		if (popup.window != null)
			return;
		
		Assert.notNull( popup );
	//	selectBinding.disable();
	//	deselectBinding.enable();
		if (windowDeselectBinding != null)
			windowDeselectBinding.enable();
		
	//	target.select();
		target.system.popups.add( popup );
	}
	
	
	public function closeList ()
	{
		if (popup.window == null)
			return;
		
	//	selectBinding.enable();
	//	deselectBinding.disable();
		if (windowDeselectBinding != null)
			windowDeselectBinding.disable();
		
	//	target.deselect();
		popup.system.popups.remove( popup );
	}
	
	
	public function checkToDeselect (mouseObj:MouseState)
	{
	//	trace(popup.window+"; "+target.selected.value);
		if (popup.window == null) // || mouseObj.related == null)
			return;
		
#if flash9
		if (mouseObj.target.is(IDisplayObject))
		{
			var newTarget = mouseObj.target.as(IDisplayObject);
			
			if (newTarget != popup && newTarget != target && !popup.children.has( newTarget ))
				target.deselect();
		}
		else
			target.deselect();
#else
		target.deselect();
#end
	}
}