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
package primevc.gui.behaviours;
 import haxe.FastList;
 import primevc.core.traits.IDisposable;


private typedef BehaviourType = IBehaviour<Dynamic>;

/**
 * List with all available behaviours
 * 
 * @author Ruben Weijers
 * @creation-date Aug 02, 2010
 */
class BehaviourList implements IDisposable
{
	private var list			: FastList < BehaviourType >;
	private var isInitialized	: Bool;
	
	public function new ()
	{
		list			= new FastList < BehaviourType > ();
		isInitialized	= false;
	}
	
	
	public inline function removeAll ()
	{
		while (!list.isEmpty()) {
			var b:BehaviourType = list.pop();
			if (b != null)
				b.dispose();
		}
	}
	
	
	public function init ()
	{
		if (!isInitialized)
		{	
			isInitialized = true;
			for (behaviour in list)
				behaviour.initialize();
		}
	}
	
	
	public inline function dispose ()					{ removeAll(); list = null; isInitialized = false; }
	public inline function add (v:BehaviourType)		{ if (isInitialized) { v.initialize(); }	return list.add(v); }
	public inline function remove (v:BehaviourType)		{ if (isInitialized) { v.dispose(); }		return list.remove(v); }
}