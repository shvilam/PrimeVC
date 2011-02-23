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
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.core.traits.IInvalidatable;
 import primevc.gui.effects.Effect;
 import primevc.gui.effects.EffectFlags;
  using primevc.utils.BitUtil;


typedef EffectType		= Effect < Dynamic, Dynamic >;
private typedef Flags	= EffectFlags;


/**
 * Class holding all style properties for effects.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 07, 2010
 */
class EffectsStyle extends StyleSubBlock
{
	private var extendedStyle	: EffectsStyle;
	private var superStyle		: EffectsStyle;
	
	private var _move	: EffectType;
	private var _resize	: EffectType;
	private var _rotate	: EffectType;
	private var _scale	: EffectType;
	private var _show	: EffectType;
	private var _hide	: EffectType;
	
	
	/**
	 * Effect that is performed when the coordinates of the targets 
	 * layoutobject have changed.
	 */
	public var move		(getMove, setMove)		: EffectType;
	
	/**
	 * Effect that is performed when the size of targets layoutobject is 
	 * changed.
	 */
	public var resize	(getResize, setResize)	: EffectType;
	
	/**
	 * Effect that is performed when the 'rotate' method of the target is called.
	 */
	public var rotate	(getRotate, setRotate)	: EffectType;
	
	/**
	 * Effect that is performed when the 'scale' method of the target is called.
	 */
	public var scale	(getScale, setScale)	: EffectType;
	
	/**
	 * Effect that is performed when the 'show' method of the target is called.
	 * This effect will stop the 'hide' effect if it's playing.
	 */
	public var show		(getShow, setShow)		: EffectType;
	/**
	 * Effect that is performed when the 'hide' method of the target is called.
	 * This effect will stop the 'show' effect if it's playing.
	 */
	public var hide		(getHide, setHide)		: EffectType;
	
	
	
