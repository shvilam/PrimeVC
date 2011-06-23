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
package primevc.utils;
 import primevc.core.net.FileType;
 import primevc.core.net.MimeType;
  using primevc.utils.IfUtil;


/**
 * @author Ruben Weijers
 * @creation-date Mar 29, 2011
 */
extern class FileUtil
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
	
	
	/**
	 * Method will return the extension of the given filename or an empty string
	 * if the file doesn't have an extension.
	 * 
	 * 	- Returns the string after the last dot in the path.
	 * 	- Returns an empty string if it has no dots in the path.
	 *	- Returns empty string if the first char is a dot and there are no other dots (UNIX hidden file convention).
	 * 
	 * @author Danny Wilson
	 */
	public static inline function getExtension (fileName:String) : String
	{
		if (!fileName.notNull()) return "";
		else {
			var idx = fileName.lastIndexOf('.');
			var ext = idx <= 1 ? "" : fileName.substr(idx+1).toLowerCase();
			return (ext == "jpg" ? "jpeg" : ext).toUpperCase();
		}
	}
	
	
	/**
	 * Method will change the extension of the given filename and return the
	 * new filename.
	 * 
	 * @author Danny Wilson
	 */
	public static inline function setExtension (fileName:String, ext:String) : String
	{
		Assert.notNull(ext);
		Assert.notNull(fileName);
		
		var idx		= fileName.lastIndexOf('.');
		fileName	= idx <= 1
						? fileName + '.' + ext
						: fileName.substr(0, fileName.lastIndexOf('.')) + '.' + ext;
		return fileName;
	}
}