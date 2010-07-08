package primevc.gui.core;
 import haxe.FastList;
 import primevc.core.IDisposable;
 import primevc.gui.behaviours.IBehaviour;
 import primevc.gui.display.ISprite;
 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.UserEvents;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.states.SkinStates;


/**
 * Interface for a skin.
 * 
 * @author Ruben Weijers
 * @creation-date Jun 08, 2010
 */
interface ISkin implements ISprite, implements IDisposable //, implements ILayoutOwner
{
	public var userEvents		(default, null)		: UserEvents;
	public var displayEvents	(default, null)		: DisplayEvents;
	
//	public var owner			(default, setOwner) : OwnerClass;
	public var layout			(default, null)		: LayoutClient;
	
	public var behaviours		: FastList < IBehaviour <ISkin> >;
	public var skinState		: SkinStates;
	
	
	public function init ()					: Void;
	private function createLayout ()		: Void;
	private function createStates ()		: Void;
	private function createBehaviours ()	: Void;
	private function createChildren ()		: Void;
	
	private function removeStates ()		: Void;
	private function removeBehaviours ()	: Void;
	private function removeChildren ()		: Void;
	
}