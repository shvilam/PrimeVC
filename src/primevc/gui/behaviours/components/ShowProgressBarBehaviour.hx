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
 import primevc.core.net.ICommunicator;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.components.ProgressBar;
 import primevc.gui.core.IUIContainer;

 import primevc.gui.styling.StyleState;
 import primevc.gui.styling.StyleStateFlags;

  using primevc.utils.Bind;


/**
 * Behaviour will show a progressbar for the given ICommunicator when it starts
 * loading and will remove it when the loading is completed or done.
 * 
 * The target will get the style-state "progress" during the loading and when
 * the loading failes, the style-state value will be changed to "error".
 * 
 * @author Ruben Weijers
 * @creation-date Apr 15, 2011
 */
class ShowProgressBarBehaviour extends BehaviourBase<IUIContainer>
{
	private var loader		: ICommunicator;
	private var bar			: ProgressBar;
	
	/**
	 * Reference to the "loading" style-state for the target
	 */
	private var targetStyle	: StyleState;
	
	
	
	
	public function new (target:IUIContainer, loader:ICommunicator) //, autoDispose:Bool = false)
	{
		super(target);
		Assert.notNull(loader);
		this.loader = loader;
	}
	
	
	override private function init ()
	{
		Assert.notNull(loader);
	//	if (loader.isCompleted())
	//		return;
		createBar.on( loader.events.load.started, this );
		if (loader.isStarted && !loader.isCompleted())
			createBar();
	}
	
	
	override private function reset ()
	{
		Assert.that(initialized);
		loader.events.load.unbind(this);
		loader = null;
		
		if (targetStyle != null) {
			targetStyle.dispose();
			targetStyle = null;
		}
		
		if (bar != null) {
			bar.dispose();
			bar = null;
		}
	}
	
	
	private function createBar ()
	{
		if (bar != null)
			disposeBar();
		
		targetStyle	= target.style.createState( StyleStateFlags.PROGRESS );
		bar			= new ProgressBar(target.id.value+"Progress");
		bar.source	= loader;
		bar.disable();
		
		var e = loader.events.load;
		disposeBar.onceOn( e.completed, this );
		disposeBar.onceOn( e.error, this );
		
		addBar();
	}
	
	
	/**
	 * Add the progressbar after the component is initialized to prevend the
	 * bar to appear underneath the other children of the target
	 */
	private function addBar ()
	{
		if (target.isInitialized())
		{
			target.layoutContainer.children.add( bar.layout, 0 );
			target.children.add( bar );
		}
		else
			addBar.onceOn( target.state.initialized.entering, this );
	}
	
	
	private function disposeBar ()
	{
	//	trace(this);
		loader.events.load.unbind(this);
		bar.dispose();
		Assert.null(bar.window);
		Assert.null(bar.container);
		targetStyle.current = loader.isCompleted() ? StyleStateFlags.NONE : StyleStateFlags.ERROR;
	}
	
	
#if debug
	override public function toString ()
	{
		return super.toString() + " -> "+loader+"; started: "+loader.isStarted+"; completed: "+loader.isCompleted();
	}
#end
}