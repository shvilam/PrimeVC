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
 import primevc.core.dispatcher.Signal1;
 import primevc.core.geom.Box;
 import primevc.core.geom.IntRectangle;
 import primevc.core.geom.RectangleFlags;
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.traits.IInvalidatable;
 import primevc.core.traits.Invalidatable;
 import primevc.core.validators.IntRangeValidator;
// import primevc.core.validators.ValidatingValue;
#if debug
 import primevc.core.traits.IUIdentifiable;
 import primevc.utils.ID;
#end
 import primevc.types.Number;
 import primevc.gui.layout.ILayoutClient;
 import primevc.gui.states.ValidateStates;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.IfUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = LayoutFlags;


/**
 * Base class for layout clients without implementing x, y, width and height.
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class LayoutClient extends Invalidatable
			,	implements ILayoutClient
#if debug	,	implements IUIdentifiable #end
{
	/**
	 * Flag indicating if the object should broadcast an invalidate call or do
	 * nothing with it.
	 */
	public var invalidatable		(default, setInvalidatable)			: Bool;
	
	/**
	 * Bitflag with all the changes that are done to the layout until it get's
	 * validated.
	 */
	public var changes 				(default, null)						: Int;
//	public var filledProperties		(default, null)						: Int;
	public var includeInLayout		(default, setIncludeInLayout)		: Bool;
	
	public var parent				(default, setParent)				: ILayoutContainer;
	public var changed				(default, null)						: Signal1<Int>;
	
	
	/**
	 * Size of the layouclient including the padding but without the margin
	 */
	public var innerBounds			(default, null)						: IntRectangle;
	/**
	 * Size of the layouclient including the padding and margin
	 */
	public var outerBounds			(default, null)						: IntRectangle;
	
	
	/**
	 * rules for sizing / positioning the layout with relation to the parent
	 */
	public var relative				(default, setRelative)				: RelativeLayout;
	
	/**
	 * @default	false
	 */
	public var maintainAspectRatio	(default, setMaintainAspectRatio)	: Bool;
	public var aspectRatio			(default, null)						: Float;
	
	
	public var state				(default, null)						: SimpleStateMachine < ValidateStates >;
	
	
	/**
	 * Flag indicating wether validateHorizontal method is called after the width has been changed
	 * This flag has nothing to do with the method validateWidth 	//FIXME!
	 */
	public var hasValidatedWidth	(default, null)						: Bool;
	
	/**
	 * Flag indicating wether validateVertical method is called after the height has been changed
	 * This flag has nothing to do with the method validateHeight 	//FIXME!
	 */
	public var hasValidatedHeight	(default, null)						: Bool;
	
	
	//
	// POSITION PROPERTIES
	//
	
	public var x					(default, setX)						: Int;
	public var y					(default, setY)						: Int;
	
	public var width				(getWidth, setWidth)				: Int;
	public var height				(getHeight, setHeight)				: Int;
		private var _width			: Int;
		private var _height			: Int;
	
	public var widthValidator		(default, setWidthValidator)		: IntRangeValidator;
	public var heightValidator		(default, setHeightValidator)		: IntRangeValidator;
	
	public var percentWidth			(default, setPercentWidth)			: Float;
	public var percentHeight		(default, setPercentHeight)			: Float;
	
	public var padding				(default, setPadding)				: Box;
	public var margin				(default, setMargin)				: Box;
	
#if debug
	public var _oid					(default, null)						: Int;
