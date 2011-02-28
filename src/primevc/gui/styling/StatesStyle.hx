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
package primevc.gui.styling;
 import primevc.core.traits.IInvalidatable;
 import primevc.types.SimpleDictionary;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
  using primevc.utils.BitUtil;


typedef StatesListType	= SimpleDictionary < Int, StyleBlock >;
private typedef Flags	= StyleStateFlags;


/**
 * @author Ruben Weijers
 * @creation-date Oct 20, 2010
 */
class StatesStyle extends StyleSubBlock
{
	private var extendedStyle	: StatesStyle;
	private var superStyle		: StatesStyle;
	public var states			(default, null) : StatesListType;
	
	
	public function new (states:StatesListType = null)
	{
		super();
		this.states = states;
		
		updateFilledPropertiesFlag();
		updateAllFilledPropertiesFlag();
	}
	
	
	override public function dispose ()
	{
		if (states != null) {
			states.dispose();
			states = null;
		}
		super.dispose();
	}
	
	
	override private function updateOwnerReferences (changedReference:Int) : Void
	{
		if (changedReference.has( StyleFlags.EXTENDED_STYLE ))
		{
			if (extendedStyle != null)
				extendedStyle.listeners.remove( this );
			
			extendedStyle = null;
			if (owner != null && owner.extendedStyle != null)
			{
				extendedStyle = owner.extendedStyle.states;
				
				if (extendedStyle != null)
					extendedStyle.listeners.add( this );
			}
		}
		
		
		if (changedReference.has( StyleFlags.SUPER_STYLE ))
		{
			if (superStyle != null)
				superStyle.listeners.remove( this );
			
			superStyle = null;
			if (owner != null && owner.superStyle != null)
			{
				superStyle = owner.superStyle.states;
				
				if (superStyle != null)
					superStyle.listeners.add( this );
			}
		}
	}
	
	
	private function updateFilledPropertiesFlag ()
	{
		if (states != null)
		{
			//define filled states
			var stateNames = states.keys();
			for (stateName in stateNames)
				filledProperties = filledProperties.set(stateName);
		}
	}
	
	
	override public function updateAllFilledPropertiesFlag ()
	{
		inheritedProperties = 0;
		if (extendedStyle != null)	inheritedProperties  = extendedStyle.allFilledProperties;
		if (superStyle != null)		inheritedProperties |= superStyle.allFilledProperties;
		
		allFilledProperties = filledProperties | inheritedProperties;
		inheritedProperties	= inheritedProperties.unset( filledProperties );
	}
	
	
	override public function getPropertiesWithout (noExtendedStyle:Bool, noSuperStyle:Bool)
	{
		var props = filledProperties;
		if (!noExtendedStyle && extendedStyle != null)	props |= extendedStyle.allFilledProperties;
		if (!noSuperStyle && superStyle != null)		props |= superStyle.allFilledProperties;
		return props;
	}
	
	
	/**
	 * Method is called when a property in the super- or extended-style is 
	 * changed. If the property is not set in this style-object, it means that 
	 * the allFilledPropertiesFlag needs to be changed..
	 */
	override public function invalidateCall ( changeFromOther:Int, sender:IInvalidatable ) : Void
	{
		Assert.that(sender != null);
		
		if (sender == owner)
			return super.invalidateCall( changeFromOther, sender );
		
		if (filledProperties.has( changeFromOther ))
			return;
		
		//The changed property is not in this style-object.
		//Check if the change should be broadcasted..
		var propIsInExtended	= extendedStyle != null	&& extendedStyle.allFilledProperties.has( changeFromOther );
		var propIsInSuper		= superStyle != null	&& superStyle	.allFilledProperties.has( changeFromOther );
		
		if (sender == extendedStyle)
		{
			if (propIsInExtended)	allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the super style and the extended-style doesn't have the property that is changed, broadcast the change as well
		else if (sender == superStyle && !propIsInExtended)
		{
			if (propIsInSuper)		allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		return;
	}
	
	
	
	//
	// STATE METHODS
	//
	
	public function set (stateName:Int, state:StyleBlock) : Void
	{
		if (states == null && state == null)
			return;
		
		if (states == null)		states = new StatesListType();
		if (state == null)		states.unset( stateName );
		else					states.set( stateName, state );
		
		markProperty( stateName, state != null );
	}
	
	
	public function get (stateName:Int) : StyleBlock
	{
	//	Assert.that( has(stateName), Flags.readProperties( allFilledProperties ) );
		
		if (this.doesntHave(stateName))
			return null;
		
		var v:StyleBlock = null;
		if (filledProperties.has(stateName))		v = states.get( stateName );
		if (v == null && extendedStyle != null)		v = extendedStyle.get( stateName );
		if (v == null && superStyle != null)		v = superStyle.get( stateName );
		return v;
	}
	
	
	
	//
	// CODE / CSS SUPPORT
	//
	
	
#if neko
	public function keys () : Iterator < Int >				{ return states != null ? states.keys() : null; }
	public function iterator () : Iterator < StyleBlock >	{ return states != null ? states.iterator() : null; }


	override public function toCSS (prefix:String = "")
	{
		var css = [];
		
		if (!isEmpty())
		{
			var stateNames = states.keys();
			for (stateName in stateNames)
			{
				var state = states.get( stateName );
				
				if (state != null)
					css.push( state.toCSS( prefix + ":" + Flags.stateToString(stateName) ) );
			}
		}
		
		if (css.length > 0)
			return "\n" + css.join("\n");
		else
			return "";
	}
	
	
	override public function cleanUp ()
	{
		if (!isEmpty())
		{
			states.cleanUp();
			updateFilledPropertiesFlag();
			updateAllFilledPropertiesFlag();
		}
	}
	

	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ states ] );
	}
#end


#if debug
	override public function readProperties (flags:Int = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;

		return Flags.readProperties(flags);
	}
#end


#if (debug && flash9)
	public function toString () 
	{
		var statesToFind	= allFilledProperties;
		var output			= [];
		
		while (statesToFind > 0)
		{
			statesToFind = addStateStringToArray( statesToFind, output, Flags.CHECKED );
			statesToFind = addStateStringToArray( statesToFind, output, Flags.DISABLED );
			statesToFind = addStateStringToArray( statesToFind, output, Flags.DOWN );
			statesToFind = addStateStringToArray( statesToFind, output, Flags.ERROR );
			statesToFind = addStateStringToArray( statesToFind, output, Flags.FOCUS );
			statesToFind = addStateStringToArray( statesToFind, output, Flags.HOVER );
			statesToFind = addStateStringToArray( statesToFind, output, Flags.INVALID );
			statesToFind = addStateStringToArray( statesToFind, output, Flags.LOADED );
			statesToFind = addStateStringToArray( statesToFind, output, Flags.LOADING );
			statesToFind = addStateStringToArray( statesToFind, output, Flags.OPTIONAL );
			statesToFind = addStateStringToArray( statesToFind, output, Flags.REQUIRED );
			statesToFind = addStateStringToArray( statesToFind, output, Flags.VALID );
		}
		
		return "StatesStyle "+output.join(", ");
	}
	
	
	private function addStateStringToArray ( statesToFind:Int, output:Array<String>, state:Int )
	{
		if (statesToFind.has( state ))
		{
			output.push( Flags.stateToString( state ) );
			statesToFind = statesToFind.unset( state );
		}
		return statesToFind;
	}
#end
}