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
package primevc.gui.layout.algorithms;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.geom.IRectangle;
 import primevc.core.IDisposable;
 import primevc.gui.layout.ILayoutContainer;
 import primevc.gui.layout.LayoutClient;


/**
 * @since	mar 20, 2010
 * @author	Ruben Weijers
 */
interface ILayoutAlgorithm implements IDisposable
{
	/**
	 * Signal that will be dispatched when properties of the algorithm have 
	 * been changed and the layout needs to be validated again.
	 */
	public var algorithmChanged (default, null)				: Signal0;
	public var group			(default, setGroup)			: ILayoutContainer<LayoutClient>;
	
	
	/**
	 * Method indicating if the size is invalidated or not.
	 */
	public function isInvalid (changes:Int)					: Bool;
	
	/**
	 * Method to prepare the algorithm to measure. This method can be used to
	 * set properties that are needed for both the meausureHorizontal method 
	 * and the meausureVertical method.
	 */
	public function prepareMeasure ()						: Void;
	
	/**
	 * Method will measure the given target according to the algorithms
	 * rules. The result of the measuring should be put in 
	 * 		Layoutgroup.MeasuredWidth
	 * 		Layoutgroup.MeasuredHeight
	 */
	public function measure ()								: Void;
	
	public function measureHorizontal ()					: Void;
	public function measureVertical ()					 	: Void;
	
	/**
	 * Method will apply it's layout algorithm on the given target.
	 */
	public function apply ()								: Void;
	
	/**
	 * Method will return the depth that belongs to the given coordinates.
	 * The depth of an object depends on the type of algorithm that is used.
	 * 
	 * Before calling this method, the method 'removeStartPosFromPoint' should
	 * be called to make sure the point is valid within the algorithms.
	 */
	public function getDepthForBounds (bounds:IRectangle)	: Int;
}