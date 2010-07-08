package primevc.gui.layout.algorithms.tile;
 import primevc.gui.layout.LayoutClient;
 

/**
 * Dynamic tile-group will try to place as
 * 
 * @creation-date	Jul 8, 2010
 * @author			Ruben Weijers
 */
class DynamicTileGroup <ChildType:LayoutClient> extends TileGroup <ChildType>
{
	public var next : DynamicTileGroup < ChildType >;
	
	
}