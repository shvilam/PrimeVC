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
 import primevc.utils.IntMath;
  using primevc.utils.Bind;


/**
 * Effect to play multiple effects at the same time.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class ParallelEffect extends CompositeEffect < ParallelEffect >
{
	/**
	 * Number of effects that are currently playing.
	 */
	private var playingEffects : Int;
	
	
	override public function add (effect)
	{
		super.add(effect);
		lowerChildPlayCount.on( effect.ended, this );
	}
	
	
	override private function getCompositeDuration ()
	{
		var d = 0;
		for (effect in effects)		d = IntMath.max(d, effect.duration);
		return d;
	}
	
	
	//
	// EFFECT CONTROLS
	//
	
	override public function stop ()
	{
		super.stop();
		playingEffects = 0;
	}
	
	
	override private function playWithEffect ()
	{
		stopDelay();
		stopTween();
		playingEffects = effects.length;
		
		//play all effects directly with tween
		for (effect in effects)		effect.play( true, true );
	}
	
	
	override private function playWithoutEffect ()
	{
		stopDelay();
		stopTween();
		playingEffects = effects.length;
		
		//play all effects directly without tween
		for (effect in effects)		effect.play( false, true );
	}



	//
	// EVENTHANDLERS
	//

	private function lowerChildPlayCount () : Void
	{
		if (--playingEffects <= 0) {
			onTweenReady();
			playingEffects = 0;
		}
	}
}