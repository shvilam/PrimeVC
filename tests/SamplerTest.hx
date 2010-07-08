import flash.Lib;
import flash.sampler.Api;
import flash.system.System;
import flash.utils.QName;
 

/**
 * Description
 * 
 * @creation-date	Jun 15, 2010
 * @author			Ruben Weijers
 */
class SamplerTest 
{
	public static function main ()
	{
		var inst = new SamplerTest();
		inst.test1();
		inst.test2();
	}
	
	
	public function new() {}
	
	public function test1 () {
		var s = System.totalMemory;
		var t = Lib.getTimer();
	//	for (i in 0...100000)
		var result = doComplexCalculation();
		trace("test1 size " + makeReadable(System.totalMemory - s));
			
		trace("test1 duration: " + (Lib.getTimer() - t));
	}
	public function test2 () {
		var t = Lib.getTimer();
		Api.startSampling();
	//	for (i in 0...100000)
		var result = doComplexCalculation();
		
		Api.pauseSampling();
		var end = Lib.getTimer();
		var time:Float = 0;
		var samples = Api.getSamples();
		
		trace("size this " + makeReadable(Api.getSize(this)));
		trace("size result " + makeReadable(Api.getSize(result)));
		trace("samples " + samples.length + "; vs " + Api.getSampleCount());
	//	for (sample in samples) {
	//		trace("time: " + (sample.time / 1000));
	//		trace(Type.getClass(sample));
		//	for (item in sample.stack)
			//	trace("\t" + item);
	//	}
		
		time = samples.pop().time - samples.shift().time;
		
		trace("test2 duration: " + (time / 1000)+"; vs "+(end - t));
	}
	
	public function doComplexCalculation ()
	{
		/*(102489456 / 8.5) * 1024 +5.3 / 128;
		(102489456 / 8.5) * 1024 +5.3 / 127;
		(102489456 / 8.5) * 1024 +5.3 / 126;
		(102489456 / 8.5) * 1024 +5.3 / 125;*/
		var arr = [];
		for ( i in 0...100000 ) {
			arr.push( i + " lalalala" );
		}
		return arr;
	}
	
	private static inline var sizes = ["B", "KB", "MB", "GB"];
	public static function makeReadable (mem:Float):String
	{
		var output:String = "";
		
		for (size in sizes) {
			if (mem >= 1024) {
				mem /= 1024; //>>= 10;	//divide by 1024 (2^10)
			} else {
				output = mem + " " + size;
				break;
			}
		}
		return output;
	}
}