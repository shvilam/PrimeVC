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
#if (debug || neko)
 import primevc.tools.generator.ICodeGenerator;
 import primevc.tools.generator.Reference;
 import primevc.utils.StringUtil;
#end
 import primevc.core.traits.Invalidatable;
 import primevc.gui.display.IDisplayObject;
	
#if (flash8 || flash9 || js)
 import primevc.gui.effects.effectInstances.IEffectInstance;
#end

 import primevc.types.Number;
  using primevc.utils.NumberUtil;


/**
 * Base class for every effect
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class Effect < TargetType, EffectClass:IEffect > extends Invalidatable, implements IEffect
{
#if (debug || neko)
	public var uuid				(default, null)	: String;
	/**
	 * String name of the easing method...
	 */
	public var easingName		(default, setEasingName)		: String;
#end
	
	public var easing			(default, setEasing)			: Easing;
	public var delay			(default, setDelay)				: Int;
	public var duration			(default, setDuration)			: Int;
	public var autoHideFilters	(default, setAutoHideFilters)	: Bool;
	
	
	public function new( newDuration:Int = 350, newDelay:Int = 0, newEasing:Easing = null ) 
	{
		super();
#if (debug || neko)
		uuid			= StringUtil.createUUID();
#end
		duration		= newDuration.notSet()	? 350 : newDuration;
		delay			= newDelay <= 0			? Number.INT_NOT_SET : newDelay;
		easing			= newEasing;
		autoHideFilters	= false;
	}
	
	
	override public function dispose ()
	{
		easing = null;
		super.dispose();
		//dispose all effect instances?
	}
	
	
	public function clone () : IEffect
	{
		Assert.abstract(); return null;
	}
	
	
	public function setValues( v:EffectProperties ) : Void
	{
		Assert.abstract();
	}
	
	
#if (flash8 || flash9 || js)
	/**
	 * Method will start a new effect on the given target and return the 
	 * playing effect instance.
	 */
	public function play (target:TargetType, withEffect:Bool = true, playDirectly:Bool = false) : IEffectInstance < TargetType, EffectClass >
	{
		Assert.that(target != null && duration > 0);
		var c = createEffectInstance(target);
		c.play(withEffect, playDirectly);
		return c;
	}
	
	
	public function createEffectInstance (target:TargetType) : IEffectInstance < TargetType, EffectClass >
	{
		Assert.abstract();
		return null;
	}
#end
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setDelay (v:Int) : Int
	{
		Assert.that(v >= 0 || v.notSet(), "delay should be 0 or larger.. it is: "+v);
		if (delay != v) {
			delay = v;
			invalidate( EffectFlags.DELAY );
		}
		return v;
	}
	
	
	private inline function setEasing (v:Easing) : Easing
	{
		if (easing != v) {
			easing = v;
			invalidate( EffectFlags.EASING );
		}
		return v;
	}
	
	
	private inline function setDuration (v:Int) : Int
	{
		if (duration != v) {
			duration = v;
			invalidate( EffectFlags.DURATION );
		}
		return v;
	}
	
	
	private inline function setAutoHideFilters (v:Bool) : Bool
	{
		if (autoHideFilters != v) {
			autoHideFilters = v;
			invalidate( EffectFlags.AUTO_HIDE_FILTERS );
		}
		return v;
	}
	
	
#if (debug || neko)
	private inline function setEasingName (v:String) : String
	{
		return easingName = v;
	}


	public function toString ()
	{
		return toCSS();
	}
	
	
	private function easingToCSS () : String
	{
	#if neko
		return easingName;
	}
	
	
	private function easingToCode() : Reference
	{
		var path = "feffects.easing.";
		return switch (easingName) {
			case "back-in":			Reference.func( path + "Back.easeIn" );
			case "back-out":		Reference.func( path + "Back.easeOut" );
			case "back-in-out":		Reference.func( path + "Back.easeInOut" );
			
			case "bounce-in":		Reference.func( path + "Bounce.easeIn" );
			case "bounce-out":		Reference.func( path + "Bounce.easeOut" );
			case "bounce-in-out":	Reference.func( path + "Bounce.easeInOut" );
			
			case "circ-in":			Reference.func( path + "Circ.easeIn" );
			case "circ-out":		Reference.func( path + "Circ.easeOut" );
			case "circ-in-out":		Reference.func( path + "Circ.easeInOut" );
			
			case "cubic-in":		Reference.func( path + "Cubic.easeIn" );
			case "cubic-out":		Reference.func( path + "Cubic.easeOut" );
			case "cubic-in-out":	Reference.func( path + "Cubic.easeInOut" );
			
			case "elastic-in":		Reference.func( path + "Elastic.easeIn" );
			case "elastic-out":		Reference.func( path + "Elastic.easeOut" );
			case "elastic-in-out":	Reference.func( path + "Elastic.easeInOut" );
			
			case "expo-in":			Reference.func( path + "Expo.easeIn" );
			case "expo-out":		Reference.func( path + "Expo.easeOut" );
			case "expo-in-out":		Reference.func( path + "Expo.easeInOut" );
			
			case "linear-in":		Reference.func( path + "Linear.easeIn" );
			case "linear-out":		Reference.func( path + "Linear.easeOut" );
			case "linear-in-out":	Reference.func( path + "Linear.easeInOut" );
			
			case "quad-in":			Reference.func( path + "Quad.easeIn" );
			case "quad-out":		Reference.func( path + "Quad.easeOut" );
			case "quad-in-out":		Reference.func( path + "Quad.easeInOut" );
			
			case "quart-in":		Reference.func( path + "Quart.easeInOut" );
			case "quart-out":		Reference.func( path + "Quart.easeOut" );
			case "quart-in-out":	Reference.func( path + "Quart.easeInOut" );
			
			case "quint-in":		Reference.func( path + "Quint.easeIn" );
			case "quint-out":		Reference.func( path + "Quint.easeOut" );
			case "quint-in-out":	Reference.func( path + "Quint.easeInOut" );
			default:	null;
		}
	#else
		return "";
	#end
	}


	public function toCSS (prefix:String = "")		{ Assert.abstract(); return null; }
	public function isEmpty () : Bool				{ return duration <= 0; }
#end

#if neko
	public function cleanUp ()						{}
	public function toCode (code:ICodeGenerator)	{ Assert.abstract(); }
#end
}