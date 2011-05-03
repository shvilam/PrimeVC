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
package primevc.core.net;



/**
 * Utility to help with http status codes
 * @author Ruben Weijers
 * @creation-date Apr 01, 2011
 */
class HttpStatusCodes
{
	public static inline function isClientError (code:Int)		{ return code >= 400 && code < 500; }
	public static inline function isServerError (code:Int)		{ return code >= 500 && code < 600; }
	public static inline function isOk (code:Int)				{ return code == 200; }
	
	
	public static inline function read (code:Int) : String
	{
		return "("+code+") => "+switch (code) {
			case 100: "Continue";
			case 101: "Switching Protocols";
			
			case 200: "OK";
			case 201: "Created";
			case 202: "Accepted";
			case 203: "Non-Authoritative Information";
			case 204: "No Content";
			case 205: "Reset Content";
			case 206: "Partial Content";
			
			case 300: "Multiple Choices";
			case 301: "Moved Permanently";
			case 302: "Moved Temporarily";
			case 303: "See Other";
			case 304: "Not Modified";
			case 305: "Use Proxy";
			
			case 400: "Bad Request";
			case 401: "Unauthorized";
			case 402: "Payment Required";
			case 403: "Forbidden";
			case 404: "Not Found";
			case 405: "Method Not Allowed";
			case 406: "Not Acceptable";
			case 407: "Proxy Authentication Required";
			case 408: "Request Time-Out";
			case 409: "Conflict";
			case 410: "Gone";
			case 411: "Length Required";
			case 412: "Precondition Failed";
			case 413: "Request Entity Too Large";
			case 414: "Request-URL Too Large";
			case 415: "Unsupported Media Type";
			
			case 500: "Server Error";
			case 501: "Not Implemented";
			case 502: "Bad Gateway";
			case 503: "Out of Resources";
			case 504: "Gateway Time-Out";
			case 505: "HTTP Version not supported";
			
			default:  "unkown code ";
		}
	}
}