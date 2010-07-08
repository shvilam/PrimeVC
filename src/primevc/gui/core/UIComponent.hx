package primevc.gui.core;
 

/**
 * UIComponent defines the data property.
 * 
 * @see				primevc.gui.core.UIComponentBase
 * @see				primevc.gui.core.IUIComponentBase
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class UIComponent <DataProxyType> extends UIComponentBase, implements IUIComponent <DataProxyType>
{
	public var data (default, setData)	: DataProxyType;
	
	
	private function setData (newData)
	{
		data = newData;
		if (skin != null && data != null)
			componentState.current = componentState.initialized;
		return data;
	}
	
	
	override private function setSkin (newSkin) {
		newSkin = super.setSkin(newSkin);
		
		if (newSkin != null && data != null)
			componentState.current = componentState.initialized;
		
		return newSkin;
	}
}