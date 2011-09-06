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
 *  Ruben Weijers   <ruben @ rubenw.nl>
 */
package primevc.gui.components;
 import primevc.core.collections.ListChange;
 import primevc.core.dispatcher.Wire;
 import primevc.core.Bindable;
 
 import primevc.gui.core.IUIDataElement;
 import primevc.gui.core.UIElementFlags;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.display.IInteractiveObject;
 
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.events.MouseEvents;
 
 import primevc.gui.input.KeyCodes;
 import primevc.gui.traits.ISelectable;
 
  using primevc.gui.input.KeyCodes;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


/**
 * ListView with support for selecting / deselecting item-renderers, even when
 * they are not rendered yet.
 * Currently only one item-renderer can be selected at the same time..
 * 
 * @author Ruben Weijers
 * @creation-date Jun 29, 2011
 */
class SelectableListView<ListDataType> extends ListView<ListDataType>
{
    private static inline var CURRENT_FOCUS = 1 << 30;
    
	/**
	 * holds the currently selected data
	 */
    public var selected             (default, null) : Bindable<ListDataType>;
    
    /**
     * Cached value of the last selected list-data. Needed to deselect item-renderers
     * in validate
     */
    private var previousSelected    : ListDataType;
    
    //
    // KEYBOARD NAVIGATION SUPPORT
    //
    
    /**
     * wire used to update the current focus reference
     */
	private var mouseMoveWire	    : Wire<MouseState -> Void>;
	private var invalidateWire      : Wire<Dynamic>;
	
	/**
	 * property with the data-index of the current item-renderer with focus.
	 * The focus can be changed by using the keyboard or the mouse.
	 */
	private var focusIndex          : Int;
	private var currentFocus        : IUIDataElement<ListDataType>;
    
    
    override private function createBehaviours ()
    {
		selected        = new Bindable<ListDataType>();
		focusIndex      = -1;
		
        handleChildChange.on( children.change, this );
        enableNavigtion	 .on( displayEvents.addedToStage, this );
		disableNavigation.on( displayEvents.removedFromStage, this );
		
        //save wire for invalidation.. if the selection is with the mouse/keyboard, there's no need to invalidate the selection
        invalidateWire  = invalidateSelection   .on( selected.change, this );
		mouseMoveWire	= checkHoveredItem      .on( userEvents.mouse.move, this );
		updateFocusAfterScroll                  .on( userEvents.mouse.scroll, this );
		mouseMoveWire.disable();
		
        super.createBehaviours();
    }
    
    
    override public function dispose ()
    {
        if (isDisposed())
            return;
        
        children.change.unbind(this);
        
        invalidateWire  .dispose();
        mouseMoveWire	.dispose();
        selected        .dispose();
        
		mouseMoveWire	= null;
		invalidateWire  = null;
        
        super.dispose();
    }
    
    
    override public function validate ()
    {
        //must cache the value of changes since super.validate will change this value to '0' when it's done
        var changes = this.changes;

        // first validate the super method to make sure the data is initialized before selecting an item-renderer
        super.validate();

        // check if there's a change in the selected data.
        if (changes.has(UIElementFlags.SELECTED))
        {
            if (previousSelected != null)
            {
                // Check if there's a renderer for the previous selected vo.
                // If there isn't, the deselecting is handled by 'handleChildChange'
                var r = getRendererFor( previousSelected );
                if (r != null && r.is(ISelectable))
                    r.as(ISelectable).deselect();
            }
            
            if (selected.value != null)
            {
                // Check if there's a renderer for the new selected value.
                // If there isn't, the list should scroll to the selected data position
                // and the selecting part is handled by 'handleChildChange'.
#if debug       Assert.notNull(data, "SelectableListView must have data if it needs to select a value"); #end
        /*      var d = getDepthFor(selected.value);
                if (d > -1)
                    Assert.that(d < children.length, this+": "+selected.value+" depth is "+d+" but doesn't exist. Children length: "+children.length+"; changes: "+changes);
#end*/
                var r = getRendererFor(selected.value);
                if (r != null)
                {
                    if (r.is(ISelectable))
                        r.as(ISelectable).select();
                    focusRenderer(r);
                }
                else
                {
                    currentFocus = null;
                    focusIndex   = data.indexOf(selected.value);
                    layoutContainer.scrollToDepth( focusIndex );
                }
            }
            
            previousSelected = null;
        }
        
        if (changes.has(CURRENT_FOCUS) && focusIndex > -1)
            focusRendererAt(focusIndex);
    }


