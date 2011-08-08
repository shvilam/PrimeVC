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
 *  Danny Wilson    <danny @ onlinetouch.nl>
 */
package primevc.tools.valueobjects;
 import primevc.core.collections.ListChange;
 import primevc.utils.FastArray;
  using primevc.utils.FastArray;
  using primevc.utils.IfUtil;


/**
 * @author Danny Wilson
 * @creation-date Dec 03, 2010
 */
class ListChangeVO extends PropertyChangeVO
{
    public static inline function make(propertyID, changes : FastArray<ListChange<Dynamic>>)
    {
        var l = new ListChangeVO(); // Could come from freelist if profiling tells us to
        l.propertyID = propertyID;
        l.changes    = changes.clone();
        return l;
    }
    
    
    public var changes : FastArray<ListChange<Dynamic>>;
    private function new() {}
    
    
    override public function dispose()
    {
        if (this.changes.notNull()) {
            for (i in 0 ... this.changes.length) changes[i] = null;
            this.changes = null;
        }
        super.dispose();
    }
    
    
#if debug
    public function toString ()
    {
        var output = [];
        for (change in changes)
            output.push( change );
        
        return output.length > 0 ? "\n\t\t\t\t" + output.join("\n\t\t\t\t") : "no-changes";
    }
#end
}
