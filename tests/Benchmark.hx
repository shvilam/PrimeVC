 import flash.display.DisplayObject;
 import flash.events.Event;
 import flash.system.System;
 import primevc.utils.FastArray;
 


interface IThread {
	var next				: IThread;
	var isFinished			: Bool;
	function run ()			: Bool;
}


interface ITest implements IThread {
	function getSummery()	: String;
}



class Thread implements IThread
{
	public var next : IThread;
	
	/**
	 * App wide thread operations that have run within this frame
	 */
	public static var RUNNED_THIS_FRAME				: Int = 0;
	/**
	 * Time spent this frame
	 */
	public static var frameTime = 0.0;
	/**
	 * Max number of miliseconds per frame
	 */
	public static var FRAME_DURATION = (1000 / flash.Lib.current.stage.frameRate) - 0.5;
	
	/**
	 * Total iterations runned by this thread over all the frames
	 */
	public var runnedIterations	: Int;
	/**
	 * Needed number of iterations in this thread over all
	 * frames before it is finished.
	 */
	public var neededIterations	: Int;
	/**
	 * Flag indicating if this thread is done with executing.
	 */
	public var isFinished		: Bool;
	
	/**
	 * The method that's gonna do all the iterations. The first
	 * parameter is the number of iterations that should run now.
	 */
	public var executeOne	: Void -> Void;
	
	
	public function new (executeOne	: Void -> Void) {
		this.executeOne	= executeOne;
	}
	
	public function reset () : Void {
		isFinished			= false;
		runnedIterations	= 0;
	}
	
	
	public function start () : Void {
		reset();
		if (executeOne == null)		finish();
		else						execute();
	}
	
	public function finish () : Void	{ isFinished = true; }
	public function pause () : Void		{ }
	public function resume () : Void	{ execute(); }
	
	
	public function run () : Bool {
		if (MainThread.pausingFrames > 0)
			return isFinished;
		
		if (!isFinished) {
			if (runnedIterations == 0)	start();
			else						resume();
		}
		
		return isFinished;
	}
	
	private function doExecuteTen() {
		for (i in 0 ... 10) executeOne();
	}
	
	public inline function execute () : Void {
/*		var maxThisFrame:Int = Std.int( Math.min(
			neededIterations - runnedIterations,
			OPERATIONS_PER_FRAME - RUNNED_THIS_FRAME
		) );
*/	//	trace("execute; needed: " + neededIterations + "; runned: " + runnedIterations + "; allowed: " + (OPERATIONS_PER_FRAME - RUNNED_THIS_FRAME));
	//	trace("max " + maxThisFrame);
		
		var T = Thread;
		var runned = runnedIterations;
		var L = flash.Lib;
		
		while (T.frameTime < T.FRAME_DURATION && runned < neededIterations)
		{
			var t = L.getTimer();
			
			doExecuteTen();
			
			runned += 10;
			T.frameTime += L.getTimer() - t;
		//	trace("runned");
		}
		runnedIterations = runned;
		
		
		//trace(runnedIterations);
		
		if (runnedIterations >= neededIterations)
			finish();
		else
			pause();
	}
}




class MainThread
{
	public var target			: DisplayObject;
	public var firstThread		: IThread;
	public var lastAddedThread	: IThread;
	public var currentThread	: IThread;
	
	public static var pausingFrames	: Int;
	
	
	public function new (target : DisplayObject) {
		this.target = target;
	}
	
	
	public function start () : Void {
		if (target == null)
			return;
		
		trace("START RUNNING THREADS - " + flash.Lib.current.stage.frameRate + " FPS");
#if debug
		trace("debug mode ON");
#else
		trace("debug mode OFF");
#end
		pausingFrames = 0;
		target.addEventListener( Event.ENTER_FRAME, run );
	}
	
	
	public function finish () : Void {
		target.removeEventListener( Event.ENTER_FRAME, run );
		trace("FINISHED THREADS");
	}
	
	
	public function run (event)
	{
		if (lastGcMemory == 0)
			lastGcMemory = System.totalMemory;
		
		//only lower the frames when it hasn't reached 0
		if (pausingFrames > 0) {
			pausingFrames--;
			if (pausingFrames == 0)
				lastGcMemory = System.totalMemory;
		}
		
		if (pausingFrames > 0)
			return;
		
		if (currentThread == null) {
			finish();
			return;
		}
		
		Thread.RUNNED_THIS_FRAME = 0;
		Thread.frameTime = 0;
		
		//run as much threads as possible in this frame
		while ( currentThread != null ) {
			var finished = currentThread.run();
			if (finished)
				currentThread = currentThread.next;
			else
				break;
		}
	}
	
	
	public static var lastGcMemory : UInt = 0;
	
	public static function gc () : Bool
	{
		if (pausingFrames > 0)
			return true;
		
		var change = System.totalMemory - lastGcMemory;
		
		if (change > 10000000) {	//over 1MB of changes
			pausingFrames = Std.int( flash.Lib.current.stage.frameRate );
			trace("Waiting " + pausingFrames + " frames to garbage collect. Memory change: "+change);
			System.gc();
		} else {
			pausingFrames = 0;
		}
		
		return pausingFrames > 0;
	}
	
	
/*	public function pauseThread (event) : Void {
		trace("pause thread "+timer.delay);
		if (currentThread == null)
			finish();
		else
			currentThread.pause();
	}
*/	
	
