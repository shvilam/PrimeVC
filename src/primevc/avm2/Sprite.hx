package primevc.avm2;
 import primevc.core.IDisposable;
 import primevc.gui.display.ISprite;
 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.UserEvents;
 
 import flash.display.DisplayObjectContainer;
 import flash.display.InteractiveObject;
 
  using primevc.utils.TypeUtil;

 
/**
 * AVM2 sprite implementation
 * 
 * @author	Danny Wilson
 */
class Sprite extends flash.display.Sprite, implements ISprite
{
	public var userEvents (default, null)		: UserEvents;
	public var displayEvents (default, null)	: DisplayEvents;
	
	
	public function new()
	{
		super();
		userEvents		= new UserEvents( this );
		displayEvents	= new DisplayEvents( this );
	}
	
	
	public function dispose()
	{
		if (userEvents == null)
			return;		// already disposed
		
		userEvents.dispose();
		displayEvents.dispose();
		userEvents		= null;
		displayEvents	= null;
		
		for (i in 0 ... numChildren)
		{
			var child = getChildAt(0);
			if (child.is(IDisposable))
				cast(child, IDisposable).dispose();
			
			if (child.parent != null)
				child.parent.removeChild( child );		//just to be sure
		}
		
		if (parent != null)
			parent.removeChild(this);
	}
	
	
	public function attachTo(target:DisplayObjectContainer)
	{
		target.addChild(this);
	}
	
	
/*	public inline function resizeScrollRect (newWidth:Float, newHeight:Float)
	{
		var rect			= scrollRect == null ? new flash.geom.Rectangle() : scrollRect;
		rect.width			= newWidth;
		rect.height			= newHeight;
		scrollRect			= rect;
	}
	
	
	public inline function moveScrollRect (?newX:Float = 0, ?newY:Float = 0)
	{
		var rect			= scrollRect == null ? new flash.geom.Rectangle() : scrollRect;
		rect.x				= newX;
		rect.y				= newY;
		scrollRect			= rect;
	}*/
}
