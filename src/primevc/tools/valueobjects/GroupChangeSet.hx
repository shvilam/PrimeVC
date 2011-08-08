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
 import primevc.core.collections.IRevertableList;
  using primevc.tools.valueobjects.ChangesUtil;
  using primevc.utils.IfUtil;


/**
 * Represents a group of changes applied on different value-objects.
 * The grouped changes can be undone/redone at once.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 27, 2011
 */
 class GroupChangeSet extends ChangeSet
{
    // Could come from freelist if profiling tells us to
    public static inline function make ()   { return new GroupChangeSet(); }
    
    
    public function add (change:ChangeSet)
    {
        untyped change.nextSet = nextSet;
        nextSet = change;
    }


#if debug
    public function toString ()
    {
        var output = [];
        
        var change = nextSet;
        while(change != null)
        {
            output.push( Std.string(change) );
            change = change.nextSet;
        }
        
        return "GroupChangeSet at " + Date.fromTime(timestamp)+"; changes: \n\t\t\t" + output.join("\n\t\t\t");
    }
#end
}
