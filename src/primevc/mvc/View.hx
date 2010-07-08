package primevc.mvc;
 import primevc.gui.display.Sprite;

/**
 * Class description
 * 
 * @author Danny Wilson
 * @creation-date Jun 22, 2010
 */
class View implements primevc.core.IDisposable 
{
	var target : Sprite;
	
	public function new (sprite:Sprite)
	{
		target = sprite;
	}
	
	public function dispose()
	{
		if (target == null) return; // already disposed
		
		target.dispose();
		target = null;
	}
}