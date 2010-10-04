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
 import primevc.gui.effects.effectInstances.IEffectInstance;
 import primevc.gui.styling.declarations.EffectStyleDeclarations;
  using primevc.utils.Bind;


private typedef EffectType = IEffectInstance < Dynamic, Dynamic >;

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
	
//	private var moveInstance	: EffectType;
//	private var resizeInstance	: EffectType;
//	private var rotateInstance	: EffectType;
//	private var scaleInstance	: EffectType;
//	private var showInstance	: EffectType;
//	private var hideInstance	: EffectType;
	
	/**
	 * Effect that is performed when the coordinates of the targets 
	 * layoutobject have changed.
	 */
	public var move		(default, setMove)		: EffectType;
	
	/**
	 * Effect that is performed when the size of targets layoutobject is 
	 * changed.
	 */
	public var resize	(default, setResize)	: EffectType;
	
	/**
	 * Effect that is performed when the 'rotate' method of the target is called.
	 */
	public var rotate	(default, setRotate)	: EffectType;
	
	/**
	 * Effect that is performed when the 'scale' method of the target is called.
	 */
	public var scale	(default, setScale)		: EffectType;
	
	/**
	 * Effect that is performed when the 'show' method of the target is called.
	 * This effect will stop the 'hide' effect if it's playing.
	 */
	public var show		(default, setShow)		: EffectType;
	/**
	 * Effect that is performed when the 'hide' method of the target is called.
	 * This effect will stop the 'show' effect if it's playing.
	 */
	public var hide		(default, setHide)		: EffectType;
	
	
	private var effects : EffectStyleDeclarations;
	
	
	public function new ( target:IUIElement )
	{
		this.target = target;
		effects		= target.style.getEffects();
	}
	
	
	public function dispose ()
	{
		if (move != null)	move.dispose();
		if (resize != null)	resize.dispose();
		if (rotate != null)	rotate.dispose();
		if (scale != null)	scale.dispose();
		if (show != null)	show.dispose();
		if (hide != null)	hide.dispose();
		
		effects.dispose();
		effects = null;
		target = null;
		move = resize = rotate = scale = show = hide = null;
	}
	
	
	
	
	//
	// EFFECT HANDLERS
	//
	
	
	public function playMove ()
	{	
		Assert.that( effects != null );
		if (move == null)
		{
			var effect = effects.move;
			if (effect != null)
				move = effect.createEffectInstance( target );
		}
		
		if (move != null)
		{
			move.setValues( EffectProperties.position( target.x, target.y, target.layout.getHorPosition(), target.layout.getVerPosition() ) );
			move.play();
		}
	}
	
	
	public inline function playResize ()
	{
		Assert.that( effects != null );
		if (resize == null)
		{
			var effect = effects.resize;
			if (effect != null)
				resize = effect.createEffectInstance( target );
		}
		
		if (resize != null)
		{
			resize.setValues( EffectProperties.size( target.width, target.height, target.layout.width, target.layout.height ) );
			resize.play();
		}
	}
	
	
	public inline function playRotate ( endV:Float )
	{
		if (rotate == null)
		{
			var effect = effects.rotate;
			if (effect != null)
				rotate = effect.createEffectInstance( target );
		}
		
		if (rotate != null)
		{
			rotate.setValues( EffectProperties.rotation( target.rotation, endV ) );
			rotate.play();
		}
	}
	
	
	public inline function playScale ( endSx:Float, endSy:Float )
	{
		if (scale == null)
		{
			var effect = effects.scale;
			if (effect != null)
				scale = effect.createEffectInstance( target );
		}
		
		if (scale != null)
		{
			scale.setValues( EffectProperties.scale( target.scaleX, target.scaleY, endSx, endSy ) );
			scale.play();
		}
	}
	
	
	public inline function playShow ()
	{
		if (show == null)
		{
			var effect = effects.show;
			if (effect != null)
				show = effect.createEffectInstance( target );
		}
		
		if (show != null)
		{
			if (hide != null)
				hide.stop();
		
			if (show == hide)
				show.isReverted = false;
		
			show.play();
		}
	}
	
	
	public inline function playHide ()
	{
		if (hide == null)
		{
			var effect = effects.hide;
			if (effect != null)
				hide = effect.createEffectInstance( target );
		}
		
		if (hide != null)
		{
			if (hide != null)
				hide.stop();
		
			if (show == hide)
				hide.isReverted = true;
		
			hide.play();
		}
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private function setMove (v)
	{
		if (v != move)
		{
			if (move != null)
				move.dispose();
			
			move = v;
			
			if (move != null)
				playMove.on( target.layout.events.posChanged, this );
		}
		return v;
	}
	
	
	private function setResize (v)
	{
		if (v != resize)
		{
			if (resize != null)
				resize.dispose();

			resize = v;

			if (resize != null)
				playResize.on( target.layout.events.sizeChanged, this );
		}
		return v;
	}
	
	
	private function setRotate (v)
	{
		if (v != rotate)
		{
			if (rotate != null)
				rotate.dispose();
			
			rotate = v;
		}
		return v;
	}
	
	
	private function setScale (v)
	{
		if (v != scale)
		{
			if (scale != null)
				scale.dispose();
			
			scale = v;
		}
		return v;
	}
	
	
	private function setShow (v)
	{
		if (v != show)
		{
			if (show != null)
				show.dispose();
			
			show = v;
		}
		return v;
	}
	
	
	private function setHide (v)
	{
		if (v != hide)
		{
			if (hide != null)
				hide.dispose();
			
			hide = v;
		}
		return v;
	}
}