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
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.display.VectorShape;
 import primevc.gui.display.Sprite;
 import primevc.gui.display.Window;

 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.traits.IGraphicsOwner;

  using primevc.core.states.SimpleStateMachine;
  using primevc.utils.Bind;			// for writing easy-to-read signal-bindings
  using primevc.utils.BitUtil;		// for writing easy-to-read bit-flag-operations



/**
 * LayoutExample2 is identical to LayoutExample1, except it uses primes display-package instead of flash.display.*
 *
 * @author			Ruben Weijers
 * @creation-date	Jan 25, 2012
 */
class LayoutExample2 extends Window
{
	public static function main ()
		Window.startup(function (stage) { return new LayoutExample2(stage); })


	public var layout (default, null) : LayoutContainer;


	public function new (stage)
	{
		super(stage);
		
		// StageLayout automatically adjusts its size to the flash-stage-size
		layout	 = #if flash9 new primevc.avm2.layout.StageLayout( flash.Lib.current.stage ) #else new LayoutContainer() #end;
		
		// ----
		// Some example layout-algorithms - uncomment to try em out.
		// ----
	//	layout.algorithm = new primevc.gui.layout.algorithms.tile.SimpleTileAlgorithm(vertical);
		layout.algorithm = new primevc.gui.layout.algorithms.tile.SimpleTileAlgorithm();
	//	layout.algorithm = new primevc.gui.layout.algorithms.DynamicLayoutAlgorithm( function () { return new primevc.gui.layout.algorithms.circle.HorizontalCircleAlgorithm(); }, function () { return new primevc.gui.layout.algorithms.circle.VerticalCircleAlgorithm(); } );
	//	layout.algorithm = new primevc.gui.layout.algorithms.DynamicLayoutAlgorithm( function () { return new primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm(); }, function () { return new primevc.gui.layout.algorithms.circle.VerticalCircleAlgorithm(); } );
		
		// create children
		for (i in 0...20)	new Box().attachTo(this);
		for (i in 0...20)	new InteractiveBox().attachTo(this);
		for (i in 0...20)	new Box().attachTo(this);
		

		// add layout-validation
		if (layout.state.is(invalidated))
			invalidateLayout();
		invalidateLayout.onEntering( layout.state, invalidated, this );
	}


	private function invalidateLayout ()
		layout.validate.onceOn( displayEvents.enterFrame, this )
}




/**
 * A simple Box which is positioned by the layout code in LayoutExample2
 *
 * @author			Ruben Weijers
 * @creation-date	Jan 24, 2012
 */
private class Box
{
#if debug
	private static var counter = 0;
	private var num			(default, null) : Int;
#end
	public  var display		(default, null) : IDisplayObject;
	public  var layout 		(default, null) : LayoutClient;
	private var color		: UInt;

	
	public function new() 
	{
		if (display == null)	display = new VectorShape();
		if (color 	== 0)		color 	= 0xffaaaa;
		
#if debug num	= counter++; #end
		layout	= new LayoutClient(30, 50);
		layout.margin = new primevc.core.geom.Box(20,5);
		
		applyLayout.on( layout.changed, this );						//apply position and size changes
		draw();
	}


	public inline function attachTo (parent:LayoutExample2) {
		parent.layout.attach(this.layout);
		display.attachDisplayTo(parent);
		return this;
	}

	
	private function draw () {
		var g = cast(display, IGraphicsOwner).graphics;
		g.clear();
		g.beginFill(color, 1);
		g.drawRect(0,0,layout.width, layout.height);
		g.endFill();
	}


	private function applyLayout (changes:Int) {
		var l = layout;
		if (changes.has( LayoutFlags.X ))		display.x 		= l.getHorPosition();		// getHorPosition also includes the position of any virtual-layoutcontainers that can be used. x-value of layout is only the x + margin-left
		if (changes.has( LayoutFlags.Y ))		display.y 		= l.getVerPosition();
		if (changes.has( LayoutFlags.WIDTH ))	display.width	= l.innerBounds.width; 		// innerBounds are the size + padding, outerbounds would give us size + padding + margin
		if (changes.has( LayoutFlags.HEIGHT ))	display.height	= l.innerBounds.height;
	}
}


/**
 * A simple Box with mouse hover interactions which is positioned by the layout code in LayoutExample2
 *
 * @author			Ruben Weijers
 * @creation-date	Jan 25, 2012
 */
private class InteractiveBox extends Box
{
	public function new ()
	{
		color 	= 0xddccbb;
		var d	= new Sprite();
		display = d;
		super();

		makeBigger.on( d.userEvents.mouse.rollOver, this );
		makeNormal.on( d.userEvents.mouse.rollOut, this );
	}


	private function makeNormal ()	{ layout.resize(30,50); color = 0xddccbb; draw(); }
	private function makeBigger ()	{ layout.resize(80,80); color = 0xeeaadd; draw(); }
}
