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
 * DAMAGE.
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.display;
#if flash9
 import flash.text.AntiAliasType;
 import flash.text.GridFitType;
 import flash.text.StyleSheet;
 import flash.text.TextFieldAutoSize;
 import flash.text.TextFieldType;
 import flash.text.TextFormat;
 import flash.text.TextLineMetrics;
#end
 import primevc.core.IBindable;
 import primevc.gui.events.TextEvents;
 import primevc.gui.traits.IInteractive;
 import primevc.gui.traits.ITextStylable;


/**
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
interface ITextField 
		implements IDisplayObject	
	,	implements IInteractive 
	,	implements ITextStylable
{
	
	public var textEvents			(default, null)			: TextEvents;
	
	/**
	 * The real text-value of the inputfield. The UITextField can apply a
	 * text-transform on the 'text' property but it will leave the 'value' 
	 * unchanged.
	 * 
	 * TODO: not implemented for the htmlText property
	 */
	public var data					(default, setData)		: IBindable < String >;
	public var value				(getValue, setValue)	: String;
	
	
#if flash9
	//
	// SIZE
	//
	
	public var autoSize								: TextFieldAutoSize;
	public var textHeight			(default, null)	: Float;
	public var textWidth			(default, null)	: Float;
	
	
	//
	// TEXT PROPERTIES
	//
	
	public var text									: String;
	public var htmlText								: String;
	public var length				(default, null)	: Int;
	public var restrict								: String;
	
	
	//
	// FIELD SETTINGS
	//
	
	public var displayAsPassword					: Bool;
	public var embedFonts							: Bool;
	public var type									: TextFieldType;
	public var useRichTextClipboard					: Bool;
	
	
	//
	// FONT SETTINGS
	//
	
	public var antiAliasType						: AntiAliasType;
	public var condenseWhite						: Bool;
	public var gridFitType							: GridFitType;
	public var sharpness							: Float;
	
	
	//
	// FONT FORMATTING
	//
	
//	public var defaultTextFormat					: TextFormat;
	public var styleSheet							: StyleSheet;
	public var textColor							: UInt;
	public var thickness							: Float;
	
	
	//
	// OBJECT STYLING
	//
	
	public var background							: Bool;
	public var border								: Bool;
	public var backgroundColor						: UInt;
	public var borderColor							: UInt;
	
	
	//
	// SELECTION
	//
	
	public var alwaysShowSelection					: Bool;
	public var selectable							: Bool;
	public var selectedText			(default, null)	: String;
	public var selectionBeginIndex	(default, null)	: Int;
	public var selectionEndIndex	(default, null)	: Int;
	
	
	//
	// SCROLLING
	//
	
	public var bottomScrollV		(default, null)	: Int;
	public var maxScrollH			(default, null)	: Int;
	public var maxScrollV			(default, null)	: Int;
	public var mouseWheelEnabled					: Bool;
	public var scrollH								: Int;
	public var scrollV								: Int;
	
	
	//
	// LINES / CARET
	//
	
	public var caretIndex			(default, null)	: Int;
	public var maxChars								: Int;
	public var multiline							: Bool;
	public var numLines				(default, null)	: Int;
	public var wordWrap								: Bool;
	
	
	
	
	
	public function getCharBoundaries (charIndex : Int)					: flash.geom.Rectangle;
	public function getCharIndexAtPoint (x : Float, y : Float)			: Int;
	public function getFirstCharInParagraph (charIndex : Int)			: Int;
	public function getImageReference (id : String)						: flash.display.DisplayObject;
	
	public function getLineIndexAtPoint (x : Float, y : Float)			: Int;
	public function getLineIndexOfChar (charIndex : Int)				: Int;
	public function getLineLength (lineIndex : Int)						: Int;
	public function getLineMetrics (lineIndex : Int)					: TextLineMetrics;
	public function getLineOffset (lineIndex : Int)						: Int;
	public function getLineText (lineIndex : Int)						: String;
	
	public function getParagraphLength (charIndex : Int)				: Int;
	
	public function appendText (newText:String)																: Void;
	public function getRawText ()																			: String;
	public function getXMLText (?beginIndex:Int = 0, ?endIndex:Int = 2147483647)							: String;
	public function insertXMLText (beginIndex:Int, endIndex:Int, richText:String, ?pasting:Bool = false)	: Void;
	public function replaceSelectedText (value : String)													: Void;
	public function replaceText (beginIndex:Int, endIndex:Int, newText:String)								: Void;
	
	public function getTextFormat (?beginIndex:Int = -1, ?endIndex:Int = -1)								: TextFormat;
	public function getTextRuns (?beginIndex : Int = 0, ?endIndex : Int = 2147483647)						: Array<Dynamic>;
	public function setSelection (beginIndex : Int, endIndex : Int)											: Void;
	public function setTextFormat (format:TextFormat, ?beginIndex:Int = -1, ?endIndex:Int = -1)				: Void;
#end
}