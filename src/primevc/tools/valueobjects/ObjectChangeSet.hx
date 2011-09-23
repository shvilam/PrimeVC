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
  using primevc.utils.TypeUtil;


/**
 * Group of changes applied on a value-object in one commit.
 * 
 * @author Danny Wilson
 * @creation-date Dec 03, 2010
 */
class ObjectChangeSet extends ChangeSet
{
    public static inline function make (vo:ValueObjectBase, changes:Int)
    {
        var s = new ObjectChangeSet();  // Could come from freelist if profiling tells us to
        s.vo = vo;
        s.propertiesChanged = changes;
        return s;
    }
    
    public var vo                   (default, null) : ValueObjectBase;
    public var parent               (default, null) : ObjectPathVO;
    public var propertiesChanged    (default, null) : Int;
    
    
    public function add (change:PropertyChangeVO)
    {
        untyped change.next = next;
        next = change;
    }
    
    public function has (propertyID : Int) : Bool   { return (propertiesChanged & (1 << ((propertyID & 0xFF) + untyped vo._fieldOffset(propertyID >>> 8)))).not0(); }
    
    
    public inline function addChange (id:Int, flagBit:Int, value:Dynamic)
    {
        if (flagBit.not0())
            add(PropertyValueChangeVO.make(id, null, value));
    }
    
    
    public inline function addBindableChange<T> (id:Int, flagBit:Int, oldValue:Dynamic, value:Dynamic)
    {
        if (flagBit.not0())
            add(PropertyValueChangeVO.make(id, oldValue, value));
    }
    
    
    public inline function addListChanges<T> (id:Int, flagBit:Int, list:IRevertableList<T>)
    {
        if (flagBit.not0())
            add(ListChangeVO.make(id, list.changes));
    }
    
    
#if debug
    public function toString ()
    {
        var output = [];
        
        var change = next;
        while(change != null)
        {
            if (change.is(PropertyChangeVO))    output.push( vo.propertyIdToString( change.as(PropertyChangeVO).propertyID ) + ": " + change );
            else                                output.push( Std.string(change) );
            
            change = change.next;
        }
        
        return "ObjectChangeSet at " + Date.fromTime(timestamp) + " on "+vo+"; changes: \n\t\t\t" + output.join("\n\t\t\t");
    }
#end
}