    override private function removeData ()
    {
        blurRenderers();
        deselectRenderers();
        super.removeData();
    }
    
    
    private inline function focusRenderer (child:IUIDataElement<ListDataType>)
    {
        if (currentFocus != child || focusIndex == -1)
        {
            if (isOnStage() && child.is(IInteractiveObject))
                window.focus = child.as(IInteractiveObject);
            
            currentFocus     = child;
            focusIndex       = depthToIndex( children.indexOf(child) );
        }
    }
    
    
    private inline function focusRendererAt (index:Int)
    {
        if (focusIndex != index || currentFocus == null)
        {
            Assert.that(index > -1);
            focusIndex   = index;
            currentFocus = getRendererAt( indexToDepth(index) );

            if (currentFocus != null)
            {
                if (isOnStage() && currentFocus.is(IInteractiveObject))
                    window.focus = currentFocus.as(IInteractiveObject);
                
                layoutContainer.scrollTo(currentFocus.layout);
            }
            else
            {
                layoutContainer.scrollToDepth(index);
				invalidate( CURRENT_FOCUS );
            }
        }
    }
    
    
    private inline function blurRenderers ()
    {
        if (isOnStage() && window.focus == currentFocus.as(IInteractiveObject))
            window.focus = null;
        
        currentFocus = null;
        focusIndex   = -1;
    }


    public inline function deselectRenderers ()
    {
        previousSelected = null;
        selected         = null;
    }
    
    
    
    //
    // EVENTHANDLERS
    //
    
    private function handleChildChange (change:ListChange<IDisplayObject>)
    {
        switch (change)
        {
            case added(r, newPos):
                if (r.is(ISelectable)) {
                    var r = r.as(ISelectable);
                    if (getRendererData(cast r) == selected.value)  r.select();
                    if (depthToIndex(newPos) == focusIndex)         focusRenderer(cast r);
                }
            
            case removed(r, oldPos):
                if (r.is(ISelectable) && getRendererData(cast r) == selected.value)
                    r.as(ISelectable).deselect();
            
            case moved(r, newPos, oldPos):
                if (r.is(ISelectable))
                {
                    var r = r.as(ISelectable);
                    r.selected.value = getRendererData(cast r) == selected.value;
                    
                    if (depthToIndex(newPos) == focusIndex)
                        focusRenderer(cast r);
                }
            
            case reset:
        }
    }
    
    
    private function invalidateSelection (newVO:ListDataType, oldVO:ListDataType)
    {
        // If previousSelected isn't null, it means that the value is already 
        // changed but not yet validated. In that case, the previousSelected shouldn't change
        if (previousSelected == null)
            previousSelected = oldVO;
        
        invalidate(UIElementFlags.SELECTED);
    }
    
    
    private function enableNavigtion ()
    {
	    if (!mouseMoveWire.isEnabled()) {
	        changeSelectedItem.on( userEvents.key.down, this );
		    mouseMoveWire.enable();
	    }
    }
    
    
    private function disableNavigation ()
    {
        if (mouseMoveWire.isEnabled()) {
            userEvents.key.down.unbind(this);
		    mouseMoveWire.disable();
	    }
	    
	    blurRenderers();
    }
    
    
    private function changeSelectedItem (event:KeyboardState)
	{
		var index	= focusIndex;
		if (index == -1)
		    index   = depthToIndex(0);
		
		var k		= event.keyCode();
		var max		= data.length - 1;
		
		if (k.isEnter())
		{
		    if (index > -1) {
		        invalidateWire.disable();
		        selected.value = data.getItemAt(index);
		        invalidateWire.enable();
	        }
		}
		else
		{
			if		(k == KeyCodes.UP)		index -= 1;
			else if (k == KeyCodes.DOWN)	index += 1;
			else if (k == KeyCodes.PAGE_UP	 || k == KeyCodes.HOME)		index = 0;
			else if (k == KeyCodes.PAGE_DOWN || k == KeyCodes.END)		index = max;
			
			// TODO: check if a-z is pressed to select items that start with that letter
			
			if (index.isWithin(0, max))
	            focusRendererAt( index );
		}
	}
	
	
	private function checkHoveredItem (mouse:MouseState) : Void
	{
		var target = mouse.target.as(IUIDataElement);
		if (target == null || target == cast currentFocus)
			return;
		
	    focusRenderer( cast target );
	}
	
	
	private function updateFocusAfterScroll (mouse:MouseState)
	{
	    var target = mouse.target;
	    if (target != null && target.is(IUIDataElement) && target.is(IInteractiveObject))
	        focusRenderer(cast target);
	}
}