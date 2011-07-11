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
 *  Ruben Weijers   <ruben @ onlinetouch.nl>
 */
package primevc.gui.core;
 import primevc.core.dispatcher.Wire;
 import primevc.core.Bindable;
 
 import primevc.gui.behaviours.layout.ValidateLayoutBehaviour;
 import primevc.gui.behaviours.BehaviourList;
 import primevc.gui.display.BitmapData;
 import primevc.gui.display.BitmapShape;
 import primevc.gui.effects.UIElementEffects;
 import primevc.gui.layout.ILayoutContainer;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.managers.ISystem;
 import primevc.gui.states.UIElementStates;
#if flash9
 import primevc.core.collections.SimpleList;
 import primevc.gui.styling.UIElementStyle;
#end
 import primevc.gui.traits.IValidatable;
 import primevc.types.Number;
 import primevc.utils.Formulas;
  using primevc.gui.utils.UIElementActions;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;


/**
 * @author Ruben Weijers
 * @creation-date Jul 08, 2011
 */
class UIBitmap extends BitmapShape, implements IUIElement
{
    public var prevValidatable  : IValidatable;
    public var nextValidatable  : IValidatable;
    private var changes         : Int;
    
    
    public var behaviours       (default, null)                 : BehaviourList;
    public var id               (default, null)                 : Bindable < String >;
    public var state            (default, null)                 : UIElementStates;
    public var effects          (default, default)              : UIElementEffects;
    
    public var layout           (default, null)                 : LayoutClient;
    public var system           (getSystem, never)              : ISystem;
    public var data             (getData, setData)              : BitmapData;
    
#if flash9
    public var style            (default, null)                 : UIElementStyle;
    public var styleClasses     (default, null)                 : SimpleList< String >;
    public var stylingEnabled   (default, setStylingEnabled)    : Bool;
#end
    
    
    public function new (idValue:String = null, data:BitmapData = null)
    {
        super(data);
#if debug
        if (idValue == null)
            idValue = this.getReadableId();
#end
        id      = new Bindable<String>(idValue);
        visible = false;
        changes = 0;
        init.onceOn( displayEvents.addedToStage, this );
        
        state           = new UIElementStates();
        behaviours      = new BehaviourList();
#if flash9
        styleClasses    = new SimpleList<String>();
        stylingEnabled  = true;
#end
        
        //add default behaviours
        behaviours.add( new ValidateLayoutBehaviour(this) );
        
        createBehaviours();
        createLayout();
        
        state.current = state.constructed;
    }


    override public function dispose ()
    {
        if (isDisposed())
            return;
        
        if (container != null)          detachDisplay();
        if (layout.parent != null)      detachLayout();
        
        data = null;
        //Change the state to disposed before the behaviours are removed.
        //This way a behaviour is still able to respond to the disposed
        //state.
        state.current = state.disposed;
        
        removeValidation();
        behaviours.dispose();
        state     .dispose();
        id        .dispose();
#if flash9
        if (style.target == this)
            style.dispose();
        
        styleClasses.dispose();
#end

        if (layout != null)         layout.dispose();
        
        id              = null;
#if flash9
        style           = null;
        styleClasses    = null;
#end
        state           = null;
        behaviours      = null;
        layout          = null;

        super.dispose();
    }


    public inline function isDisposed ()    { return state == null || state.is(state.disposed); }
    public inline function isInitialized () { return state != null && state.is(state.initialized); }
    public function isResizable ()          { return true; }
    
    
    //
    // METHODS
    //
    
    private function init ()
    {
        behaviours.init();
        validate();
        removeValidation.on( displayEvents.removedFromStage, this );
        updateScale     .on( layout.changed, this );
        
        state.current = state.initialized;
    }
    
    
    private function createLayout () : Void
    {
        layout = new AdvancedLayoutClient();
    }


