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
package primevc.utils;
 import primevc.core.geom.Matrix2D;
 import primevc.core.geom.Rectangle;
  using primevc.utils.Formulas;
 

/**
 * Helper class for working with float-matrices
 * 
 * @creation-date   Oct 04, 2011
 * @author          Ruben Weijers
 */
extern class MatrixUtil
{
    /**
     * Rotates an IPositionable object around the given anchor
     *
     * @param   m           matrix to rotate
     * @param   rotation    rotation in degrees
     * @param   anchorX     x-coordinate to rotate around (relative to the object -> 0 is leftside of the object)
     * @param   anchorY     y-coordinate to rotate around (relative to the object -> 0 is topside of the object)
     * @param   leftPos     x-coordinate of the leftside of the already rotated object (doesn't have to be equal to object.x if it's already rotated)
     * @param   topPos      y-coordinate of the leftside of the already rotated object (doesn't have to be equal to object.y if it's already rotated)
     */
    public static inline function rotateAroundPoint (m:Matrix2D, rotation:Float, anchorX:Float, anchorY:Float, leftPos:Float, topPos:Float) : Void
    {
        m.translate( -(anchorX + leftPos), -(anchorY + topPos) );
        m.rotate( rotation.degreesToRadians() );
        m.translate( anchorX + leftPos, anchorY + topPos );
    }


    public static inline function rotateAroundCenter (m:Matrix2D, rotation:Float, bounds:Rectangle) : Void
    {
        rotateAroundPoint(m, rotation, bounds.width * .5, bounds.height * .5, bounds.left, bounds.top);
    }
}