	public function new (move:EffectType = null, resize:EffectType = null, rotate:EffectType = null, scale:EffectType = null, show:EffectType = null, hide:EffectType = null)
	{
		super();
		this.move	= move;
		this.resize	= resize;
		this.rotate	= rotate;
		this.scale	= scale;
		this.show	= show;
		this.hide	= hide;
	}
	
	
	override public function dispose ()
	{
		_move = _resize = _rotate = _scale = _show = _hide = null;
		extendedStyle = superStyle = null;
		super.dispose();
	}
	
	
	override private function updateOwnerReferences (changedReference:Int) : Void
	{
		if (changedReference.has( StyleFlags.EXTENDED_STYLE ))
		{
			if (extendedStyle != null)
				extendedStyle.listeners.remove( this );
			
			extendedStyle = null;
			if (owner != null && owner.extendedStyle != null)
			{
				extendedStyle = owner.extendedStyle.effects;
				
				if (extendedStyle != null)
					extendedStyle.listeners.add( this );
			}
		}
		
		
		if (changedReference.has( StyleFlags.SUPER_STYLE ))
		{
			if (superStyle != null)
				superStyle.listeners.remove( this );
			
			superStyle = null;
			if (owner != null && owner.superStyle != null)
			{
				superStyle = owner.superStyle.effects;
				
				if (superStyle != null)
					superStyle.listeners.add( this );
			}
		}
	}
	
	
	override public function updateAllFilledPropertiesFlag ()
	{
		super.updateAllFilledPropertiesFlag();
		
		if (allFilledProperties < Flags.ALL_PROPERTIES && extendedStyle != null)	allFilledProperties |= extendedStyle.allFilledProperties;
		if (allFilledProperties < Flags.ALL_PROPERTIES && superStyle != null)		allFilledProperties |= superStyle.allFilledProperties;
	}
	
	
	/**
	 * Method is called when a property in the super- or extended-style is 
	 * changed. If the property is not set in this style-object, it means that 
	 * the allFilledPropertiesFlag needs to be changed..
	 */
	override public function invalidateCall ( changeFromOther:Int, sender:IInvalidatable ) : Void
	{
		Assert.that(sender != null);
		
		if (sender == owner)
			return super.invalidateCall( changeFromOther, sender );
		
		if (filledProperties.has( changeFromOther ))
			return;
		
		//The changed property is not in this style-object.
		//Check if the change should be broadcasted..
		var propIsInExtended	= extendedStyle != null	&& extendedStyle.allFilledProperties.has( changeFromOther );
		var propIsInSuper		= superStyle != null	&& superStyle	.allFilledProperties.has( changeFromOther );
		
		if (sender == extendedStyle)
		{
			if (propIsInExtended)	allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the super style and the extended-style doesn't have the property that is changed, broadcast the change as well
		else if (sender == superStyle && !propIsInExtended)
		{
			if (propIsInSuper)		allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		return;
	}
	
	
	
	//
	// GETTERS
	//
	
	private function getMove ()
	{
		var v = _move;
		if (v == null && extendedStyle != null)		v = extendedStyle.move;
		if (v == null && superStyle != null)		v = superStyle.move;
		return v;
	}
	
	
	private function getResize ()
	{
		var v = _resize;
		if (v == null && extendedStyle != null)		v = extendedStyle.resize;
		if (v == null && superStyle != null)		v = superStyle.resize;
		return v;
	}
	
	
	private function getRotate ()
	{
		var v = _rotate;
		if (v == null && extendedStyle != null)		v = extendedStyle.rotate;
		if (v == null && superStyle != null)		v = superStyle.rotate;
		return v;
	}
	
	
	private function getScale ()
	{
		var v = _scale;
		if (v == null && extendedStyle != null)		v = extendedStyle.scale;
		if (v == null && superStyle != null)		v = superStyle.scale;
		return v;
	}
	
	
	private function getShow ()
	{
		var v = _show;
		if (v == null && extendedStyle != null)		v = extendedStyle.show;
		if (v == null && superStyle != null)		v = superStyle.show;
		return v;
	}
	
	
	private function getHide ()
	{
		var v = _hide;
		if (v == null && extendedStyle != null)		v = extendedStyle.hide;
		if (v == null && superStyle != null)		v = superStyle.hide;
		return v;
	}
	
	
	
	//
	// SETTERS
	//
	
	
	private function setMove (v)
	{
		if (v != _move) {
			_move = v;
			markProperty( Flags.MOVE, v != null );
		}
		return v;
	}
	
	
	private function setResize (v)
	{
		if (v != _resize) {
			_resize = v;
			markProperty( Flags.RESIZE, v != null );
		}
		return v;
	}
	
	
	private function setRotate (v)
	{
		if (v != _rotate) {
			_rotate = v;
			markProperty( Flags.ROTATE, v != null );
		}
		return v;
	}
	
	
	private function setScale (v)
	{
		if (v != _scale) {
			_scale = v;
			markProperty( Flags.SCALE, v != null );
		}
		return v;
	}
	
	
	private function setShow (v)
	{
		if (v != _show) {
			_show = v;
			markProperty( Flags.SHOW, v != null );
		}
		return v;
	}
	
	
	private function setHide (v)
	{
		if (v != _hide) {
			_hide = v;
			markProperty( Flags.HIDE, v != null );
		}
		return v;
	}
	
	
	
	
	
#if neko
	override public function toCSS (prefix:String = "")
	{
		var css = [];
		if (_move != null)		css.push( "move-effect: " + _move.toCSS(prefix) );
		if (_resize != null)	css.push( "resize-effect: " + _resize.toCSS(prefix) );
		if (_rotate != null)	css.push( "rotate-effect: " + _rotate.toCSS(prefix) );
		if (_scale != null)		css.push( "scale-effect: " + _scale.toCSS(prefix) );
		if (_show != null)		css.push( "show-effect: " + _show.toCSS(prefix) );
		if (_hide != null)		css.push( "hide-effect: " + _hide.toCSS(prefix) );
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
	
	
	override public function cleanUp ()
	{
		if (_move != null)
		{
			_move.cleanUp();
			if (_move.isEmpty()) {
				_move.dispose();
				move = null;
			}
		}
		
		if (_resize != null)
		{
			_resize.cleanUp();
			if (_resize.isEmpty()) {
				_resize.dispose();
				resize = null;
			}
		}
		
		if (_rotate != null)
		{
			_rotate.cleanUp();
			if (_rotate.isEmpty()) {
				_rotate.dispose();
				rotate = null;
			}
		}
		
		if (_scale != null)
		{
			_scale.cleanUp();
			if (_scale.isEmpty()) {
				_scale.dispose();
				scale = null;
			}
		}
		
		if (_show != null)
		{
			_show.cleanUp();
			if (_show.isEmpty()) {
				_show.dispose();
				show = null;
			}
		}
		
		if (_hide != null)
		{
			_hide.cleanUp();
			if (_hide.isEmpty()) {
				_hide.dispose();
				hide = null;
			}
		}
	}


	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ _move, _resize, _rotate, _scale, _show, _hide ] );
	}
#end

#if debug
	override public function readProperties (flags:Int = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;

		return Flags.readProperties(flags);
	}
#end
}