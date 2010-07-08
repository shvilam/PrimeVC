package primevc.gui.layout.algorithms;
 import primevc.gui.layout.algorithms.directions.Horizontal;
 

/**
 * Interface to make sure that a given algorithm is meant for horizontal
 * layouting.
 *
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
interface IHorizontalAlgorithm implements ILayoutAlgorithm
{
	public var direction			(default, setDirection)	: Horizontal;
	
	/**
	 * Flag defining if the algorithm should find the biggest
	 * height as well or just measure the width.
	 * 
	 * Getting the biggest height is usefull when a horizontal layout algorithm
	 * is used standalone. By turning the boolean to false you can use it in 
	 * combination with a vertical algorithm.
	 * 
	 * @default true
	 */
//	public var measureHighestHeight : Bool;
}