	//
	// adding threads
	//
	
	public function add ( thread:Thread ) : Void {
		if (firstThread == null) {
			firstThread = currentThread = lastAddedThread = thread;
		} else {
			lastAddedThread.next = thread;
			lastAddedThread = thread;
		}
	}
}





/**
 * @creation-date	Jun 9, 2010
 * @author			Ruben Weijers
 */
class Benchmark extends MainThread
{
	public function new() {
		super( flash.Lib.current.stage );
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
	}
	
	override public function finish() {
		super.finish();
		
		var sum =	"\n ==================" +
					"\n\t\tSUMMARY" + 
					"\n==================";
		var currentTest:ITest = cast firstThread;
		while (currentTest != null) {
			sum += "\n" + currentTest + ": \t\t" + currentTest.getSummery();
			currentTest = cast currentTest.next;
		}
		trace(sum);
	}
}




class Comparison extends Thread, implements ITest
{
	public var name				: String;
	public var childIterations	: Int;
	private var firstTest		: Test;
	private var lastAddedTest	: Test;
	private var currentTest		: Test;
	private var isStarted		: Bool;
	
	
	public function new ( name:String, repeat:Int )
	{
		super( null );
		this.name			= name;
		childIterations	= repeat;
		isStarted			= false;
	}
	
	
	override public function run () : Bool
	{
		if (!isStarted) {
			isStarted = true;
			trace(this);
		}
		
		if (currentTest != null) {
			if (currentTest.isFinished) {
				currentTest = cast currentTest.next;
			}
			
			if (currentTest != null) {
				currentTest.run();
			}
		}
		
		if (currentTest == null)
			finish();
		
		return isFinished;
	}
	
	
	override public function finish () {
		super.finish();
		trace("");
	}
	
	
	public function getSummery () : String
	{
		var sum:String				= "";
		var result:String;
		var results:FastArray<String>	= FastArrayUtil.create();
		var fastests:FastArray<Test>	= FastArrayUtil.create();		//make a vector with fastests test in case there are more then one tests with the same time
		
		var currentTest				= firstTest;
		var fastestTime				= StopWatch.MAX_VALUE; //currentTest.timer.fastest;
		var i:Int					= 0;
		var tabs:Int;
		var maxTabs:Int				= 8;
		
		while (currentTest != null) {
			if (currentTest.timer.fastest < fastestTime) {
				fastestTime = currentTest.timer.fastest;
				fastests	= FastArrayUtil.create();
				fastests.push( currentTest );
			}
			else if (currentTest.timer.fastest == fastestTime) {
				fastests.push( currentTest );
			}
			
			result	= currentTest.getSummery();
			
			//add test name
			tabs	= maxTabs - Std.int( Math.ceil( result.length / 4 ) );
			result	= ++i + ". " + result;
			
			for ( j in 0...tabs )
				result += "\t";
			
			result += currentTest;
			
			//add memory usage
			tabs	= maxTabs - Std.int( Math.ceil( (currentTest.toString().length + 1) / 4 ) );
			for ( j in 0...tabs )
				result += "\t";
			
			result += MemorySampler.makeReadable( currentTest.memorySampler.totalMemory );
			
			results.push( result );
			currentTest = cast currentTest.next;
		}
		
		sum += "\n" + results.join("\n");
		sum += "\n------------------";
		sum += "\nFastest: " + fastestTime + " ms by " + fastests.join(" and ");
		sum += "\nIterations: " + childIterations + "; repeated: " + Test.REPEAT_TEST + " times";
		
		return sum +"\n";
	}
	
	
	public function toString () : String {
		return "\n======== COMPARISON OF "+name.toUpperCase()+" ========";
	}
	
	
	public function add ( test:Test ) {
		if (firstTest == null) {
			firstTest = lastAddedTest = currentTest = test;
		} else {
			lastAddedTest.next	= test;
			lastAddedTest		= test;
		}
		lastAddedTest.neededIterations = childIterations;
	}
}


/**
 * @creation-date	Jun 9, 2010
 * @author			Ruben Weijers
 */
class Test extends Thread, implements ITest
{
	public static inline var REPEAT_TEST : Int = 7;
	
	/**
	 * Method that will be called before the tests are run
	 */
	private var initMethod		: Void -> Void;
	private var name			: String;
	public var timer			: StopWatch;
	public var memorySampler	: MemorySampler;
	
