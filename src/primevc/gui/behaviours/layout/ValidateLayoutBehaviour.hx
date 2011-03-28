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
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.states.ValidateStates;
 import primevc.gui.traits.IDrawable;
 import primevc.gui.traits.IPropertyValidator;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
 

/**
 * Instance will trigger layout.validate on a 'enterFrame event' when the 
 * layout is invalidated or when the target is added to the stage with an 
 * invalidated layout.
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class ValidateLayoutBehaviour extends ValidatingBehaviour < IUIElement >, implements IPropertyValidator
{
	private var isNotPositionedYet	: Bool;
	private var stateChangeWire		: Wire<Dynamic>;
	private var layoutChangeWire	: Wire<Dynamic>;
	
	
	override private function init ()
	{
		Assert.that(target.layout != null);
		
		var layout			= target.layout;
		isNotPositionedYet	= true;
		Assert.that(layout != null, "Layout of "+target+" can't be null for "+this);
		
#if debug
		layout.name = target.id.value+"Layout";
#end
		
		stateChangeWire		= layoutStateChangeHandler	.on( layout.state.change, this );
		layoutChangeWire	= applyChanges				.on( layout.changed, this );
		
		updateTarget.on( target.displayEvents.addedToStage, this );
		disableWires.on( target.displayEvents.removedFromStage, this );
		
		if (isOnStage())	updateTarget();
		else				disableWires();
	}
	
	
	override private function reset ()
	{
		if (target.layout == null)
			return;
		
		target.displayEvents.addedToStage.unbind( this );
		target.displayEvents.removedFromStage.unbind( this );
		
		if (stateChangeWire != null)	stateChangeWire.dispose();
		if (layoutChangeWire != null)	layoutChangeWire.dispose();
		
		super.reset();
	}
	
	
	private function updateTarget ()
	{
		stateChangeWire.enable();
		layoutChangeWire.enable();
		
		var curState = target.layout.state.current;
		layoutStateChangeHandler( curState, null );
		
		if (curState == ValidateStates.validated)
			applyChanges( LayoutFlags.POSITION | LayoutFlags.SIZE );
	}
	
	
	private function disableWires ()
	{
		stateChangeWire.disable();
		layoutChangeWire.disable();
		
		if (isQueued())
			getValidationManager().remove( this );
		
		Assert.that(!isQueued());
	}
	
	
#if debug
	/**
	 * method will return the state of all the parents/grandparents of the 
	 * given layoutclient
	 */
	private function getParentsState (layout:LayoutClient, level:Int = 0) : String
	{
		var s = "\n\t\t\t\t[ "+level+" ] = "+layout+" => "+layout.state.current; //+"; in queue? "+isQueued();
		if (layout.parent != null)
			s += getParentsState( cast layout.parent, level + 1 );
		
		return s;
	}
#end
	
	private function layoutStateChangeHandler (newState:ValidateStates, oldState:ValidateStates)
	{
		Assert.that(isOnStage(), target+"");
		
	//	if (isQueued() && newState == ValidateStates.parent_invalidated)
	//		getValidationManager().remove( this );
	
		if (newState == ValidateStates.invalidated)
			invalidate();
		
	//	else if (newState == ValidateStates.validated) // && !target.layout.includeInLayout)		will happen in the queuemanager
	//		getValidationManager().remove(this);
	}
	
	
	public inline function invalidate ()				{ getValidationManager().add( this ); }
	public inline function validate ()					{ if (target != null) target.layout.validate(); }
	override private function getValidationManager ()	{ return isOnStage() ? cast target.system.invalidation : null; }
	
	
	public function applyChanges (changes:Int)
	{
		var l = target.layout;
		
	//	if (changes.has( LayoutFlags.SIZE | LayoutFlags.POSITION ))
	//	trace(target+"; x="+l.getHorPosition()+", y="+l.getVerPosition()+", width="+l.outerBounds.width+", height="+l.outerBounds.height+"; "+changes.has( LayoutFlags.POSITION )+"; "+changes.has( LayoutFlags.SIZE ));
		
		if (changes.has( LayoutFlags.POSITION ))
		{
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
				
				target.rect.move( newX, newY );
				target.x = newX;
				target.y = newY;
				isNotPositionedYet = false;
			}
			else
				target.effects.playMove();
		}
		
		
		
		if (changes.has( LayoutFlags.SIZE ))
		{
			if (target.effects == null)
			{
				var b = target.layout.innerBounds;
				target.rect.resize( b.width, b.height );
				
				if (!target.is(IDrawable)) {
					target.width	= target.rect.width;
					target.height	= target.rect.height;
				}
			}
			else
				target.effects.playResize();
		}
	}
	
	
#if debug
	override public function toString ()
	{
		var className = Type.getClassName( Type.getClass( this ) );
		return className.split(".").pop() + " ( "+target+"."+target.layout.state.current+" )";
	}
#end
}