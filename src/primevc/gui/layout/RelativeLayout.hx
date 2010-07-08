package primevc.gui.layout;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.IDisposable;
 import primevc.core.Number;


/**
 * The relative layout class describes the wanted settings of a layout client
 * in relation with the layout-parent.
 * 
 * In a relative layout it's possible to set the prop 
 * 		horizontalCenter = 0
 * to make sure the layout is always centered in relation with it's layout
 * parent.
 * 
 * The parent can choose to apply or ignore the relative properties depending 
 * on the layout-algorithm that is uses. When the algorithm is positionating 
 * every layout-child next to eachother, the horizontalCenter will be ignored
 * for example.
 * 
 * This class is not meant for standalone use but should always be placed in
 * the LayoutClient.relative property.
 * 
 * @see		primevc.gui.layout.LayoutClient
 * 
 * @creation-date	Jun 22, 2010
 * @author			Ruben Weijers
 */
class RelativeLayout implements IDisposable
{
	/**
	 * Flag indicating if the relative-properties are enabled or disabled.
	 * When the value is false, it will still be possible to change the
	 * values but there won't be fired a change signal to let the layout-
	 * client now that it's changed.
	 * 
	 * @default	true
	 */
	public var enabled				: Bool;
	
	/**
	 * Signal to notify listeners that a property of the relative layout is 
	 * changed.
	 */
	public var changed				(default, null) : Signal0;
	
	
	//
	// CENTERING PROPERTIES
	//
	
	/**
	 * Defines at what horizontal-location the center of the layoutclient 
	 * should be placed in the center of the parent-layout.
	 * 
	 * @example
	 * 		layout.relative.hCenter = 10;
	 * 
	 * Will make the center of the layout be placed at 10px right from the 
	 * center of the parent.
	 * 
	 * @default		Number.NOT_SET
	 */
	public var hCenter		(default, setHCenter)	: Int;
	
	/**
	 * Defines at what vertical-location the center of the layoutclient 
	 * should be placed in the center of the parent-layout.
	 * 
	 * @example
	 * 		layout.relative.vCenter = 10;
	 * 
	 * Will make the center of the layout be placed at 10px below the 
	 * center of the parent.
	 * 
	 * @default		Number.NOT_SET
	 */
	public var vCenter		(default, setVCenter)	: Int;
	
	
	
	
	//
	// BOX PROPERTIES
	//
	
	/**
	 * Property defines the relative left position in relation with the parent.
	 * @example		
	 * 		client.relative.left = 10;	//left side of client will be 10px from the left side of the parent
	 * @default		Number.NOT_SET
	 */
	public var left					(default, setLeft)				: Int;
	/**
	 * Property defines the relative right position in relation with the parent.
	 * @see			primevc.gui.layout.RelativeLayout#left
	 * @default		Number.NOT_SET
	 */
	public var right				(default, setRight)				: Int;
	/**
	 * Property defines the relative top position in relation with the parent.
	 * @see			primevc.gui.layout.RelativeLayout#left
	 * @default		Number.NOT_SET
	 */
	public var top					(default, setTop)				: Int;
	/**
	 * Property defines the relative bottom position in relation with the parent.
	 * @see			primevc.gui.layout.RelativeLayout#left
	 * @default		Number.NOT_SET
	 */
	public var bottom				(default, setBottom)			: Int;
	
	
	public function new () 
	{
		changed	= new Signal0();
		hCenter	= Number.NOT_SET;
		vCenter	= Number.NOT_SET;
		left	= Number.NOT_SET;
		right	= Number.NOT_SET;
		bottom	= Number.NOT_SET;
		top		= Number.NOT_SET;
	}
	
	
	public function dispose ()
	{
		changed.dispose();
		changed = null;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setHCenter (v) {
		//unset left and right
		if (v != Number.NOT_SET)
			left = right = Number.NOT_SET;
		
		if (v != hCenter) {
			hCenter = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private function setVCenter (v) {
		//unset top and bottom
		if (v != Number.NOT_SET)
			top = bottom = Number.NOT_SET;
		
		if (v != vCenter) {
			vCenter = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	
	
	private inline function setLeft (v) {
		if (v != Number.NOT_SET)
			hCenter = Number.NOT_SET;
		
		if (v != left) {
			left = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private inline function setRight (v) {
		if (v != Number.NOT_SET)
			hCenter = Number.NOT_SET;
		
		if (v != right) {
			right = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private inline function setTop (v) {
		if (v != Number.NOT_SET)
			vCenter = Number.NOT_SET;
		
		if (v != top) {
			top = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
	
	private inline function setBottom (v) {
		if (v != Number.NOT_SET)
			vCenter = Number.NOT_SET;
		
		if (v != bottom) {
			bottom = v;
			if (enabled)
				changed.send();
		}
		return v;
	}
}