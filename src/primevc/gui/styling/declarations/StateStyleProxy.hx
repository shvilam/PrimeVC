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
package primevc.gui.styling.declarations;
 import primevc.gui.styling.IElementStyle;
 import primevc.gui.styling.declarations.StyleProxyBase;
  using primevc.utils.BitUtil;

private typedef Flags = StyleStates;


/**
 * @author Ruben Weijers
 * @creation-date Okt 20, 2010
 */
class StateStyleProxy extends StyleProxyBase < StateStyleDeclarations >
{
	public function new (styleSheet:IElementStyle)				{ super( styleSheet, StyleFlags.STATES ); }
	override public function forwardIterator ()					{ return cast new StateGroupForwardIterator( styleSheet, propertyTypeFlag); }
	override public function reversedIterator ()				{ return cast new StateGroupReversedIterator( styleSheet, propertyTypeFlag); }

#if debug
	override public function readProperties (props:Int = -1)	{ return Flags.readProperties( (props == -1) ? filledProperties : props ); }
#end
	
	
	/**
	 * when the states of any style changes, broadcast the change..
	 */
	override public function invalidateCall ( changeFromSender, sender )
	{
		if (changeFromSender > 0)
			change.send( changeFromSender );
	}
}


class StateGroupForwardIterator extends StyleGroupForwardIterator < StateStyleDeclarations >
{
	override public function next ()	{ return setNext().data.states; }
}


class StateGroupReversedIterator extends StyleGroupReversedIterator < StateStyleDeclarations >
{
	override public function next ()	{ return setNext().data.states; }
}


/*
class StateStyleProxy extends StateStyleDeclarations
{
	private var target	: StyleSheet;
	public var change	(default, null)	: Signal1 < UInt >;
	
	
	public function new (newTarget:StyleSheet)
	{	
		target	= newTarget;
		change	= new Signal1();
		super();
	}
	
	
	override public function dispose ()
	{	
		change.dispose();
		change	= null;
		target	= null;
		super.dispose();
	}
	
	
	override public function updateAllFilledPropertiesFlag () : Void
	{
		super.updateAllFilledPropertiesFlag();
		
		for (styleObj in target)
		{
			if (styleObj.has( StyleFlags.STATES ))
				allFilledProperties = allFilledProperties.set( styleObj.states.allFilledProperties );
			
			if (allFilledProperties == Flags.ALL_STATES)
				break;
		}
	}
	
	
	override public function invalidateCall (changes:UInt, sender:IInvalidatable)
	{
		var t = sender.as(StateStyleDeclarations);
		
		if (t.owner.type != StyleDeclarationType.id)
		{
			for (styleObj in target)
			{
				if (!styleObj.has( StyleFlags.STATES ))
					continue;
				
				if (styleObj.states == t)
					break;
			
				changes = changes.unset( styleObj.states.allFilledProperties );
			}
		}
		
		if (t.filledProperties.has(changes))	allFilledProperties = allFilledProperties.set( changes );
		else									updateAllFilledPropertiesFlag();
		
		invalidate( changes );
	}
	
	
	override public function invalidate (changes:UInt)
	{
		if (changes > 0)
			change.send( changes );
	}
	
	
	
	//
	// GETTERS
	//
	
	override public function get (stateName:UInt) : UIElementStyle
	{
		if (!has(stateName))
			return null;
		
		var v = super.get(stateName);
		if (v == null)
			for (styleObj in target)
				if (styleObj.hasState( stateName )) {
					v = styleObj.states.get( stateName );
					break;
				}
		
		return v;
	}
}*/