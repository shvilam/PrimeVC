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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.components.skins;
 import primevc.core.Bindable;
 import primevc.gui.behaviours.components.DirectToolTipBehaviour;
 import primevc.gui.components.DataButton;
 import primevc.gui.core.Skin;
 import primevc.gui.core.UIGraphic;
 import primevc.gui.core.UITextField;
 import primevc.gui.layout.algorithms.RelativeAlgorithm;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.RelativeLayout;
 import primevc.types.Number;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberMath;


/**
 * Buttonskin to display a IOS/android look-a-like sliding toggle-button
 * 
 * @author Ruben Weijers
 * @creation-date Mar 10, 2011
 */
class SlidingToggleButtonSkin extends Skin<DataButton<Null<Bool>>>
{
	
	/**
	 * The graphic that will be moved to the left when the button is toggled 'off'
	 * and to the right when the button is toggled 'on'.
	 */
	private var slideBtn		: UIGraphic;
	
	/**
	 * Color behind the 'onIcon'
	 */
	private var onBg			: UIGraphic;
	
	/**
	 * Stripe which is visible when the button is toggled on. The stripe
	 * represents an '1'.
	 */
//	private var onIcon			: UIGraphic;
	private var onLabel			: UITextField;
	
	/**
	 * Open circle which is visible when the button is toggled off. The circle
	 * represents an '0'.
	 */
//	private var offIcon			: UIGraphic;
	private var offLabel		: UITextField;
	
	
	/**
	 * Label with the value of the owner.data.value + on/off
	 */
//	private var tooltipLabel	: Bindable<String>;
	
	
	override private function createBehaviours ()
	{
	//	tooltipLabel = new Bindable<String>(owner.data.value);
		
		behaviours.add( new DirectToolTipBehaviour( owner, owner.data ) );
		trace(owner.data.value);
		
		owner.getLabelForVO = getButtonLabel;
	//	updateToolTip		.on( owner.data.change, this );
		owner.toggleSelect	.on( owner.userEvents.mouse.click, this );
		slide				.on( owner.selected.change, this );
		
		owner.vo.pair( owner.selected );
	}
	
	
	override private function removeBehaviours ()
	{
		super.removeBehaviours();
	//	tooltipLabel.dispose();
	//	tooltipLabel = null;
		owner.getLabelForVO = null;
		owner.vo.unbind( owner.selected );
		
		owner.layout.changed.unbind(this);
		owner.data.change.unbind(this);
		owner.userEvents.mouse.click.unbind(this);
		owner.selected.change.unbind(this);
	}
	
	
	override public function createChildren ()
	{
		slideBtn	= new UIGraphic("slide");
		onBg		= new UIGraphic("onBg");
	//	onIcon		= new UIGraphic("onIcon");
	//	offIcon		= new UIGraphic("offIcon");
		onLabel		= new UITextField("onLabel");
		offLabel	= new UITextField("offLabel");
		
		onLabel.data.value			= "aan";
		offLabel.data.value			= "uit";
		slideBtn.layout.relative	= new RelativeLayout();
	//	offIcon.layout.maintainAspectRatio	= true;
	//	offIcon.layout.resize(10,10);
		
		var l = owner.layoutContainer;
		var c = owner;
		
		l.children.add( onBg.layout );
		l.children.add( offLabel.layout );
		l.children.add( onLabel.layout );
	//	l.children.add( offIcon.layout );
	//	l.children.add( onIcon.layout );
		l.children.add( slideBtn.layout );
		c.children.add( onBg );
	//	c.children.add( offIcon );
	//	c.children.add( onIcon );
		c.children.add( offLabel );
		c.children.add( onLabel );
		c.children.add( slideBtn );
		
		l.algorithm = new RelativeAlgorithm();
		positionIcons.on( l.changed, this );	//update the position of the on/off icons
		positionIcons(LayoutFlags.SIZE);
		slide();
	}
	
	
	override private function removeChildren ()
	{
		var l = owner.layoutContainer.children;
		var c = owner.children;
		
		c.remove( onBg );
	//	c.remove( offIcon );
	//	c.remove( onIcon );
		c.remove( offLabel );
		c.remove( onLabel );
		c.remove( slideBtn );
	//	l.remove( offIcon.layout );
	//	l.remove( onIcon.layout );
		l.remove( offLabel.layout );
		l.remove( onLabel.layout );
		l.remove( onBg.layout );
		l.remove( slideBtn.layout );
	}
	
	
	
	//
	// EVENTHANDLERS
	//
	
	
	private function slide ()
	{
		var isSelected:Null<Bool>	= owner.selected.value;
		var slideLayout				= slideBtn.layout.relative;
		
		if (isSelected == null) {
			slideLayout.left	= slideLayout.right = Number.INT_NOT_SET;
			slideLayout.hCenter	= 0;
		}
		else if (isSelected) {
			slideLayout.left	= slideLayout.hCenter = Number.INT_NOT_SET;
			slideLayout.right	= 0;
		}
		else {
			slideLayout.right	= slideLayout.hCenter = Number.INT_NOT_SET;
			slideLayout.left	= 0;
		}
		updateOnBackground();
	//	updateToolTip();
	}
	
	
	private function positionIcons (changes:Int)
	{
		if (changes.hasNone( LayoutFlags.SIZE ))
			return;
		
		Assert.notNull( owner );
		Assert.notNull( owner.layout );
		var bounds = owner.layout.innerBounds;
	//	onIcon.layout.innerBounds	.centerX = (bounds.width * .30).roundFloat();
	//	offIcon.layout.innerBounds	.centerX = (bounds.width * .75).roundFloat();
		onLabel.layout.innerBounds	.centerX = (bounds.width * .25).roundFloat();
		offLabel.layout.innerBounds	.centerX = (bounds.width * .75).roundFloat();
		updateOnBackground();
	}
	
	
	private inline function updateOnBackground ()
	{
		var l = owner.layout.innerBounds;
		onBg.layout.outerBounds.width = (l.width * (owner.selected.value ? 0.6 : 0.5)).roundFloat();
	}
	
	
	private function getButtonLabel (newVal:Bool)
	{
	//	trace(owner.defaultLabel);
	//	trace(newVal);
		return owner.defaultLabel + ": " + (newVal ? "aan" : "uit");
	}
	
	
/*	override public function drawGraphics ()
	{
		trace("draw stripe");
#if flash9
		var l = slideBtn.layout.innerBounds;
		var g = slideBtn.graphics;
		
		var padding	= 3;
		var height	= l.height - (padding * 2);
		var x		= (l.width * .5) - (padding * .5) - .5;
		g.lineStyle( 1.5, 0x9b9b9b, 1.0 );
		g.moveTo( x, padding );
		g.lineTo( x, height );
		
		var x = l.centerX + (padding * .5) + .5;
		g.moveTo( x, padding );
		g.lineTo( x, height );
#end
	}*/
}