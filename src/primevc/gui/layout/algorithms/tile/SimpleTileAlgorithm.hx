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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package primevc.gui.layout.algorithms.tile;
 import primevc.core.geom.space.Direction;
 import primevc.core.geom.IRectangle;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.algorithms.LayoutAlgorithmBase;
 import primevc.gui.layout.IAdvancedLayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.types.Number;
 import primevc.utils.NumberUtil;
  using primevc.utils.BitUtil;
  using primevc.utils.IfUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;



/**
 * Class descriptions
 * 
 * @author Ruben Weijers
 * @creation-date Jun 25, 2011
 */
class SimpleTileAlgorithm extends LayoutAlgorithmBase, implements ILayoutAlgorithm
{
	public var direction	(default, setDirection)		: Direction;
	private var columns		: Int;
	private var rows		: Int;
	
	
	public function new (direction:Direction = null)
	{
		super();
		(untyped this).direction	= direction == null ? horizontal : direction;
		rows = columns = Number.INT_NOT_SET;
	}
	
	
	private inline function setDirection (v:Direction)
	{
		if (v != direction) {
			direction = v;
			algorithmChanged.send();
		}
		return v;
	}
	
	
	/**
	 * Method indicating if the changes of a layoutcontainer-child should make
	 * the layoutcontainer revalidate
	 */
	public inline function isInvalid (changes:Int)
	{
		return	changes.has( LayoutFlags.WIDTH * group.childWidth.notSet().boolCalc() )
			&&	changes.has( LayoutFlags.HEIGHT * group.childHeight.notSet().boolCalc() );
	}
	
	
	private inline function getMaxWidth () : Int
	{
		var g = this.group;
		var groupW = g.hasMaxWidth() ? g.widthValidator.max : g.width;
		if (g.is(IAdvancedLayoutClient) && g.as(IAdvancedLayoutClient).explicitWidth.isSet())
			groupW = g.as(IAdvancedLayoutClient).explicitWidth;
		
		return groupW;
	}
	
	
	private inline function getMaxHeight () : Int
	{
		var g = this.group;
		var groupH = g.hasMaxHeight() ? g.heightValidator.max : g.height;
		if (g.is(IAdvancedLayoutClient) && g.as(IAdvancedLayoutClient).explicitHeight.isSet())
			groupH = g.as(IAdvancedLayoutClient).explicitHeight;
		
		return groupH;
	}
	
	
	
