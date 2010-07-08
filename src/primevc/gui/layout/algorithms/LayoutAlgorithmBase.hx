package primevc.gui.layout.algorithms;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.Number;
 import primevc.core.IDisposable;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.ILayoutGroup;
 import primevc.gui.layout.LayoutClient;
  using primevc.utils.TypeUtil;
 

/**
 * Base class for algorithms
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class LayoutAlgorithmBase implements IDisposable
{
	public var childWidth				(default, setChildWidth)	: Int;
	public var childHeight				(default, setChildHeight)	: Int;
	
	public var algorithmChanged 		(default, null)				: Signal0;
	public var apply					(default, null)				: Void -> Void;
	public var group					(default, setGroup)			: ILayoutGroup<LayoutClient>;
	
	
	public function new()
	{
		algorithmChanged	= new Signal0();
		childWidth			= Number.NOT_SET;
		childHeight			= Number.NOT_SET;
	}
	
	
	public function dispose ()
	{
		algorithmChanged.dispose();
		algorithmChanged	= null;
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setGroup (v)
	{
		return group = v;
	}
	
	
	private function setChildWidth (v)
	{
		if (v != childWidth)
		{
			childWidth = v;
			algorithmChanged.send();
		}
		return v;
	}
	
	
	private function setChildHeight (v)
	{
		if (v != childHeight)
		{
			childHeight = v;
			algorithmChanged.send();
		}
		return v;
	}
	
	
	private inline function setGroupHeight (h:Int)
	{
		if (group.is(AdvancedLayoutClient))
			group.as(AdvancedLayoutClient).measuredHeight = h;
		else
			group.height = h;
	}
	
	
	private inline function setGroupWidth (w:Int)
	{
		if (group.is(AdvancedLayoutClient))
			group.as(AdvancedLayoutClient).measuredWidth = w;
		else
			group.width = w;
	}
}