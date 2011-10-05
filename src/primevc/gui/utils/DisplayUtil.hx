/*
 * Copyright (c) 2011, The PrimeVC Project Contributors
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
 *  Ruben Weijers   <ruben @ rubenw.nl>
 */
package primevc.gui.utils;
 import primevc.gui.display.IDisplayObject;
  using primevc.utils.MatrixUtil;
 

/**
 * Helper class for working with display-objects
 * 
 * @creation-date   Oct 04, 2011
 * @author          Ruben Weijers
 */
extern class DisplayUtil
{
    /**
     * Rotates an DisplayObject object around the given anchor
     *
     * @param   target      object to rotate
     * @param   rotation    rotation in degrees
     */
    public static inline function rotateAroundCenter (target:IDisplayObject, rotation:Float) : Void
    {
        var m = target.transform.matrix;
        var r = target.rotation >= 0 ? target.rotation : 360 + target.rotation;
        m.rotateAroundCenter(rotation - r, target.getBounds(target.parent));
        target.transform.matrix = m;
    }
}