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
package primevc.gui.traits;
 import primevc.core.geom.Rectangle;
 import primevc.gui.layout.IScrollableLayout;


/**
 * @author Ruben Weijers
 * @creation-date Aug 02, 2010
 */
interface IScrollable implements IDisplayable, implements IInteractive
{
	public var scrollableLayout (getScrollableLayout, never) : IScrollableLayout;
	
	/**
	 * Flag indicating wether there's a behaviour for scrolling the container or
	 * not.
	 * @default	false
	 */
	public var isScrollable		: Bool;

//#if flash9
//  public var scrollRect       : primevc.core.geom.Rectangle;
//#end
    /** set's the scrollRect.x position to the given x **/
    public function scrollToX        (x:Float) : Void;
    /** set's the scrollRect.y position to the given y **/
    public function scrollToY        (y:Float) : Void;
    public function scrollTo         (x:Float, y:Float) : Void;
    /** updates the scrollRect.x position to scrollableLayout.scrollPos.x **/
    public function applyScrollX     () : Void;
    /** updates the scrollRect.x position to scrollableLayout.scrollPos.x **/
    public function applyScrollY     () : Void;
    /** set's the scrollRect size to the given width and height **/
    public function setClippingSize  (w:Float, h:Float) : Void;

    public function createScrollRect (w:Float, h:Float): Void;
    public function removeScrollRect ()                : Void;
    
    public function getScrollRect    ()                : Rectangle;
    public function setScrollRect    (v:Rectangle)     : Rectangle;

    /**
     * Method which should cause the object to start listening to 
     * layout.scrollPos and layout.size changes and apply them
     */
    public function enableClipping    () : Void;

    /**
     * Method in which the object stops listening to 
     * layout.scrollPos and layout.size changes
     */
    public function disableClipping   () : Void;
}