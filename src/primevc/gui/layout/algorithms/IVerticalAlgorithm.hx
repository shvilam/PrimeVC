package primevc.gui.layout.algorithms;
 import primevc.gui.layout.algorithms.directions.Vertical;
 

/**
 * Interface to make sure that a given algorithm is meant for vertical
 * layouting.
 *
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
interface IVerticalAlgorithm implements ILayoutAlgorithm
{
	public var direction			(default, setDirection)	: Vertical;
	
	/**
	 * Flag defining if the algorithm should find the biggest
	 * width as well or just measure the height.
	 * 
	 * Getting the biggest width is usefull when a vertical layout algorithm
	 * is used standalone. By turning the boolean to false you can use it in 
	 * combination with a horizontal algorithm.
	 * 
	 * @default true
	 */
//	public var measureHighestWidth : Bool;
}