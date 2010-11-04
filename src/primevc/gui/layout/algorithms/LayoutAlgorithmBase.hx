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
#if neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.utils.StringUtil;
#end
 import primevc.core.dispatcher.Signal0;
 import primevc.core.IDisposable;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.ILayoutContainer;
 import primevc.gui.layout.LayoutClient;
 import primevc.types.Number;
 import primevc.utils.IntMath;
  using primevc.utils.IntMath;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
 

/**
 * Base class for algorithms
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class LayoutAlgorithmBase 
				implements IDisposable
#if neko	,	implements ICodeFormattable		#end
{
	public var algorithmChanged 		(default, null)				: Signal0;
	public var group					(default, setGroup)			: ILayoutContainer<LayoutClient>;
	
#if neko
	public var uuid						(default, null)				: String;
#end

	private var validatePrepared		: Bool;
	
	
	public function new()
	{
#if neko
		uuid				= StringUtil.createUUID();
#end
		algorithmChanged	= new Signal0();
		validatePrepared	= false;
	}
	
	
	public function dispose ()
	{
		algorithmChanged.dispose();
		algorithmChanged	= null;
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setGroupHeight (h:Int)
	{
		if (h <= 0)
			h = Number.INT_NOT_SET;
		
		if (group.is(AdvancedLayoutClient))
			group.as(AdvancedLayoutClient).measuredHeight = h;
		else
			group.height = h;
	}
	
	
	private inline function setGroupWidth (w:Int)
	{
		if (w <= 0)
			w = Number.INT_NOT_SET;
		
		if (group.is(AdvancedLayoutClient))
			group.as(AdvancedLayoutClient).measuredWidth = w;
		else
			group.width = w;
	}
	
	
	private function setGroup (v)		{ return group = v; }
	public function prepareValidate ()	{ validatePrepared = true; }
	
	
	
	
	//
	// START VALUES
	//

	private inline function getTopStartValue ()		: Int
	{
		var top:Int = 0;
		if (group.margin != null)	top += group.margin.top;
		if (group.padding != null)	top += group.padding.top;
		return top;
	}
	
	
	private inline function getVerCenterStartValue ()	: Int
	{
		var start:Int = 0;
		
		if (group.is(AdvancedLayoutClient))
		{
			var group = group.as(AdvancedLayoutClient);
			if (group.explicitHeight.isSet() && group.measuredHeight.isSet())
				start = IntMath.max( group.explicitHeight - group.measuredHeight, 0 ).divCeil( 2 );
		}
		
		return start += getTopStartValue();
	}


	private inline function getBottomStartValue ()	: Int
	{
		var start = group.height;
		
		if (group.is(AdvancedLayoutClient))
			start = IntMath.max(group.as(AdvancedLayoutClient).measuredHeight, start);
		
		return start += getTopStartValue();
	}
	
	
	private inline function getLeftStartValue ()	: Int
	{
		var start:Int = 0;
		if (group.margin != null)	start += group.margin.left;
		if (group.padding != null)	start += group.padding.left;
		return start;
	}
	
	
	private inline function getHorCenterStartValue ()	: Int
	{
		var start:Int = 0;
		
		if (group.is(AdvancedLayoutClient))
		{
			var group = group.as(AdvancedLayoutClient);
			if (group.explicitWidth.isSet() && group.measuredWidth.isSet())
				start = IntMath.max( group.explicitWidth - group.measuredWidth, 0 ).divCeil( 2 );
		}
		
		return start += getLeftStartValue();
	}


	private inline function getRightStartValue ()	: Int
	{
		var start = group.width;
		
		if (group.is(AdvancedLayoutClient))
			start = IntMath.max(group.as(AdvancedLayoutClient).measuredWidth, start);
		
		return start += getLeftStartValue();
	}
	
	
	
	
#if (neko || debug)
	public function toString () : String				{ return toCSS(); }
	public function toCSS (prefix:String = "") : String	{ Assert.abstract(); return ""; }
	public function isEmpty () : Bool					{ return false; }
#end
	
#if neko
	public function cleanUp () : Void					{  }
	public function toCode (code:ICodeGenerator)		{ code.construct( this ); }
#end
}