#end
	
	
	
	//
	// METHODS
	//
	
	public function new (newWidth:Int = Number.INT_NOT_SET, newHeight:Int = Number.INT_NOT_SET)
	{
		super();
#if debug
		name = "LayoutClient" + counter++;
		_oid = ID.getNext();
#end
		maintainAspectRatio = false;
		invalidatable		= true;
		
		changed		= new Signal1<Int>();
		innerBounds	= new IntRectangle( x, y, newWidth.getBiggest( 0 ) + getHorPadding(), newHeight.getBiggest( 0 ) + getVerPadding() );
		outerBounds	= new IntRectangle( x, y, innerBounds.width + getHorMargin(), innerBounds.height + getVerMargin() );
		
		_width		= newWidth;
		_height		= newHeight;
		(untyped this).percentWidth		= Number.FLOAT_NOT_SET;
		(untyped this).percentHeight	= Number.FLOAT_NOT_SET;
		(untyped this).includeInLayout	= true;
		
		innerBounds	.listeners.add( this );
		outerBounds	.listeners.add( this );
		
		//remove and set correct flags
		changes = changes.set( Flags.X | Flags.Y | Flags.WIDTH * newWidth.isSet().boolCalc() | Flags.HEIGHT * newHeight.isSet().boolCalc() );
		
		state				= new SimpleStateMachine<ValidateStates>( changes == 0 ? ValidateStates.validated : ValidateStates.invalidated );
		hasValidatedHeight	= false;
		hasValidatedWidth	= false;
		
	//	Assert.that( state.current == ValidateStates.validated && changes == 0, name+"; "+readChanges() );
	}
	
	
	override public function dispose ()
	{
		//remove the layoutclient from the parents layout.
		if (parent != null && parent.children != null && parent.children.has(this))
			parent.children.remove(this);
		
		innerBounds	.dispose();
		outerBounds	.dispose();
		state		.dispose();
		changed		.dispose();
		
		//don't trigger the setters for the properties below
		(untyped this).relative			= null;		//do not dispose relative, can be used by other clients as well
		(untyped this).widthValidator	= null;		//do not dispose widthValidator, can be used by other clients as well
		(untyped this).heightValidator	= null;		//do not dispose heightValidator, can be used by other clients as well
		(untyped this).padding			= (untyped this).margin	= null;
		
		percentWidth	= percentHeight	= Number.FLOAT_NOT_SET;
		innerBounds		= outerBounds	= null;
		state			= null;
	//	events			= null;
		parent			= null;
		changed			= null;
		
		super.dispose();
	}
	
	
	private function resetProperties () : Void
	{
		parent	= null;
		margin	= null;
		padding = null;
		x = y = width = height = 0;
		validate();
		changes	= 0;
	}
	
	
	public inline function resetValidation ()
	{
		state.current	= ValidateStates.validated;
		changes			= 0;
		invalidatable	= hasValidatedWidth	= hasValidatedHeight = true;
	}
	
	
	
	//
	// LAYOUT METHODS
	//
	
	/**
	 * Method will set or unset the given propertyflag in the filledProperties
	 * property. Method will also call invalidate after that.
	 * 
	 * FIXME: future thingy
	 */
