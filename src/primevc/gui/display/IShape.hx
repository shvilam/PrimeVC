package primevc.gui.display;
 import primevc.core.geom.Matrix2D;


/**
 * Describes the properties of a shape
 *
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
interface IShape implements IDisplayObject
{
#if flash9
	var graphics (default,null) : flash.display.Graphics;
#end
}