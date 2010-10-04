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
 import primevc.core.collections.ArrayList;


typedef ChildEffectType = Effect < Dynamic, Dynamic >;


/**
 * Composite Effect is a base class for classes which execute multiple effects
 * like SequenceEffect and ParallelEffect.
 * Each effect in a composite effect will have the same parent.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class CompositeEffect extends Effect < Dynamic, CompositeEffect >
{
	public var effects				(default, null)					: ArrayList < ChildEffectType >;
	public var compositeDuration	(getCompositeDuration, never)	: Int;
	
	
	public function new (duration:Int = 350, delay:Int = 0, easing:Easing = null)
	{	
		effects = new ArrayList < ChildEffectType > ();
		super(duration, delay, easing);
		init();
	}
	
	
	/**
	 * Method to fill the CompositeEffect with child-effects. Overwrite this
	 * method when you're extending ParallelEffect or SequenceEffect.
	 */
	public function init () {}
	override public function setValues (v:EffectProperties) {}
	
	
	override public function dispose ()
	{
		effects.dispose();
		effects = null;
		super.dispose();
	}
	
	
	public function add (effect:Effect<Dynamic, Dynamic>)
	{
		effects.add( effect );
	}
	
	
	public function remove (effect:Effect<Dynamic, Dynamic>)
	{
		effects.remove( effect );
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function getCompositeDuration ()
	{
		return duration;
	}
}