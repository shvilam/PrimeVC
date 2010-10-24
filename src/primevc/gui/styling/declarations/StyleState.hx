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
 import primevc.core.IDisposable;
 import primevc.gui.styling.StyleSheet;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;


/**
 * 
 * @author Ruben Weijers
 * @creation-date Oct 20, 2010
 */
class StyleState implements IDisposable
{
	public var current		(default, setCurrent)	: UInt;
	public var styleSheet	(default, null)			: StyleSheet;
	
	
	public function new (styleSheet:StyleSheet, current:Int = 0)
	{
		this.styleSheet	= styleSheet;
		this.current	= current;
		
	//	checkStateStyles.on ( styleSheet.change, this );
	}
	
	
	public function dispose ()
	{
	//	styleSheet.change.unbind( this );
		current		= StyleStates.NONE;
		styleSheet	= null;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getStates ()
	{
		return styleSheet.states;
	}
	
	private inline function setCurrent (v:UInt) : UInt
	{
		if (v != current)
		{
			Assert.that( styleSheet != null );
			var changes = 0;
			if (current != 0)
				changes = changes.set( removeStyles() );
			
			current = v;
			
			if (current != 0)
				changes = changes.set( setStyles() );
			
		//	trace("setCurrentState "+v+"; all-states: "+styleSheet.readStates()+"; changedProperties "+styleSheet.readProperties(changes));
			styleSheet.change.send( changes );
		}
		return v;
	}
	
	
	//
	// METHODS
	//
	
	/**
	 * Method will look in all the available state-lists to find every 
	 * styledefinition for the requested state. If a style-definition is found,
	 * it will be added to the parent.
	 * 
	 * @return all the changes in the StyleSheet that are caused by adding the styles
	 */
	public function setStyles () : UInt
	{
		if (current == 0 || getStates().filledProperties.hasNone( current ))
			return 0;
		
		var changes		= 0;
		var iterator	= getStates().reversed();
		for (stateGroup in iterator)
			if (stateGroup.has( current ))
				changes = changes.set( styleSheet.addStyle( stateGroup.get( current ) ) );
		
		return changes;
	}
	
	
	/**
	 * Method will look in all the available state-lists to find every 
	 * styledefinition for the requested state. If a style-definition is found,
	 * it will be added to the parent.
	 * 
	 * @return all the changes in the StyleSheet that are caused by adding the styles
	 */
	public function removeStyles () : UInt
	{
		if (current == 0 || getStates().filledProperties.hasNone( current ))
			return 0;
		
		var changes = 0;
		for (stateGroup in getStates())
			if (stateGroup.has( current ))
				changes = changes.set( styleSheet.removeStyleCell( styleSheet.styles.getCellForItem( stateGroup.get( current ) ) ) );
		
		return changes;
	}
	

#if debug
	public function toString ()
	{
		return StyleStates.stateToString( current );
	}
#end
}