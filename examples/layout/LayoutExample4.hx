/*
 * Copyright (c) 2012, The PrimeVC Project Contributors
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
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package examples.layout;
 import primevc.gui.core.UIComponent;
 import primevc.gui.core.UIGraphic;

/**
 * LayoutExample4 is identical to LayoutExample1-3, but uses css for styling.
 *
 * @author			Ruben Weijers
 * @creation-date	Jan 25, 2012
 */
class LayoutExample4 extends primevc.gui.core.UIWindow
{
	public static function main ()
		primevc.gui.display.Window.startup(function (stage) { return new LayoutExample4(stage); })


	override private function createChildren () {
		for (i in 0...20)	attach( new UIGraphic() );
		for (i in 0...20)	attach( new UIComponent() );
		for (i in 0...20)	attach( new UIGraphic() );
	}
}