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
 *  Danny Wilson    <danny @ onlinetouch.nl>
 */
package primevc.gui.events;
 import primevc.core.dispatcher.Signals;
 import primevc.core.geom.Point;
 import primevc.core.traits.IClonable;
 import primevc.gui.events.KeyModState;


typedef TouchEvents = 
    #if     flash9  primevc.avm2.events.TouchEvents;
    #elseif flash   primevc.avm1.events.TouchEvents;
    #elseif js      primevc.js  .events.TouchEvents;
    #elseif neko    primevc.neko.events.TouchEvents;
    #else           #error; #end

typedef TouchHandler    = TouchState -> Void;
typedef TouchSignal     = primevc.core.dispatcher.Signal1<TouchState>;


/**
 * Cross-platform touch events.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 10, 2011
 */
class TouchSignals extends Signals
{
    /** Fires to indicate when the user places a touch point on the touch surface. */
    public var start        (getStart,  null) : TouchSignal;
    /** Fires when the user removes a touch point from the touch surface, also including cases where the touch point physically leaves the touch surface, such as being dragged off of the screen */
    public var end          (getEnd,    null) : TouchSignal;
    /** Fires to indicate when the user moves a touch point along the touch surface. */
    public var move         (getMove,   null) : TouchSignal;
    /** Fires when the user removes a touch point from the touch surface, also including cases where the touch point physically leaves the touch surface, such as being dragged off of the screen */
    public var cancel       (getCancel, null) : TouchSignal;
    
    
    private inline function getStart ()     { if (start == null)        { createStart(); }  return start; }
    private inline function getEnd ()       { if (end == null)          { createEnd(); }    return end; }
    private inline function getMove ()      { if (move == null)         { createMove(); }   return move; }
    private inline function getCancel ()    { if (cancel == null)       { createCancel(); } return cancel; }
    
    
    private function createStart ()         { Assert.abstract(); }
    private function createEnd ()           { Assert.abstract(); }
    private function createMove ()          { Assert.abstract(); }
    private function createCancel ()        { Assert.abstract(); }
}

/**
 * State information sent by TouchSignal.
 * 
 * @author Danny Wilson
 * @author Ruben Weijers
 * @creation-date Nov 10, 2011
 */
class TouchState implements IClonable<TouchState>, implements haxe.Public
{
    public static inline var fake = new TouchState( null, null, null );
    
    /**
     * Target of the event
     */  
    var target  (default,null)      : UserEventTarget;
    var local   (default,null)      : Point;
    var stage   (default,null)      : Point;
    
    
    public function new(t:UserEventTarget, l:Point, s:Point)
    {
        this.target = t;
        this.local  = l;
        this.stage  = s;
    }
    
#if flash9
    public inline function isDispatchedBy (obj:UserEventTarget) : Bool
    {
        return obj != null && obj == related;
    }
#end
    
    
    public inline function clone () : TouchState
    {
        return new TouchState(target, local, stage);
    }
    
    
#if debug
    public var owner : TouchSignal;
    
    public function toString () {
        return "TouchState of "+owner+"; pos: "+local;
    }
#end
}
