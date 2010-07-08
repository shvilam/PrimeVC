package primevc.gui.layout;
 import primevc.core.collections.ArrayList;
 import primevc.core.collections.IList;
 import primevc.core.geom.Box;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.states.LayoutStates;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;


private typedef Flags = LayoutFlags;


/**
 * @since	mar 20, 2010
 * @author	Ruben Weijers
 */
class LayoutGroup extends AdvancedLayoutClient, implements ILayoutGroup<LayoutClient>, implements IAdvancedLayoutClient
{
	public var algorithm	(default, setAlgorithm)		: ILayoutAlgorithm;
	public var children		(default, null)				: IList<LayoutClient>;
	
	
	public function new ()
	{
		super();
		padding		= new Box(0, 0);
		children	= new ArrayList<LayoutClient>();
		
		childAddedHandler.on( children.events.added, this );
		childRemovedHandler.on( children.events.removed, this );
		
		invalidateChildList.on( children.events.added, this );
		invalidateChildList.on( children.events.moved, this );
		invalidateChildList.on( children.events.removed, this );
	}
	
	
	override public function dispose ()
	{
		children.dispose();
		children	= null;
		algorithm	= null;
		
		super.dispose();
	}
	
	
	//
	// LAYOUT METHODS
	//
	
	public inline function childInvalidated (childChanges:Int) : Bool
	{
		var r = false;
		if (algorithm != null && algorithm.isInvalid(childChanges)) {
			invalidate( LayoutFlags.CHILDREN_INVALIDATED );
			r = true;
		}
		return r;
	}
	
	
	override public function measure ()
	{
		if (changes == 0 || states.is(LayoutStates.measuring))
			return;
		
		states.current = LayoutStates.measuring;
		
		for (child in children)
			child.measure();
		
		if (algorithm != null)
			algorithm.measure();
		
		super.measure();
	}
	
	
	override public function validate ()
	{
		if (changes == 0)
			return;
		
		states.current = LayoutStates.validating;
		
		if (algorithm != null)
			algorithm.apply();
		
		for (child in children)
			child.validate();
		
		super.validate();
	}
	
	
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setAlgorithm (v:ILayoutAlgorithm)
	{
		if (v != algorithm)
		{
			if (algorithm != null) {
				algorithm.group = null;
				algorithm.algorithmChanged.unbind(this);
			}
			
			algorithm = v;
			invalidate( LayoutFlags.ALGORITHM_CHANGED );
			
			if (algorithm != null) {
				algorithm.group = this;
				algorithmChangedHandler.on( algorithm.algorithmChanged, this );
			}
		}
		return v;
	}
	
	
	//
	// EVENT HANDLERS
	//
	
	private function algorithmChangedHandler ()							{ invalidate( LayoutFlags.ALGORITHM_CHANGED ); }
	private function invalidateChildList ()								{ invalidate( LayoutFlags.LIST_CHANGED ); }
	private function childAddedHandler (child:LayoutClient, pos:Int)	{ child.parent = this; }
	private function childRemovedHandler (child:LayoutClient, pos:Int)	{ child.parent = null; }
}