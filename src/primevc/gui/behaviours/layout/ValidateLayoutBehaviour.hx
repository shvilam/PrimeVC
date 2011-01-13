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
package primevc.gui.behaviours.layout;
 import primevc.core.collections.FastDoubleCell;
 import primevc.core.dispatcher.Wire;
 import primevc.gui.behaviours.ValidatingBehaviour;
 import primevc.gui.core.IUIElement;
 import primevc.gui.core.UIWindow;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.states.ValidateStates;
 import primevc.gui.traits.IDrawable;
 import primevc.gui.traits.IPropertyValidator;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberMath;
  using primevc.utils.TypeUtil;
 

/**
 * Instance will trigger layout.validate on a 'enterFrame event' when the 
 * layout is invalidated.
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class ValidateLayoutBehaviour extends ValidatingBehaviour < IUIElement >, implements IPropertyValidator
{
	private var isNotPositionedYet	: Bool;
	
	
	override private function init ()
	{
		var layout			= target.layout;
		isNotPositionedYet	= true;
		Assert.that(layout != null, "Layout of "+target+" can't be null for "+this);
		
#if debug
		layout.name = target.id.value+"Layout";
#end
		
		layoutStateChangeHandler.on( layout.state.change, this );
		applyChanges.on( layout.changed, this );
		layoutStateChangeHandler( layout.state.current, null );
	}
	
	
	override private function reset ()
	{
		if (target.layout == null)
			return;
		
		super.reset();
		
		target.layout.state.change.unbind( this );
		target.layout.changed.unbind( this );
	}
	
	
	private function layoutStateChangeHandler (newState:ValidateStates, oldState:ValidateStates)
	{
		if (!isOnStage())
			return;
		
		if (isQueued() && newState == ValidateStates.parent_invalidated)
			getValidationManager().remove( this );
		
		else if (!isQueued() && newState == ValidateStates.invalidated)
			invalidate();
	}
	
	
	public inline function invalidate ()				{ getValidationManager().add( this ); }
	public inline function validate ()					{ target.layout.validate(); }
	override private function getValidationManager ()	{ return isOnStage() ? cast target.window.as(UIWindow).invalidationManager : null; }
	
	
	public function applyChanges (changes:Int)
	{
		if (changes.has( LayoutFlags.X | LayoutFlags.Y ))
		{
			//	trace(target+".applyPosition; " + " - pos: " + target.layout.getHorPosition() + ", " + target.layout.getVerPosition() + " - old pos "+target.x+", "+target.y+"; padding? "+target.layout.padding);
			
			if (target.effects == null || isNotPositionedYet)
			{
				var l = target.layout;
				var newX = l.getHorPosition();
				var newY = l.getVerPosition();
			
				if (!isNotPositionedYet && target.x == newX && target.y == newY)
					return;
			
				if (target.is(IDrawable))
				{
					var t = target.as(IDrawable);
					if (t.graphicData.border != null)
					{
						var borderWidth = t.graphicData.border.weight;
						newX -= (borderWidth * target.scaleX).roundFloat();
						newY -= (borderWidth * target.scaleY).roundFloat();
					}
				}
			
				target.x	= target.rect.left	= newX;
				target.y	= target.rect.top	= newY;
				isNotPositionedYet = false;
			}
			else
				target.effects.playMove();
		}
		
		
		
		if (changes.has( LayoutFlags.WIDTH | LayoutFlags.HEIGHT ))
		{
			if (target.id.value == "video")
				trace("\t"+target+".sizeChanged; outer: "+target.layout.outerBounds); //+"; inner: "+target.layout.innerBounds);
			if (target.effects == null)
			{
				var b = target.layout.innerBounds;

				target.rect.width	= b.width;
				target.rect.height	= b.height;

				/*if (target.is(IDrawable))
				{
					var t = target.as(IDrawable);
					if (t.graphicData.border != null)
					{
						var borderWidth = t.graphicData.border.weight.roundFloat();
						target.rect.width += borderWidth;
						target.rect.height += borderWidth;
					}
				}*/

				if (!target.is(IDrawable)) {
					target.width	= target.rect.width;
					target.height	= target.rect.height;
				}
			}
			else
				target.effects.playResize();

		//	trace("\t\tfinal size: "+target.rect.width+", "+target.rect.height+"\n");
		}
	}
}