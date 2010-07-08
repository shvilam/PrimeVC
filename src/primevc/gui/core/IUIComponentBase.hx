package primevc.gui.core;
 import haxe.FastList;
 import primevc.core.IDisposable;
 import primevc.gui.behaviours.IBehaviour;
 import primevc.gui.states.UIComponentStates;
 

/**
 * Interface for UIComponentBase.
 *
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
interface IUIComponentBase implements IDisposable
{
	public var behaviours		: FastList < IBehaviour < IUIComponentBase > >;
	public var componentState	: UIComponentStates;
	public var skin				(default, setSkin)	: ISkin;
	
	
	/**
	 * Factory method for creating the default skin of this UIComponent. Setting
	 * the skin property in the constructor will cause the createSkin method
	 * not being called.
	 * 
	 * Use the setupSkin() method for giving the skin different properties or 
	 * adding skins to skin from child components.
	 */
	private function createSkin ()					: Void;
	
	
	
	/**
	 * This is the first method that will be runned by the constructor.
	 * Overwrite this method to instantiate the states of the component.
	 */
	private function setupStates ()					: Void;
	/**
	 * After constructing the states, the behaviours will be created.
	 * Overwrite this method to define all the behaviours of the component.
	 */
	private function setupBehaviours ()				: Void;
	/**
	 * After creating the behaviours, the component can also create child UIComponents.
	 * These components can be added by callig the addChild method. This will
	 * on default also add the skin of the child as child to the parent skin.
	 */
	private function setupChildren ()				: Void;
	/**
	 * After creating the child componentns, the skin will be created.
	 * Overwrite this method to give the current skin the right properties
	 * and subskins.
	 */
	private function setupSkin ()					: Void;
	
	
	/**
	 * Implement this method to clean-up the states of the component
	 */
	private function removeStates ()				: Void;
	/**
	 * Implement this method to clean-up the behaviours of the component
	 */
	private function removeBehaviours ()			: Void;
	/**
	 * Implement this method to clean-up the skin of the component
	 */
	private function removeSkin ()					: Void;
	/**
	 * Implement this method to clean-up the children of the component
	 */
	private function removeChildren ()				: Void;
	
	
	
//	public function add ( child:IUIComponent )		: IUIComponent;
//	public function remove ( child:IUIComponent )	: IUIComponent;
//	private var childeren							: FastList;
}