/*	private function markProperty ( propFlag:Int, isSet:Bool ) : Void
	{
		if (isSet)	filledProperties = filledProperties.set( propFlag );
		else		filledProperties = filledProperties.unset( propFlag );
		invalidate( propFlag );
	}*/
	
	
	
	override public function invalidate (change:Int)
	{
		var oldChanges = changes;
		changes = changes.set(change);
		if (changes == oldChanges)
			return;
		
		invalidateLayout();
	}
	
	
	private function invalidateLayout ()
	{
		if (!invalidatable || changes == 0 || state == null || state.current == null)
			return;
		
		if (includeInLayout && parent != null)
			super.invalidate(changes);
		
		if (state.is(ValidateStates.validated))
			state.current = (includeInLayout && parent != null && parent.isInvalidated()) ? ValidateStates.parent_invalidated : ValidateStates.invalidated;
	}
	
	
	
	public function validate ()
	{
		if (changes == 0)
			return;
		
		state.current = ValidateStates.validating;
		validateHorizontal();
		validateVertical();
		
		if (!includeInLayout || parent == null || !parent.isValidating())
			validated();
	}
	
	
	
	public function validateHorizontal ()
	{
		if (changes > 0)
		{
		//	if (changes.has( Flags.PADDING | Flags.MARGIN ))
		//		updateAllWidths(width, true);
			
#if debug	Assert.notEqual( state.current, ValidateStates.validated, name+"; "+readChanges() ); #end
			state.current = ValidateStates.validating;
			hasValidatedWidth = true;
		}
	}
	
	
	
	public function validateVertical ()
	{
		if (changes > 0)
		{
		//	if (changes.has( Flags.PADDING | Flags.MARGIN ))
		//		updateAllHeights(height, true);
			
#if debug	Assert.notEqual( state.current, ValidateStates.validated, name+"; "+readChanges() ); #end
			state.current = ValidateStates.validating;
			hasValidatedHeight = true;
		}
	}
	
	
	
	public function validated ()
	{
		if (isInvalidated())
			validate();
#if debug
		Assert.that(!state.is(ValidateStates.invalidated), this+" ; "+parent+"; "+readChanges());
#end
		//make sure the changes property is resetted first. If something responds to a state-change or changed event, the property needs to be empty
		var lastChanges = changes;
		changes			= 0;
		
		state.current = ValidateStates.validated;
		if (lastChanges.has( Flags.WIDTH_PROPERTIES | Flags.HEIGHT_PROPERTIES | Flags.X | Flags.Y ))
			changed.send( lastChanges );
	}
	
	
	public inline function isValidated ()	{ return state.is(ValidateStates.validated); }
	public inline function isValidating ()	{ return state == null ? false : state.is(ValidateStates.validating) || (parent != null && parent.isValidating()); }
	public inline function isInvalidated ()	{ return state == null ? false : state.is(ValidateStates.invalidated) || state.is(ValidateStates.parent_invalidated); }
	
	
	
	//
	// SIZE METHODS
	//
	
	private inline function getWidth ()		{ return _width; }
	private inline function getHeight ()	{ return _height; }
	
	
	/**
	 * Setter for width value.
	 * It will do the following steps:
	 * 		1. validate width (aspectratio / min-max-value)
	 *		2. set width
	 *		3. update inner/outerbounds
	 *		4. invalidate object
	 *		5. apply aspectratio to height
	 */
	private  function setWidth (v:Int)
	{
		if (_width != v)
		{
			//step 1 - 4
			updateAllWidths( validateWidth( v, Flags.VALIDATE_ALL ) );
			
			if (maintainAspectRatio)
			{
				if (aspectRatio.notSet())
					calculateAspectRatio( width, height );
				
				if (aspectRatio.isSet())
					updateAllHeights( calcHeightForWidth(v) );	//calling this method won't trigger the setHeight method (to prevend infinite loops)
			}
		}
		
		return _width;
	}
	
	
	/**
	 * Setter for height value.
	 * @see setWidth
	 */
	private  function setHeight (v:Int)
	{
		if (_height != v)
		{
			updateAllHeights( validateHeight( v, Flags.VALIDATE_ALL ) );
			
			if (maintainAspectRatio)
			{
				if (aspectRatio.notSet())
					calculateAspectRatio( width, height );
				
				if (aspectRatio.isSet())
					updateAllWidths( calcWidthForHeight(v) );	//calling this method won't trigger the setWidth method (to prevend infinite loops)
			}
		}
		
		return _height;
	}
	
	
	
	/**
	 * Method will validate the given value against the given validate-options.
	 * The method will try to make the new-width fit in
	 */
	private function validateWidth (v:Int, options:Int) : Int
	{
		if (v.notSet() || options == 0)
			return v;
		
		// 1. validate value with min/max value (if they are set)
		if (options.has( Flags.VALIDATE_RANGE ) && widthValidator != null)
			v = widthValidator.validate(v);
		
		
		if (options.has( Flags.VALIDATE_ASPECT ) && maintainAspectRatio && aspectRatio.isSet())
		{
			// 2. validate the new height
			var h1 = calcHeightForWidth( v );
			var h2 = validateHeight( h1, Flags.VALIDATE_RANGE );
			
			if (h1 != h2)
			{
				// 3. if h1 is different then h2, we need to recalculate the width
				var w1 = calcWidthForHeight( h2 );
#if debug		var w2 = validateWidth( w1, Flags.VALIDATE_RANGE );
				Assert.equal( w1, w2, "It seems as if the width/height combination is impossible with the min-max restrictions.. WidthValidator: "+widthValidator+"; heightValidator: "+heightValidator+"; "+this);
#end			
				v = w1;
			}
		}
		
		// 4. return the validated width
		return v;
	}
	
	
	
	/**
	 * Method will validate the given value against the given validate-options.
	 * The method will try to make the new-height fit in
	 */
	private function validateHeight (v:Int, options:Int) : Int
	{
		if (v.notSet() || options == 0)
			return v;
		
		// 1. validate value with min/max value (if they are set)
		if (options.has( Flags.VALIDATE_RANGE ) && heightValidator != null)
			v = heightValidator.validate(v);
		
		
		if (options.has( Flags.VALIDATE_ASPECT ) && maintainAspectRatio && aspectRatio.isSet())
		{
			// 2. validate the new width
			var w1 = calcWidthForHeight( v );
			var w2 = validateWidth( w1, Flags.VALIDATE_RANGE );
			
			if (w1 != w2)
			{
				// 3. if w1 is different then w2, we need to recalculate the height
				var h1 = calcHeightForWidth( w2 );
#if debug		var h2 = validateHeight( h1, Flags.VALIDATE_RANGE );
				Assert.equal( h1, h2, "It seems as if the width/height combination is impossible with the min-max restrictions.. WidthValidator: "+widthValidator+"; heightValidator: "+heightValidator+"; "+this);
#end			
				v = h1;
			}
		}
		
		// 4. return the validated height
		return v;
	}
	
	
	
	
	/**
	 * Method will change the value of the width property and the inner- and 
	 * outerbounds to make sure they all have the same value.
	 * 
	 * The given value will not be validated.
	 * Do not call this method directly! This will be done by setWidth who will
	 * also validate the value first.
	 * 
	 * @param v 		new value for _width property
	 * @param force		Flag indicating that all properties should get updated, 
	 * 					even though nothing has changed.
	 * 
	 * @return the _width value
	 */
	public function updateAllWidths (v:Int, force:Bool = false) : Int
	{
		if (!force && _width == v && v.isSet())
			return v;
		
#if debug	Assert.that( v.notSet() || v > -1, this+" width = "+v );
			Assert.that( v < 10000, this+" width = "+v ); #end
		
		var outer = outerBounds, inner = innerBounds;
		outer.invalidatable = inner.invalidatable = false;
		
		_width		= v;
		inner.width = getUsableWidth() + getHorPadding();
		outer.width = inner.width + getHorMargin();
		
		outer.resetValidation();
		inner.resetValidation();
		
		hasValidatedWidth = false;
		invalidate( Flags.WIDTH );
		
		return v;
	}
	
	
	/**
	 * Method will change the value of the height property and the inner- and 
	 * outerbounds to make sure they all have the same value.
	 * 
	 * The given value will not be validated.
	 * Do not call this method directly! This will be done by setHeight who will
	 * also validate the value first.
	 * 
	 * @param v 		new value for _height property
	 * @param force		Flag indicating that all properties should get updated, 
	 * 					even though nothing has changed.
	 * 
	 * @return the _height value
	 */
	public function updateAllHeights (v:Int, force:Bool = false) : Int
	{
		if (!force && _height == v && v.isSet())
			return v;
		
#if debug	Assert.that( v.notSet() || v > -1, this+" height = "+v );
			Assert.that( v < 10000, this+" height = "+v ); #end
		
		var outer = outerBounds, inner = innerBounds;
		outer.invalidatable = inner.invalidatable = false;
		
		_height			= v;
		inner.height	= getUsableHeight() + getVerPadding();
		outer.height	= inner.height + getVerMargin();
		
		outer.resetValidation();
		inner.resetValidation();
		
		hasValidatedHeight = false;
		invalidate( Flags.HEIGHT );
		
		return v;
	}
	
	
	/**
	 * @return _width if the value is set, otherwise '0' or the minWidth
	 */
	private inline function getUsableWidth ()
	{
		var v = _width;
		if (v.notSet())		v = widthValidator != null ? widthValidator.min : 0;
		if (v.notSet())		v = 0;
		return v;
	}
	
	
	/**
	 * @return _height if the value is set, otherwise '0'
	 */
	private inline function getUsableHeight ()
	{
		var v = _height;
		if (v.notSet())		v = heightValidator != null ? heightValidator.min : 0;
		if (v.notSet())		v = 0;
		return v;
	}
	
	
	/**
	 * Internal method that will update all the values of the innerBounds 
	 * without sending an change event.
	 * 
	 * Method is used when the padding/margin changes.
	 */
	private inline function updateInnerBounds ()
	{
		var box = innerBounds;
		box.invalidatable	= false;
		box.left			= margin == null ? x : x + margin.left;
		box.top				= margin == null ? y : y + margin.top;
		box.width			= getUsableWidth() + getHorPadding();
		box.height			= getUsableHeight() + getVerPadding();
		box.resetValidation();
	}
	
	
	/**
	 * internal method that will update all the values of the outerbounds 
	 * without sending an change event.
	 * 
	 * Method is used when the padding/margin changes.
	 */
	private inline function updateOuterBounds ()
	{
		var box = outerBounds;
		box.invalidatable	= false;
		box.left			= x;
		box.top				= y;
		box.width			= getUsableWidth() + getHorPadding() + getHorMargin();
		box.height			= getUsableHeight() + getVerPadding() + getVerMargin();
		box.resetValidation();
	}
	
	
	
	
	//
	// ASPECTRATIO METHODS
	//
	
	
	private inline function calcWidthForHeight (h:Int) : Int	{ Assert.notEqual(aspectRatio, 0); Assert.that(aspectRatio.isSet()); return (h * aspectRatio).roundFloat(); }
	private inline function calcHeightForWidth (w:Int) : Int	{ Assert.notEqual(aspectRatio, 0); Assert.that(aspectRatio.isSet()); return (w / aspectRatio).roundFloat(); }
	
	
	private inline function calculateAspectRatio (w:Int, h:Int)
	{
		aspectRatio = Number.FLOAT_NOT_SET;
		if (w.isSet() && h.isSet() && w > 0 && h > 0)
		{
			aspectRatio	= w / h;
			Assert.that(aspectRatio.isSet());
			validateAspectRatio(w, h);
		}
		return aspectRatio;
	}
	
	
	/**
	 * Method will make sure that that if maintain-aspect ratio is set to true,
	 * the aspect-ratio applyable is.
	 * F.e if the aspect-ratio is 4:7 and width and height both have a min-value
	 * of 50 and a max-value of 60, it's impossible to give both values a valid
	 * value.
	 * 
	 * The method will throw an error in debug-mode and in release-mode it will
	 * turn maintainAspectRatio off.
	 */
	private inline function validateAspectRatio (width:Int, height:Int) : Void
	{
		if (maintainAspectRatio && widthValidator != null && heightValidator != null && aspectRatio > 0)
		{
			Assert.that(aspectRatio != 0, "there's no aspect-ratio given.. value is 0; "+this+". w: "+width+", h: "+height);
		
			var w1	= calcWidthForHeight( height );
			var w2	= validateWidth( w1, Flags.VALIDATE_RANGE );
		
			if (w1 != w2)
			{
				var h1	= calcHeightForWidth( w2 );
				var h2	= validateHeight( h1, Flags.VALIDATE_RANGE );
			
				if (h1 != h2)
				{
					var w3 = calcWidthForHeight( h2 );
					var w4 = validateWidth(w3, Flags.VALIDATE_RANGE );
					
					if (w3 != w4) {
#if debug				throw "Impossible to maintain the aspectratio for "+this+". Aspect-ratio is "+aspectRatio+", w1: "+w1+"; w2: "+w2+", h1: "+h1+"; h2: "+h2+"; width-validator: "+widthValidator+"; height-validator: "+heightValidator;
#else					maintainAspectRatio = h1 != h2;	#end
					}
				}
			}
		}
	}
	
	
	
	
	
	//
	// OTHER METHODS
	//
	
	/**
	 * Method will resize the LayoutClient. The aspectratio will be 
	 * recalculated If maintainAspectRatio is set to true.
	 */
	public function resize (newWidth:Int, newHeight:Int)
	{
		if (maintainAspectRatio)
			calculateAspectRatio( newWidth, newHeight );
		
		updateAllWidths(  validateWidth(  newWidth,  Flags.VALIDATE_ALL ) );
		updateAllHeights( validateHeight( newHeight, Flags.VALIDATE_ALL ) );
	}
	
	
	
	
	
	override public function invalidateCall (propChanges:Int, sender:IInvalidatable)
	{
		if (propChanges == 0)
			return;
		
		if (!sender.is(IntRectangle)) {
			super.invalidateCall( propChanges, sender );
			return;
		}
		
		
		if (propChanges == RectangleFlags.BOTTOM || propChanges == RectangleFlags.RIGHT)
			return;
		
		var box = sender.as(IntRectangle);
		
		if (box == outerBounds)
		{
			if (propChanges.has( RectangleFlags.LEFT ))		x		= box.left;
			if (propChanges.has( RectangleFlags.TOP ))		y		= box.top;
			if (propChanges.has( RectangleFlags.WIDTH ))	width	= box.width - getHorPadding() - getHorMargin();
			if (propChanges.has( RectangleFlags.HEIGHT ))	height	= box.height - getVerPadding() - getVerMargin();
		}
	
		else if (box == innerBounds)
		{
			if (propChanges.has( RectangleFlags.LEFT ))		x		= margin == null ? box.left : box.left - margin.left;
			if (propChanges.has( RectangleFlags.TOP ))		y		= margin == null ? box.top : box.top - margin.top;
			if (propChanges.has( RectangleFlags.WIDTH ))	width	= box.width - getHorPadding();
			if (propChanges.has( RectangleFlags.HEIGHT ))	height	= box.height - getVerPadding();
		}
	}
	
	
	/**
	 * Method needs to get called when the horizontal padding or margin is changed
	 * This needs to be done manually since padding/margin don't accept change listeners..
	 * 
	 * Method will update the width of the client. If the client has a width of 
	 * 100%, it will lower the value of the 'width' value.. otherwise it will increase
	 * the width of the outerBounds.
	 * 
	 * FIXME
	 */
	public function invalidateHorPaddingMargin () //changes:Int)
	{
	//	invalidate( changes );	// <-- will destroy the applicition... things start freezing.. weird stuff :-S
		if (percentWidth.isSet())
			width = outerBounds.width - getHorPadding() - getHorMargin();
		else
			updateAllWidths(width, true);
	}
	
	
	/**
	 * @see invalidateHorPaddingMargin
	 */
	public function invalidateVerPaddingMargin ()
	{
		if (percentHeight.isSet())
			height = outerBounds.height - getVerPadding() - getVerMargin();
		else
			updateAllHeights(height, true);
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	public inline function getHorPosition ()
	{
		var pos = innerBounds.left;
		if (parent.is(VirtualLayoutContainer))
			pos += parent.getHorPosition();
		
		return pos;
	}
	
	
	public inline function getVerPosition ()
	{
		var pos = innerBounds.top;
		if (parent.is(VirtualLayoutContainer))
			pos += parent.getVerPosition();
		
		return pos;
	}
	
	
	public inline function getHorPadding () : Int	{ return padding == null ? 0 : padding.left + padding.right; }
	public inline function getVerPadding() : Int	{ return padding == null ? 0 : padding.top + padding.bottom; }
	public inline function getHorMargin () : Int	{ return margin == null ? 0 : margin.left + margin.right; }
	public inline function getVerMargin() : Int		{ return margin == null ? 0 : margin.top + margin.bottom; }
	
	
	
	
	//
	// POSITION SETTERS
	//
	
	private function setX (v:Int) : Int
	{
		if (x != v)
		{
#if debug	Assert.that( v.notSet() || (v > -1000 && v < 10000), this+".invalidX: "+v ); #end
			x = v;
			outerBounds.left = v;
			innerBounds.left = (margin == null) ? v : v + margin.left;
			invalidate( Flags.X );
		}
		return x;
	}
	
	
	private function setY (v:Int) : Int
	{
		if (y != v)
		{
#if debug	Assert.that( v.notSet() || (v > -1000 && v < 10000), this+".invalidY: "+v ); #end
			y = v;
			outerBounds.top = v;
			innerBounds.top = (margin == null) ? v : v + margin.top;
			invalidate( Flags.Y );
		}
		return y;
	}
	
	
	private inline function setPercentWidth (v:Float)
	{
		if (v.notEqualTo( percentWidth ))	//notEqualTo will also compare NaN.. @see NumberUtil
		{
			percentWidth = v;
			invalidate( Flags.WIDTH | Flags.PERCENT_WIDTH );
		}
		return v;
	}
	
	
	private inline function setPercentHeight (v:Float)
	{
		if (v.notEqualTo( percentHeight ))	//notEqualTo will also compare NaN
		{
			percentHeight = v;
			invalidate( Flags.HEIGHT | Flags.PERCENT_HEIGHT );
		}
		return v;
	}
	
	
	private function setPadding (v:Box)
	{
		if (padding != v)
		{
			padding = v;
			updateInnerBounds();
			updateOuterBounds();
			
			invalidate( Flags.HEIGHT | Flags.WIDTH );
		}
		return padding;
	}
	
	
	private function setMargin (v:Box)
	{
		if (margin != v)
		{
			margin = v;
			updateInnerBounds();
			updateOuterBounds();
			
			invalidate( Flags.HEIGHT | Flags.WIDTH );
		}
		return padding;
	}
	
	
	private inline function setParent (v)
	{
		return parent = v;
	}
	
	
	private inline function setIncludeInLayout (v:Bool)
	{
		if (includeInLayout != v)
		{
			includeInLayout = v;
			if (v)		invalidate( Flags.INCLUDE | Flags.PERCENT_HEIGHT | Flags.PERCENT_WIDTH | Flags.RELATIVE );
			else		invalidate( Flags.INCLUDE );
		}
		return includeInLayout;
	}
	
	
	private  function setMaintainAspectRatio (v:Bool) : Bool
	{
		if (v != maintainAspectRatio)
		{
			maintainAspectRatio = v;
			if (v && width.isSet() && height.isSet())
				resize(width, height);	//resize method will take care of applying and calculating the aspect-ratio
		}
		return v;
	}
	
	
	private inline function setRelative (v:RelativeLayout)
	{
		if (relative != v)
		{
			if (relative != null && relative.change != null)	relative.change.unbind( this );
			if (v != null)										handleRelativeChange.on( v.change, this );
			
			relative = v;
			handleRelativeChange();
		}
		return v;
	}
	
	
	private inline function setWidthValidator (v:IntRangeValidator)
	{
		if (widthValidator != v)
		{
			if (widthValidator != null)			widthValidator.change.unbind( this );
			if (v != null)						handleWidthValidatorChange.on( v.change, this );
			
			widthValidator = v;
			handleWidthValidatorChange();
		}
		return v;
	}
	
	
	private inline function setHeightValidator (v:IntRangeValidator)
	{
		if (heightValidator != v)
		{
			if (heightValidator != null)		heightValidator.change.unbind( this );
			if (v != null)						handleHeightValidatorChange.on( v.change, this );
			
			heightValidator = v;
			handleHeightValidatorChange();
		}
		return v;
	}
	
	
	private inline function setInvalidatable (v:Bool)
	{
		if (v != invalidatable)
		{
			invalidatable = v;
			
			//broadcast queued changes?
			if (v && changes > 0)
				invalidateLayout();
		}
		return v;
	}
	
	
	
	
	//
	// EVEMT HANDLERS
	//
	
	private inline function handleRelativeChange ()	{ invalidate(Flags.RELATIVE); }
	private function handleWidthValidatorChange ()	{ updateAllWidths ( validateWidth ( _width, Flags.VALIDATE_ALL ) ); }
	private function handleHeightValidatorChange ()	{ updateAllHeights( validateHeight( _height, Flags.VALIDATE_ALL ) ); }
	
	
	
	
#if debug
	public inline function readChanges (changes:Int = -1) : String
	{
		if (changes == -1)
			changes = this.changes;
		
		return Flags.readProperties(changes);
	}
	
	
	public static var counter:Int = 0;
	public var name:String;
	@:keep public function toString() { return state.current+"_"+name; } // + " - " + _oid; }
#end
}