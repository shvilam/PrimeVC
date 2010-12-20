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
 import primevc.gui.effects.SequenceEffect;
  using primevc.utils.Bind;


/**
 * Class description
 * 
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
class SequenceEffectInstance extends CompositeEffectInstance
{
	override public function playWithEffect ()
	{
		stopDelay();
		stopTween();
		
		if (effectInstances.length == 0) {
			onTweenReady();
			return;
		}
		
		//play all effects directly with tween
		var len:Int		= effectInstances.length;
		var firstEffect	= effectInstances[ isReverted ? len - 1 : 0 ];
		var prevEffect	= firstEffect;
		for (i in 1...len)
		{
			var curEffect = effectInstances[ isReverted ? len - i : i ];
			curEffect.playWithEffect.onceOn( prevEffect.ended, this );
			prevEffect = curEffect;
		}
		
		lastChildReadyHandler.onceOn( prevEffect.ended, this );
		firstEffect.playWithEffect();
	}


	override public function playWithoutEffect ()
	{
		stopDelay();
		stopTween();
		
		if (effectInstances.length == 0) {
			onTweenReady();
			return;
		}
		
		//play all effects directly with tween
		var len:Int		= effectInstances.length;
		var firstEffect	= effectInstances[ isReverted ? len - 1 : 0 ];
		var prevEffect	= firstEffect;
		for (i in 1...len)
		{
			var curEffect = effectInstances[ isReverted ? len - i : i ];
			curEffect.playWithoutEffect.onceOn( prevEffect.ended, this );
			prevEffect = curEffect;
		}

		lastChildReadyHandler.onceOn( prevEffect.ended, this );
		firstEffect.playWithoutEffect();
	}
	
	
	private function lastChildReadyHandler () {
		onTweenReady();
	}
}