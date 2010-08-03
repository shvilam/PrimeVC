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
package primevc.gui.graphics.shapes;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.geom.IRectangle;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.IGraphicElement;
 import primevc.gui.traits.IDrawable;


/**
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
interface IGraphicShape implements IGraphicElement
{
	public var fill			(default, setFill)		: IFill;
	public var border		(default, setBorder)	: IBorder <IFill>;
	public var layout		(default, setLayout)	: IRectangle; //LayoutClient;
	
	/**
	 * Signal to notify other objects than IGraphicElement of changes within
	 * the shape.
	 */
	public var changeEvent	(default, null)			: Signal0;
	
	
	/**
	* @param	target
	* target in which the shape will be drawn
	* 
	* @param	useCoordinates
	 * Flag indicating if the draw method should also use the coordinates of the
	 * layoutclient.
	 * 
	 * If a shape is directly drawn into a IDrawable element, this is not the 
	 * case. If a shape is part of a composition of shapes, then the shape 
	 * should respect the coordinates of the LayoutClient.
	 */
	public function draw (target:IDrawable, ?useCoordinates:Bool = false) : Void;
}