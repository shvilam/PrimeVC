package primevc.gui.display;
 import flash.geom.Point;
 import primevc.core.IDisposable;
 import primevc.core.geom.Matrix2D;
 import primevc.gui.events.DisplayEvents;
 

/**
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
interface IDisplayObject implements IDisposable
{
	var displayEvents (default, null)	: DisplayEvents;
	
#if flash9
	var filters					: Array < Dynamic >;
	var name					: String;
	var parent(default,null)	: flash.display.DisplayObjectContainer;
//	var stage (default,null)	: flash.display.Stage;
	var scrollRect				: flash.geom.Rectangle;
	var transform				: flash.geom.Transform; //Matrix2D;
	
	var alpha					: Float;
	var visible					: Bool;
	
	var height					: Float;
	var width					: Float;
	var x						: Float;
	var y						: Float;
	var rotation				: Float;
	
	var scaleX					: Float;
	var scaleY					: Float;
	
	var mouseX (default,null)	: Float;
	var mouseY (default, null)	: Float;
	
	function globalToLocal (point : Point) : Point;
	function localToGlobal (point : Point) : Point;
	
	#if flash10
	var rotationX				: Float;
	var rotationY				: Float;
	var rotationZ				: Float;
	var scaleZ					: Float;
	var z						: Float;
	#end
	
#else
	var parent		(default, null)						: ISprite;
	var visible		(getVisibility, setVisibility)		: Bool;
	var transform	(default, null)						: Matrix2D;
	
	var alpha		(getAlpha,		setAlpha)			: Float;
	var x			(getX,			setX)				: Float;
	var y			(getY,			setY)				: Float;
	var width		(getWidth,		setWidth)			: Float;
	var height		(getHeight,		setHeight)			: Float;
#end
}