package cases;
 import primevc.core.collections.BalancingListCollection;
 import primevc.core.collections.ChainedListCollection;
 import primevc.core.collections.SimpleList;
 

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
		trace("START SIMPLE-LIST");
		var tile1:Tile, tile2:Tile, tile3:Tile;
		var list = new SimpleList<Tile>();
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
		// test moving items around
		//
		
		trace(list);
		
		//test moving items higher in the list
		trace("moving item up: "+tile1+" to 2");
		list.move(tile1, 2);
		trace(list);
		Assert.equal( list.first.data,		tile3 );
		Assert.equal( list.last.data,		tile1 );
		Assert.equal( list.first.next.data,	tile2 );
		Assert.equal( list.last.next,		null );
		Assert.equal( list.last.prev.data,	tile2 );
		
		//test moving items lower in the list
		trace("moving item down: "+tile1+" to 0");
		list.move(tile1, 0);
		trace(list);
		Assert.equal( list.first.data,		tile1 );
		Assert.equal( list.last.data,		tile2 );
		Assert.equal( list.first.next.data,	tile3 );
		Assert.equal( list.last.next,		null );
		Assert.equal( list.last.prev.data,	tile3 );
		
		trace("END SIMPLE LIST\n\n");
		
		
		
		//
		// TEST CHAINEDLIST COLLECTION
		//
		trace("START CHAINED LIST COLLECTION");
		
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
		Assert.equal(chained.lists.getItemAt(0).length, 4);
		
		chained.add( tile = new Tile() );
		chained.add( tile = new Tile() );
		Assert.equal(chained.indexOf( tile ), 5 );
		Assert.equal(chained.length, 6);
		Assert.equal(chained.lists.getItemAt(0).length, 4);
		Assert.equal(chained.lists.getItemAt(1).length, 2);
		Assert.equal(chained.lists.length, 2);
		
		iterateList(chained);
		
		Assert.equal(chained.lists.getItemAt(0).getItemAt(0).id, 0);
		Assert.equal(chained.lists.getItemAt(0).getItemAt(1).id, 1);
		Assert.equal(chained.lists.getItemAt(0).getItemAt(2).id, 2);
		Assert.equal(chained.lists.getItemAt(0).getItemAt(3).id, 3);
		Assert.equal(chained.lists.getItemAt(1).getItemAt(0).id, 4);
		Assert.equal(chained.lists.getItemAt(1).getItemAt(1).id, 5);
		
		chained.add( tile = new Tile(), 2 );
		chained.add( tile = new Tile(), 2 );
		Assert.equal(chained.indexOf( tile ), 2 );
		Assert.equal(chained.length, 8);
		Assert.equal(chained.lists.getItemAt(0).length, 4);
		Assert.equal(chained.lists.getItemAt(1).length, 4);
		
		Assert.equal(chained.lists.getItemAt(0).getItemAt(0).id, 0);
		Assert.equal(chained.lists.getItemAt(0).getItemAt(1).id, 1);
		Assert.equal(chained.lists.getItemAt(0).getItemAt(2).id, 7);
		Assert.equal(chained.lists.getItemAt(0).getItemAt(3).id, 6);
		Assert.equal(chained.lists.getItemAt(1).getItemAt(0).id, 2);
		Assert.equal(chained.lists.getItemAt(1).getItemAt(1).id, 3);
		Assert.equal(chained.lists.getItemAt(1).getItemAt(2).id, 4);
		Assert.equal(chained.lists.getItemAt(1).getItemAt(3).id, 5);
		
		//
		//test moving items around
		//
		var ctile0 = chained.getItemAt(0);
		var ctile1 = chained.getItemAt(1);
		var ctile2 = chained.getItemAt(2);
		var ctile3 = chained.getItemAt(3);
		var ctile4 = chained.getItemAt(4);
		var ctile5 = chained.getItemAt(5);
		var ctile6 = chained.getItemAt(6);
		var ctile7 = chained.getItemAt(7);
		
		trace(chained);
		
		//move item to lower position
		trace("moving item up: "+ctile6+" to 2");
		chained.move( ctile6, 2 );
		trace(chained);
		Assert.equal( ctile0, chained.getItemAt(0));
		Assert.equal( ctile1, chained.getItemAt(1));
		Assert.equal( ctile6, chained.getItemAt(2));
		Assert.equal( ctile2, chained.getItemAt(3));
		Assert.equal( ctile3, chained.getItemAt(4));
		Assert.equal( ctile4, chained.getItemAt(5));
		
		//move item to higher position
		trace("moving item down: "+ctile0+" to 4");
		chained.move( ctile0, 4 );
		trace(chained);
		Assert.equal( ctile1, chained.getItemAt(0));
		Assert.equal( ctile6, chained.getItemAt(1));
		Assert.equal( ctile2, chained.getItemAt(2));
		Assert.equal( ctile3, chained.getItemAt(3));
		Assert.equal( ctile0, chained.getItemAt(4));
		Assert.equal( ctile4, chained.getItemAt(5));
		
		trace("END CHAINED LIST COLLECTION\n\n");
		
		
		
		//
		// TEST BALANCING LIST COLLECTION
		//
		trace("BALANCING LIST COLLECTION");
		
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
		Assert.equal(balancingCol.lists.getItemAt(0).length, 2);
		Assert.equal(balancingCol.lists.getItemAt(1).length, 2);
		Assert.equal(balancingCol.lists.getItemAt(2).length, 2);
		Assert.equal(balancingCol.lists.getItemAt(3).length, 1);
		
		balancingCol.add( tile = new Tile(), 3 );
	//	iterateList(balancingCol);
		Assert.equal(balancingCol.indexOf( tile ), 3 );
		Assert.equal(balancingCol.length, 8);
		Assert.equal(balancingCol.lists.length, 4);
		Assert.equal(balancingCol.lists.getItemAt(0).length, 2);
		Assert.equal(balancingCol.lists.getItemAt(1).length, 2);
		Assert.equal(balancingCol.lists.getItemAt(2).length, 2);
		Assert.equal(balancingCol.lists.getItemAt(3).length, 2);
		Assert.equal(balancingCol.lists.getItemAt(3).getItemAt(0).id, 7 );
		Assert.equal(balancingCol.lists.getItemAt(0).getItemAt(1).id, 3 );
		Assert.equal(balancingCol.lists.getItemAt(1).getItemAt(1).id, 4 );
		Assert.equal(balancingCol.lists.getItemAt(2).getItemAt(1).id, 5 );
		Assert.equal(balancingCol.lists.getItemAt(3).getItemAt(1).id, 6 );
		
		var removed = balancingCol.getItemAt(0);
		removed = balancingCol.remove( removed );
		
		Assert.equal(balancingCol.length, 7);
		Assert.equal(balancingCol.lists.length, 4);
		Assert.equal(balancingCol.indexOf(removed), -1);
		Assert.equal(balancingCol.lists.getItemAt(0).length, 2);
		Assert.equal(balancingCol.lists.getItemAt(1).length, 2);
		Assert.equal(balancingCol.lists.getItemAt(2).length, 2);
		Assert.equal(balancingCol.lists.getItemAt(3).length, 1);
		Assert.equal(balancingCol.lists.getItemAt(0).getItemAt(0).id, 1 );
		Assert.equal(balancingCol.lists.getItemAt(1).getItemAt(0).id, 2 );
		Assert.equal(balancingCol.lists.getItemAt(2).getItemAt(0).id, 7 );
		Assert.equal(balancingCol.lists.getItemAt(3).getItemAt(0).id, 3 );
		Assert.equal(balancingCol.lists.getItemAt(0).getItemAt(1).id, 4 );
		Assert.equal(balancingCol.lists.getItemAt(1).getItemAt(1).id, 5 );
		Assert.equal(balancingCol.lists.getItemAt(2).getItemAt(1).id, 6 );
		
		//
		//test moving items around
		//
		var btile0 = balancingCol.getItemAt(0);
		var btile1 = balancingCol.getItemAt(1);
		var btile2 = balancingCol.getItemAt(2);
		var btile3 = balancingCol.getItemAt(3);
		var btile4 = balancingCol.getItemAt(4);
		var btile5 = balancingCol.getItemAt(5);
		var btile6 = balancingCol.getItemAt(6);
		trace(balancingCol);
		
		//move item to lower position
		trace("moving item down: "+btile6+" to 2");
		balancingCol.move( btile6, 2 );
		trace(balancingCol);
		Assert.equal( btile0, balancingCol.getItemAt(0));
		Assert.equal( btile1, balancingCol.getItemAt(1));
		Assert.equal( btile6, balancingCol.getItemAt(2));
		Assert.equal( btile2, balancingCol.getItemAt(3));
		Assert.equal( btile3, balancingCol.getItemAt(4));
		Assert.equal( btile4, balancingCol.getItemAt(5));
		
		//move item to higher position
		trace("moving item up: "+btile0+" to 4");
		balancingCol.move( btile0, 4 );
		trace(balancingCol);
		Assert.equal( btile1, balancingCol.getItemAt(0));
		Assert.equal( btile6, balancingCol.getItemAt(1));
		Assert.equal( btile2, balancingCol.getItemAt(2));
		Assert.equal( btile3, balancingCol.getItemAt(3));
		Assert.equal( btile0, balancingCol.getItemAt(4));
		Assert.equal( btile4, balancingCol.getItemAt(5));
		
		//*/
		
		trace("TEST FINISHED!");
	}
	
	
	public static inline function iterateList (lists:ChainedListCollection<Tile>) {
		
	//	trace("\niterating through items " + lists.length);
		
		var pos = 0;
		for (item in lists) {
	//		trace("list[" + pos + "] = " + item);
			pos++;
		}
		
	//	trace("finished iterating through items\n");
	}
}

class Tile
{
	public static var COUNTER:Int = 0;
	
	public var id:Int;
	public function new () { this.id = COUNTER++; }
	public function toString () { return "Tile" + id; }
}