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
 import primevc.utils.FastArray;
  using primevc.utils.FastArray;



/**
 * Composite Effect is a base class for classes which execute multiple effects
 * like SequenceEffect and ParallelEffect.
 * Each effect in a composite effect will have the same parent.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class CompositeEffect < ClassName > extends Effect < Dynamic, ClassName >
{
	private var effects				: FastArray < Effect < Dynamic, Dynamic > >;
	public var compositeDuration	(getCompositeDuration, never)	: Int;
	
	
	public function new (target, duration:Int = 350, delay:Int = 0, easing:Easing = null)
	{
		super(target, duration, delay, easing);
		effects = FastArrayUtil.create();
	}
	
	
	override public function dispose ()
	{
		for (effect in effects)
			effect.dispose();
		
		effects = null;
		super.dispose();
	}
	
	
	public function add (effect:Effect<Dynamic, Dynamic>)
	{
		effects.push( effect );
		effect.target		= target;
		effect.easing		= easing;
		effect.isReverted	= isReverted;
	}
	
	
	public function remove (effect:Effect<Dynamic, Dynamic>)
	{
		effects.remove( effect );
		effect.dispose();
	}
	
	
	override public function stop ()
	{
		super.stop();
		for (effect in effects)		effect.stop();
	}
	
	
	override public function reset ()
	{
		for (effect in effects)		effect.reset();
	}


	override private function calculateTweenStartPos () : Float
	{
		return 0;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function getCompositeDuration ()
	{
		return duration;
	}
	
	
	override private function setEasing (v)
	{
		super.setEasing( v );
		for (effect in effects)		effect.easing = easing;
		return easing;
	}
	
	
	override private function setTarget (v)
	{
		super.setTarget( v );
		for (effect in effects)		effect.target = target;
		return target;
	}
	
	
	override private function setIsReverted (v)
	{
		super.setIsReverted( v );
		for (effect in effects)		effect.isReverted = isReverted;
		return isReverted;
	}
}