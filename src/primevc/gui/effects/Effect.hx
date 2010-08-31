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
package primevc.gui.effects;
 import haxe.Timer;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.IDisposable;
 import primevc.core.traits.IClonable;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.states.EffectStates;
  using	primevc.utils.TypeUtil;


/**
 * Base class for every effect
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class Effect < TargetType, ClassName > implements IDisposable, implements IClonable < ClassName >
{
	/**
	 * Event that is dispatched when the effect starts playing
	 */
	public var started		(default, null)				: Signal0;
	/**
	 * Event that is dispatched when the effect is finished or stopped
	 */
	public var ended		(default, null)				: Signal0;
	
	/**
	 * The easing type that the effect should use
	 * @default		null
	 * @see			feffects.easing
	 */
	public var easing		(default, setEasing)		: Easing;
	
	/**
	 * State of the effect
	 * @default		EffectStates.empty
	 */
	public var state		(default, null)				: EffectStates;
	
	/**
	 * Flag indicating if the effect should play reverted or not
	 * @default		false
	 */
	public var isReverted	(default, setIsReverted)	: Bool;
	
	/**
	 * Number of milliseconds to wait before starting the effect
	 * @default		0
	 */
	public var delay		(default, setDelay)			: Int;
	
	/**
	 * Effect duration
	 * @default		350
	 */
	public var duration		(default, setDuration)		: Int;
	
	/**
	 * Target to play the effect on
	 */
	public var target		(default, setTarget)		: TargetType;
	
	
	
#if flash9
	/**
	 * Original array with filters of the target. For most effects the filters
	 * will be temporary disabled to speed up the effect.
	 */
	private var cachedFilters			: Array < Dynamic >;
	
	/**
	 * Flag indicating if the target's filters should be hidden when the effect
	 * is running.
	 * @default	true
	 */
	public var hideFiltersDuringEffect	: Bool;
