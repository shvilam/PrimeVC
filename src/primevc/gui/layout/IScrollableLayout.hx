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
package primevc.gui.layout;
 import primevc.core.geom.BindablePoint;
 import primevc.core.geom.IntPoint;


/**
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
interface IScrollableLayout implements ILayoutContainer, implements IAdvancedLayoutClient
{
	/**
	 * horizontal and vertical scroll position
	 */
	public var scrollPos			(default, null)					: BindablePoint;
	
	/**
	 * The total width of the container that is invisible and can be scrolled
	 */
	public var scrollableWidth		(getScrollableWidth, never)		: Int;
	
	/**
	 * The total height of the container that is invisible and can be scrolled
	 */
	public var scrollableHeight		(getScrollableHeight, never)	: Int;
	
	/**
	 * The minimum value of the scrollX position (<= 0). This is number is set
	 * by a layoutalgorithm when there are children with a negative x-position.
	 */
	public var minScrollXPos		(default, setMinScrollXPos)		: Int;
	/**
	 * The minimum value of the scrollY position (<= 0). This is number is set
	 * by a layoutalgorithm when there are children with a negative y-position.
	 */
	public var minScrollYPos		(default, setMinScrollYPos)		: Int;
	
	
	/**
	 * Method will return if the container is horizontal scrollable
	 */
	public function horScrollable			()						: Bool;
	/**
	 * Method will return if the container is vertical scrollable
	 */
	public function verScrollable			()						: Bool;
	
	/**
	 * Method will tell if the coordinates of the given point are valid values
	 * for the scrollposition or not. If the coordinates are invalid it will
	 * change them to valid positions.
	 */
	public function validateScrollPosition	(pos:IntPoint)			: IntPoint;
}