    private function updateScale (changes:Int)
    {
        if (changes.has(LayoutFlags.SIZE) && data != null)
        {
            // Adjust the scale of the Bitmap since it's not allowed to change the size of 
            // the bitmapdata.
            var l = layout.as(AdvancedLayoutClient);
            scaleX = scaleY = Formulas.scale( l.measuredWidth, l.measuredHeight, l.width, l.height );
        }
    }
    
    
    //
    // ATTACH METHODS
    //
    
    public inline function attachLayoutTo   (t:ILayoutContainer, pos:Int = -1)  : IUIElement    { t.children.add( layout, pos );                                            return this; }
    public inline function detachLayout     ()                                  : IUIElement    { layout.parent.children.remove( layout );                                  return this; }
    public inline function attachTo         (t:IUIContainer, pos:Int = -1)      : IUIElement    { attachLayoutTo(t.layoutContainer, pos);   attachDisplayTo(t, pos);        return this; }
    public inline function detach           ()                                  : IUIElement    { detachDisplay();                          detachLayout();                 return this; }
    public inline function changeLayoutDepth(pos:Int)                           : IUIElement    { layout.parent.children.move( layout, pos );                               return this; }
    public inline function changeDepth      (pos:Int)                           : IUIElement    { changeLayoutDepth(pos);                   changeDisplayDepth(pos);        return this; }
    
    
    //
    // IPROPERTY-VALIDATOR METHODS
    //
    
    private var validateWire : Wire<Dynamic>;
    
    public function invalidate (change:Int)
    {
        if (change != 0)
        {
            changes = changes.set( change );
            
            if (changes == change && isInitialized())
                if      (system != null)        system.invalidation.add(this);
                else if (validateWire != null)  validateWire.enable();
                else                            validateWire = validate.on( displayEvents.addedToStage, this );
        }
    }
    
    
    public function validate ()
    {
        if (validateWire != null)
            validateWire.disable();
        
        changes = 0;
    }
    
    
    /**
     * method is called when the object is removed from the stage or disposed
     * and will remove the object from the validation queue.
     */
    private function removeValidation () : Void
    {
        if (isQueued() &&isOnStage())
            system.invalidation.remove(this);

        if (!isDisposed() && changes > 0)
            validate.onceOn( displayEvents.addedToStage, this );
    }
    
    
    
    //
    // GETTERS / SETTESR
    //
    
    private inline function getSystem () : ISystem      { return window.as(ISystem); }
    public inline function isOnStage () : Bool          { return window != null; }
    public inline function isQueued () : Bool           { return nextValidatable != null || prevValidatable != null; }
    

    private inline function setData (v:BitmapData) : BitmapData
    {
        var cur = getData();
        if (cur != v)
        {
#if flash9  bitmapData  = v;
#else       data        = v; #end
            var l       = layout.as(AdvancedLayoutClient);

            if (v != null)
            {
                l.measuredWidth  = v.width;
                l.measuredHeight = v.height;
            }
            else
                l.measuredWidth = l.measuredHeight = Number.INT_NOT_SET;
        }
        return v;
    }


    private inline function getData () : BitmapData
    {
        return #if flash9 bitmapData; #else data; #end
    }

    
#if flash9
    private function setStylingEnabled (v:Bool)
    {
        if (v != stylingEnabled)
        {
            if (stylingEnabled) {
                style.dispose();
                style = null;
            }
            
            stylingEnabled = v;
            if (v)
                style = new UIElementStyle(this, this);
        }
        return v;
    }
#end
    
    
    //
    // ACTIONS (actual methods performed by UIElementActions util)
    //

    public inline function show ()                      { this.doShow(); }
    public inline function hide ()                      { this.doHide(); }
    public inline function move (x:Int, y:Int)          { this.doMove(x, y); }
    public inline function resize (w:Int, h:Int)        { this.doResize(w, h); }
    public inline function rotate (v:Float)             { this.doRotate(v); }
    public inline function scale (sx:Float, sy:Float)   { this.doScale(sx, sy); }
    
    
    
    //
    // ABSTRACT METHODS
    //
    
    private function createBehaviours ()    : Void      {} //   { Assert.abstract(); }
    
    
#if debug
    override public function toString() { return id.value; }
#end
}