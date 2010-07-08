package primevc.gui.display;
 import primevc.core.IDisposable;
 import primevc.core.geom.Matrix2D;
 import primevc.core.geom.Rectangle;
 import primevc.gui.events.UserEvents;

#if flash9
 import flash.display.DisplayObject;
#else
#end


/**
 * Sprite interface for every platform.
 *
 * @creation-date	Jun 11, 2010
 * @author			Ruben Weijers
 */
interface ISprite implements IDisplayObject
{
	var userEvents		(default, null)									: UserEvents;
	
	function startDrag(lockCenter:Bool = false, ?bounds:Rectangle) 		: Void;
	function stopDrag()													: Void;
	
#if flash9
	
	var dropTarget (default,null)										: DisplayObject;
	var graphics (default,null)											: flash.display.Graphics;
	
	var mouseEnabled													: Bool;
	var doubleClickEnabled												: Bool;
	var mouseChildren													: Bool;
	
	var tabEnabled														: Bool;
	var tabIndex														: Int;
	var tabChildren														: Bool;
	
	var buttonMode														: Bool;
	var useHandCursor													: Bool;
	
	
	var numChildren(default,null)										: Int;
	
	function addChild (child:DisplayObject)								: DisplayObject;
	function addChildAt (child:DisplayObject, index:Int)				: DisplayObject;
	
	function contains (child:DisplayObject)								: Bool;
	function getChildAt (index:Int)										: DisplayObject;
	function getChildIndex (child:DisplayObject)						: Int;
	
	function removeChild (child:DisplayObject)							: DisplayObject;
	function removeChildAt (index:Int)									: DisplayObject;
	
	function setChildIndex (child:DisplayObject, index:Int)				: Void;
	
	function swapChildren (child1:DisplayObject, child2:DisplayObject)	: Void;
	function swapChildrenAt (index1:Int, index2:Int)					: Void;
	
#else

	var dropTarget		(default, null)									: IDisplayObject;
	var numChildren		(getNumChildren, never)							: Int;
	var mouseEnabled	(getEnabled, setEnabled)						: Bool;
	
	function addChild(child:ISprite)									: Void;
	function addChildAt(child:ISprite, depth:Int)						: Void;
	function getChildIndex(child:ISprite)								: Int;
	function swapChildren(a:Sprite, b:ISprite)							: Void;
#end
}