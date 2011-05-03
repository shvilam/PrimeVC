/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.avm2.input;
 import com.asual.swfaddress.SWFAddress;
 import com.asual.swfaddress.SWFAddressEvent;
 import flash.external.ExternalInterface;
 import flash.net.URLRequest;
 import flash.system.Capabilities;
 import primevc.gui.events.BrowserEvents;
 import primevc.types.URI;


/**
 * Browser defines method to interact with the browser like reading/writing
 * the url.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 24, 2011
 */
class Browser
{
	public static var instance (getInstance, null)		: Browser;
		private static inline function getInstance ()	{ return instance == null ? instance = new Browser() : instance; }
	
	
	public var events		(default,		null)		: BrowserEvents;
	public var address		(getAddress,	setAddress)	: String;
	public var history		(getHistory,	setHistory)	: Bool;
	public var title		(getTitle,		setTitle)	: String;
	public var status		(getStatus,		setStatus)	: String;
	public var strict		(getStrict,		setStrict)	: Bool;
	/**
	 * indicating if the application is currently running in the browser
	 */
	public var available	(getAvailable,	never)		: Bool;
	
	/**
	 * property with flashvars as an dynamic object
	 */
	public var variables	(default,		null)		: Dynamic;
	
	
	/**
	 * Returns the flash-player version
	 */
	public var flashVersion	(getFlashVersion,	never)	: String;
	public var isFlashDebug	(getIsFlashDebug,	never)	: Bool;
	
	/**
	 * Returns the operatingsystem the user has
	 */
	public var os			(getOS,				never)	: String;
	
	/**
	 * Returns the name of the browser
	 */
	public var name			(getName,			null)	: String;
	public var screenWidth	(getScreenWidth,	never)	: Float;
	public var screenHeight	(getScreenHeight,	never)	: Float;
	
	
	
	//
	// BROWSER METHODS
	//
	
	public inline function openURI (uri:URI, target:String = "_self")
	{
		openUrl( uri.toString(), target );
	}
	
	
	public inline function openUrl (url:String, target:String = "_self")
	{
		if (!available)		flash.Lib.getURL( new URLRequest(url), target);
		else				SWFAddress.href( url, target );
	}
	
	
	public inline function openPopup (uri:URI, name:String = "", options:String = "")
	{
		SWFAddress.popup( uri.toString(), name, options );
	}
	
	
	public inline function sendMail (to:String, subject:String, body:String)
	{
		openUrl( "mailto:"+to+"?subject="+subject+"&body="+StringTools.urlEncode( body ) );
	//	if (!available)		openUrl( url );
	//	else				ExternalInterface.call("function sendMail(link) { var a = window.unload; var b = window.onbeforeunload; window.onunload = window.onbeforeunload = null; window.alert(window.onbeforeunload); window.location = link; window.onbeforeunload = b; window.onunload = a; }", url);
	}
	
	
	/**
	 * Loads the previous URL in the history URL
	 */
	public inline function goBack ()			{ SWFAddress.back(); }
	/**
	 * Loads the next URL in the history lsit
	 */
	public inline function goForward ()			{ SWFAddress.forward(); }
	
	/**
	 * Loads a URL from the history list.
	 * @param Int represeting the relative position in the history list.
	 */
	public inline function goBackTo (pos:Int)	{ SWFAddress.go(pos); }
	
	
	
	//
	// JAVASCRIPT LISTENERS
	//
	
	
	/**
	 * Method will add a listener for javscript-method calls
	 * @return 		true when the externalinterface is available, else false
	 */
	public inline function addJsCallback (jsFunctionName:String, appMethod:Dynamic) : Bool
	{
		if (available)
			ExternalInterface.addCallback( jsFunctionName, appMethod );
		
		return available;
	}
	
	
	/**
	 * Method allows application to call a javascript method
	 * @return 	Whatever the method returns
	 */
	public inline function callJsMethod (jsFunctionName:String, ?info:haxe.PosInfos)
	{
		if (available)
			Reflect.callMethod( null, ExternalInterface.call, info.customParams );
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getAddress ()		{ return SWFAddress.getValue(); }
	private inline function setAddress (v)		{ SWFAddress.setValue(v); return v; }
	
	private inline function getHistory ()		{ return SWFAddress.getHistory(); }
	private inline function setHistory (v)		{ SWFAddress.setHistory(v); return v; }
	
	private inline function getTitle ()			{ return SWFAddress.getTitle(); }
	private inline function setTitle (v)		{ SWFAddress.setTitle(v); return v; }
	
	private inline function getStrict ()		{ return SWFAddress.getStrict(); }
	private inline function setStrict (v)		{ SWFAddress.setStrict(v); return v; }
	
	private inline function getStatus ()		{ return SWFAddress.getStatus(); }
	private inline function setStatus (v)		{ SWFAddress.setStatus(v); return v; }
	
	private inline function getAvailable ()		{ return ExternalInterface.available; }
	
	private inline function getFlashVersion ()	{ return Capabilities.version; }
	private inline function getIsFlashDebug ()	{ return Capabilities.isDebugger; }
	private inline function getOS ()			{ return Capabilities.os; }
	private inline function getScreenWidth ()	{ return Capabilities.screenResolutionX; }
	private inline function getScreenHeight ()	{ return Capabilities.screenResolutionY; }
	
	/**
	 * Returns the name of the browser
	 */
	private function getName ()
	{
		if (!available)		return "no browser";
		if (name != null)	return name;
		
		//check the version via external-interface
		var versionCheck = "function() { return navigator.appVersion; }";
		return name = ExternalInterface.call(versionCheck);
	}
	
	
	
	
	private function new ()
	{
		events = new BrowserEvents( untyped(SWFAddress)._dispatcher);
		
		if (available)
			variables = flash.Lib.current.loaderInfo.parameters;
	}
}