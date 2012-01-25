/*
 * Copyright (c) 2012, The PrimeVC Project Contributors
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
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package examples.layout;
 import flash.display.Sprite;
 import flash.display.Shape;

 import primevc.gui.events.DisplayEvents;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.layout.LayoutFlags;

 import primevc.utils.FastArray;

  using primevc.core.states.SimpleStateMachine;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.FastArray;



/**
 * This example shows how to use LayoutContainer, LayoutClient
 * and some layout-algorithms.
 *
 * NOTE: Example is currently flash-only!
 *
 * @author			Ruben Weijers
 * @creation-date	Jan 24, 2012
 */
class LayoutExample1 extends Sprite
{
	public static function main () {
		var stage = flash.Lib.current.stage;
		stage.scaleMode	= flash.display.StageScaleMode.NO_SCALE;
		stage.addChild( new LayoutExample1() );
	}


	public  var layout			(default, null) : LayoutContainer;
	private var children		(default, null) : FastArray<Box>;
	public  var displayEvents	(default, null) : DisplayEvents;


	public function new ()
	{
		super();

		displayEvents = new DisplayEvents(this);
		children = FastArrayUtil.create();
		layout	 = #if flash9 new primevc.avm2.layout.StageLayout( flash.Lib.current.stage ) #else new LayoutContainer() #end;
	//	layout.algorithm = new primevc.gui.layout.algorithms.tile.SimpleTileAlgorithm(vertical);
		layout.algorithm = new primevc.gui.layout.algorithms.tile.SimpleTileAlgorithm();
	//	layout.algorithm = new primevc.gui.layout.algorithms.DynamicLayoutAlgorithm( function () { return new primevc.gui.layout.algorithms.circle.HorizontalCircleAlgorithm(); }, function () { return new primevc.gui.layout.algorithms.circle.VerticalCircleAlgorithm(); } );
	//	layout.algorithm = new primevc.gui.layout.algorithms.DynamicLayoutAlgorithm( function () { return new primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm(); }, function () { return new primevc.gui.layout.algorithms.circle.VerticalCircleAlgorithm(); } );
		
		for (i in 0...50)
			children.push( new Box().attachTo(this) );
		
		if (layout.state.is(invalidated))
			invalidate();
		invalidate.onEntering( layout.state, invalidated, this );
	}


	private function invalidate ()
		layout.validate.onceOn( displayEvents.enterFrame, this )
}




/**
 * @author			Ruben Weijers
 * @creation-date	Jan 24, 2012
 */
class Box extends Shape
{
#if debug
	private static var counter = 0;
	private var num				(default, null) : Int;
#end
	public  var layout 			(default, null) : LayoutClient;

	
	public function new() 
	{
		super();
#if debug num	= counter++; #end
		layout	= new LayoutClient(30, 50);
		layout.margin = new primevc.core.geom.Box(10,5);
		
		applyLayout.on( layout.changed, this );						//apply position and size changes
		draw();
	}


	public inline function attachTo (parent:LayoutExample1) {
		parent.layout.children.add(this.layout);
		parent.addChild(this);
		return this;
	}

	
	private inline function draw () {
		var g = graphics;
		g.beginFill(0xff0000, 1);
		g.drawRect(0,0,layout.width, layout.height);
		g.endFill();
	}


	private function applyLayout (changes:Int) {
		var l = layout;
		if (changes.has( LayoutFlags.X ))		x 		= l.getHorPosition();		// getHorPosition also includes the position of any virtual-layoutcontainers that can be used. x-value of layout is only the x + margin-left
		if (changes.has( LayoutFlags.Y ))		y 		= l.getVerPosition();
		if (changes.has( LayoutFlags.WIDTH ))	width	= l.innerBounds.width; 		// innerBounds are the size + padding, outerbounds would give us size + padding + margin
		if (changes.has( LayoutFlags.HEIGHT ))	height	= l.innerBounds.height;
	}
}
