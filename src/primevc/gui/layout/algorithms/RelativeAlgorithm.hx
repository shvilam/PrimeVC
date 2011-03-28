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
 import primevc.core.geom.Box;
 import primevc.core.geom.IRectangle;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.algorithms.LayoutAlgorithmBase;
 import primevc.gui.layout.IScrollableLayout;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.RelativeLayout;
 import primevc.types.Number;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = LayoutFlags;


/**
 * Relative Algorithm allows layout-children to apply relative properties.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 12, 2010
 */
class RelativeAlgorithm extends LayoutAlgorithmBase, implements ILayoutAlgorithm
{
	private var validatePreparedHor : Bool;
	private var validatePreparedVer : Bool;
	
	
	public inline function isInvalid (changes:Int)
	{
		return changes.has( Flags.WIDTH | Flags.HEIGHT | Flags.X | Flags.Y | Flags.RELATIVE | Flags.LIST );
	}
	
	
	/**
	 * Updating the size of the children should be done before the layout can 
	 * calculate anything else. Therefore this method will try to do that.
	 */
	override public function prepareValidate ()
	{
		if (!validatePrepared)
		{
		/*	if (group.name == "spreadEditorLayout") {
				trace("w: "+group.hasValidatedWidth+"; "+validatePreparedHor+"; "+group.width+"; "+group.state.current+" == "+(group.hasValidatedWidth && !validatePreparedHor && group.width.isSet()));
				trace("h: "+group.hasValidatedHeight+"; "+validatePreparedVer+"; "+group.height+"; "+group.state.current+" == "+(group.hasValidatedHeight && !validatePreparedVer && group.height.isSet()));
			}*/
			
			
			if (group.hasValidatedWidth && !validatePreparedHor && group.width.isSet())
			{
				var children = group.children;
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (child.relative == null || !child.includeInLayout)
						continue;
					
					if (child.relative.left.isSet() && child.relative.right.isSet())
						child.outerBounds.width	= group.width - child.relative.right - child.relative.left;
				}

				validatePreparedHor = true;
			}
			
			
			
			if (group.hasValidatedHeight && !validatePreparedVer && group.height.isSet())
			{
				var children = group.children;
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (child.relative == null || !child.includeInLayout)
						continue;
					
					var old = child.outerBounds.height;
					if (child.relative.top.isSet() && child.relative.bottom.isSet())
						child.outerBounds.height = group.height - child.relative.bottom - child.relative.top;
					
				//	if (group.name == "spreadEditorLayout")
				//		trace("\t\t\tendupdate"+child+"; "+group.height+"; "+old+" => "+child.outerBounds.height+"; "+child.outerBounds.invalidatable);
				}

				validatePreparedVer = true;
			}

			if (validatePreparedVer && validatePreparedHor)
				validatePrepared = true;
		}
	}
	
	
	public inline function validate ()				{ if (!validatePrepared) 	prepareValidate(); }
	public inline function validateHorizontal ()	{  }
	public inline function validateVertical ()		{  }
	
	
	public inline function apply ()
	{
		if (!validatePrepared)
			validate();
		
		var padding		= group.padding;
		var groupBounds	= group.innerBounds;
		
		//properties to find the corners of the outer children
		//this is actually measuring, but can't be done before the position of the children is defined
		var mostLeftVal:Int		= Number.INT_NOT_SET;
		var mostRightVal:Int	= Number.INT_NOT_SET;
		var mostTopVal:Int		= Number.INT_NOT_SET;
		var mostBottomVal:Int	= Number.INT_NOT_SET;
		
	/*	if (group.name == "spreadEditorLayout") {
			trace("w: "+group.hasValidatedWidth+"; "+validatePreparedHor+"; "+group.width+"; "+group.state.current);
			trace("h: "+group.hasValidatedHeight+"; "+validatePreparedVer+"; "+group.height+"; "+group.state.current);
		}*/
		
		var children = group.children;
		for (i in 0...children.length)
		{
			var child = children.getItemAt(i);
			if (!child.includeInLayout)
				continue;
			
			var childProps	= child.relative;
			var childBounds	= child.outerBounds;
			if (childProps != null)
			{
				//
				//apply horizontal
				//
				
				if		(childProps.left.isSet())		childBounds.left		= padding.left + childProps.left;
				else if (childProps.right.isSet())		childBounds.right		= groupBounds.width - padding.right - childProps.right;
				else if (childProps.hCenter.isSet())	childBounds.left		= ( ( groupBounds.width - childBounds.width ) >> 1 ) + childProps.hCenter; // ( ( groupBounds.width - childBounds.width ) * .5 ).roundFloat() + childProps.hCenter;
			
			
				//
				//apply vertical
				//
			
				if		(childProps.top.isSet())		childBounds.top		= padding.top + childProps.top;
				else if (childProps.bottom.isSet())		childBounds.bottom	= groupBounds.height - padding.bottom - childProps.bottom;
				else if (childProps.vCenter.isSet())	childBounds.top		= ( ( groupBounds.height - childBounds.height ) >> 1 ) + childProps.vCenter; // ( ( groupBounds.height - childBounds.height ) * .5 ).roundFloat() + childProps.vCenter;
				
			}
			
			if (mostLeftVal.notSet() || childBounds.left < mostLeftVal)		mostLeftVal		= childBounds.left;
			if (mostTopVal.notSet() || childBounds.top < mostTopVal)		mostTopVal		= childBounds.top;
			if (childBounds.right > mostRightVal)							mostRightVal	= childBounds.right;
			if (childBounds.bottom > mostBottomVal)							mostBottomVal	= childBounds.bottom;
		}
		
		if (mostRightVal.isSet() && mostLeftVal.isSet())	setGroupWidth( mostRightVal - mostLeftVal );
		if (mostBottomVal.isSet() && mostTopVal.isSet())	setGroupHeight( mostBottomVal - mostTopVal );
		
		if (group.is(IScrollableLayout))
		{
			var s = group.as(IScrollableLayout);
			if (mostLeftVal.isSet())	s.minScrollXPos = mostLeftVal;
			if (mostTopVal.isSet())		s.minScrollYPos = mostTopVal;
		}
		
		validatePrepared	= false;
		validatePreparedHor	= false;
		validatePreparedVer	= false;
	}
	
	
	/**
	 * When the relative algorithm is used, the position of an object doesn't
	 * have any influence on the depth. That's why the algorithm will always 
	 * return the position at the end of the child-list.
	 */
	public inline function getDepthForBounds (bounds:IRectangle) : Int
	{
		return group.children.length;
	}


#if (neko || debug)
	override public function toString () : String
	{
		return toCSS(); //group + ".RelativeAlgorithm()"; // ( " + group.bounds.width + " -> " + group.bounds.height + " ) ";
	}
	
	override public function toCSS (prefix:String = "") : String
	{
		return "relative";
	}
#end
}