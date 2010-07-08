package primevc.gui.core;
 import haxe.FastList;
 import primevc.gui.behaviours.layout.SkinLayoutBehaviour;
 import primevc.gui.behaviours.IBehaviour;
 import primevc.gui.display.Sprite;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.states.SkinStates;
 

/**
 * Base Skin class.
 * 
 * TODO Ruben: explain the difference between UIComponent en Skin
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class Skin <OwnerClass> extends Sprite, implements ISkin //<OwnerClass>
{
	public var layout			(default, null)		: LayoutClient;
	public var owner			(default, setOwner) : OwnerClass;
	
	public var behaviours		: FastList < IBehaviour <ISkin> >;
	public var skinState		: SkinStates;
	
	
	public function new()
	{
		super();
		visible			= false;
		skinState		= new SkinStates();
		
		behaviours		= new FastList< IBehaviour <ISkin> > ();
		behaviours.add( new SkinLayoutBehaviour (this) );
		
		createStates();
		createBehaviours();
		createLayout();
		
		skinState.current = skinState.constructed;
	}
	
	
	public function init ()
	{
		createChildren();
		visible = true;
		skinState.current = skinState.initialized; 
	}
	
	
	override public function dispose ()
	{
		if (behaviours == null)
			return;
		
		removeChildren();
		removeBehaviours();
		removeStates();
		
		if (layout != null)
			layout.dispose();
		
		behaviours	= null;
		layout		= null;
		owner		= null;
		
		super.dispose();
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setOwner (newOwner) {
		return this.owner = newOwner;
	}
	
	
	
	
	//
	// METHODS
	//
	
	//TODO RUBEN - enable Assert.abstract
	private function createLayout ()		: Void; //	{ Assert.abstract(); }
	private function createStates ()		: Void; //	{ Assert.abstract(); }
	private function createBehaviours ()	: Void; //	{ Assert.abstract(); }
	private function createChildren ()		: Void; //	{ Assert.abstract(); }
	
	private function removeStates ()		: Void; //	{ Assert.abstract(); }
	private function removeChildren ()		: Void; //	{ Assert.abstract(); }
	private function removeBehaviours ()	: Void
	{
		while (!behaviours.isEmpty())
			behaviours.pop().dispose();
	}
}