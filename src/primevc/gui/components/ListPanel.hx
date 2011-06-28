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
 import primevc.core.collections.IReadOnlyList;
 import primevc.core.Bindable;



/**
 * Panel with a ListView as content instead of a UIContainer.
 * 
 * @author Ruben Weijers
 * @creation-date Apr 29, 2011
 */
class ListPanel<ListDataType> extends Panel, implements IListHolder<ListDataType>
{
	public var list (default, null)	: ListView<ListDataType>;
	
	/**
	 * If the items in the list are selectable, this bindable holds the position
	 * of the currently selected index.
	 */
	public var selectedIndex					(default, null)	: Bindable<Int>;
	
	
	
	public function new (id:String = null, label:String = null, data:IReadOnlyList<ListDataType> = null)
	{
		content = list	= new ListView<ListDataType>("content", data);
		selectedIndex	= new Bindable<Int>(-1);
		super(id, label);
	}
	
	
	override public function dispose ()
	{
		super.dispose();
		
		selectedIndex.dispose();
		selectedIndex	= null;
		list			= null;
	}
}