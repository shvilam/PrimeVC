package primevc.gui.events;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.dispatcher.Signals; 


typedef DisplayEvents = 
	#if		flash9	primevc.avm2.events.DisplayEvents;
	#elseif	flash8	primevc.avm1.events.DisplayEvents;
	#elseif	js		primevc.js  .events.DisplayEvents;
	#else	error	#end

/**
 * Cross-platform displayobject events
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class DisplaySignals extends Signals
{
	var addedToStage		(default,null) : Signal0;
	var removedFromStage	(default,null) : Signal0;
	var enterFrame			(default,null) : Signal0;
}
