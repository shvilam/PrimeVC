package primevc.gui.events;
 import primevc.core.dispatcher.Signals;
 import primevc.core.dispatcher.INotifier;

typedef UserEvents = 
	#if		flash9	primevc.avm2.events.UserEvents;
	#elseif	flash8	primevc.avm1.events.UserEvents;
	#elseif	js		primevc.js  .events.UserEvents;
	#else	error	#end

/**
 * Cross-platform user-interface events.
 * 
 * @author Danny Wilson
 * @creation-date jun 15, 2010
 */
class UserSignals extends Signals, implements haxe.Public
{
	var mouse	(default,null) : MouseEvents;
	var key		(default,null) : KeyboardEvents;
	var focus	(default,null) : INotifier<Void->Void>;
	var blur	(default,null) : INotifier<Void->Void>;
}
