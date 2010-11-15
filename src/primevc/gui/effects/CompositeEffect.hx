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
#if neko
 import primevc.tools.generator.ICodeGenerator;
  using primevc.types.Reference;
#end
 import primevc.types.Number;
 import primevc.utils.NumberMath;
  using primevc.utils.NumberUtil;


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
	
	
	public function new (duration:Int = 0, delay:Int = 0, easing:Easing = null)
	{
		effects		= new ArrayList < ChildEffectType > ();
		duration	= duration <= 0	? Number.INT_NOT_SET : duration;
		super(duration, delay, easing);
		init();
	}
	
	
	/**
	 * Method to fill the CompositeEffect with child-effects. Overwrite this
	 * method when you're extending ParallelEffect or SequenceEffect.
	 */
	public function init () {}
	override public function setValues (v:EffectProperties)
	{
		for (effect in effects)
			effect.setValues(v);
	}
	
	
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
		var duration = this.duration;
		
		for (effect in effects)
			duration = IntMath.max(duration, effect.duration);
		
		return duration;
	}


#if neko
	override public function toCSS (prefix:String = "") : String
	{
		var props = [];

		if (duration.isSet())		props.push( duration + "ms" );
		if (delay.isSet())			props.push( delay + "ms" );
		if (easing != null)			props.push( easing.toCSS() );
		
		if (effects.length > 0) {
			var cssEff = [];
			for (effect in effects)
				cssEff.push( effect.toCSS() );
			
			props.push( "(" + cssEff.join(", ") + ")" );
		}
		
		return props.join(" ");
	}
	
	
	override public function isEmpty ()
	{
		return getCompositeDuration() <= 0 || effects.length <= 0;
	}
	
	
	override public function toCode (code:ICodeGenerator) : Void
	{
		if (!isEmpty()) {
			code.construct( this, [ duration, delay, easing ] );
			for (effect in effects)
				code.setAction( this, "add", [ effect ] );
		}
	}
#end
}