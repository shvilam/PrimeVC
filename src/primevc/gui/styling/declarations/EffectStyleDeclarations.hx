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
package primevc.gui.styling.declarations;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.gui.effects.Effect;
 import primevc.gui.effects.EffectFlags;


typedef EffectType = Effect < Dynamic, Dynamic >;


/**
 * Class holding all style properties for effects.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 07, 2010
 */
class EffectStyleDeclarations extends StylePropertyGroup
{
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
		_move	= move;
		_resize	= resize;
		_rotate	= rotate;
		_scale	= scale;
		_show	= show;
		_hide	= hide;
	}
	
	
	
	//
	// GETTERS
	//
	
	
	private function getMove ()
	{
		var v = _move;
		if (v == null && getExtended() != null)		v = getExtended().effects.move;
		if (v == null && getSuper() != null)		v = getSuper().effects.move;
		return v;
	}
	
	
	private function getResize ()
	{
		var v = _resize;
		if (v == null && getExtended() != null)		v = getExtended().effects.resize;
		if (v == null && getSuper() != null)		v = getSuper().effects.resize;
		return v;
	}
	
	
	private function getRotate ()
	{
		var v = _rotate;
		if (v == null && getExtended() != null)		v = getExtended().effects.rotate;
		if (v == null && getSuper() != null)		v = getSuper().effects.rotate;
		return v;
	}
	
	
	private function getScale ()
	{
		var v = _scale;
		if (v == null && getExtended() != null)		v = getExtended().effects.scale;
		if (v == null && getSuper() != null)		v = getSuper().effects.scale;
		return v;
	}
	
	
	private function getShow ()
	{
		var v = _show;
		if (v == null && getExtended() != null)		v = getExtended().effects.show;
		if (v == null && getSuper() != null)		v = getSuper().effects.show;
		return v;
	}
	
	
	private function getHide ()
	{
		var v = _hide;
		if (v == null && getExtended() != null)		v = getExtended().effects.hide;
		if (v == null && getSuper() != null)		v = getSuper().effects.hide;
		return v;
	}
	
	
	
	//
	// SETTERS
	//
	
	
	private function setMove (v)
	{
		if (v != _move) {
			_move = v;
			invalidate( EffectFlags.MOVE );
		}
		return v;
	}
	
	
	private function setResize (v)
	{
		if (v != _resize) {
			_resize = v;
			invalidate( EffectFlags.RESIZE );
		}
		return v;
	}
	
	
	private function setRotate (v)
	{
		if (v != _rotate) {
			_rotate = v;
			invalidate( EffectFlags.ROTATE );
		}
		return v;
	}
	
	
	private function setScale (v)
	{
		if (v != _scale) {
			_scale = v;
			invalidate( EffectFlags.SCALE );
		}
		return v;
	}
	
	
	private function setShow (v)
	{
		if (v != _show) {
			_show = v;
			invalidate( EffectFlags.SHOW );
		}
		return v;
	}
	
	
	private function setHide (v)
	{
		if (v != _hide) {
			_hide = v;
			invalidate( EffectFlags.HIDE );
		}
		return v;
	}
	
	
	
	
	
#if (neko || debug)
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
	
	
	override public function isEmpty ()
	{
		return _move == null && _resize == null && _rotate == null && _scale == null && _show == null && _hide == null;
	}
#end
	
	
#if neko
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ _move, _resize, _rotate, _scale, _show, _hide ] );
	}
#end
}