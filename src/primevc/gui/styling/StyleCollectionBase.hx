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
package primevc.gui.styling;
 import primevc.core.collections.iterators.IIterator;
 import primevc.core.collections.PriorityList;
 import primevc.core.collections.FastDoubleCell;
// import primevc.core.dispatcher.Signal1;
 import primevc.core.traits.IInvalidatable;
 import primevc.core.traits.IInvalidateListener;
 import primevc.core.traits.IDisposable;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;
#if debug
  using Type;
#end


typedef CellType = FastDoubleCell < StyleBlock >;

/**
 * Base class for style-proxy's
 * 
 * @author Ruben Weijers
 * @creation-date Oct 22, 2010
 */
class StyleCollectionBase < StyleGroupType:StyleSubBlock >
				implements IInvalidateListener
#if flash9	,	implements haxe.rtti.Generic #end
{
	/**
	 * Flag with all the style-declaration-properties that are defined for 
	 * the stylesheet.target.
	 */
	public var filledProperties		(default, null)	: UInt;
	
	/**
	 * Bit-flag from StyleFlags indicating which property is searched in this 
	 * proxy.
	 */
	public var propertyTypeFlag		(default, null)	: UInt;
//	public var change				(default, null)	: Signal1 < UInt >;
	
	private var elementStyle		: IUIElementStyle;
	
	/**
	 * Cached iterator that is only used to update the filled properties flag.
	 * Since this operation happens quite frequent, the iterator is cached.
	 */
	private var groupIterator		: StyleCollectionForwardIterator < StyleGroupType >;
	private var changes				: UInt;
	
	
	public function new (elementStyle:IUIElementStyle, propertyTypeFlag:UInt)
	{
	//	change					= new Signal1();
		changes					= 0;
		this.elementStyle		= elementStyle;
		this.propertyTypeFlag	= propertyTypeFlag;
		filledProperties		= 0;
		groupIterator			= forwardIterator();
	}
	
	
	public function dispose ()
	{
	//	change.dispose();
		groupIterator.dispose();
		
		groupIterator	= null;
		elementStyle	= null;
	//	change			= null;
	}
	
	
	public inline function has (properties:UInt) : Bool
	{
		return filledProperties.has(properties);
	}
	
	
	public function updateFilledPropertiesFlag (?excludedStyle:StyleGroupType) : Void
	{	
		Assert.notNull( groupIterator );
		filledProperties = 0;
		groupIterator.rewind();
		
		//loop through every stylegroup that has the defined StyleGroupType
		if (elementStyle.styles.length > 0)
			for ( styleGroup in groupIterator )
				if (styleGroup != excludedStyle)
					filledProperties = filledProperties.set( styleGroup.allFilledProperties );
	}
	
	
	public function invalidateCall ( changeFromSender:UInt, sender:IInvalidatable ) : Void
	{
		changes = changes.set( getRealChangesOf( cast sender, changeFromSender ) );
	//	trace("\tchanged properties " + readProperties(changes));
		apply();
	}
	
	
	public function add ( style:StyleGroupType )
	{
		style.listeners.add( this );
		changes				= changes.set( getRealChangesOf( style, style.allFilledProperties ) );
		filledProperties	= filledProperties.set( changes );
	//	trace("\t"+this+".styleAdded; " + readProperties(filledProperties));
	}
	
	
	public function remove ( style:StyleGroupType, isStyleStillInList:Bool = true )
	{
		style.listeners.remove( this );
		updateFilledPropertiesFlag( style );	//exclude the to be removed style
		
		if (isStyleStillInList)
			changes = changes.set( getRealChangesOf( style, style.allFilledProperties ) );
		else
			changes = changes.set( style.allFilledProperties );
	//	trace("\t"+this+".styleRemoved; " + readProperties(filledProperties)+"; changes: "+readProperties(changes));
	}
	
	
	public function apply ()
	{
		Assert.abstract();
	}
	
	
	/**
	 * Method returns the flags that are changed when the given style-group 
	 * was changed.
	 * 
	 * @example
	 * 		#aId.layout.width = 50;
	 * 		aComponent.layout.width = 40;
	 * 		aComponent.layout.height = 40;
	 * 
	 * Then the width of aComponent.layout changes:
	 * 		aComponent.layout.width = 60;
	 * 
	 * The width of #aId.layout has a higher priority so the real-changes for
	 * the IUIElement are none.
	 * 
	 * When the height of aComponent.layout would change, there is no style
	 * defined with a higher priority height, so the real-changes for the 
	 * IUIelement are 'height'.
	 */
	private function getRealChangesOf ( styleGroup:StyleGroupType, styleChanges:Int ) : UInt
	{
		if (elementStyle.styles.length > 0)
		{
			var styleCell:CellType = null;
			var iterator = reversedIterator();
			while( iterator.hasNext() )
			{
				var curCell = iterator.currentCell;
				if (iterator.next() == styleGroup) {
					styleCell = curCell;
					break;
				}	
			}
		
			Assert.notNull( styleCell );
			iterator.setCurrent( cast styleCell.prev );
		
			for (styleGroup in iterator)
			{
				styleChanges = styleChanges.unset( styleGroup.allFilledProperties );
				if (styleChanges == 0)
					break;
			}
		}
		
		return styleChanges;
	}
	
	
	
	public function iterator ()						: Iterator < StyleGroupType >							{ return forwardIterator(); }
	public function reversed ()						: Iterator < StyleGroupType >							{ return reversedIterator(); }
	public function forwardIterator ()				: StyleCollectionForwardIterator < StyleGroupType >		{ Assert.abstract(); return null; }
	public function reversedIterator ()				: StyleCollectionReversedIterator < StyleGroupType >	{ Assert.abstract(); return null; }
	
#if debug
	public function readProperties (props:Int = -1)	: String	{ Assert.abstract(); return null; }
	public function toString () : String						{ return this.getClass().getClassName(); }
#end
}



