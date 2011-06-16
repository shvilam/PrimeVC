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
 import primevc.core.net.CommunicationType;
 import primevc.gui.behaviours.UpdateMaskBehaviour;
 import primevc.core.Bindable;

 import primevc.gui.components.Label;
 import primevc.gui.components.ProgressBar;

 import primevc.gui.core.UIGraphic;
 import primevc.gui.core.Skin;

 import primevc.gui.display.VectorShape;
 import primevc.gui.layout.RelativeLayout;
 import primevc.gui.graphics.shapes.Circle;

  using primevc.utils.NumberUtil;
  using primevc.utils.Bind;


/**
 * Circle loader skin for the ProgressBar component. Use the following style-names
 * to style the different parts of the skin
 * 	- ProgressBar				-> style for the complete circle (i.e. background, border)
 * 	- ProgressBar #indicator	-> style for the filled part of the circle that indicates the progress
 * 
 * @author Ruben Weijers
 * @creation-date Apr 19, 2011
 */
class CircleProgressSkin extends Skin<ProgressBar>
{
	private var label		: Bindable<String>;
	private var indicator	: UIGraphic;
	private var labelField	: Label;
	

	override private function createBehaviours ()
	{
		label = new Bindable<String>();
	//	labelPrefix	= owner.source.type == CommunicationType.loading ? 'Laden: ' : 'Uploaden: ';
		update.on( owner.data.perc.change, this );
	}
	
	
	override private function removeBehaviours ()
	{
		if (label != null) {
			label.dispose();
			label = null;
		}
		
		owner.data.perc.change.unbind(this);
		super.removeBehaviours();
	}


	override public function createChildren ()
	{
		indicator	= new UIGraphic("indicator");
		labelField	= new Label(null, label);
		
		//put labelfield in the center
		var r = labelField.layout.relative = new RelativeLayout();
		r.hCenter = r.vCenter = 0;
		
		owner.attach( indicator ).attach( labelField );
		
		//override their default shape to a circle
		indicator.graphicData.shape			= owner.graphicData.shape = new Circle();
		indicator.graphicData.percentage	= owner.data.percentage;
		indicator.layout.percentWidth		= indicator.layout.percentHeight = 1;
	}


	override public  function removeChildren ()
	{
		if (indicator != null)
		{
			indicator.dispose();
			labelField.dispose();
			label.dispose();

			indicator	= null;
			labelField	= null;
			label		= null;
		}
	}


	//
	// EVENTHANDLERS
	//

	private function update (newVal:Float, oldVal:Float)
	{
		label.value = (newVal * 100).roundFloat() + "%";
		indicator.graphicData.percentage = newVal;
	}
}