	/**
	 * Method to prepare the algorithm to validate. This method can be used to
	 * set properties that are needed for both the validateHorizontal method 
	 * and the validateVertical method.
	 */
	override public function prepareValidate ()
	{
		if (!validatePrepared)
		{
			var group		= this.group;
			var children	= group.children;
			var explLength	= group.childrenLength;
			var realLength	= children.length;
			var childW		= group.childWidth;
			var childH		= group.childHeight;
			var measW		= 0;	//measured group width
			var measH		= 0;	//measured group height
			
			switch (direction)
			{
				case horizontal:
					//get current group width
					var groupW = getMaxWidth();
					if (groupW.notSet())
						return;
					
					//
					//calculate group width
					//
					if (childW.isSet())
					{
						columns	= groupW < childW ? 1 : (groupW / childW).floorFloat().getSmallest(explLength);
						rows	= (explLength / columns).ceilFloat();
						measW	= columns * childW;
					}
					else
					{
						columns = Number.INT_NOT_SET;
						rows	= 0;
						
						//calculate total width by finding the widest row
						var rowW = 0; //current row width
						for (i in 0...realLength)
						{
							var child = children.getItemAt(i);
							if (!child.includeInLayout)
								continue;
							
							if ((rowW + child.width) > groupW) {
								if (rowW > measW)
									measW = rowW;
								//start new row
								rowW = 0;
								rows++;
							}
							rowW += child.width;
						}
					}
					
					//
					//calculate group height
					//
					if (childH.isSet() && columns.isSet())
						measH = rows * childH;
					else
					{
						//calculate total height by finding the heighest child in each row
						var rowH = 0;
						var rowW = 0;
						
						for (i in 0...realLength)
						{
							var child = children.getItemAt(i);
							if (!child.includeInLayout)
								continue;
							
							if ((rowW + child.width) > groupW) {
								//start new row
								measH  += rowH;
								rowH	= rowW = 0;
							}
							
							rowW += child.width;
							if (child.height > rowH)
								rowH = child.height;
						}
					}
				
				
				
				case vertical:
					//get group height
					var groupH = getMaxHeight();
					if (groupH.notSet())
						return;
					
					//
					//calculate group height
					//
					if (childH.isSet())
					{
						rows	= groupH < childH ? 1 : (groupH / childH).floorFloat().getSmallest(explLength);
						columns	= (explLength / rows).ceilFloat();
						measH	= rows * childH;
					}
					else
					{
						rows	= Number.INT_NOT_SET;
						columns	= 0;
						
						//calculate total height by finding the heighest column
						var colH = 0; //current column height
						for (i in 0...realLength)
						{
							var child = children.getItemAt(i);
							if (!child.includeInLayout)
								continue;
							
							var childH = child.height;
							if ((colH + childH) > groupH) {
								if (colH > measH)
									measH = colH;
								//start new column
								colH = 0;
								columns++;
							}
						}
					}
					
					//
					//calculate group width
					//
					if (childW.isSet())
						measH = columns * childW;
					else
					{
						//calculate total width by finding the widest child in each column
						var colH = 0;
						var colW = 0;
						
						for (i in 0...realLength)
						{
							var child = children.getItemAt(i);
							if (!child.includeInLayout)
								continue;
							
							if ((colH + child.height) > groupH) {
								//start new row
								measW	+= colW;
								colH = colW = 0;
							}
							
							colH += child.height;
							if (child.width > colW)
								colW = child.width;
						}
					}
			}
			
		//	trace("realLength: "+realLength+"; explicitLength: "+explLength+"; cols: "+columns+"; rows: "+rows+"; childW: "+childW+"; childH: "+childH+"; groupW: "+getMaxWidth()+"; measW: "+measW+"; measH: "+measH);
			
			setGroupWidth( measW );
			setGroupHeight( measH );
			validatePrepared = true;
		}
	}
	
	
	public inline function validate () {}
	public function validateHorizontal () {}
	public function validateVertical () {}
	
	
	/**
	 * Method will apply it's layout algorithm on the given target.
	 */
	public function apply ()
	{
		var group	 = this.group;
		var children = group.children;
		var length	 = children.length;
		
		var startX	= getLeftStartValue();
		var nextX	= startX;
		var startY	= getTopStartValue();
		var nextY	= startY;
		var childW	= group.childWidth;
		var childH	= group.childHeight;
		var start	= group.fixedChildStart;
		
		switch (direction)
		{
			case horizontal:
				var groupW = getMaxWidth();
				
				if (start > 0) {
					if (childW.isSet())		nextX += start >= columns ? (start % columns) * childW : start * childW;
					if (childH.isSet())		nextY += (start / columns).floorFloat() * childH;
				}
				
		//		trace("nextX: " + nextX+"; nextY: "+nextY+"; columns: "+columns+"; rows: "+rows+"; start: "+start+"; childW: "+childW+"; childH: "+childH);
				
				//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
				if (childH.isSet() && childW.isSet())
				{
					for (i in 0...length)
					{
						var child = children.getItemAt(i);
						if (!child.includeInLayout)
							continue;
						
						if ((nextX + childW) > groupW) {
							nextY += childH;
							nextX  = startX;
						}
						
						child.outerBounds.left	= nextX;
						child.outerBounds.top	= nextY;
						nextX += childW;
					}
				}
				else
				{
					var rowH = 0;
					for (i in 0...length)
					{
						var child	= children.getItemAt(i);
						var rect	= child.outerBounds;
						if (!child.includeInLayout)
							continue;
						
						var w = childW.isSet() ? childW : rect.width;
						var h = childH.isSet() ? childH : rect.height;
						if ((nextX + w) > groupW) {
							nextY  += rowH;
							nextX	= startX;
							rowH	= 0;
						}
						
						if (h > rowH)
							rowH = h;
						
						rect.left	= nextX;
						rect.top	= nextY;
						nextX += w;
					}
				}
				
			
			case vertical:
				var groupH = getMaxHeight();
				
				if (start > 0) {
					if (childH.isSet())		nextY += start > rows ? (start % rows) * childH : start * childH;
					if (childW.isSet())		nextX += (start / rows).floorFloat() * childW;
				}
				
				//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
				if (childH.isSet() && childW.isSet())
				{
					for (i in 0...length)
					{
						var child = children.getItemAt(i);
						if (!child.includeInLayout)
							continue;
						
						if ((nextY + childH) > groupH) {
							nextX += childW;
							nextY  = startX;
						}
						
						child.outerBounds.left	= nextX;
						child.outerBounds.top	= nextY;
						nextY += childH;
					}
				}
				else
				{
					var colW = 0;
					for (i in 0...length)
					{
						var child	= children.getItemAt(i);
						var rect	= child.outerBounds;
						if (!child.includeInLayout)
							continue;
						
						var w = childW.isSet() ? childW : rect.width;
						var h = childH.isSet() ? childH : rect.height;
						if ((nextY + h) > groupH) {
							nextX  += colW;
							nextY	= startY;
							colW	= 0;
						}
						
						if (w > colW)
							colW = w;
						
						rect.left	= nextX;
						rect.top	= nextY;
						nextY += h;
					}
				}
		}
		validatePrepared = false;
	}
	
	
	/**
	 * Method will return the depth that belongs to the given coordinates.
	 * The depth of an object depends on the type of algorithm that is used.
	 * 
	 * Before calling this method, the method 'removeStartPosFromPoint' should
	 * be called to make sure the point is valid within the algorithms.
	 */
	public function getDepthForBounds (bounds:IRectangle)
	{
		return 0; //FIXME
	}
	
	
	/**
	 * Method will return the depth of the first visible child, based on:
	 * 	- childWidth / childHeight
	 * 	- explicitWidth / explicitHeight
	 * 	- scrollPos.x / scrollPos.y
	 */
	override public function getDepthOfFirstVisibleChild ()	: Int
	{
		if (columns.notSet() && rows.notSet())
			return 0;
		
		switch (direction)
		{
			case horizontal:
				if (group.childHeight.notSet())
					return 0;

				Assert.that(group.is(IScrollableLayout), group+" should be scrollable");
				var group	= group.as(IScrollableLayout);
				var childH	= group.childHeight;
				return ((group.scrollPos.y / childH).floorFloat() * columns).within(0, group.childrenLength);
			
			
			case vertical:
				if (group.childWidth.notSet())
					return 0;

				Assert.that(group.is(IScrollableLayout), group+" should be scrollable");
				var group	= group.as(IScrollableLayout);
				var childW	= group.childWidth;
				return ((group.scrollPos.x / childW).floorFloat() * rows).within(0, group.childrenLength);
		}
	}
	
	
	/**
	 * Method will return the maximum visible children based on:
	 * 	- childWidth / childHeight
	 * 	- explicitWidth / explicitHeight
	 */
	override public function getMaxVisibleChildren ()
	{
		var g = this.group;
		if (columns.notSet() && rows.notSet())
			return 0;
		
//		trace(direction+"; childSize: "+g.childHeight+", "+g.childWidth+"; size: "+g.width+", "+g.height+"; columns: "+columns+"; rows: "+rows+"; l: "+g.childrenLength);
		switch (direction) {
			case horizontal:
			    if (g.childHeight.isSet())  return g.height.isSet() ? IntMath.min( ((g.height / g.childHeight).ceilFloat() + 1) * columns, g.childrenLength) : 0;
			    else                        return g.childrenLength;
			case vertical:
			    if (g.childWidth .isSet())  return g.width .isSet() ? IntMath.min( ((g.width  / g.childWidth) .ceilFloat() +1) * rows, g.childrenLength) : 0;
			    else                        return g.childrenLength;
		}
		
	}
	
	
	override public function scrollToDepth (depth:Int)
	{
	    if (!group.is(IScrollableLayout))
	        return;
	    
	    var group       = this.group.as(IScrollableLayout);
	    var childH      = group.childHeight;
	    var childW      = group.childWidth;
	    var children    = group.children;
	    
	    switch (direction)
	    {
	        case horizontal:
                //
                // scroll vertically
                //
    	        var scrollY = Number.INT_NOT_SET;
    	        
    	        
	            if (childW.isSet() && childH.isSet())
	            {
	                Assert.that(columns.isSet());
	                var row = (depth / columns).floorFloat();
	                scrollY = row * childH;
	            }
	            else
	            {
	                Assert.that( depth < children.length );
	                scrollY = children.getItemAt(depth).outerBounds.top;
	            }
	            
	            if (scrollY.isSet())
        		    group.scrollPos.y = scrollY;
	            
	        
	        
	        case vertical:
	            //
	            // scroll horizontally
	            //
	            var scrollX = Number.INT_NOT_SET;
	            
	            
	            if (childW.isSet() && childH.isSet())
	            {
	                Assert.that(rows.isSet());
	                var col = (depth / rows).floorFloat();
	                scrollX = col * childW;
	            }
	            else
	            {
	                Assert.that( depth < children.length );
	                scrollX = children.getItemAt(depth).outerBounds.left;
	            }
	            
	            if (scrollX.isSet())
        		    group.scrollPos.x = scrollX;
		}
		
		
	}
}