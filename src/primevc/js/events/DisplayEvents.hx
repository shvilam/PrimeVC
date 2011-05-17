package primevc.js.events;

import primevc.core.dispatcher.Signals;

/**
 * @author	Stanislav Sopov
 * @since	March 8, 2011
 */ 
class DisplayEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var nodeInserted			(getNodeInserted,			null):DisplaySignal;
	public var nodeInsertedIntoDoc	(getNodeInsertedIntoDoc,	null):DisplaySignal;
	public var nodeRemoved			(getNodeRemoved,			null):DisplaySignal;
	public var nodeRemovedFromDoc	(getNodeRemovedFromDoc,		null):DisplaySignal;
	public var charDataModified		(getCharDataModified,		null):DisplaySignal;
	public var subtreeModified		(getSubtreeModified,		null):DisplaySignal;
	public var attrModified			(getAttrModified,			null):DisplaySignal;
	public var attrNameChanged		(getAttrNameChanged, 		null):DisplaySignal;
	public var elemNameChanged		(getElemNameChanged, 		null):DisplaySignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getNodeInserted			() { if (nodeInserted			== null) { createNodeInserted();		} return nodeInserted; }
	private inline function getNodeInsertedIntoDoc	() { if (nodeInsertedIntoDoc	== null) { createNodeInsertedIntoDoc(); } return nodeInsertedIntoDoc; }
	private inline function getNodeRemoved			() { if (nodeRemoved			== null) { createNodeRemoved(); 		} return nodeRemoved; }
	private inline function getNodeRemovedFromDoc	() { if (nodeRemovedFromDoc		== null) { createNodeRemovedFromDoc(); 	} return nodeRemovedFromDoc; }
	private inline function getCharDataModified		() { if (charDataModified		== null) { createCharDataModified(); 	} return charDataModified; }
	private inline function getSubtreeModified		() { if (subtreeModified 		== null) { createSubtreeModified(); 	} return subtreeModified; }
	private inline function getAttrModified			() { if (attrModified 			== null) { createAttrModified(); 		} return attrModified; }
	private inline function getAttrNameChanged		() { if (attrNameChanged 		== null) { createAttrNameChanged(); 	} return attrNameChanged; }
	private inline function getElemNameChanged		() { if (elemNameChanged 		== null) { createElemNameChanged(); 	} return elemNameChanged; }
	
	private function createNodeInserted			() { nodeInserted			= new DisplaySignal(eventDispatcher, "DOMNodeInserted"); }
	private function createNodeInsertedIntoDoc	() { nodeInsertedIntoDoc	= new DisplaySignal(eventDispatcher, "DOMNodeInsertedIntoDocument"); }
	private function createNodeRemoved			() { nodeRemoved			= new DisplaySignal(eventDispatcher, "DOMNodeRemoved"); }
	private function createNodeRemovedFromDoc	() { nodeRemovedFromDoc		= new DisplaySignal(eventDispatcher, "DOMNodeRemovedFromDocument"); }
	private function createCharDataModified		() { charDataModified		= new DisplaySignal(eventDispatcher, "DOMCharacterDataModified"); }
	private function createSubtreeModified		() { subtreeModified		= new DisplaySignal(eventDispatcher, "DOMSubtreeModified"); }
	private function createAttrModified			() { attrModified			= new DisplaySignal(eventDispatcher, "DOMAttrModified"); }
	private function createAttrNameChanged		() { attrNameChanged		= new DisplaySignal(eventDispatcher, "DOMAttributeNameChanged"); }
	private function createElemNameChanged		() { elemNameChanged		= new DisplaySignal(eventDispatcher, "DOMElementNameChanged"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).nodeInserted		!= null ) nodeInserted.dispose();
		if ( (untyped this).nodeInsertedIntoDoc	!= null ) nodeInsertedIntoDoc.dispose();
		if ( (untyped this).nodeRemoved			!= null ) nodeRemoved.dispose();
		if ( (untyped this).nodeRemovedFromDoc	!= null ) nodeRemovedFromDoc.dispose();
		if ( (untyped this).charDataModified	!= null ) charDataModified.dispose();
		if ( (untyped this).subtreeModified		!= null ) subtreeModified.dispose();
		if ( (untyped this).attrModified		!= null ) attrModified.dispose();
		if ( (untyped this).attrNameChanged		!= null ) attrNameChanged.dispose();
		if ( (untyped this).elemNameChanged		!= null ) elemNameChanged.dispose();
		
		nodeInserted = 
		nodeInsertedIntoDoc = 
		nodeRemoved = 
		nodeRemovedFromDoc = 
		charDataModified = 
		subtreeModified = 
		attrModified = 
		attrNameChanged = 
		elemNameChanged = 
		null;
	}
}