	private var timesRepeated	: Int;
	
	
	public function new( method : Void -> Void, name:String, iterations:Int = 1, ?initMethod : Void -> Void )
	{
		timer				= new StopWatch();
		memorySampler		= new MemorySampler();
		this.name			= name;
		this.initMethod		= initMethod;
		super(method);
		neededIterations	= iterations;
		timesRepeated		= 0;
	}
	
	
	override public function start () {
		if (timesRepeated == 0) {
			trace(this);
			if (initMethod != null)
				initMethod();
		}
		super.start();
	}
	
	
	override private function doExecuteTen()
	{
		timer.resume();
		memorySampler.start();
		for (i in 0 ... 10) executeOne();
		memorySampler.stop();
		timer.pause();
	}
	
	
	override public function finish ()
	{
		timer.stop();
		timer.reset();
		memorySampler.stop();
		MainThread.gc();
		
		if (++timesRepeated < REPEAT_TEST) {
			//repeat this thread some more
			reset();
			run();
		} else {
			trace(timer.times);
			trace("Mem: " + MemorySampler.makeReadable(memorySampler.totalMemory) + " ("+memorySampler.totalMemory+")");
		//	System.gc();
		//	trace("Retained "+MemorySampler.makeReadable(System.totalMemory - memorySampler.totalMemory));
		//	trace(timer+"\n");
			super.finish();
		}
	}
	
	
	/*public inline function performTests (allowedIterations:Int) : Void {
	//	trace("performing " + this + "; iteration "+runnedIterations+"; repeated: "+timesRepeated);
		for ( j in 0...allowedIterations )
			method();
	}*/
	
	
	public function toString () : String {
		return name;
	}
	
	
	public function getSummery () : String {
		return timer.toString();
	}
}




class StopWatch
{
	public static inline var MAX_VALUE:Int			= 2147483647;
	
	private var timesList							: FastArray < Int >;
	public var average		(getAverage, null)		: Float;
	public var fastest		(getFastest, null)		: Int;
	public var currentTime	(getCurrentTime, null)	: Int;
	public var times		(getTimes, null)		: String;
	
	private var startTime							: Int;
	private var runnedTime							: Int;
	
	public function new () {
		timesList = FastArrayUtil.create();
		reset();
	}
	
	
	public inline function reset ()			{ runnedTime	 = 0; }
	public inline function pause ()			{ runnedTime	+= flash.Lib.getTimer() - startTime; }
	public inline function resume ()		{ startTime		 = flash.Lib.getTimer(); }
/*	public inline function start () {
		reset();
		resume();
	}
*/	public inline function stop () {
		pause();
		timesList.push( runnedTime );
	}
	
	
	private inline function getCurrentTime () : Int {
		return runnedTime;
	}
	
	private inline function getAverage () : Float
	{
		var len:Int		= timesList.length;
		var total:Int	= 0;
		for ( i in 0...len ) {
			total += timesList[i];
		}
		return Math.round( (total / len) * 1000 ) / 1000;
	}
	
	private inline function getFastest () : Int {
		var len:Int	= timesList.length;
		var fas:Int	= len > 0 ? timesList[0] : -1;
		
		for ( i in 1...len ) {
			if (timesList[i] < fas)
				fas = timesList[i];
		}
		return fas;
	}
	
	
	public function toString () : String {
		return fastest + " ms";
	}
	public inline function getTimes () : String {
		return "Times: " + timesList.join(" ms, ") + " ms";
	}
}




class MemorySampler
{
	public var current		: UInt;
	public var totalMemory	: UInt;
	
	
	public function new () {
		current = 0;
		totalMemory = 0;
	}
	
	public function start () {
		current = System.totalMemory;
	}
	
	public function stop () {
		if (current != 0) {
			var m = System.totalMemory - current;
			if (m > 0)
				totalMemory += m;
			current = 0;
		}
	}
	
	
	private static inline var sizes = ["B", "KB", "MB", "GB"];
	
	public static function makeReadable (mem:Int):String
	{
		var output:String = "";
		
		for (size in sizes) {
			if (mem >= 1024) {
				mem >>= 10;	//divide by 1024 (2^10)
			} else {
				output = mem + " " + size;
				break;
			}
		}
		return output;
	}
}

/*
class MemorySampler
{
	public var samples		: FastArray < UInt >;
	public var current		: MemorySample;
	public var totalMemory	(getTotalMemory, null)	: Int;
	
	
	public function new () {
		samples = FastArrayUtil.create();
		current = new MemorySample();
	}
	
	public function start () {
		current.start();
	}
	
	public function stop () {
		if (current != null) {
			current.stop();
			samples.push( current.usage );
			current.reset();
		}
	}
	
	private inline function getTotalMemory () : UInt
	{
		var total:Int = 0;
		for (sample in samples) {
			total += sample;
		}
		return total;
	}
	
	
	private static inline var sizes = ["B", "KB", "MB", "GB"];
	
	public static function makeReadable (mem:Int):String
	{
		var output:String = "";
		
		for (size in sizes) {
			if (mem >= 1024) {
				mem >>= 10;	//divide by 1024 (2^10)
			} else {
				output = mem + " " + size;
				break;
			}
		}
		return output;
	}
}
class MemorySample
{
	public var startMem	: Int;
	private var _usage	: Int;
	public var usage	(getUsage, null) : Int;
		private inline function getUsage () : Int { return _usage; }
	
	public function new ()		{ }
	public function start ()	{ startMem = System.totalMemory; }
	public function stop ()		{ _usage = System.totalMemory - startMem; }	
	public function reset ()	{ _usage = 0; startMem = 0; }
}*/