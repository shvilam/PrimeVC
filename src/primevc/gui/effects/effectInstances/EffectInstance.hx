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
package primevc.gui.effects.effectInstances;
 import haxe.Timer;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.traits.IDisposable;
 import primevc.core.ListNode;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.effects.EffectProperties;
 import primevc.gui.effects.IEffect;
 import primevc.gui.states.EffectStates;
  using primevc.utils.NumberMath;
  using primevc.utils.TypeUtil;


/**
 * Base class for an effect that is currently playing.
 * See interface IEffectInstance for descriptions of the properties.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 01, 2010
 */
class EffectInstance < TargetType, PropertiesType:IEffect > 
				extends ListNode < EffectInstance < TargetType, PropertiesType > >
			,	implements IEffectInstance < TargetType, PropertiesType > 
{
	public var started		(default, null)				: Signal0;
	public var ended		(default, null)				: Signal0;
	public var state		(default, null)				: EffectStates;
	
	public var isReverted	(default, setIsReverted)	: Bool;
	public var effect		(default, null)				: PropertiesType;
	
	private var target			: TargetType;
	private var prevTween		: feffects.Tween;
	private var delayTimer		: Timer;
	
	
#if flash9
	private var cachedFilters	: Array < Dynamic >;
#end
	
	
	public function new (newTarget:TargetType, newEffect:PropertiesType)
	{
		target		= newTarget;
		effect		= newEffect;
		
		started		= new Signal0();
		ended		= new Signal0();
		
		state		= EffectStates.initialized;
		isReverted	= false;
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
	
	
	public function setValues( v:EffectProperties ) : Void		{ Assert.abstract(); }
	private function initStartValues()				: Void		{ Assert.abstract(); }
	private function tweenUpdater( tweenPos:Float )	: Void		{ Assert.abstract(); }
	private function calculateTweenStartPos ()		: Float		{ Assert.abstract(); return 0; }
	
	
	
	public inline function revert ( withEffect:Bool = true, directly:Bool = false ) : Void
	{
		isReverted = !isReverted;
		play( withEffect, directly );
	}
	
	
	public function play ( withEffect:Bool = true, directly:Bool = false ) : Void
	{
		if (state == EffectStates.waiting && !directly)
			return;
		
		stopDelay();
		stopTween();
		hideFilters();
		started.send();
		
		if (directly || effect.delay <= 0)
		{
			if (withEffect)		playWithEffect();
			else				playWithoutEffect();
		}
		else
		{
			state		= EffectStates.waiting;
			delayTimer	= withEffect ? Timer.delay( playWithEffect, effect.delay ) : Timer.delay( playWithoutEffect, effect.delay );
		}
	}
	
	
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
	
	public function playWithEffect ()
	{
		//calculate the tweens end and start position
		initStartValues();
		var calcStartPos	= calculateTweenStartPos();
		var startPos		= isReverted ? 1.0 : 0.0;
		var endPos			= isReverted ? 0.0 : 1.0;
		
		//use current start pos, even when it's reversed
		if (calcStartPos > 0 && state != EffectStates.initialized)
			startPos = calcStartPos;
		
		//if the effect is playing for the first time, give the target it's start position
		if (state == EffectStates.initialized)
			tweenUpdater( startPos );
		
		state = EffectStates.playing;
		
		if (startPos == endPos)
		{
			onTweenReady();
		}
		else
		{
			//calculate tween duration
			var valDiff:Float			= startPos > endPos ? startPos - endPos : endPos - startPos;
			var calcDuration:Int		= ( effect.duration * valDiff ).roundFloat();
#if debug
			if (slowMotion)			calcDuration *= 10;
#end
			prevTween = new feffects.Tween( startPos, endPos, calcDuration, null, null, effect.easing );
			prevTween.setTweenHandlers( tweenUpdater, onTweenReady );
			prevTween.start();
		}
	}
	
	
	public function playWithoutEffect ()
	{
		state = EffectStates.playing;
		
		//call the effect handler once to make sure it's hidden
		tweenUpdater( isReverted ? 0 : 1 );
		onTweenReady();
	}
	
	
	private function onTweenReady ( ?tweenPos:Float )
	{
		state = EffectStates.finished;
		applyFilters();
		ended.send();
	}
	
	
	private inline function hideFilters ()
	{
#if flash9
		if (effect.autoHideFilters && target != null && target.is(IDisplayObject))
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
		if (effect.autoHideFilters && target != null && target.is(IDisplayObject) && cachedFilters != null)
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
	
	
	private function setIsReverted (v:Bool)
	{
		return isReverted = v;
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