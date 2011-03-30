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
 import primevc.core.math.PercentageHelper;
 import primevc.core.states.SimpleStateMachine;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.traits.ICommunicator;
  using primevc.utils.Bind;
  using Type;



enum ProgressBarMode {
	/** update the bar by setting the progress manully **/
	manual;
	/** update the bar by progress and complete events **/
	event;
}



/**
 * Progressbar component.
 * Can be used to present the progress of some activity.
 * 
 * The look&feel of a progressBar is defined by the skin it is using. On default
 * this is 'LinearProgressSkin' for a straight line loader.
 * 
 * @author Ruben Weijers
 * @creation-date Mar 24, 2011
 */
class ProgressBar extends UIDataContainer<PercentageHelper>
{
	/**
	 * current mode of the progressbar
	 */
	public var mode				(default, null)			: ProgressBarMode;
	
	public var source			(default, setSource)	: ICommunicator;
	
	public var progressState	(default, null)			: SimpleStateMachine<ProgressState>;
	
	
	
	public function new (id:String, max:Float = 1.0, min:Float = 0.0)
	{
		super(id, new PercentageHelper(0, min, max));
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setSource (v:ICommunicator)
	{
		if (v != source)
		{
			mode = v == null ? ProgressBarMode.manual : ProgressBarMode.event;
			
			if (source != null) {
				source.events.unbind( this );
			}
			
			source = v;
			
			if (v != null) {
				var e = v.events.load;
				handleBegin		.on( e.started, this );
				handleProgress	.on( e.progress, this );
				handleCompleted	.on( e.completed, this );
				handleError		.on( e.error, this );
			}
		}
		
		return v;
	}
	
	
	private inline function setState ( state:ProgressState ) : Void
	{
		if (progressState.current != state) {
			if (progressState.current != null)	styleClasses.remove( progressState.current.enumConstructor() );
			if (state != null)					styleClasses.add( state.enumConstructor() );
			
			progressState.current = state;
		}
	}
	
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function handleBegin ()		{ data.validator.max	= source.bytesTotal;	setState( ProgressState.start ); }
	private function handleCompleted ()	{ data.value			= source.bytesLoaded;	setState( ProgressState.complete ); }
	private function handleError ()		{ setState( ProgressState.error ); }
	private function handleProgress ()	{ data.value			= source.bytesLoaded;	setState( ProgressState.progress ); }
}



enum ProgressState {
	start;
	complete;
	error;
	progress;
	indeterminate;
}