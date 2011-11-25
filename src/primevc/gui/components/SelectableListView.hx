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
 import primevc.core.dispatcher.Signal0;
 import primevc.core.Bindable;
 
 import primevc.gui.core.IUIDataElement;
 import primevc.gui.core.UIElementFlags;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.display.IInteractiveObject;
 
 import primevc.gui.events.MouseEvents;
 import primevc.gui.traits.ISelectable;
 
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.IfUtil;
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
     * Signal is fired when the user selects an item from the list. This signal is also
     * fired when the user selects an item that is already selected ('selected.changed' 
     * won't be fired then).
     *
     * This signal is needed when i.e. the ListView is used in a comboBox then needs to
     * be closed after the user tried to select an item. 
     */
    public  var itemSelected        (default, null) : Signal0;

    /**
     * Cached value of the last selected list-data. Needed to deselect item-renderers
     * in validate
     */
    private var previousSelected    : ListDataType;
    /**
     * property with the data-index of the current item-renderer with focus.
     * The focus can be changed by using the keyboard or the mouse.
     */
    public  var focusIndex          (default, null) : Int;
    public  var currentFocus        (default, null) : IUIDataElement<ListDataType>;
    
    
    override private function createBehaviours ()
    {
        super.createBehaviours();

        itemSelected    = new Signal0();
		selected        = new Bindable<ListDataType>();
		
        handleChildChange   .on( children.change, this );
        handleRendererClick .on( childClick, this );
		
        // store wire for invalidation.. if the selection is with the mouse/keyboard, there's no need to invalidate the selection
        invalidateSelection.on( selected.change, this );

        if (selected.value.notNull() && focusIndex == -1)
            focusRendererAt(data.indexOf(selected.value));
    }
    
    
    override public function dispose ()
    {
        if (isDisposed())
            return;
        
        children.change.unbind(this);

        itemSelected    .dispose();
        selected        .dispose();
        itemSelected    = null;
        selected        = null;
        
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
            if (previousSelected.notNull())
            {
                // Check if there's a renderer for the previous selected vo.
                // If there isn't, the deselecting is handled by 'handleChildChange'
                var r = getRendererFor( previousSelected );
                if (r.notNull() && r.is(ISelectable))
                    r.as(ISelectable).deselect();
            }
            
            if (selected.value.notNull())
            {
                // Check if there's a renderer for the new selected value.
                // If there isn't, the list should scroll to the selected data position
                // and the selecting part is handled by 'handleChildChange'.
                var r = getRendererFor(selected.value);
                if (r.notNull())
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
        if (currentFocus != null)
            blurRenderers();
        deselectRenderers();
        super.removeData();
    }



    //
    // RENDERER METHODS
    //
    

    public inline function select (item:ListDataType)
    {
        selected.value = item;
        itemSelected.send();
    }


    public inline function deselectRenderers ()
    {
        previousSelected = null;
        selected         = null;
    }

    
    public  function blurRenderers ()
    {
        if (isOnStage() && window.focus == currentFocus.as(IInteractiveObject))
            window.focus = null;
        
        currentFocus = null;
        focusIndex   = -1;
    }

    
    public function focusRenderer (child:IUIDataElement<ListDataType>)
    {
        if (currentFocus != child || focusIndex == -1)
        {
            if (isOnStage() && child.is(IInteractiveObject))
                window.focus = child.as(IInteractiveObject);
            
#if flash9  Assert.equal(child.parent, this, child+" should be a direct child of "+this); #end
            currentFocus     = child;
            focusIndex       = depthToIndex( children.indexOf(child) );
        }
    }
    
    
    public function focusRendererAt (index:Int)
    {
        if (focusIndex != index || currentFocus.isNull())
        {
            Assert.that(index > -1);
            focusIndex   = index;
            currentFocus = getRendererAt( indexToDepth(index) );

            if (currentFocus.notNull())
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
    
    
    
    //
    // EVENTHANDLERS
    //
    
    private function handleChildChange (change:ListChange<IDisplayObject>)
    {
        switch (change)
        {
            case added(r, newPos):
                if (r.is(ISelectable) && getRendererData(cast r) == selected.value)
                    r.as(ISelectable).select();
                
                if (depthToIndex(newPos) == focusIndex)
                    focusRenderer(cast r);
            
            case removed(r, oldPos):
                if (r.is(ISelectable) && getRendererData(cast r) == selected.value)
                    r.as(ISelectable).deselect();
                
                if (currentFocus == r)
                    currentFocus = null;
            
            case moved(r, newPos, oldPos):
                if (r.is(ISelectable))
                    r.as(ISelectable).selected.value = getRendererData(cast r) == selected.value;
                
                if (depthToIndex(newPos) == focusIndex)
                    focusRenderer(cast r);
            
            case reset:
        }
    }


    /**
     * Method is called when an item-renderer in the list is clicked. The
     * method will try to update the value of the combobox.
     */
    private function handleRendererClick (mouseEvt:MouseState) : Void
    {
        if (mouseEvt.target.notNull())
            select( getRendererData( cast mouseEvt.target) );
    }
    
    
    private function invalidateSelection (newVO:ListDataType, oldVO:ListDataType)
    {
        // If previousSelected isn't null, it means that the value is already 
        // changed but not yet validated. In that case, the previousSelected shouldn't change
        if (previousSelected.isNull())
            previousSelected = oldVO;
        
        invalidate(UIElementFlags.SELECTED);
    }
}