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
package primevc.gui.components;
 import primevc.gui.core.UIContainer;
 import primevc.gui.core.UITextField;
  using primevc.utils.IntUtil;


/**
 * TextArea component displays a multiline textfield and adds the posibility
 * to divide the text of the component in multiple columns.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
class TextArea extends UIContainer < String >
{
	private static inline var MAX_COLUMNS	: Int = 40;
	
	/**
	 * Vector with all column fields
	 */
	private var fields : FastArray < UITextField >;
	
	/**
	 * Number of columns in this TextArea
	 * @default	1
	 */
	public var columns	(default, setColumns)	: Int;
	
	
	public function new (id:String = null, ?value:String, ?columns:Int = 1)
	{
		super(id, value);
		this.columns = columns;
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setColumns (v:Int)
	{
		v = v.within( 1, MAX_COLUMNS );
		if (v != columns) {
			columns = v;
			invalidate( Flags.COLUMNS );
		}
		return v;
	}
}