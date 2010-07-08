package primevc.gui.layout.algorithms;
 import primevc.core.AbstractFactory;


/**
 * @since	mar 21, 2010
 * @author	Ruben Weijers
 */
class LayoutAlgorithmFactory extends AbstractFactory < ILayoutAlgorithm >
{
	public static var instance	(getInstance, null)	: LayoutAlgorithmFactory;
	
	private static inline function getInstance ()
	{
		return if (instance != null) instance
		     else  instance = new LayoutAlgorithmFactory();
	}
	
	
	public static function create ( algorithm : Class < ILayoutAlgorithm > ) : ILayoutAlgorithm
	{
		return instance.getProduct(algorithm);
	}
}