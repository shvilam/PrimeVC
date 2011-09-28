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



typedef FileFilter = #if flash9 flash.net.FileFilter; #else FileFilterInst; #end


/**
 * Class usable for defining file-types in an uploadwindow
 * 
 * mac filetypes:
 * @see http://www.tink.ws/blog/macintosh-file-types/
 * 
 * @author Ruben Weijers
 * @creation-date Mar 30, 2011
 */
class FileFilters
{
	public static inline var image	= [ new FileFilter("Images (gif, png, jpg)", "*.png;*.gif;*.jpeg;*.jpg", "JPEG;jp2_;GIFf;PNGf") ];		//FIXME add SVG support
	public static inline var video	= [ new FileFilter("Videos (mpeg, mp4, avi, flv)", "*.mpeg;*.mp4;*.avi;*.flv", "MPEG;AVI;FLV_") ];
	public static inline var flash	= [ new FileFilter("Flash", "*.swf", "SWFL") ];
	public static inline var audio	= [ new FileFilter("Audio (mp3, mp2, wav)", "*.mp3;*.mp2;*.wav", "WAVE;WAV;MP3_;Mp3_;MPG3;MPG2;MP2_;Mp2_") ];
}


#if !flash9
class FileFilterInst
{
	public var description	(default, null) : String;
	public var extension	(default, null)	: String;
	public var macType		(default, null)	: String;


	public function new (description:String, extension:String, macType:String)
	{
		this.description	= description;
		this.extension		= extension;
		this.macType		= macType;
	}
}
#end