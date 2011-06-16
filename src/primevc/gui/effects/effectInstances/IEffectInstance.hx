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
 import primevc.gui.effects.EffectProperties;
 import primevc.gui.effects.IEffect;
 import primevc.gui.states.EffectStates;


/**
 * @author Ruben Weijers
 * @creation-date Oct 02, 2010
 */
interface IEffectInstance < TargetType, PropertiesType:IEffect > 
		implements IDisposable
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
	 * Target to play the effect on
	 */
	private var target		: TargetType;
	
	
	public var effect		(default, null)				: PropertiesType;
	
	
	
	/**
	 * Method to set the explicit start and end values of the effect
	 * @see	EffectProperties
	 */
	public  function setValues( v:EffectProperties ) : Void;
	/**
	 * Method that is called before the effect is started to choose if the 
	 * effect should use the target's original value or if it should use the
	 * explicit value.
	 * The explicitvalue will be choosen when it is set.
	 */
	private function initStartValues()				: Void;
	/**
	 * Method which will perform the transformation from visible to hidden.
	 * Needs to be overwritten by subclasses.
	 */
	private function tweenUpdater( tweenPos:Float )	: Void;
	/**
	 * Method will calculate the start position for the play tween. When the 
	 * target for example already has an alpha of 0.4, the start position
	 * won't be '0' but 0.4. The tween-duration will also be 40% smaller.
	 * @return	Float between 0 and 1
	 */
	private function calculateTweenStartPos ()		: Float;
	
	
	/**
	 * Method will play the effect in oppposite direction
	 */
	public  function revert ( withEffect:Bool = true, directly:Bool = false ) : Void;
	
	/**
	 * Method will play the effect
	 */
	public  function play ( withEffect:Bool = true, directly:Bool = false ) : Void;
	
	/**
	 * Method will stop the effect
	 */
	public  function stop () : Void;
	public  function reset () : Void;
	
	
	/**
	 * Method is called after the hideTimer has finished running. It will apply
	 * the changed values with an effect.
	 */
	public  function playWithEffect () : Void;
	
	
	/**
	 * Method is called after the hideTimer has finished running. It will apply
	 * the changed values without an effect.
	 */
	public  function playWithoutEffect () : Void;
	
	
	private function onTweenReady ( ?tweenPos:Float ) : Void;
	
	
	private function hideFilters () : Void;
	private function applyFilters () : Void;
	
	private function stopDelay () : Void;
	private function stopTween () : Void;
	
	
	/**
	 * Getter indicating wether the effect is playing or not
	 */
	public  function isPlaying () : Bool;
	/**
	 * Getter indicating wether the effect is waiting on the delay to finish
	 * before it start's playing
	 */
	public  function isWaiting () : Bool;
}