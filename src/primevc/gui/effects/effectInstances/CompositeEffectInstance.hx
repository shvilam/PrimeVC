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
 import primevc.gui.effects.CompositeEffect;		//imports typedef ChildEffectType
 import primevc.gui.effects.EffectProperties;
 import primevc.gui.effects.IEffect;
 import primevc.utils.FastArray;
  using primevc.utils.Bind;
  using primevc.utils.FastArray;


/**
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
class CompositeEffectInstance extends EffectInstance < Dynamic, CompositeEffect >
{
	private var effectInstances : FastArray < IEffectInstance < Dynamic, Dynamic > >;
	
	
	public function new (target, effect)
	{	
		effectInstances = FastArrayUtil.create();
		super(target, effect);
		
		addEffectInstance.on( effect.effects.events.added, this );
		removeEffectInstance.on( effect.effects.events.removed, this );
		
		for (childEffect in effect.effects)
			addEffectInstance( childEffect, -1 );
	}
	
	
	override public function dispose ()
	{
		if (state == null)
			return;
		
		for (inst in effectInstances)
			inst.dispose();
		
		effect.effects.events.added.unbind(this);
		effect.effects.events.removed.unbind(this);
		effectInstances = null;
		super.dispose();
	}
	
	
	override public function stop ()
	{
		super.stop();
		
		if (effectInstances != null)
			for (effect in effectInstances)
				effect.stop();
	}
	
	
	override public function reset ()
	{
		for (effect in effectInstances)
			effect.reset();
	}
	
	
	override private function setIsReverted (v)
	{
		super.setIsReverted( v );
		for (effect in effectInstances)
			effect.isReverted = isReverted;
		return isReverted;
	}
	
	
	override private function initStartValues () {}
	override public function setValues (v:EffectProperties)
	{
		for (effect in effectInstances)
			effect.setValues(v);
	}
	
	
	override private function calculateTweenStartPos () : Float { return 0; }
	
	
	private function addEffectInstance (v:ChildEffectType, depth:Int ) : Void
	{
		effectInstances.push( v.createEffectInstance( target ) );
	}
	
	
	private function removeEffectInstance (v:ChildEffectType, lastDepth:Int ) : Void
	{
		var i = effectInstances[ lastDepth ];
		effectInstances.remove( i );
		i.dispose();
	}
}