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
package primevc.gui.effects;
 import primevc.core.IDisposable;
 import primevc.gui.core.IUIElement;
  using primevc.utils.Bind;


/**
 * Container with empty slots for effects that will be bound to events that
 * happen in an IUIElement.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 01, 2010
 */
class UIElementEffects implements IDisposable
{
	public var target	(default, null)			: IUIElement;
	
	
	//
	// SLOTS
	//
	
	/**
	 * Effect that is performed when the coordinates of the targets 
	 * layoutobject have changed.
	 */
	public var move		(default, setMove)		: Effect < Dynamic, Dynamic >;
	
	/**
	 * Effect that is performed when the size of targets layoutobject is 
	 * changed.
	 */
	public var resize	(default, setResize)	: Effect < Dynamic, Dynamic >;
	
	/**
	 * Effect that is performed when the 'rotate' method of the target is called.
	 */
	public var rotate	(default, setRotate)	: Effect < Dynamic, Dynamic >;
	
	/**
	 * Effect that is performed when the 'scale' method of the target is called.
	 */
	public var scale	(default, setScale)		: Effect < Dynamic, Dynamic >;
	
	/**
	 * Effect that is performed when the 'show' method of the target is called.
	 * This effect will stop the 'hide' effect if it's playing.
	 */
	public var show		(default, setShow)		: Effect < Dynamic, Dynamic >;
	/**
	 * Effect that is performed when the 'hide' method of the target is called.
	 * This effect will stop the 'show' effect if it's playing.
	 */
	public var hide		(default, setHide)		: Effect < Dynamic, Dynamic >;
	
	
	
	public function new ( target:IUIElement )
	{
		this.target = target;
	}
	
	
	public function dispose ()
	{
		if (move != null)	move.dispose();
		if (resize != null)	resize.dispose();
		if (rotate != null)	rotate.dispose();
		if (scale != null)	scale.dispose();
		if (show != null)	show.dispose();
		if (hide != null)	hide.dispose();
		
		target = null;
		move = resize = rotate = scale = show = hide = null;
	}
	
	
	
	
	//
	// EFFECT HANDLERS
	//
	
	
	public inline function playMove ()
	{
		Assert.that( move != null );
		move.setValues( EffectProperties.position( target.x, target.y, target.layout.getHorPosition(), target.layout.getVerPosition() ) );
		move.play();
	}
	
	
	public inline function playResize ()
	{
		Assert.that( resize != null );
		resize.setValues( EffectProperties.size( target.width, target.height, target.layout.width, target.layout.height ) );
		resize.play();
	}
	
	
	public inline function playRotate ( endV:Float )
	{
		Assert.that( rotate != null );
		rotate.setValues( EffectProperties.rotation( target.rotation, endV ) );
		rotate.play();
	}
	
	
	public inline function playScale ( endSx:Float, endSy:Float )
	{
		Assert.that( scale != null );
		scale.setValues( EffectProperties.scale( target.scaleX, target.scaleY, endSx, endSy ) );
		scale.play();
	}
	
	
	public inline function playShow ()
	{
		Assert.that( show != null );
		if (hide != null)
			hide.stop();
		
		if (show == hide)
			show.isReverted = false;
		
		show.play();
	}
	
	
	public inline function playHide ()
	{
		Assert.that( hide != null );
		if (show != null)
			show.stop();
		
		if (show == hide)
			hide.isReverted = true;
		
		hide.play();
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setMove (v)
	{
		if (v != move)
		{
			if (move != null) {
				move.target = null;
				target.layout.events.posChanged.unbind(this);
			}
			
			move = v;
			
			if (move != null) {
				move.target	= target;
				playMove.on( target.layout.events.posChanged, this );
			}
		}
		return v;
	}
	
	
	private inline function setResize (v)
	{
		if (v != resize)
		{
			if (resize != null) {
				resize.target = null;
				target.layout.events.sizeChanged.unbind(this);
			}

			resize = v;

			if (resize != null) {
				resize.target = target;
				playResize.on( target.layout.events.sizeChanged, this );
			}
		}
		return v;
	}
	
	
	private inline function setRotate (v)
	{
		if (v != rotate)
		{
			if (rotate != null)		rotate.target = null;
			rotate = v;
			if (rotate != null)		rotate.target = target;
		}
		return v;
	}
	
	
	private inline function setScale (v)
	{
		if (v != scale)
		{
			if (scale != null)		scale.target = null;
			scale = v;
			if (scale != null)		scale.target = target;
		}
		return v;
	}
	
	
	private inline function setShow (v)
	{
		if (v != show)
		{
			if (show != null)		show.target = null;
			show = v;
			if (show != null)		show.target = target;
		}
		return v;
	}
	
	
	private inline function setHide (v)
	{
		if (v != hide)
		{
			if (hide != null)		hide.target = null;
			hide = v;
			if (hide != null)		hide.target = target;
		}
		return v;
	}
}