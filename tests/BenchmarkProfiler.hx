import flash.display.DisplayObject;
import flash.events.Event;
import flash.sampler.Api;
import flash.sampler.DeleteObjectSample;
import flash.sampler.NewObjectSample;
import flash.sampler.Sample;
import flash.sampler.StackFrame;
import flash.system.System;
import flash.Vector;
 


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
	
	
	public function new (target : DisplayObject) {
		this.target = target;
		sampleTypes();
	}
	
	
	public function sampleTypes ()
	{
		Api.startSampling();
		for (i in 0...100)
			new Array();

		var cpuSamples	= [];
		var newSamples	= [];
		var delSamples	= [];
		var ids			= [];

		var lastTime:Float = 0;
		var samples = Api.getSamples();
		trace("sample length: " + samples.length);
		for (s in samples )
		{
			assert(s.time > 0, "sample time"); // positive
		//	assert(Math.floor(s.time) == s.time, "floored time: " + s.time); // integral
			assert(s.time >= lastTime, s.time + ":" + lastTime); // ascending
			assert(s.stack == null || Std.is(s.stack, Array));
			if(s.stack != null) {
				assert(Std.is( s.stack[0], StackFrame));
				assert(Std.is( s.stack[0].name, String));
			}

			if(Std.is( s, NewObjectSample)) {
				var nos:NewObjectSample = cast s;
				assert(nos.id > 0, cast nos.id);
				assert(Std.is( nos.type, Class), Type.getClassName(nos.type));
				newSamples.push(nos);
				ids[cast nos.id] = "got one";
			}
			else if(Std.is( s, DeleteObjectSample)) {
				var dos:DeleteObjectSample = cast s;
				delSamples.push(dos);
				assert(ids[ cast dos.id] == "got one");
			}
			else if(Std.is(s, Sample))
				cpuSamples.push(s);
			else {
				assert(false);
			}
			lastTime = s.time;
		}
		
		trace("newSamples length: " + newSamples.length);
		trace("cpuSamples length: " + cpuSamples.length);
		trace("delSamples length: " + delSamples.length);
	}
	
	private function assert(e:Bool, mess:String = null)
	{
		if(true && !e) {
			if(mess != null) trace(mess);
			trace(new flash.Error().getStackTrace());
		}     
	}     
	
	
	public function start () : Void {
		if (target == null)
			return;
		
		trace("START RUNNING THREADS ");
		target.addEventListener( Event.ENTER_FRAME, run );
	}
	
	
	public function finish () : Void {
		target.removeEventListener( Event.ENTER_FRAME, run );
		trace("FINISHED THREADS");
	}
	
	
	public function run (event)
	{
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
		
	/*	var a:UInt	= 13254879;
		var b:Int	= 15001564;
		var c:Float	= 1008.5313547876;
		var d:Bool	= true;
		var e:String= "fsdfjsdklfjdslf";
		trace("this : "+ Api.getSize( this ));
		trace("new Number() : "+ Api.getSize( c));
		trace("new int() : "+ Api.getSize( b ));
		trace("new uint() : "+ Api.getSize( a ));
		trace("new Boolean() : "+ Api.getSize( d ));
		trace("new Object() : "+ Api.getSize({}));
		trace("new Array() : "+ Api.getSize(new Array()));
		trace("new String() : "+ Api.getSize(e));
		trace("new Date() : "+ Api.getSize(new Date(2010,6,15,11,28,01)));
		trace("new XML() : "+ Api.getSize(new flash.xml.XML()));
		trace("new XMLList() : "+ Api.getSize(new flash.xml.XMLList()));
		trace("new Shape() : "+ Api.getSize(new flash.display.Shape()));
		trace("new Sprite() : "+ Api.getSize(new flash.display.Sprite()));
		trace("new MovieClip() : "+ Api.getSize(new flash.display.MovieClip()));*/
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
	private var firstTest		: Test;
	private var lastAddedTest	: Test;
	private var currentTest		: Test;
	private var isStarted		: Bool;
	
	
	public function new ( name:String )
	{
		super( null );
		this.name	= name;
		isStarted	= false;
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
		var results:Vector<String>	= new Vector<String>();
		var fastests:Vector<Test>	= new Vector<Test>();		//make a vector with fastests test in case there are more then one tests with the same time
		
		var currentTest				= firstTest;
		var fastestTime				= StopWatch.MAX_VALUE; //currentTest.timer.fastest;
		var i:Int					= 0;
		var tabs:Int;
		var maxTabs:Int				= 6;
		
		while (currentTest != null) {
			if (currentTest.timer.fastest < fastestTime) {
				fastestTime = currentTest.timer.fastest;
				fastests	= new Vector<Test>();
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
		sum += "\nFastest: " + fastestTime + " ms by " + fastests.join(" and ") +"\n";
		
		return sum;
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
	}
}


/**
 * @creation-date	Jun 9, 2010
 * @author			Ruben Weijers
 */
class Test extends Thread, implements ITest
{
	private static inline var REPEAT_TEST : Int = 7;
	
//	private var method			: Void -> Void;
	private var name			: String;
	public var timer			: StopWatch;
	public var memorySampler	: MemorySampler;
	
	private var timesRepeated	: Int;
	
	
	public function new( method : Void -> Void, iterations:Int, name:String )
	{
		timer				= new StopWatch();
		memorySampler		= new MemorySampler();
		this.name			= name;	
		
		super(method);
		neededIterations	= iterations;
		timesRepeated		= 0;
	}
	
	
	override public function start () {
		if (timesRepeated == 0) {
			trace(this);
		}
		super.start();
	}
	
	override private function doExecuteTen() {
		memorySampler.start();
		timer.resume();
		for (i in 0 ... 10) executeOne();
		timer.pause();
		memorySampler.stop();
	}
		
	override public function finish () {
		timer.stop();
		timer.reset();
		
		if (++timesRepeated < REPEAT_TEST) {
			//repeat this thread some more
			reset();
			run();
		} else {
			trace(timer.times);
			trace(memorySampler.totalMemory);
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
	
	private var timesList							: Vector < Int >;
	public var average		(getAverage, null)		: Float;
	public var fastest		(getFastest, null)		: Int;
	public var currentTime	(getCurrentTime, null)	: Int;
	public var times		(getTimes, null)		: String;
	
	private var startTime							: Int;
	private var runnedTime							: Int;
	
	public function new () {
		timesList = new Vector<Int>();
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
	/**
	 * List with all memory samples taken during the test
	 */
	public var samples		: Vector < MemorySample >;
	public var current		: MemorySample;
	public var totalMemory	(getTotalMemory, null)	: UInt;
	
	
	public function new () {
		samples = new Vector < MemorySample >();
	}
	
	public function start () {
		current = new MemorySample();
	}
	
	public function stop () {
		if (current != null) {
			current.stop();
			samples.push( current );
			current = null;
		}
	}
	
	private inline function getTotalMemory () : UInt
	{
		var total:UInt = 0;
		for (sample in samples) {
			total += sample.usage;
		}
		return total;
	}
	
	
	private static inline var sizes = ["B", "KB", "MB", "GB"];
	
	public static function makeReadable (mem:UInt):String
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
	public var startMem	: UInt;
	public var endMem	: UInt;
	public var usage	(getUsage, null) : UInt;
		private inline function getUsage () : UInt { return endMem - startMem; }
	
	public function new ()	{ startMem = System.totalMemory; }
	public function stop ()	{ endMem = System.totalMemory; }	
}