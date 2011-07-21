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
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package primevc.tools;
 import primevc.utils.FastArray;
 import primevc.utils.TimerUtil;
  using primevc.utils.FastArray;
  using primevc.utils.NumberUtil;



/**
 * @author	Ruben Weijers
 */
class StopWatch
{
//	public static inline var MAX_VALUE:Int			= 2147483647;
	
	private var timesList							: FastArray < Int >;
	public var average		(getAverage, null)		: Float;
	public var fastest		(getFastest, null)		: Int;
	public var currentTime	(getCurrentTime, null)	: Int;
	public var times		(getTimes, null)		: String;
	
	private var startTime							: Int;
	private var runnedTime							: Int;
	
	
	public  function new ()						{ timesList = FastArrayUtil.create(); reset(); }
	public  function toString ()				{ return fastest + " ms"; }
	
	
	public  inline function reset ()			{ runnedTime	 = 0; }
	public  inline function pause ()			{ runnedTime	+= TimerUtil.stamp() - startTime; }
	public  inline function resume ()			{ startTime		 = TimerUtil.stamp(); }
	public  inline function start ()			{ reset(); resume(); }
	public  inline function stop ()				{ pause(); timesList.push( runnedTime ); }
	private inline function getCurrentTime ()	{ return runnedTime; }
	public  inline function getTimes ()			{ return "Times: " + timesList.join(" ms, ") + " ms"; }
	
	
	private inline function getAverage () : Float
	{
		var len:Int		= timesList.length;
		var total:Int	= 0;
		for ( i in 0...len ) {
			total += timesList[i];
		}
		return ((total / len) * 1000).round() / 1000;
	}
	
	
	private inline function getFastest () : Int
	{
		var len:Int	= timesList.length;
		var fas:Int	= len > 0 ? timesList[0] : -1;
		
		for ( i in 1...len )
			if (timesList[i] < fas)
				fas = timesList[i];
		
		return fas;
	}
}