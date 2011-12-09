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
 *  Ruben Weijers <ruben {at} rubenw [dot] nl>
 */
package primevc.utils;
 import primevc.utils.FastArray;
  using primevc.utils.FastArray;
  using StringTools;


/**
 * @author Ruben Weijers
 * @creation-date Dec 6, 2011
 */
class Csv
{
	private static inline var LINE_SPLITTER		= "\n";
	private static inline var VAL_SPLITTER		= ",";
	private static inline var ALT_VAL_SPLITTER	= ";";
	private static inline var WIN_LINE 			= "\r\n";


	/**
	 * @param input 	CSV string
	 * @param header 	defines if the input has an header
	 */
	public static function read (input:String, header:Bool = true) : FastArray<FastArray<String>>
	{
#if debug var s = TimerUtil.stamp(); #end
		input 			= input.replace(WIN_LINE, LINE_SPLITTER);
		var out 		= FastArrayUtil.create();
		var pos 		= 0, len = input.length, cols:UInt = 0;
		var inString 	= false, char:String = null, row:FastArray<String> = null, val:StringBuf = null;
		var delimiter 	= VAL_SPLITTER;

		if (header)
		{
			//deterine the number of colums
			while (pos < len) {
				var c = input.charAt(pos++);
				if (c == LINE_SPLITTER)			{	cols++; break; }
				else if (c == delimiter)			cols++;
				else if (c == ALT_VAL_SPLITTER) { 	cols++; delimiter = ALT_VAL_SPLITTER; }
			}
			pos = 0;	//reset position to read header row as well
		}
		
		//read input
		while (pos < len)
		{
			var r:UInt = 0;
			row = FastArrayUtil.create(cols, header);
			val = new StringBuf();

			while(pos < len)
			{
				char = input.charAt(pos++);
				if (char == '"')
				{
					var n = input.charAt(pos);
					if (n == '"') 	{ pos++; } 								//beginning or ending of quotes.. skip one quote
					else 			{ inString = !inString; continue; } 	//begining or ending of string.. skip character
				}
				else if (!inString)
				{
					if (char == LINE_SPLITTER) {
						r = addCell( row, header, cols, r, val.toString() );
						break;
					}
					if (char == delimiter) {
						r   = addCell( row, header, cols, r, val.toString() );
						val = new StringBuf();
						continue;
					}
				}
				
				val.add(char);
			}
			if (pos == len)
				r = addCell( row, header, cols, r, val.toString() );
			
			if (header && row.length < cols)
				throw CsvError.tooLittleCells;
			out.push(row);
		}

		if (inString)	throw unclosedString;
	//	if (inQuote)	throw unclosedQuote;

		//remove empty rows
		var l = out.length;
		for (i in l...0)
		{
			var row = out[i];
			var empty:UInt = 0;
			for (cell in row)
				if (cell == "")
					empty++;
			
			if (row.length == empty)
				out.removeAt(i);
		}

#if debug trace("csv-parsed in "+(s - TimerUtil.stamp())+"ms"); #end
		return out;
	}


	private static inline function addCell (row:FastArray<String>, hasHeader:Bool, headerCols:Int, cellPos:Int, val:String)
	{
		if (hasHeader && headerCols == cellPos)
			throw CsvError.tooManyCells;
		
		row[cellPos] = val;
		return cellPos + 1;
	}
}


/**
 * @author Ruben Weijers
 * @creation-date Dec 6, 2011
 */
enum CsvError {
	/** Error is thrown when the csv-file has a header defined and the parser finds a row that has more columns then the header */
	tooManyCells;
	/** Error is thrown when the csv-file has a header defined and the parser finds a row that has less columns then the header */
	tooLittleCells;
	/** Error is thrown when a cell has opened a string-quote and there is no closing quote found when the end of the file is reached */
	unclosedString;
	/** Error is thrown when a cell has opened a double-quote and there is no closing double-quote found when the end of the file is reached */
	unclosedQuote;
}