/**
 * Base class for style-group iterators. A style-group-iterator iterates over
 * the style-objects of a style sheet and returns the next style-group if it
 * is found in the style-object. Style-object's who don't have the searched
 * style-group, are skipped.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 22, 2010
 */
class StyleCollectionIteratorBase implements IDisposable
{
	private var elementStyle	: IUIElementStyle;
	public var currentCell		: CellType;
	/**
	 * Flag to search for in target styles to see if the style contains the group
	 */
	private var flag		: UInt;
	
	
	public function new (elementStyle:IUIElementStyle, groupFlag:UInt)
	{
		this.elementStyle	= elementStyle;
		flag				= groupFlag;
		rewind();
	}
	
	
	public function dispose ()
	{
		elementStyle	= null;
		flag			= 0;
		currentCell		= null;
	}
	
	
	public function rewind () : Void		{ Assert.abstract(); }
	
	/**
	 * Method will set the current property to the next cell and will return 
	 * the previous current value.
	 */
	private function setNext() : CellType	{ Assert.abstract(); return null; }
	public  function hasNext () : Bool		{ return currentCell != null; }
	
	
	public function setCurrent ( cur:Dynamic )
	{
		if (cur == null) {
			currentCell = null;
			return;
		}
		
		Assert.isType( cur, CellType );
		var styleCell = cast ( cur, CellType );
		
		currentCell = styleCell;
		if (!styleCell.data.has( flag ) && hasNext())	
			setNext();
	}
}



/**
 * Iterates forward over a styles prioritylist
 * @author Ruben Weijers
 * @creation-date Oct 22, 2010
 */
class StyleCollectionForwardIterator < StyleGroupType > extends StyleCollectionIteratorBase
			,	implements IIterator < StyleGroupType >
#if flash9	,	implements haxe.rtti.Generic #end
{
	override public function rewind () : Void	{ setCurrent( elementStyle.styles.first ); }
	public function next () : StyleGroupType	{ Assert.abstract(); return null; }
	override private function setNext ()
	{
		var c = currentCell;
		setCurrent( currentCell.next );
		return c;
	}
	
	
#if (unitTesting && debug)
	public function new (elementStyle:IUIElementStyle, groupFlag:UInt)
	{
		super( elementStyle, groupFlag );
		test();
	}
	
	
	public function test ()
	{
		var cur = elementStyle.styles.first, prev:CellType = null;
		while (cur != null)
		{
			if (prev == null)	Assert.null( cur.prev, "first incorrect" );
			else				Assert.equal( cur.prev, prev, "previous incorrect" );
			
			prev	= cur;
			cur		= cur.next;
		}
	}
#end
}


/**
 * Iterates backwards over styles prioritylist
 * @author Ruben Weijers
 * @creation-date Oct 22, 2010
 */
class StyleCollectionReversedIterator < StyleGroupType > extends StyleCollectionIteratorBase
			,	implements IIterator < StyleGroupType >
#if flash9	,	implements haxe.rtti.Generic #end
{
	override public function rewind () : Void	{ setCurrent( elementStyle.styles.last ); }
	public function next () : StyleGroupType	{ Assert.abstract(); return null; }
	override private function setNext ()
	{
		var c = currentCell;
		setCurrent( currentCell.prev );
		return c;
	}


#if (unitTesting && debug)
	public function new (elementStyle:IUIElementStyle, groupFlag:UInt)
	{
		super( elementStyle, groupFlag );
		test();
	}
	
	
	public function test ()
	{
		var cur = elementStyle.styles.last, prev:CellType = null;
		while (cur != null)
		{
			if (prev == null)	Assert.null( cur.next, "last incorrect" );
			else				Assert.equal( cur.next, prev, "next incorrect" );

			prev	= cur;
			cur		= cur.prev;
		}
	}
#end
}