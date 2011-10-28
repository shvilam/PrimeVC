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
package primevc.gui.behaviours.components;
 import primevc.core.dispatcher.Wire;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.UIComponent;
 import primevc.gui.core.UITextField;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.states.ValidateStates;
 import primevc.gui.traits.IPropertyValidator;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


/**
 * @author Ruben Weijers
 * @creation-date Nov 01, 2010
 */
class LabelLayoutBehaviour extends BehaviourBase < UITextField > // extends ValidatingBehaviour < Label >, implements IPropertyValidator
{
	/**
	 * UIComponent that contains the UITextField
	 */
	private var owner 			: UIComponent;
	private var updateOwner 	: Wire<Dynamic>;
	private var updateField 	: Wire<Dynamic>;


	override private function init ()
	{
		Assert.that( target.container.is(UIComponent));
		Assert.that( target.container.as(UIComponent).layout.is(AdvancedLayoutClient));

		owner 		= target.container.as(UIComponent);
		updateField = updateFieldSize	.on( owner .layout.changed, this );
		updateOwner = updateOwnerSize	.on( target.layout.changed, this );

		updateOwnerSize( LayoutFlags.WIDTH_PROPERTIES | LayoutFlags.HEIGHT_PROPERTIES | LayoutFlags.PADDING );
		updateFieldSize( LayoutFlags.PADDING | LayoutFlags.EXPLICIT_SIZE );
	}
	
	
	override private function reset ()
	{
		if (owner.layout != null)		owner.layout.changed.unbind(this);
		if (target.layout != null)		target.layout.changed.unbind( this );
	}
	
	
	public function updateFieldSize (changes:Int)
	{
		var ownerLayout	= owner.layout.as(AdvancedLayoutClient);
		var fieldLayout	= target.layout;
		
	//	trace(target+"; explicit: "+targetLayout.explicitWidth+", "+targetLayout.explicitHeight+"; measured: "+targetLayout.measuredWidth+", "+targetLayout.measuredHeight+"; "+targetLayout.state.current+"; size: "+targetLayout.width+", "+targetLayout.height+"; field: "+fieldLayout.width+", "+fieldLayout.height+"; "+target.field.autoSize);
		updateOwner.disable();
		var updateW = (changes.has( LayoutFlags.WIDTH )  && ownerLayout.explicitWidth .isSet()); // || fieldLayout.width .notSet();
		var updateH = (changes.has( LayoutFlags.HEIGHT ) && ownerLayout.explicitHeight.isSet()); // || fieldLayout.height.notSet();
		if (updateW) { fieldLayout.width  = ownerLayout.width;	fieldLayout.percentWidth	= LayoutFlags.FILL; }
		if (updateH) { fieldLayout.height = ownerLayout.height;	fieldLayout.percentHeight	= LayoutFlags.FILL; }
		
		if (ownerLayout.explicitWidth.notSet() || ownerLayout.explicitHeight.notSet())
			updateOwner.enable();
		
		trace("\t\t"+owner+": "+fieldLayout.width+", "+fieldLayout.height+"; fieldstate "+fieldLayout.state.current);
		
		if (changes.has( LayoutFlags.PADDING ))
		{
			if (ownerLayout.padding != null)
			{
				fieldLayout.x	= ownerLayout.padding.left;
				fieldLayout.y	= ownerLayout.padding.top;
			}
			else
			{
				fieldLayout.x	= fieldLayout.y	= 0;
			}
		}
		
		fieldLayout.validate();
	//	trace("2 "+targetLayout.state.current+"; "+targetLayout.changes+"; "+targetLayout.hasValidatedWidth+", "+targetLayout.hasValidatedHeight+"; "+targetLayout.width+", "+targetLayout.height);
	}
	
	
	private function updateOwnerSize (changes:Int)
	{
		if (changes.hasNone( LayoutFlags.WIDTH | LayoutFlags.HEIGHT ))
			return;
		
		var ownerLayout	= owner.layout.as(AdvancedLayoutClient);
		var fieldLayout	= target.layout;
		
		updateField.disable();
		ownerLayout.measuredWidth	= fieldLayout.width;
		ownerLayout.measuredHeight	= fieldLayout.height;
		updateField.enable();
		
	//	targetLayout.invalidate( LayoutFlags.WIDTH | LayoutFlags.HEIGHT );
	//	targetLayout.validate();
		trace("\t\t"+owner+": ms: "+ownerLayout.measuredWidth+", "+ownerLayout.measuredHeight+"; es: "+ownerLayout.explicitWidth+", "+ownerLayout.explicitHeight+"; s: "+ownerLayout.width+", "+ownerLayout.height);
	//	trace("\t\t"+targetLayout.hasValidatedWidth+", "+targetLayout.hasValidatedHeight+"; "+targetLayout.state.current);
	}
}