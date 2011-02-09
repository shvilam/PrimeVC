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
package primevc.core.validators;
 import primevc.core.dispatcher.Signal0;


/**
 * Validator for URI's
 * 
 * @author Ruben Weijers
 * @creation-date Feb 09, 2011
 */
class URIValidator implements IValueValidator <String>
{
	public var change (default, null)	: Signal0;
	
	
	public function new()
	{
		change = new Signal0();
		change.send();
	}
	
	
	public inline function dispose ()
	{
		change.dispose();
		change = null;
	}
	
	
	private inline function broadcastChange ()
	{
		if (change != null)
			change.send();
	}
	
	
	public function validate (v:String) : String
	{
		return isValid(v) ? v : null;
	}
	
	
#if debug
	public function toString () { return "URIValidator"; }
#end
	
	
	/**
	 * Method will use a regexp to examine if the given string is a valid
	 * URI
	 */
	public static inline function isValid (v:String) : Bool
	{
		return validator.match( v );
	}
	
	
	private static inline var validator = new EReg( R_URI_PRETENDER, "i" );
	
	
	//
	//URI Regexp
	//@see http://labs.apache.org/webarch/uri/rfc/rfc3986.html
	//
/*	private static inline var R_URI_SCHEME			: String = "[a-z][a-z0-9+.-]+";										//"file|http|https|ftp|ldap|news|telnet"
	private static inline var R_URI_USERINFO		: String = "[a-z0-9_-]+(:.+)?";										//match username and optional the password
	private static inline var R_URI_DNS				: String = "(" + R_DOMAIN_LABEL + ")([.]" + R_DOMAIN_LABEL + ")+";
	private static inline var R_DEC_OCTET			: String = "([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])";			//matches a number from 0 - 255
	private static inline var R_URI_IPV4			: String = "(" + R_DEC_OCTET + "[.]){3}" + R_DEC_OCTET;
	private static inline var R_URI_IPV6			: String = "((" + R_HEX_VALUE + "){4}){5}";							//TODO: not sure how to implement the full IPv6 range.. this just covers 60 bits
	private static inline var R_URI_HOST			: String = "(" + R_URI_DNS + "|" + R_URI_IPV4 + "|" + R_URI_IPV6 + "|localhost)";
	private static inline var R_URI_PORT			: String = "[0-9]{1,4}|[0-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9{2}|655[0-2][0-9]|6553[0-5]]";	//port range from 0 - 65535
	private static inline var R_URI_AUTHORITY		: String = "(" + R_URI_USERINFO + "@)?(" + R_URI_HOST + ")(:(" + R_URI_PORT + "))?";
	private static inline var R_URI_NAME			: String = "[a-z][a-z0-9+%_, -]*";
	private static inline var R_URI_FOLDERNAME		: String = "(" + R_URI_NAME + ")|([.]{1,2})";
	private static inline var R_URI_FILENAME		: String = R_URI_NAME + "[.][a-z0-9]+";
	private static inline var R_URI_PATH			: String = "([a-z]:/)?((" + R_URI_FOLDERNAME + ")/)*((" + R_URI_FILENAME + ")|(" + R_URI_FOLDERNAME + ")/?)";		//match path with optional filename at the end
	private static inline var R_URI_QUERY_VALUE		: String = "[a-z][a-z0-9+.?/_%-]*";
	private static inline var R_URI_QUERY_VAR		: String = "((" + R_URI_QUERY_VALUE + "=" + R_URI_QUERY_VALUE + ")|(" + R_URI_QUERY_VALUE + "))";
	private static inline var R_URI_QUERY			: String = "[?]" + R_URI_QUERY_VAR + "(&" + R_URI_QUERY_VAR + ")*";
	private static inline var R_URI_FRAGMENT		: String = "#(" + R_URI_QUERY_VALUE + ")+";
	private static inline var R_URI_EXPR			: String = "((" + R_URI_SCHEME + ")://)?(" + R_URI_AUTHORITY + ")(/" + R_URI_PATH + ")?(" + R_URI_QUERY + ")?(" + R_URI_FRAGMENT + ")?";*/
	
	/**
	 * Greedy stupid URI/file matcher
	 * R_URI_EXPR took to much time
	 */
	public static inline var R_URI_PRETENDER		: String = "[/a-z0-9/&%.#+=\\;:$@?_-]+";
//	public static inline var R_FILE_EXPR			: String = R_URI_PATH;
}