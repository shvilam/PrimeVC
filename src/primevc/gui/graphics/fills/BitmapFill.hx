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
package primevc.gui.graphics.fills;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.core.geom.IRectangle;
 import primevc.core.geom.Matrix2D;
 import primevc.gui.graphics.GraphicElement;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.gui.graphics.IGraphicProperty;
 import primevc.gui.traits.IGraphicsOwner;
 import primevc.types.Asset;
  using primevc.utils.Bind;


/**
 * Bitmap fill
 * 
 * @author Ruben Weijers
 * @creation-date Jul 30, 2010
 */
class BitmapFill extends GraphicElement, implements IGraphicProperty 
{
	public var asset		(default, setAsset)		: Asset;
	public var matrix		(default, setMatrix)	: Matrix2D;
	public var smooth		(default, setSmooth)	: Bool;
	public var repeat		(default, setRepeat)	: Bool;
	public var isFinished	(default, null)			: Bool;
#if flash9
	public var data			(default, null)			: flash.display.BitmapData;
#end
	
	
	public function new (asset:Asset, matrix:Matrix2D = null, repeat:Bool = true, smooth:Bool = false)
	{
		super();
		this.asset	= asset;
		this.matrix	= matrix; //matrix == null ? new Matrix2D() : matrix;
		this.repeat = repeat;
		this.smooth	= smooth;
		isFinished	= false;
	}
	
	
	override public function dispose ()
	{
		if (asset != null) {
			asset.dispose();
		//	untyped asset = null;
		}
		if (matrix != null)
			untyped matrix = null;
		
#if flash9
		data = null;
#end
		super.dispose();
	}
	
	
	
	//
	// GETTERS / SETTERES
	//
	
	private inline function setAsset (v:Asset)
	{
		if (v != asset) {
			if (asset != null)
				asset.state.change.unbind(this);
			
			asset = v;
			
			if (asset != null)
			{
				handleAssetStateChange.on( asset.state.change, this );
				
				smooth	= asset.type != AssetType.bitmapData;

#if flash9		if (asset.state.is(AssetStates.ready))
					data = asset.getBitmapData();
				else
					asset.load();
#end
			}
		}
		return v;
	}


	private inline function setMatrix (v:Matrix2D)
	{
		if (v != matrix) {
			matrix = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}


	private inline function setSmooth (v:Bool)
	{
		if (v != smooth) {
			smooth = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}


	private inline function setRepeat (v:Bool)
	{
		if (v != repeat) {
			repeat = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}
	
	
#if flash9
	private inline function setData (v:flash.display.BitmapData)
	{
		if (v != data)
		{
			data = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}
#end
	
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private inline function handleAssetStateChange (newState:AssetStates, oldState:AssetStates)
	{
		switch (newState) {
			case AssetStates.ready:
#if flash9		data = asset.getBitmapData(); #end
			
			case AssetStates.empty:
#if flash9		data = null; #end
			default:
		}
	}
	
	
	
	//
	// IFILL METHODS
	//
	
	public inline function begin (target:IGraphicsOwner, bounds:IRectangle)
	{	
#if flash9
		isFinished = true;
		if (asset == null)
			return;
		
		var m:Matrix2D = null;
		
		if (repeat == false) {
			m = matrix == null ? new Matrix2D() : matrix;
			m.scale( bounds.width / data.width, bounds.height / data.height );
		}
		
		if (asset.state.is(AssetStates.ready))
			target.graphics.beginBitmapFill( data, m, repeat, smooth );
		
		else if (asset.state.is(AssetStates.loadable))
			asset.load();
#end
	}
	
	
	public inline function end (target:IGraphicsOwner, bounds:IRectangle)
	{	
		isFinished = false;
		if (asset != null && asset.state.is(AssetStates.ready))
		{
#if flash9
			target.graphics.endFill();
#end
		}
	}
	
	
#if neko
	override public function toString ()					{ return "BitmapFill( " + asset + ", " + smooth + ", " + repeat + " )"; }
	override public function toCSS (prefix:String = "")		{ return asset.toString + " " + repeat; }
	override public function toCode (code:ICodeGenerator)	{ code.construct( this, [ asset, matrix, repeat, smooth ] ); }
#end
}