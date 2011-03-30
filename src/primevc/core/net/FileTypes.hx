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
 * List of static arrays with file-types that can be used in FileReference.browse
 * 
 * @author Ruben Weijers
 * @creation-date Mar 29, 2011
 */
class FileTypes
{
	public static inline var image	= [ "png", "gif", "jpeg", "jpg", "svg" ];
	public static inline var video	= [ "mpeg", "mp4", "avi", "flv" ];
	public static inline var flash	= [ "swf" ];
	public static inline var sound	= [ "mp3", "mp2", "wav" ];
}


/**
 * @author Ruben Weijers
 * @creation-date Mar 29, 2011
 */
class MimeType
{
	public static inline var flash	= "application/x-shockwave-flash";
	public static inline var jpeg	= "image/jpeg";
	public static inline var gif	= "image/gif";
	public static inline var png	= "image/png";
}



/**
 * @author Ruben Weijers
 * @creation-date Mar 29, 2011
 */
class FileTypesUtil
{
	public static inline function toFileType (mimetype:String) : FileType
	{
		return switch (mimetype) {
			case MimeType.flash:	FileType.SWF;
			case MimeType.jpeg:		FileType.JPEG;
			case MimeType.gif:		FileType.GIF;
			case MimeType.png:		FileType.PNG;
			default:
				throw "Unkown mimetype: "+mimetype;
		}
	}
}