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
 import primevc.core.Application;
 import primevc.gui.behaviours.layout.AutoChangeLayoutChildlistBehaviour;
 import primevc.gui.behaviours.layout.WindowLayoutBehaviour;
 import primevc.gui.behaviours.BehaviourList;
 import primevc.gui.display.Window;
 import primevc.gui.layout.algorithms.RelativeAlgorithm;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.traits.ILayoutable;
  using primevc.utils.TypeUtil;


/**
 * UIWindow implementation including layout
 * 
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
class UIWindow extends Window, implements ILayoutable 
{
	public var layout			(default, null)					: LayoutClient;
	public var behaviours		(default, null)					: BehaviourList;
	public var layoutContainer	(getLayoutContainer, never)		: LayoutContainer;
	
	
	public function new (target:DocumentType, app:Application)
	{
		super(target, app);
		
		behaviours = new BehaviourList();
		behaviours.add( new WindowLayoutBehaviour(this) );
		behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
		
		createLayout();
		behaviours.init();
		createChildren();
	}


	override public function dispose ()
	{
		if (displayEvents == null)
			return;
		
		behaviours.dispose();
		layout.dispose();
		behaviours		= null;
		layout			= null;
		
		super.dispose();
	}
	
	
	private function createLayout ()
	{
		layout =	#if flash9	new primevc.avm2.layout.StageLayout( target );
					#else		new LayoutContainer();	#end
		layoutContainer.algorithm = new RelativeAlgorithm();
	}
	
	
	
	/**
	 * After creating the behaviours, the window can also create child 
	 * UIComponents.
	 */
	private function createChildren ()				: Void;
	
	private inline function getLayoutContainer () 	{ return layout.as(LayoutContainer); }
}