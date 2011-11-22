package primevc.js.events;
 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.UserEventTarget;


/**
 * @author	Stanislav Sopov
 * @author	Ruben Weijers
 * @since	March 8, 2011
 */ 
class DisplayEvents extends DisplaySignals
{
	public function new (target:UserEventTarget)
	{
		super();
		addedToStage		= new DomSignal0( target, "DOMNodeInsertedIntoDocument" );
		removedFromStage	= new DomSignal0( target, "DOMNodeRemovedFromDocument" );
		enterFrame			= new EnterFrameSignal();
		render				= enterFrame;	//<== FIXME?
	}
}



 import haxe.Timer;

/**
 * @author Ruben Weijers
 * @creation-date Nov 22, 2011
 */
private class EnterFrameSignal extends prime.core.dispatcher.Signal0
{
	private static inline var INTERVAL = 33; 	//30fps
	private var timer : Timer;


	public function wireEnabled (wire:Wire<Void->Void>):Void
	{
		if (ListUtil.next(n) == null) { // First wire connected
#if debug	Assert.null(timer); #end
			timer = new Timer(INTERVAL);
			timer.run = send;
		}
	}

	
	public function wireDisabled (wire:Wire<Void->Void>):Void
	{	
		if (n == null) // No more wires connected
		{
#if debug 	Assert.notNull(timer); #end
			timer.stop();
			timer.run = null;
			timer = null;
		}
	}
}


/*	var eventDispatcher:Dynamic;
	
	public var inserted				(getInserted,			null):DisplaySignal;
	public var insertedIntoDoc		(getInsertedIntoDoc,	null):DisplaySignal;
	public var removed				(getRemoved,			null):DisplaySignal;
	public var removedFromDoc		(getRemovedFromDoc,		null):DisplaySignal;
	public var charDataModified		(getCharDataModified,	null):DisplaySignal;
	public var subtreeModified		(getSubtreeModified,	null):DisplaySignal;
	public var attrModified			(getAttrModified,		null):DisplaySignal;
	public var attrNameChanged		(getAttrNameChanged,	null):DisplaySignal;
	public var elemNameChanged		(getElemNameChanged,	null):DisplaySignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getInserted				() { if (inserted			== null) { createInserted();			} return inserted; }
	private inline function getInsertedIntoDoc		() { if (insertedIntoDoc	== null) { createInsertedIntoDoc(); 	} return insertedIntoDoc; }
	private inline function getRemoved				() { if (removed			== null) { createRemoved(); 			} return removed; }
	private inline function getRemovedFromDoc		() { if (removedFromDoc		== null) { createRemovedFromDoc(); 		} return removedFromDoc; }
	private inline function getCharDataModified		() { if (charDataModified	== null) { createCharDataModified(); 	} return charDataModified; }
	private inline function getSubtreeModified		() { if (subtreeModified 	== null) { createSubtreeModified(); 	} return subtreeModified; }
	private inline function getAttrModified			() { if (attrModified 		== null) { createAttrModified(); 		} return attrModified; }
	private inline function getAttrNameChanged		() { if (attrNameChanged 	== null) { createAttrNameChanged(); 	} return attrNameChanged; }
	private inline function getElemNameChanged		() { if (elemNameChanged 	== null) { createElemNameChanged(); 	} return elemNameChanged; }
	
	private function createInserted			() { inserted			= new DisplaySignal(eventDispatcher, "DOMNodeInserted"); }
	private function createInsertedIntoDoc	() { insertedIntoDoc	= new DisplaySignal(eventDispatcher, "DOMNodeInsertedIntoDocument"); }
	private function createRemoved			() { removed			= new DisplaySignal(eventDispatcher, "DOMNodeRemoved"); }
	private function createRemovedFromDoc	() { removedFromDoc		= new DisplaySignal(eventDispatcher, "DOMNodeRemovedFromDocument"); }
	private function createCharDataModified	() { charDataModified	= new DisplaySignal(eventDispatcher, "DOMCharacterDataModified"); }
	private function createSubtreeModified	() { subtreeModified	= new DisplaySignal(eventDispatcher, "DOMSubtreeModified"); }
	private function createAttrModified		() { attrModified		= new DisplaySignal(eventDispatcher, "DOMAttrModified"); }
	private function createAttrNameChanged	() { attrNameChanged	= new DisplaySignal(eventDispatcher, "DOMAttributeNameChanged"); }
	private function createElemNameChanged	() { elemNameChanged	= new DisplaySignal(eventDispatcher, "DOMElementNameChanged"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).inserted			!= null ) inserted.dispose();
		if ( (untyped this).insertedIntoDoc		!= null ) insertedIntoDoc.dispose();
		if ( (untyped this).removed				!= null ) removed.dispose();
		if ( (untyped this).removedFromDoc		!= null ) removedFromDoc.dispose();
		if ( (untyped this).charDataModified	!= null ) charDataModified.dispose();
		if ( (untyped this).subtreeModified		!= null ) subtreeModified.dispose();
		if ( (untyped this).attrModified		!= null ) attrModified.dispose();
		if ( (untyped this).attrNameChanged		!= null ) attrNameChanged.dispose();
		if ( (untyped this).elemNameChanged		!= null ) elemNameChanged.dispose();
		
		inserted = 
		insertedIntoDoc = 
		removed = 
		removedFromDoc = 
		charDataModified = 
		subtreeModified = 
		attrModified = 
		attrNameChanged = 
		elemNameChanged = 
		null;
	}
}*/