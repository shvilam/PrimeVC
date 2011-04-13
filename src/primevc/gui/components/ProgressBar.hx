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
 import primevc.core.net.ICommunicator;
 import primevc.core.states.SimpleStateMachine;

 import primevc.gui.core.IUIContainer;
 import primevc.gui.core.UIDataContainer;

 import primevc.gui.styling.StyleState;
 import primevc.gui.styling.StyleStateFlags;

  using primevc.utils.Bind;
  using Type;



enum ProgressBarMode {
	manual;				/** update the bar by setting the progress manully **/
	event;				/** update the bar by progress and complete events **/
}
enum ProgressState {
	empty;				/** loading hasn't started (default state) **/
	started;			/** loading is started but no progress yet **/
	completed;			/** loading is completed **/
	error;				/** an error occured during loading **/
	progress;			/** loading is in progress **/
}
enum ProgressType {
	determinate;		/** loading progress can be determined **/
	indeterminate;		/** loading progress can't be determined **/
}


/**
 * Progressbar component.
 * Can be used to present the progress of some activity.
 * 
 * The look&feel of a progressBar is defined by the skin it is using. On default
 * this is 'LinearProgressSkin' when the type is 'determinate' and a gif-spinner
 * for 'indeterminate' type. The LinearProgressSkin will display a regular 
 * progress-bar.
 * 
 * @author Ruben Weijers
 * @creation-date Mar 24, 2011
 */
class ProgressBar extends UIDataContainer<PercentageHelper>
{
	/**
	 * shortcut method to instantiate a progressbar for the given target
	 * 
	 * @param	autoDispose		flag indicating if the progressbar should be disposed when loading has completed or failed
	 */
	public static inline function createIn (target:IUIContainer, source:ICommunicator = null, autoDispose:Bool = false) : ProgressBar
	{
		var b		= new ProgressBar(target.id.value+"Progress");
		b.source	= source;
		
		if (autoDispose) {
			b.dispose.on( source.events.load.completed, b );
			b.dispose.on( source.events.load.error, b );
		}
		
		target.layoutContainer.children.add( b.layout );
		target.children.add( b );
		return b;
	}
	
	
	//
	// PROPERTIES
	//
	
	/**
	 * current mode of the progressbar
	 * @default null
	 */
	public var mode				(default, null)				: ProgressBarMode;
	
	/**
	 * ICommunicator which is dispatching the loading-events. If 'source' is set
	 * to 'null', the 'mode' will be changed to manual
	 * 
	 * @default null
	 */
	public var source			(default, setSource)		: ICommunicator;
	
	/**
	 * state tells what the source is doing. The progressState won't change
	 * automaticly if the 'mode' is manual.
	 * 
	 * @default null
	 */
	public var progressState	(default, setProgressState)	: ProgressState;
	
	/**
	 * Indicates if the progress of the bar is determinate or indeterminate
	 * @default true
	 */
	public var isDeterminate	(default, setIsDeterminate)	: Bool;
	
	
	private var progressStyle		: StyleState;
	private var determinateStyle	: StyleState;
	
	
	//
	// METHODS
	//
	
	public function new (id:String, max:Float = 1.0, min:Float = 0.0)
	{
		super(id, new PercentageHelper(0, min, max));
		
		progressStyle		= style.createState();
		determinateStyle	= style.createState();
		isDeterminate		= true;
	}
	
	
	override public function dispose ()
	{
		if (isDisposed())
			return;
		
		source = null;
		progressStyle		.dispose();
		determinateStyle	.dispose();
		
		progressStyle = determinateStyle = null;
		
		super.dispose();
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setSource (v:ICommunicator)
	{
		if (v != source)
		{
			mode = v == null ? ProgressBarMode.manual : ProgressBarMode.event;
			
			if (source != null)
				source.events.load.unbind( this );
			
			source = v;
			
			if (v != null)
			{
				var e = v.events.load;
				handleBegin		.on( e.started, this );
				handleProgress	.on( e.progress, this );
				handleCompleted	.on( e.completed, this );
				handleError		.on( e.error, this );
				
				trace(v.bytesProgress+", "+v.bytesTotal);
			}
		}
		
		return v;
	}
	
	
	private /*inline*/ function setProgressState ( state:ProgressState ) : ProgressState
	{
		if (progressState != state)
		{
			progressState = state;
			progressStyle.current = switch (state) {
				case progress:		StyleStateFlags.PROGRESS;
				case completed:		StyleStateFlags.COMPLETED;
				case error:			StyleStateFlags.ERROR;
				default:			StyleStateFlags.NONE;
			}
		}
		return state;
	}
	
	
	private inline function setIsDeterminate (v:Bool) : Bool
	{
		if (v != isDeterminate) {
			isDeterminate = v;
			determinateStyle.current = v ? StyleStateFlags.DETERMINATE : StyleStateFlags.INDETERMINATE;
		}
		return v;
	}
	
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function handleBegin ()		{ progressState = ProgressState.started; }
	private function handleCompleted ()	{ updateValues();	progressState = ProgressState.completed; }
	private function handleProgress ()	{ updateValues();	progressState = ProgressState.progress; }
	private function handleError ()		{ updateValues();	progressState = ProgressState.error; }
	
	
	private inline function updateValues ()
	{
		isDeterminate			= source.bytesTotal > 0;
		if (isDeterminate) {
			data.validator.max	= source.bytesTotal;
			data.value			= source.bytesProgress;
	//		trace(source.bytesProgress+" / "+source.bytesTotal+" --- "+source.type+"; "+data.percentage+"%");
		}
	}
}