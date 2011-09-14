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
 import primevc.core.collections.PriorityList;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.traits.IInvalidateListener;
 import primevc.core.traits.IDisposable;
 import primevc.gui.styling.StyleBlock;
 import primevc.gui.traits.IStylable;
 import primevc.utils.FastArray;


/**
 * @author Ruben Weijers
 * @creation-date Oct 22, 2010
 */
interface IUIElementStyle implements IInvalidateListener, implements IDisposable
{
	public var target					(default, null) : IStylable;
	public var styles					(default, null) : PriorityList < StyleBlock >;
	
	/**
	 * Bitflag-collection with all properties that are set in the styles of 
	 * the target,
	 */
	public var filledProperties			(default, null)	: Int;
	/**
	 * Current css-states of the object.
	 */
	public var currentStates			(default, null)	: FastArray < StyleState >;
	
	
	/**
	 * Reference to the style of whom the current-style got it's properteies
	 */
	public var parentStyle				(default, null)	: IUIElementStyle;
	
	/**
	 * Signal is fired when the children-property of the element-style is
	 * changed
	 */
	public var childrenChanged			(default, null)	: Signal0;
	
	
	/**
	 * Method will try to find the closest matching style for the request 
	 * style-type.
	 */
	public function getChildStyles ( child:IUIElementStyle, name:String, type:StyleBlockType, foundStyles:FastArray<StyleBlock> = null, exclude:StyleBlock = null ) : FastArray<StyleBlock>;
//	public function addChildStyles ( child:IUIElementStyle, name:String, type:StyleBlockType, ?exclude:StyleBlock ) : Int;
//	public function removeChildStyles ( child:IUIElementStyle, name:String, type:StyleBlockType, ?exclude:StyleBlock ) : Int;
	
	public function addStyle (style:StyleBlock) : Int;
	public function removeStyle (style:StyleBlock) : Int;
//	public function findStyle ( name:String, type:StyleBlockType, ?exclude:StyleBlock ) : StyleBlock;
}