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
package primevc.core.states;
 import primevc.utils.FastArray;
 

/**
 * Finite State Machine that will automaticy instatiate all states.
 * So new State is not needed anymore :-)
 * 
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
class AutoFiniteStateMachine extends FiniteStateMachine, implements haxe.rtti.Infos
{
	public static inline var STATE_CLASS		: String = "primevc.core.states.State";
	public static inline var STATE_INTERFACE	: String = "primevc.core.states.IState";
	
	public function new() 
	{
		super();
		__init();
	}
	
	
	private function __init () : Void
	{
		var cl							= Type.getClass(this);
		var fields:FastArray<String>	= (untyped cl).fields;
		
		var struct = Xml.parse(untyped cl.__rtti).firstElement().elements();
		var element:Xml;
		var prop:Xml;
		
		if (fields == null) {
			fields = (untyped cl).fields = FastArrayUtil.create();
			
			for (element in struct)
			{
				prop = element.firstElement();
				
				if (prop != null && prop.nodeName == 'c' && (prop.get('path') == STATE_INTERFACE || prop.get('path') == STATE_CLASS))
				{
					fields.push(element.nodeName);
					setField( element.nodeName, new State( states.length ) );
				}
			}
		} else {
			for (field in fields) {
				setField( field, new State( states.length ) );
			}
		}
	}
	
	
	private function setField ( name:String, value:State ) : Void
	{
		if (Reflect.field(this, name ) == null)
		{
			Reflect.setField(this, name, value);
			if (value != null)
				states.push( value );
		}
	}
	
	
	/**
	 * method will automaticly set all state properties to 'null'
	 */
	override public function dispose ()
	{
		super.dispose();
		
		var cl = Type.getClass(this);
		var fields:FastArray<String> = untyped cl.fields;
		for (field in fields) {
			setField( field, null );
		}
	}
}