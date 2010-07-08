package cases;
 import primevc.core.collections.BalancingListCollection;
 import primevc.core.collections.ChainedListCollection;
 import primevc.core.collections.ListCollection;
 

/**
 * Description
 * 
 * @creation-date	Jul 5, 2010
 * @author			Ruben Weijers
 */
class CollectionTest 
{
	public static function main ()
	{
		var tile:Tile;
		
		
		//
		// TEST LIST COLLECTION
		//
		trace("LIST COLLECTION\n\n");
		var tile1:Tile, tile2:Tile, tile3:Tile;
		var list = new ListCollection<Tile>();
		Assert.equal(list.length, 0);
		
		list.add( tile1 = tile = new Tile() );
		Assert.equal(list.length, 1);
		Assert.equal(list.first.data, tile);
		Assert.equal(list.last.data, tile);
		Assert.equal(list.last.prev, null);
		Assert.equal(list.last.next, null);
		
		list.add( tile2 = tile = new Tile() );
		Assert.equal(list.length, 2);
		Assert.notEqual(list.first.data, tile);
		Assert.equal(list.first.data, tile1);
		Assert.equal(list.last.data, tile);
		
		Assert.equal(list.first.prev, null);
		Assert.equal(list.first.next, list.last);
		Assert.equal(list.last.data, tile);
		Assert.equal(list.last.prev, list.first);
		Assert.equal(list.last.next, null);
		
		list.add( tile3 = tile = new Tile(), 1 );
		Assert.equal(list.length, 3);
		
		Assert.notEqual(list.last.data, tile);
		Assert.equal(list.first.data, tile1);
		Assert.equal(list.last.data, tile2);
		Assert.equal(list.first.next.data, tile3);
		Assert.equal(list.last.prev.data, tile3);
		
		Assert.equal(list.first.prev, null);
		Assert.equal(list.first.next, list.last.prev);
		Assert.equal(list.first.next.next, list.last);
		Assert.equal(list.first.next.prev, list.first);
		Assert.equal(list.last.next, null);
		
		//test iterator
		var current = tile1;
		for (item in list) {
			Assert.equal(current, item);
			if (current == tile1)		current = tile3;
			else if (current == tile3)	current = tile2;
		}
		
		
		
		//
		// TEST CHAINEDLIST COLLECTION
		//
		trace("CHAINED LIST COLLECTION\n\n");
		
		Tile.COUNTER = 0;
		var chained = new ChainedListCollection<Tile>(4);
		Assert.equal( chained.length, 0 );
		Assert.equal( chained.lists.length, 0 );
		
		chained.add( tile = new Tile() );
		Assert.equal(chained.length, 1);
		Assert.equal(chained.lists.length, 1);
		Assert.equal(chained.indexOf( tile ), 0 );
		
		chained.add( tile = new Tile() );
		chained.add( tile = new Tile() );
		chained.add( tile = new Tile() );
		iterateList(chained);
		Assert.equal(chained.indexOf( tile ), 3 );
		Assert.equal(chained.length, 4);
		Assert.equal(chained.lists.length, 1);
		Assert.equal(chained.lists[0].length, 4);
		
		chained.add( tile = new Tile() );
		chained.add( tile = new Tile() );
		Assert.equal(chained.indexOf( tile ), 5 );
		Assert.equal(chained.length, 6);
		Assert.equal(chained.lists[0].length, 4);
		Assert.equal(chained.lists[1].length, 2);
		Assert.equal(chained.lists.length, 2);
		
		iterateList(chained);
		
		Assert.equal(chained.lists[0].getItemAt(0).id, 0);
		Assert.equal(chained.lists[0].getItemAt(1).id, 1);
		Assert.equal(chained.lists[0].getItemAt(2).id, 2);
		Assert.equal(chained.lists[0].getItemAt(3).id, 3);
		Assert.equal(chained.lists[1].getItemAt(0).id, 4);
		Assert.equal(chained.lists[1].getItemAt(1).id, 5);
		
		chained.add( tile = new Tile(), 2 );
		chained.add( tile = new Tile(), 2 );
		Assert.equal(chained.indexOf( tile ), 2 );
		Assert.equal(chained.length, 8);
		Assert.equal(chained.lists[0].length, 4);
		Assert.equal(chained.lists[1].length, 4);
		
		Assert.equal(chained.lists[0].getItemAt(0).id, 0);
		Assert.equal(chained.lists[0].getItemAt(1).id, 1);
		Assert.equal(chained.lists[0].getItemAt(2).id, 7);
		Assert.equal(chained.lists[0].getItemAt(3).id, 6);
		Assert.equal(chained.lists[1].getItemAt(0).id, 2);
		Assert.equal(chained.lists[1].getItemAt(1).id, 3);
		Assert.equal(chained.lists[1].getItemAt(2).id, 4);
		Assert.equal(chained.lists[1].getItemAt(3).id, 5);
		
		
		//
		// TEST BALANCING LIST COLLECTION
		//
		trace("BALANCING LIST COLLECTION\n\n");
		
		Tile.COUNTER = 0;
		var balancingCol = new BalancingListCollection<Tile>(4);
		Assert.equal(balancingCol.length, 0);
		Assert.equal(balancingCol.lists.length, 0);
		
		balancingCol.add( tile = new Tile() );
		Assert.equal(balancingCol.length, 1);
		Assert.equal(balancingCol.lists.length, 1);
		Assert.equal(balancingCol.indexOf( tile ), 0 );
		
		balancingCol.add( tile = new Tile() );
		balancingCol.add( tile = new Tile() );
		balancingCol.add( tile = new Tile() );
		Assert.equal(balancingCol.indexOf( tile ), 3 );
		Assert.equal(balancingCol.length, 4);
		Assert.equal(balancingCol.lists.length, 4);
		
	//	iterateList(balancingCol);
		balancingCol.add( tile = new Tile() );
		Assert.equal(balancingCol.indexOf( tile ), 4 );
		balancingCol.add( tile = new Tile() );
		Assert.equal(balancingCol.indexOf( tile ), 5 );
		balancingCol.add( tile = new Tile() );
		Assert.equal(balancingCol.indexOf( tile ), 6 );
		
		Assert.equal(balancingCol.length, 7);
		Assert.equal(balancingCol.lists.length, 4);
		Assert.equal(balancingCol.lists[0].length, 2);
		Assert.equal(balancingCol.lists[1].length, 2);
		Assert.equal(balancingCol.lists[2].length, 2);
		Assert.equal(balancingCol.lists[3].length, 1);
		
		balancingCol.add( tile = new Tile(), 3 );
	//	iterateList(balancingCol);
		Assert.equal(balancingCol.indexOf( tile ), 3 );
		Assert.equal(balancingCol.length, 8);
		Assert.equal(balancingCol.lists.length, 4);
		Assert.equal(balancingCol.lists[0].length, 2);
		Assert.equal(balancingCol.lists[1].length, 2);
		Assert.equal(balancingCol.lists[2].length, 2);
		Assert.equal(balancingCol.lists[3].length, 2);
		Assert.equal(balancingCol.lists[3].getItemAt(0).id, 7 );
		Assert.equal(balancingCol.lists[0].getItemAt(1).id, 3 );
		Assert.equal(balancingCol.lists[1].getItemAt(1).id, 4 );
		Assert.equal(balancingCol.lists[2].getItemAt(1).id, 5 );
		Assert.equal(balancingCol.lists[3].getItemAt(1).id, 6 );
		
		var removed = balancingCol.getItemAt(0);
		removed = balancingCol.remove( removed );
		
		Assert.equal(balancingCol.length, 7);
		Assert.equal(balancingCol.lists.length, 4);
		Assert.equal(balancingCol.indexOf(removed), -1);
		Assert.equal(balancingCol.lists[0].length, 2);
		Assert.equal(balancingCol.lists[1].length, 2);
		Assert.equal(balancingCol.lists[2].length, 2);
		Assert.equal(balancingCol.lists[3].length, 1);
		Assert.equal(balancingCol.lists[0].getItemAt(0).id, 1 );
		Assert.equal(balancingCol.lists[1].getItemAt(0).id, 2 );
		Assert.equal(balancingCol.lists[2].getItemAt(0).id, 7 );
		Assert.equal(balancingCol.lists[3].getItemAt(0).id, 3 );
		Assert.equal(balancingCol.lists[0].getItemAt(1).id, 4 );
		Assert.equal(balancingCol.lists[1].getItemAt(1).id, 5 );
		Assert.equal(balancingCol.lists[2].getItemAt(1).id, 6 );
		
		//*/
	}
	
	
	public static inline function iterateList (lists:ChainedListCollection<Tile>) {
		
		trace("\niterating through items " + lists.length);
		
		var pos = 0;
		for (item in lists) {
			trace("list[" + pos + "] = " + item);
			pos++;
		}
		
		trace("finished iterating through items\n");
	}
}

class Tile
{
	public static var COUNTER:Int = 0;
	
	public var id:Int;
	public function new () { this.id = COUNTER++; }
	public function toString () { return "Tile" + id; }
}