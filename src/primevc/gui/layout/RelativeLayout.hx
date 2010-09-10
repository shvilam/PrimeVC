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
 import primevc.core.dispatcher.Signal0;
 import primevc.core.geom.IBox;
 import primevc.core.IDisposable;
 import primevc.types.Number;
#if debug
  using primevc.utils.NumberUtil;
#end


/**
 * The relative layout class describes the wanted settings of a layout client
 * in relation with the layout-parent.
 * 
 * In a relative layout it's possible to set the prop 
 * 		horizontalCenter = 0
 * to make sure the layout is always centered in relation with it's layout
 * parent.
 * 
 * The parent can choose to apply or ignore the relative properties depending 
 * on the layout-algorithm that is uses. When the algorithm is positionating 
 * every layout-child next to eachother, the horizontalCenter will be ignored
 * for example.
 * 
 * This class is not meant for standalone use but should always be placed in
 * the LayoutClient.relative property.
 * 
 * @see		primevc.gui.layout.LayoutClient
 * 
 * @creation-date	Jun 22, 2010
 * @author			Ruben Weijers
 */
class RelativeLayout implements IBox, implements IDisposable
{
	/**
	 * Flag indicating if the relative-properties are enabled or disabled.
	 * When the value is false, it will still be possible to change the
	 * values but there won't be fired a change signal to let the layout-
	 * client now that it's changed.
	 * 
	 * @default	true
	 */
	public var enabled				: Bool;
	
	/**
	 * Signal to notify listeners that a property of the relative layout is 
	 * changed.
	 */
	public var changed				(default, null) : Signal0;
	
	
	//
	// CENTERING PROPERTIES
	//
	
	/**
	 * Defines at what horizontal-location the center of the layoutclient 
	 * should be placed in the center of the parent-layout.
	 * 
	 * @example
	 * 		layout.relative.hCenter = 10;
	 * 
	 * Will make the center of the layout be placed at 10px right from the 
	 * center of the parent.
	 * 
	 * @default		Number.INT_NOT_SET
	 */
	public var hCenter		(default, setHCenter)	: Int;
	
	/**
	 * Defines at what vertical-location the center of the layoutclient 
	 * should be placed in the center of the parent-layout.
	 * 
	 * @example
	 * 		layout.relative.vCenter = 10;
	 * 
	 * Will make the center of the layout be placed at 10px below the 
	 * center of the parent.
	 * 
	 * @default		Number.INT_NOT_SET
	 */
	public var vCenter		(default, setVCenter)	: Int;
	
	
	
	
	//
	// BOX PROPERTIES
	//
	
	/**
	 * Property defines the relative left position in relation with the parent.
	 * @example		
	 * 		client.relative.left = 10;	//left side of client will be 10px from the left side of the parent
	 * @default		Number.INT_NOT_SET
	 */
	public var left					(getLeft, setLeft)				: Int;
	/**
	 * Property defines the relative right position in relation with the parent.
	 * @see			primevc.gui.layout.RelativeLayout#left
	 * @default		Number.INT_NOT_SET
	 */
	public var right				(getRight, setRight)			: Int;
	/**
	 * Property defines the relative top position in relation with the parent.
	 * @see			primevc.gui.layout.RelativeLayout#left
	 * @default		Number.INT_NOT_SET
	 */
	public var top					(getTop, setTop)				: Int;
	/**
	 * Property defines the relative bottom position in relation with the parent.
	 * @see			primevc.gui.layout.RelativeLayout#left
	 * @default		Number.INT_NOT_SET
	 */
	public var bottom				(getBottom, setBottom)			: Int;
	
	
	public function new ( top:Int = Number.INT_NOT_SET, right:Int = Number.INT_NOT_SET, bottom:Int = Number.INT_NOT_SET, left:Int = Number.INT_NOT_SET )
	{
		this.changed	= new Signal0();
		this.hCenter	= Number.INT_NOT_SET;
		this.vCenter	= Number.INT_NOT_SET;
		this.top		= top;
		this.right		= right;
		this.bottom		= bottom;
		this.left		= left;
	}
	
	
	public function dispose ()
	{
		changed.dispose();
		changed = null;
	}
	
	
	public inline function clone () : IBox
	{
		var n = new RelativeLayout( top, right, bottom, left );
		n.vCenter = vCenter;
		n.hCenter = hCenter;
		return n;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function getLeft ()		{ return left; }
	private inline function getRight ()		{ return right; }
	private inline function getTop ()		{ return top; }
	private inline function getBottom ()	{ return bottom; }
	
	
	
	private function setHCenter (v) {
		//unset left and right
		if (v != Number.INT_NOT_SET)
			left = right = Number.INT_NOT_SET;
		
		if (v != hCenter) {
			hCenter = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private function setVCenter (v) {
		//unset top and bottom
		if (v != Number.INT_NOT_SET)
			top = bottom = Number.INT_NOT_SET;
		
		if (v != vCenter) {
			vCenter = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	
	
	private inline function setLeft (v) {
		if (v != Number.INT_NOT_SET)
			hCenter = Number.INT_NOT_SET;
		
		if (v != left) {
			left = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private inline function setRight (v) {
		if (v != Number.INT_NOT_SET)
			hCenter = Number.INT_NOT_SET;
		
		if (v != right) {
			right = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private inline function setTop (v) {
		if (v != Number.INT_NOT_SET)
			vCenter = Number.INT_NOT_SET;
		
		if (v != top) {
			top = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private inline function setBottom (v) {
		if (v != Number.INT_NOT_SET)
			vCenter = Number.INT_NOT_SET;
		
		if (v != bottom) {
			bottom = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	
#if debug
	public function toString () {
		return "RelativeLayout - t: "+top+"; r: "+right+"; b: "+bottom+"; l: "+left+"; hCenter: "+hCenter+"; vCenter: "+vCenter;
	}
	
	public function toCSSString () {
		var css = [];
		var str = "";
		
		if (top.isSet())	css.push( top + "px" );
		else				css.push( "none" );
		if (right.isSet())	css.push( right + "px" );
		else				css.push( "none" );
		if (bottom.isSet())	css.push( bottom + "px" );
		else				css.push( "none" );
		if (left.isSet())	css.push( left + "px" );
		else				css.push( "none" );
		
		str = css.join(" ");
		css = [];
		
		if (hCenter.isSet())	css.push( hCenter + "px")
		else					css.push( "none");
		if (vCenter.isSet())	css.push( vCenter + "px")
		else					css.push( "none");
		
		if (str != "")
			str += ", ";
		
		str += css.join(" ");
		
		return str;
	}
#end
}