#end
	
	private var prevTween				: feffects.Tween;
	private var delayTimer				: Timer;
	
	
	
	public function new( newTarget:TargetType, newDuration:Int = 350, newDelay:Int = 0, newEasing:Easing = null ) 
	{
		target		= newTarget;
		duration	= newDuration;
		delay		= newDelay;
		easing		= newEasing;
		isReverted	= false;
		
		started		= new Signal0();
		ended		= new Signal0();
		
		hideFiltersDuringEffect = true;
		state		= target == null || duration < 0 ? EffectStates.empty : EffectStates.initialized;
	}
	
	
	public function dispose ()
	{
		if (state == null)
			return;
		
		stop();
		started.dispose();
		ended.dispose();
		
		started		= null;
		ended		= null;
		delayTimer	= null;
		prevTween	= null;
		target		= null;
		state		= null;
	}
	
	
	public function clone () : ClassName
	{
		Assert.abstract();
		return null;
	}
	
	
	
	
	/**
	 * Method will play the effect in oppposite direction
	 */
	public inline function revert ( withEffect:Bool = true, directly:Bool = false ) : Void
	{
		isReverted = !isReverted;
		play( withEffect, directly );
	}
	
	
	/**
	 * Method will play the effect
	 */
	public function play ( withEffect:Bool = true, directly:Bool = false ) : Void
	{
		if (state == EffectStates.waiting || !directly || state == EffectStates.empty)
			return;
		
		stopDelay();
		stopTween();
		hideFilters();
		started.send();
		
		if (delay <= 0 || directly)
		{
			if (withEffect)		playWithEffect();
			else				playWithoutEffect();
		}
		else
		{
			state		= EffectStates.waiting;
			delayTimer	= withEffect ? Timer.delay( playWithEffect, delay ) : Timer.delay( playWithoutEffect, delay );
		}
	}
	
	
	/**
	 * Method will stop the effect
	 */
	public function stop () : Void
	{
		stopDelay();
		stopTween();
		applyFilters();
		
		if (isPlaying())
			state = EffectStates.finished;
	}
	
	
	public function reset ()
	{
		stop();
		tweenUpdater( isReverted ? 1 : 0 );
	}
	
	
	
	//
	// PERFORM EFFECT
	//
	
	/**
	 * Method is called after the hideTimer has finished running. It will apply
	 * the changed values with an effect.
	 */
	private function playWithEffect ()
	{
		//calculate the tweens end and start position
		var calcStartPos	= calculateTweenStartPos();
		var startPos		= isReverted ? 1.0 : 0.0;
		var endPos			= isReverted ? 0.0 : 1.0;
		
		//use current start pos, even when it's reversed
		if (calcStartPos > 0 && state != EffectStates.initialized)
			startPos = calcStartPos;
		
		//if the effect is playing for the first time, give the target it's start position
		if (state == EffectStates.initialized) {
		//	target.visible = false;
			tweenUpdater( startPos );
		//	target.visible = true;
		}
		
		state = EffectStates.playing;
		
		if (startPos == endPos)
		{
			onTweenReady();
		}
		else
		{
			//calculate tween duration
			var valDiff:Float			= startPos > endPos ? startPos - endPos : endPos - startPos;
			var calcDuration:Int		= Math.round( duration * valDiff );
#if debug
			if (slowMotion)			calcDuration *= 10;
#end
			prevTween = new feffects.Tween( startPos, endPos, calcDuration, null, null, easing );
			prevTween.setTweenHandlers( tweenUpdater, onTweenReady );
			prevTween.start();
		}
	}
	
	
	/**
	 * Method is called after the hideTimer has finished running. It will apply
	 * the changed values without an effect.
	 */
	private function playWithoutEffect ()
	{
		state = EffectStates.playing;
		
		//call the effect handler once to make sure it's hidden
		tweenUpdater( isReverted ? 0 : 1 );
		onTweenReady();
	}
	
	
	/**
	 * Method which will perform the transformation from visible to hidden.
	 * Needs to be overwritten by subclasses.
	 */
	private function tweenUpdater ( tweenPos:Float )	: Void	{ Assert.abstract(); }
	
	
	/**
	 * Method will calculate the start position for the play tween. When the 
	 * target for example already has an alpha of 0.4, the start position
	 * won't be '0' but 0.4. The tween-duration will also be 40% smaller.
	 * @return	Float between 0 and 1
	 */
	private function calculateTweenStartPos ()			: Float { Assert.abstract(); return 0; }
	
	
	private function onTweenReady ( ?tweenPos:Float )
	{
		state = EffectStates.finished;
		applyFilters();
		ended.send();
	}
	
	
	private inline function hideFilters ()
	{
#if flash9
		if (hideFiltersDuringEffect && target != null && target.is(IDisplayObject))
		{
			var d = target.as(IDisplayObject);
			if (d.filters != null) {
				cachedFilters	= d.filters;
				d.filters		= null;
			}
		}
#end
	}
	
	
	private inline function applyFilters ()
	{
#if flash9
		if (hideFiltersDuringEffect && target != null && target.is(IDisplayObject) && cachedFilters != null)
		{
			var d = target.as(IDisplayObject);
			d.filters		= cachedFilters;
			cachedFilters	= null;
		}
#end
	}
	
	
	private inline function stopDelay ()
	{
		if (delayTimer != null)
		{
			delayTimer.stop();
			delayTimer = null;
		}
	}
	
	
	private inline function stopTween ()
	{
		if (prevTween != null)
		{
			prevTween.stop();
			prevTween = null;
		}
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function isPlaying () : Bool
	{
		return state == EffectStates.playing || state == waiting;
	}
	
	
	private inline function setDelay (v:Int) : Int
	{
		Assert.that(v >= 0);
		return delay = v;
	}
	
	
	private function setIsReverted (v:Bool)		{ return isReverted = v; }
	private function setEasing (v:Easing)		{ return easing = v; }
	
	
	private function setTarget (newTarget : TargetType) : TargetType
	{
		if (target != newTarget)
		{
			if (target != null && isPlaying())
				stop();
			
			target	= newTarget;
			state	= target == null || duration < 0 ? EffectStates.empty : EffectStates.initialized;
		}
		return newTarget;
	}
	
	
	private inline function setDuration (val:Int) : Int
	{
		if (duration != val)
		{
			duration	= val;
			state		= target == null || duration < 0 ? EffectStates.empty : EffectStates.initialized;
		}
		return val;
	}
	
	
	
#if (debug && flash9)
	static public var slowMotion = function() {
		flash.Lib.current.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, 
			function(e:flash.events.KeyboardEvent) { if (e.keyCode == flash.ui.Keyboard.SHIFT) { slowMotion = true; trace("shiftDown"); } }
		);
		flash.Lib.current.addEventListener(flash.events.KeyboardEvent.KEY_UP, 
			function(e:flash.events.KeyboardEvent) { if (e.keyCode == flash.ui.Keyboard.SHIFT) { slowMotion = false; trace("shiftUp"); } }
		);
		
		return false;
	}();
#end
}