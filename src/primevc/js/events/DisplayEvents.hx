package primevc.js.events;

import primevc.core.dispatcher.Signals;
import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since	March 8, 2011
 */

class DisplayEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var insert			(getInsert,			null):DisplaySignal;
	public var insertIntoDoc	(getInsertIntoDoc,	null):DisplaySignal;
	public var remove			(getRemove,			null):DisplaySignal;
	public var removeFromDoc	(getRemoveFromDoc,	null):DisplaySignal;
	public var modifyCharData	(getModifyCharData,	null):DisplaySignal;
	public var modifySubtree	(getModifySubtree,	null):DisplaySignal;
	public var modifyAttr		(getModifyAttr,		null):DisplaySignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getInsert()			{ if (insert			== null) { createInsert();			} return insert; }
	private inline function getInsertIntoDoc()	{ if (insertIntoDoc		== null) { createInsertIntoDoc(); 	} return insertIntoDoc; }
	private inline function getRemove()			{ if (remove			== null) { createRemove(); 			} return remove; }
	private inline function getRemoveFromDoc()	{ if (removeFromDoc		== null) { createRemoveFromDoc(); 	} return removeFromDoc; }
	private inline function getModifyCharData()	{ if (modifyCharData	== null) { createModifyCharData(); 	} return modifyCharData; }
	private inline function getModifySubtree()	{ if (modifySubtree 	== null) { createModifySubtree(); 	} return modifySubtree; }
	private inline function getModifyAttr()		{ if (modifyAttr 		== null) { createModifyAttr(); 		} return modifyAttr; }
	
	private function createInsert()			{ insert			= new DisplaySignal(eventDispatcher, "DOMNodeInserted"); }
	private function createInsertIntoDoc()	{ insertIntoDoc		= new DisplaySignal(eventDispatcher, "DOMNodeInsertedIntoDocument"); }
	private function createRemove()			{ remove			= new DisplaySignal(eventDispatcher, "DOMNodeRemoved"); }
	private function createRemoveFromDoc()	{ removeFromDoc		= new DisplaySignal(eventDispatcher, "DOMNodeRemovedFromDocument"); }
	private function createModifyCharData()	{ modifyCharData	= new DisplaySignal(eventDispatcher, "DOMCharacterDataModified"); }
	private function createModifySubtree()	{ modifySubtree		= new DisplaySignal(eventDispatcher, "DOMSubtreeModified"); }
	private function createModifyAttr()		{ modifyAttr		= new DisplaySignal(eventDispatcher, "DOMAttrModified"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).insert			!= null ) insert.dispose();
		if ( (untyped this).insertIntoDoc	!= null ) insertIntoDoc.dispose();
		if ( (untyped this).remove			!= null ) remove.dispose();
		if ( (untyped this).removeFromDoc	!= null ) removeFromDoc.dispose();
		if ( (untyped this).modifyCharData	!= null ) modifyCharData.dispose();
		if ( (untyped this).modifySubtree	!= null ) modifySubtree.dispose();
		if ( (untyped this).modifyAttr		!= null ) modifyAttr.dispose();
		
		insert =
		insertIntoDoc =
		remove =
		removeFromDoc = 
		modifyCharData = 
		modifySubtree = 
		modifyAttr = 
		null;
	}
}