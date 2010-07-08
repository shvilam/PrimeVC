package primevc.gui.core;
 

/**
 * UIComponent interface with data property.
 *
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
interface IUIComponent <DataProxyType> implements IUIComponentBase
{
	public var data (default, setData)	: DataProxyType;
}