package primevc.gui.display;
 

/**
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
#if flash9
typedef GraphicsOwner = {
	var graphics : flash.display.Graphics;
}
#else
error
#end