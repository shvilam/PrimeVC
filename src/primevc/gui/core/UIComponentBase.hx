package primevc.gui.core;
 import haxe.FastList;
 import primevc.gui.behaviours.IBehaviour;
 import primevc.gui.states.UIComponentStates;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * UIComponentBase defines the basic behaviour of a UIComponent without data.
 *
 * These include the default states of a component, the way it
 * should change between states and a helper function to setup a new skin.
 * 
 * You should never have to extend UIComponentBase class directly.
 * Instead, define new components as subclasses of UIComponent.
 *
 * To create a component, extend UIComponent and override the 
 * following methods:
 * 	- setupStates
 * 	- setupBehaviours
 *  - setupChildren
 *  - setupSkin
 *  - removeStates
 *  - removeSkin
 *  - removeChildren
 * 
 * Non of these methods need to call their super methods because they
 * are empty.
 *  
 * When any behaviours outside of "public var behaviours" are defined,
 * the removeBehaviours() method should be overridden.
 * 
 * @author Ruben Weijers
 * @creation-date Jun 07, 2010
 */
class UIComponentBase implements IUIComponentBase
{
	public var behaviours		: FastList < IBehaviour < IUIComponentBase > >;
	public var componentState	: UIComponentStates;
	public var skin				(default, setSkin)	: ISkin;
	
	
	private function new (?skin : ISkin)
	{
		componentState	= new UIComponentStates();
		behaviours		= new FastList <IBehaviour <IUIComponentBase> > ();
	//	behaviours.add( cast new ComponentBehaviour( this ) );
		
		if (skin != null)
			this.skin = skin;
		else
			createSkin();
		
		setupStates();
		setupBehaviours();
		setupChildren();
		setupSkin();
		
	//	componentState.current = componentState.constructed;
	}
	
	
	public function dispose ()
	{
		if (componentState == null)
			return;
		
		removeSkin();
		removeChildren();
		
		//Change the state to disposed before the behaviours are removed.
		//This way a behaviour is still able to respond to the disposed
		//state.
		componentState.current = componentState.disposed;
		
		removeBehaviours();
		removeStates();
		
		componentState.dispose();
		
		componentState	= null;
		behaviours		= null;
		skin			= null;
	}
	
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	private function setSkin (newSkin)
	{
		if (skin != null)
			removeSkin();
		
		skin = newSkin;
		
		if (skin != null && skin.is(Skin)) {
			cast(skin, Skin<Dynamic>).owner = this;
		}
		
		return skin;
	}
	
	
	
	
	//
	// METHODS
	//
	
	
	private function removeBehaviours ()	: Void
	{
		while (!behaviours.isEmpty())
			behaviours.pop().dispose();
	}
	
	
	//
	// ABSTRACT METHODS
	//
	
	private function createSkin ()			: Void	{ Assert.abstract(); }
	private function setupStates ()			: Void	{ Assert.abstract(); }
	private function setupBehaviours ()		: Void	{ Assert.abstract(); }
	private function setupChildren ()		: Void	{ Assert.abstract(); }
	private function setupSkin ()			: Void	{ Assert.abstract(); }
	
	
	private function removeStates ()		: Void	{ Assert.abstract(); }
	private function removeSkin ()			: Void	{ Assert.abstract(); }
	private function removeChildren ()		: Void	{ Assert.abstract(); }
}