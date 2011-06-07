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
package primevc.gui.components;
 import flash.errors.Error;
 import primevc.core.dispatcher.Wire;
 import primevc.gui.core.UIContainer;
 import primevc.gui.core.UIWindow;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.states.ValidateStates;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.input.KeyCodes;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;



/**
 * Class to add debug buttons to the window
 * 
 * @author Ruben Weijers
 * @creation-date Feb 22, 2011
 */
class DebugBar extends UIContainer
{
	private var inspectStageBtn			: Button;
	private var inspectLayoutBtn		: Button;
	private var validateLayoutBtn		: Button;
	private var showInvalidatedBtn		: Button;
	private var showRenderingBtn		: Button;
	private var toggleTraceLayoutBtn	: Button;
	private var clearTracesBtn			: Button;
	private var garbageCollectBtn		: Button;
	private var wireCountBtn			: Button;
	
	
	override private function createChildren ()
	{
#if !debug
		Assert.that(false, "Can't use DebugBar without being in debugmode");
#end
		inspectStageBtn			= new Button("inspectStageBtn", "Inspect Stage");
		inspectLayoutBtn		= new Button("inspectLayoutBtn", "Controleer layout");
		validateLayoutBtn		= new Button("validateLayoutBtn", "Forceer layout validatie");
		showInvalidatedBtn		= new Button("showInvalidatedBtn", "Trace invalidated queue");
		showRenderingBtn		= new Button("showRenderingBtn", "Trace render queue");
		toggleTraceLayoutBtn	= new Button("toggleTraceValidationBtn", "Trace layout validation");
		clearTracesBtn			= new Button("clearTracesBtn", "Clear traces");
		garbageCollectBtn		= new Button("garbageCollectBtn", "Garbage Collect");
		wireCountBtn			= new Button("wireCountBtn", "Count wires");
		
		attach( clearTracesBtn )	.attach( inspectStageBtn )	.attach( inspectLayoutBtn )		.attach( validateLayoutBtn );
		attach( showInvalidatedBtn ).attach( showRenderingBtn )	.attach( toggleTraceLayoutBtn )	.attach( garbageCollectBtn ).attach(wireCountBtn);
		
		haxe.Log.clear			.on( clearTracesBtn.userEvents.mouse.click, this );
		inspectAllLayouts		.on( inspectLayoutBtn.userEvents.mouse.click, this );
		forceAllValidation		.on( validateLayoutBtn.userEvents.mouse.click, this );
		inspectStage			.on( inspectStageBtn.userEvents.mouse.click, this );
		traceInvalidationQueue	.on( showInvalidatedBtn.userEvents.mouse.click, this );
		traceRenderingQueue		.on( showRenderingBtn.userEvents.mouse.click, this );
		toggleTraceLayout		.on( toggleTraceLayoutBtn.userEvents.mouse.click, this );
		flash.system.System.gc	.on( garbageCollectBtn.userEvents.mouse.click, this );
		countWires				.on( wireCountBtn.userEvents.mouse.click, this );
		
		handleHotkeys.on ( window.userEvents.key.down, this );
	}
	
	
	function handleHotkeys (k:KeyboardState)
	{
		if (k.ctrlKey() && k.shiftKey()) switch (k.keyCode()) {
			case KeyCodes.C: haxe.Log.clear();
			case KeyCodes.V: forceAllValidation();
			case KeyCodes.I: inspectAllLayouts();
		}
	}
	
	//
	// DEBUG METHODS
	//
	
	
	/**
	 * Method will check every layoutcontainer it can find to see if it's validated
	 */
	private function inspectAllLayouts ()
	{
		var s = "\n\tbeginInspectingLayout";
		try {
			var result = inspectIfContainerIsValidated(window.as(UIWindow).popupLayout);
			s += "\n\t- popupLayout:";
			s += result.errors;
			s += "\n\tfinished Inspecting popupsLayout: "+result.valid+" valid layouts. "+result.invalid + " invalid layouts";
			
			result = inspectIfContainerIsValidated(window.as(UIWindow).layoutContainer);
			s += result.errors;
			s += "\n\tfinished InspectingLayout: "+result.valid+" valid layouts. "+result.invalid + " invalid layouts";
			trace(s);
		} catch (e:Error) {
			trace("[ERROR INSPECTING LAYOUT] :: "+e.errorID+": "+e.message);
			trace(e.getStackTrace());
		}
	}
	
	
	private function inspectIfContainerIsValidated (cont:LayoutContainer, result:Dynamic = null) : Dynamic
	{
		if (result == null)
			result = {valid: 0, invalid: 0, errors: ""};
		
		inspectIfLayoutIsValidated( cont, result );
		
		for (child in cont.children)
			if (Std.is(child, LayoutContainer))
				inspectIfContainerIsValidated(cast child, result);
			else
				inspectIfLayoutIsValidated( child, result );
		
		return result;
	}
	
	
	private inline function inspectIfLayoutIsValidated (layout:LayoutClient, result:Dynamic)
	{
		if (!layout.state.is( ValidateStates.validated )) {
			result.errors += "\n\t\t[ "+result.invalid+" ]layout of "+layout+"("+layout.includeInLayout+")"+" is "+layout.state.current+" instead of validated. Invalidated properties: "+layout.readChanges();
			result.invalid++;
		}
		else
			result.valid++;
	}
	
	
	private function forceAllValidation ()
	{
		trace("begin force validation");
		var counter  = forceValidationOnContainer(window.as(UIWindow).layoutContainer);
			counter += forceValidationOnContainer(window.as(UIWindow).popupLayout);
		trace("finished forcing validation: revalidated "+counter+" layouts");
		inspectAllLayouts();
	}
	
	
	private function forceValidationOnContainer (cont:LayoutContainer, counter:Int = 0)
	{
		if (forceValidationOnLayout( cont ))
			counter++;
		
		for (child in cont.children)
			if (Std.is(child, LayoutContainer)) {
				counter = forceValidationOnContainer(cast child, counter);
			} else {
				if (forceValidationOnLayout( child ))
					counter++;
			}

		return counter;
	}
	
	private function forceValidationOnLayout (layout:LayoutClient)
	{
		if (!layout.state.is( ValidateStates.validated )) {
			layout.validate();
			return true;
		}
		return false;
	}
	
	
	
	
	
	/**
	 * Method will try to send the window object to the insepct window of alcon trace
	 */
	private function inspectStage ()
	{
#if AlconTrace
		com.hexagonstar.util.debug.Debug.inspect( window );
#end
	}
	
	
	
	private function traceInvalidationQueue ()
	{
		var o = system.invalidation.traceQueues;
		system.invalidation.traceQueues = true;
		system.invalidation.traceQueue();
		system.invalidation.traceQueues = o;
	}
	
	
	private function traceRenderingQueue ()
	{
		var o = system.rendering.traceQueues;
		system.rendering.traceQueues = true;
		system.rendering.traceQueue();
		system.rendering.traceQueues = o;
	}
	
	
	private function toggleTraceLayout ()
	{
		toggleTraceLayoutBtn.toggleSelect();
		if (toggleTraceLayoutBtn.selected.value)
		{
			system.invalidation.traceQueues = true;
			toggleTraceLayoutBtn.data.value = "Stop Tracing layout validation";
		}
		else
		{
			system.invalidation.traceQueues = false;
			toggleTraceLayoutBtn.data.value = "Trace layout validation";
		}
	}
	
	
	private function countWires ()
	{
		trace("total: "+Wire.instanceCount+"; disposed: "+Wire.disposeCount);
	}
}