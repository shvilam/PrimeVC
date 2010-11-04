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
  using primevc.utils.BitUtil;


/**
 * LayoutContainer without a display-object owning the layout-container. This
 * means that the position of the container should be added to the position of
 * all it's children.
 * 
 * @example
 * 		var box		= new VirtualLayoutContainer();
 * 		var tile1	= new Tile();
 * 		var tile2	= new Tile();
 * 		box.children.add( tile1.layout );
 * 		box.children.add( tile2.layout);
 * 
 * 		tile1.layout.x = 50;
 * 		tile2.layout.y = 120;
 *		box.x = 300;
 *		box.y = 10;
 * 
 *	 - the x of tile1 should now be tile1.layout.x + box.x = 350
 *	 - the y of tile1 should now be tile1.layout.y + box.y = 10
 *	 - the x of tile2 should now be tile2.layout.x + box.x = 300
 *	 - the y of tile2 should now be tile2.layout.y + box.y = 130
 * 
 * @author Ruben Weijers
 * @creation-date Jul 14, 2010
 */
class VirtualLayoutContainer extends LayoutContainer
{
#if debug
	public function new ()
	{
		super();
		name = "VirtualLayoutContainer";
	}
#end
	
	
	override public function invalidate (change)
	{
		super.invalidate(change);
		
		if (change.has( LayoutFlags.X | LayoutFlags.Y))
			for (child in children)
				child.invalidate(change);
	}
}