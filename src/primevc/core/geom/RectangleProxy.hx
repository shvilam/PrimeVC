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
package primevc.core.geom;
 import primevc.core.geom.constraints.ContrainedRect;
 import primevc.core.IDisposable;


/**
 * Rectangle Proxy is a Rectangle with Float properties that will keep itself
 * in sync with an BindableBox (which will have integers).
 * 
 * This is usefull when an object is dragged and needs to stay within the 
 * boundaries of another object.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
class RectangleProxy extends Rectangle, implements IDisposable
{
	private var originalRect (default, null)	: ContrainedRect;
	
	
	public function new ( originalRect:ContrainedRect )
	{
		super( originalBounds.left, originalBounds.top, originalBounds.width, originalBounds.height );
		this.originalRect = originalRect;
		
		updateLeft	.on( originalRect.leftProp.change );
		updateRight	.on( originalRect.rightProp.change );
		updateTop	.on( originalRect.topProp.change );
		updateBottom.on( originalRect.bottomProp.change );
	}
	
	
	public function dispose ()
	{
		super.dispose();
		originalRect.leftProp	.change.unbind( this );
		originalRect.rightProp	.change.unbind( this );
		originalRect.topProp	.change.unbind( this );
		originalRect.bottomProp	.change.unbind( this );
	}
	
	
	private inline function updateLeft (v:Int)		{ left		= v; }
	private inline function updateRight (v:Int)		{ right		= v; }
	private inline function updateTop (v:Int)		{ top		= v; }
	private inline function updateBottom (v:Int)	{ bottom	= v; }
}