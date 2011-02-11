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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.components;
 import primevc.types.Bitmap;


/**
 * DataButton is a button that can be used as an ItemRenderer
 * 
 * @author Ruben Weijers
 * @creation-date Feb 11, 2011
 */
class DataButton <DataType> extends Button, implements IItemRenderer <DataType>
{
	// IItemRenderer Properties
	public var vo				(getVO, setVO)	: DataType;
	public var getLabelForVO					: DataType -> String;
	
	
	public function new (id:String = null, value:String = null, icon:Bitmap = null, vo:DataType = null)
	{
		super(id, value, icon);
		this.vo = vo;
	}
	
	
	override public function dispose ()
	{
		vo = null;
		super.dispose();
	}
	
	
	private function setVO (v)
	{
		if (v != vo) {
			vo = v;
		}
		
		return v;
	}
	
	
	private inline function getVO () {
		return vo;
	}
}