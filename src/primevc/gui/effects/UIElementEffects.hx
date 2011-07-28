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
 import primevc.core.traits.IDisposable;
 import primevc.gui.core.IUIElement;
 import primevc.gui.effects.effectInstances.IEffectInstance;
  using primevc.utils.Bind;


typedef EffectInstanceType = IEffectInstance < Dynamic, Dynamic >;

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
	public var move			(default, setMove)			: EffectInstanceType;
	
	/**
	 * Effect that is performed when the size of targets layoutobject is 
	 * changed.
	 */
	public var resize		(default, setResize)		: EffectInstanceType;
	
	/**
	 * Effect that is performed when the 'rotate' method of the target is called.
	 */
	public var rotate		(default, setRotate)		: EffectInstanceType;
	
	/**
	 * Effect that is performed when the 'scale' method of the target is called.
	 */
	public var scale		(default, setScale)			: EffectInstanceType;
	
	/**
	 * Effect that is performed when the 'show' method of the target is called.
	 * This effect will stop the 'hide' effect if it's playing.
	 */
	public var show			(default, setShow)			: EffectInstanceType;
	/**
	 * Effect that is performed when the 'hide' method of the target is called.
	 * This effect will stop the 'show' effect if it's playing.
	 */
	public var hide			(default, setHide)			: EffectInstanceType;
	
	
	public function new ( target:IUIElement )
	{
		this.target 	= target;
	}
	
	
	public function dispose ()
	{
		target	= null;

		if (move != null)	{ move.dispose();	move 	= null; }
		if (resize != null)	{ resize.dispose(); resize 	= null; }
		if (rotate != null)	{ rotate.dispose(); rotate 	= null; }
		if (scale != null)	{ scale.dispose();	scale 	= null; }
		if (show != null)	{ show.dispose();	show 	= null; }
		if (hide != null)	{ hide.dispose();	hide 	= null; }
	}
	
	
	
	
	//
	// EFFECT HANDLERS
	//
	
	
	public function playMove ()
	{
#if (flash8 || flash9 || js)
		var newX = target.layout.getHorPosition();
		var newY = target.layout.getVerPosition();
		if (move != null)
		{
			move.setValues( EffectProperties.position( target.x, target.y, newX, newY ) );
			move.play();
		}
		else
		{
			target.x = newX;
			target.y = newY;
			target.rect.move( newX, newY );
		}
#end
	}
	
	
	public function playResize ()
	{
#if (flash8 || flash9 || js)
		var bounds = target.layout.innerBounds;
		
		if (resize != null)
		{
			resize.setValues( EffectProperties.size( target.width, target.height, bounds.width, bounds.height ) );
			resize.play();
		}
		else
			target.rect.resize( bounds.width, bounds.height );
#end
	}
	
	
	public inline function playRotate ( endV:Float )
	{
#if (flash8 || flash9 || js)
		if (rotate != null)
		{
			rotate.setValues( EffectProperties.rotation( target.rotation, endV ) );
			rotate.play();
		}
		else
		{
			target.rotation = endV;
		}
#end
	}
	
	
	public inline function playScale ( endSx:Float, endSy:Float )
	{
#if (flash8 || flash9 || js)
		if (scale != null)
		{
			scale.setValues( EffectProperties.scale( target.scaleX, target.scaleY, endSx, endSy ) );
			scale.play();
		}
		else
		{
			target.scaleX = endSx;
			target.scaleY = endSy;
		}
#end
	}
	
	
	public function playShow ()
	{
#if (flash8 || flash9 || js)
		if (show != null)
		{
			if (hide != null) {
				if (hide.isWaiting())	{ hide.stop(); }
				if (hide.isPlaying())	{ hide.stop(); }
				else					target.visible = false;
			}
			else
				target.visible = false;
			
			if (show == hide)
				show.isReverted = false;
			
			show.play();
		}
#end
	}
	
	
	public function playHide ()
	{
#if (flash8 || flash9 || js)
		if (hide != null)
		{
			if (show != null) {
				if (show.isWaiting())	{ show.stop(); }
				if (show.isPlaying())	{ show.stop(); }
			}
			
			if (show == hide)
				hide.isReverted = true;
			
			hide.play();
		}
#end
	}
	

	public inline function isPlayingHide ()	{ return hide != null && (hide.isPlaying() || hide.isWaiting()) && (show != hide ||  hide.isReverted); }
	public inline function isPlayingShow ()	{ return show != null && (show.isPlaying() || show.isWaiting()) && (show != hide || !show.isReverted); }
	
	
	
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
			
		//	if (move != null)
		//		playMove.on( target.layout.events.posChanged, this );
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
		//	if (resize != null)
		//		playResize.on( target.layout.events.sizeChanged, this );
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
			/*if (show != null && v == null)
				target.displayEvents.addedToStage.unbind(this);
			else
				playShow.on( target.displayEvents.addedToStage, this );
			*/
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