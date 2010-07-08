package primevc.gui.display;
 

typedef Shape = 
	#if		flash9	primevc.avm2.Shape;
	#elseif	flash8	primevc.avm1.Shape;
	#elseif	js		primevc.js  .Shape;
	#else			ShapeImpl

import primevc.gui.events.IDisplayEvents;
import primevc.core.geom.Matrix2D;
import primevc.gui.events.DisplayEvents;


/**
 * Default mock implementation for Shape
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class ShapeImpl implements IShape
{
	public var displayEvents	(default, null)					: IDisplayEvents;
	
	public var parent			(default,null)					: ISprite;
	public var transform		(default,null)					: Matrix2D;
	public var maxWidth			(getMaxWidth,never)				: Float;
	public var visible			(getVisibility, setVisibility)	: Bool;
	
	public var alpha			(default, setAlpha)				: Float;
	public var width			(default, default)				: Float;
	public var x				(default, default)				: Float;
	public var y				(default, default)				: Float;
	public var width			(default, default)				: Float;
	public var height			(default, default)				: Float;
	
	private inline function setAlpha(a:Float)		{ return alpha = a; }
	
	
	public function new() {
		events = new DisplayEvents( this );
	}
	
	private inline function getVisibility()			{ return _visible; }
	private inline function setVisibility(v:Bool)	{ return _visible = v; }
	
	public function resizeScrollRect (newWidth:Float, newHeight:Float) {}
	public function moveScrollRect (?newX:Float = 0, ?newY:Float = 0) {}
	
	
	public inline function dispose() : Void
	{
		displayEvents.dispose();
		displayEvents	= null;
		parent			= null;
	}
	
	private var _visible:Bool;
	private inline function getMaxWidth() { return 1024; }
	
}

#end