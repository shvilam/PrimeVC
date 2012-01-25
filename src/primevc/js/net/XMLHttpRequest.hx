package primevc.js.net;

import js.Dom;
import js.Lib;


/**
 * @author	Stanislav Sopov
 * @since	Arpil 5, 2011
 */

extern class XMLHttpRequest {

	var onreadystatechange : Void -> Void;
	
	var readyState : Int;
	var responseText : String;
	//var responseXML : Xml;
	var status : Int;
	var statusText : String;

	function new() : Void;

	function abort() : Void;

	function getAllResponseHeaders() : String;
	function getResponseHeader( name : String ) : String;
	function setRequestHeader( name : String, value : String ) : Void;
	function open( method : String, url : String, async : Bool ) : Void;
	function send( content : String ) : Void;
	
	function addEventListener ( type : String, listener : Event -> Void, useCapture : Bool) : Void; 
	function dispatchEvent ( evt : Event ) : Void;
	function overrideMimeType ( mimeType : String ) : Void; 
	function removeEventListener ( type : String, listener : Event -> Void, useCapture : Bool) : Void;
	
	
	#if !jsfl
	private static function __init__() : Void {
		untyped
		primevc.js.net["XMLHttpRequest"] =
			if( window.XMLHttpRequest )
				__js__("XMLHttpRequest");
			else if( window.ActiveXObject )
				function() {
					try {
						return __new__("ActiveXObject","Msxml2.XMLHTTP");
					}catch(e:Dynamic){
						try {
							return __new__("ActiveXObject","Microsoft.XMLHTTP");
						}catch(e:Dynamic){
							throw "Unable to create XMLHttpRequest object.";
						}
					}
				};
			else
				throw "Unable to create XMLHttpRequest object.";
	}
	#end

}
